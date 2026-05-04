<?php
namespace App\Services;

use App\Models\Gudang;
use App\Models\OrderItemLotAllocation;
use App\Models\StockLot;
use App\Models\StockMovement;
use App\Models\VariantStock;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use RuntimeException;

class VariantStockService
{
    /**
     * Set stok awal (upsert unik per gudang+variant).
     * @param int $gudangId
     * @param int $variantId
     * @param int $qty
     * @param int|null $minStok
     * @return VariantStock
     */
    public function setInitialStock(int $gudangId, int $variantId, int $qty, ?int $minStok = null): VariantStock
    {
        return DB::transaction(function () use ($gudangId, $variantId, $qty, $minStok) {
            $gudang = Gudang::query()->with('cabang')->findOrFail($gudangId);
            /** @var VariantStock $stock */
            $stock = VariantStock::query()->firstOrNew([
                'gudang_id'          => $gudang->id,
                'product_variant_id' => $variantId,
            ]);

            $stock->cabang_id = $gudang->cabang_id;
            $stock->qty       = (int) $qty;
            if ($minStok !== null) {
                $stock->min_stok = (int) $minStok;
            }

            $stock->save();

            // (Optional) dispatch event: VariantStockInitialized
            return $stock->refresh();
        });
    }

    /**
     * Penyesuaian manual stok.
     * @param VariantStock $stock
     * @param 'increase'|'decrease' $type
     * @param int $amount
     * @param string|null $note
     * @return VariantStock
     */
    public function adjust(VariantStock $stock, string $type, int $amount, ?string $note = null): VariantStock
    {
        return DB::transaction(function () use ($stock, $type, $amount, $note) {
            $stock->lockForUpdate();
            if ($type === 'increase') {
                $stock->qty += $amount;
            } else {
                if ($stock->qty < $amount) {
                    throw new RuntimeException('Stok tidak mencukupi untuk dikurangi.');
                }
                $stock->qty -= $amount;
            }
            $stock->save();

            return $stock->refresh();
        });
    }

    public function updateStockConfig(VariantStock $stock, array $payload): VariantStock
    {
        return DB::transaction(function () use ($stock, $payload) {
            $stock = VariantStock::query()
                ->whereKey($stock->id)
                ->lockForUpdate()
                ->firstOrFail();

            foreach (['min_stok', 'safety_stock', 'lead_time_days', 'reorder_point'] as $field) {
                if (array_key_exists($field, $payload)) {
                    $stock->{$field} = $payload[$field] !== null
                        ? (int) $payload[$field]
                        : null;
                }
            }

            $stock->save();

            return $stock->refresh()->load(['gudang', 'variant', 'cabang']);
        });
    }

    public function updateMinStok(VariantStock $stock, int $minStok): VariantStock
    {
        return $this->updateStockConfig($stock, [
            'min_stok' => $minStok,
        ]);
    }

    public function ensureUniquenessAndSync(VariantStock $stock): void
    {
        $duplicate = VariantStock::query()
            ->where('id', '!=', $stock->id)
            ->where('gudang_id', $stock->gudang_id)
            ->where('product_variant_id', $stock->product_variant_id)
            ->exists();

        if ($duplicate) {
            throw new RuntimeException('Data stok duplikat untuk gudang & varian yang sama.');
        }
    }

    public function receiveLot(
        int $gudangId,
        int $variantId,
        int $qty,
        ?string $lotNo = null,
        string | \DateTimeInterface  | null $receivedAt = null,
        string | \DateTimeInterface  | null $expiresAt = null,
        ?float $unitCost = null,
        ?string $note = null,
        ?string $refType = null,
        ?string $refId = null
    ): StockLot {
        return DB::transaction(function () use (
            $gudangId,
            $variantId,
            $qty,
            $lotNo,
            $receivedAt,
            $expiresAt,
            $unitCost,
            $note,
            $refType,
            $refId
        ) {
            if ($qty <= 0) {
                throw new RuntimeException('Qty penerimaan harus > 0');
            }

            $gudang = Gudang::query()->with('cabang')->findOrFail($gudangId);

            /** @var VariantStock|null $stock */
            $stock = VariantStock::query()
                ->where('gudang_id', $gudang->id)
                ->where('product_variant_id', $variantId)
                ->lockForUpdate()
                ->first();

            if (! $stock) {
                $stock = new VariantStock([
                    'gudang_id'          => $gudang->id,
                    'product_variant_id' => $variantId,
                    'cabang_id'          => $gudang->cabang_id,
                    'qty'                => 0,
                    'min_stok'           => 0,
                ]);
                $stock->save();
                // baris baru yang baru dibuat tidak perlu di-lock ulang
            }

            try {
                $received = $receivedAt ? Carbon::parse($receivedAt) : now();
            } catch (\Throwable $e) {
                throw ValidationException::withMessages([
                    'received_at' => ['Format tanggal tidak valid. Gunakan YYYY-MM-DD.'],
                ]);
            }

            $expires = null;
            if ($expiresAt !== null) {
                try {
                    $expires = Carbon::parse($expiresAt)->toDateString();
                } catch (\Throwable $e) {
                    throw ValidationException::withMessages([
                        'expires_at' => ['Format tanggal tidak valid. Gunakan YYYY-MM-DD.'],
                    ]);
                }
            }

            if ($lotNo === null || trim($lotNo) === '') {
                $lotNo = sprintf('LOT-%s-G%02d-%04d', now()->format('Ymd'), $gudang->id, random_int(0, 9999));
            }

            $stock->qty += (int) $qty;
            $stock->save();

            // 6) Buat layer lot
            $lot = StockLot::create([
                'cabang_id'          => $gudang->cabang_id,
                'gudang_id'          => $gudang->id,
                'product_variant_id' => $variantId,
                'lot_no'             => $lotNo,
                'received_at'        => $received,
                'expires_at'         => $expires,
                'qty_received'       => (int) $qty,
                'qty_remaining'      => (int) $qty,
                'unit_cost'          => $unitCost,
            ]);

            StockMovement::create([
                'cabang_id'          => $gudang->cabang_id,
                'gudang_id'          => $gudang->id,
                'product_variant_id' => $variantId,
                'stock_lot_id'       => $lot->id,
                'type'               => 'IN',
                'qty'                => (int) $qty,
                'unit_cost'          => $unitCost,
                'ref_type'           => $refType,
                'ref_id'             => $refId,
                'note'               => $note ?? 'RECEIVE',
            ]);

            return $lot;
        });
    }

    public function allocateFifoAndDeduct(
        int $gudangId,
        int $variantId,
        int $orderItemId,
        int $qty,
        ?string $note = null,
        ?string $refType = 'SALE',
        ?string $refId = null,
        ?int $cabangId = null,
    ): void {
        DB::transaction(function () use ($gudangId, $variantId, $orderItemId, $qty, $note, $refType, $refId, $cabangId) {
            if ($qty <= 0) {
                throw new RuntimeException('Qty keluaran harus > 0');
            }

            if ($cabangId === null) {
                $gudang   = Gudang::query()->with('cabang')->findOrFail($gudangId);
                $cabangId = (int) $gudang->cabang_id;
            }

            $lots = StockLot::query()
                ->where('gudang_id', $gudangId)
                ->where('product_variant_id', $variantId)
                ->where('qty_remaining', '>', 0)
                ->orderByRaw('COALESCE(received_at, created_at) ASC, id ASC')
                ->lockForUpdate()
                ->get();

            $remain = (int) $qty;

            foreach ($lots as $lot) {
                if ($remain <= 0) {
                    break;
                }

                $take = min($remain, (int) $lot->qty_remaining);
                if ($take <= 0) {
                    continue;
                }

                $lot->qty_remaining -= $take;
                $lot->save();

                StockMovement::create([
                    'cabang_id'          => $cabangId,
                    'gudang_id'          => $gudangId,
                    'product_variant_id' => $variantId,
                    'stock_lot_id'       => $lot->id,
                    'type'               => 'OUT',
                    'qty'                => -$take,
                    'unit_cost'          => $lot->unit_cost,
                    'ref_type'           => $refType,
                    'ref_id'             => $refId ?? (string) $orderItemId,
                    'note'               => $note ?? 'SALE',
                ]);

                OrderItemLotAllocation::create([
                    'order_item_id' => $orderItemId,
                    'stock_lot_id'  => $lot->id,
                    'qty_allocated' => $take,
                    'unit_cost'     => $lot->unit_cost,
                ]);

                $remain -= $take;
            }

            if ($remain > 0) {
                throw new RuntimeException('Stok tidak mencukupi per FIFO (lot habis).');
            }

            /** @var VariantStock $stock */
            $stock = VariantStock::query()
                ->where('gudang_id', $gudangId)
                ->where('product_variant_id', $variantId)
                ->lockForUpdate()
                ->firstOrFail();

            if ($stock->qty < (int) $qty) {
                throw new RuntimeException('Stok agregat kurang (inkonsisten).');
            }

            $stock->qty -= (int) $qty;
            $stock->save();
        });
    }
}
