<?php

namespace App\Services;

use App\Models\VariantStock;
use App\Models\Gudang;
use Illuminate\Support\Facades\DB;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use App\Models\StockLot;
use App\Models\StockMovement;
use App\Models\OrderItemLotAllocation;
use RuntimeException;
use Carbon\Carbon;
use Illuminate\Validation\ValidationException;

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
                'gudang_id' => $gudang->id,
                'product_variant_id' => $variantId,
            ]);

            $stock->cabang_id = $gudang->cabang_id;
            $stock->qty       = (int)$qty;
            if ($minStok !== null) $stock->min_stok = (int)$minStok;
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
            $stock->lockForUpdate(); // hindari race condition
            if ($type === 'increase') {
                $stock->qty += $amount;
            } else {
                // cegah negatif
                if ($stock->qty < $amount) {
                    throw new \RuntimeException('Stok tidak mencukupi untuk dikurangi.');
                }
                $stock->qty -= $amount;
            }
            $stock->save();

            // (Optional) audit log penyesuaian menggunakan $note
            return $stock->refresh();
        });
    }

    /**
     * Update threshold low-stock.
     */
    public function updateMinStok(VariantStock $stock, int $minStok): VariantStock
    {
        $stock->min_stok = $minStok;
        $stock->save();
        return $stock->refresh();
    }

    /**
     * Konsistensi: pastikan 1 baris per (gudang, variant) dan cabang sinkron.
     * Bisa dipanggil sebagai maintenance/command bila perlu.
     */
    public function ensureUniquenessAndSync(VariantStock $stock): void
    {
        $duplicate = VariantStock::query()
            ->where('id', '!=', $stock->id)
            ->where('gudang_id', $stock->gudang_id)
            ->where('product_variant_id', $stock->product_variant_id)
            ->exists();

        if ($duplicate) {
            throw new \RuntimeException('Data stok duplikat untuk gudang & varian yang sama.');
        }
    }

    /**
     * Penerimaan stok ke lot baru (IN) + update agregat + ledger.
     */
    public function receiveLot(
        int $gudangId,
        int $variantId,
        int $qty,
        ?string $lotNo = null,
        string|\DateTimeInterface|null $receivedAt = null, // 'Y-m-d' atau timestamp
        string|\DateTimeInterface|null $expiresAt = null,  // 'Y-m-d' (opsional)
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

            // 1) Ambil gudang & cabang
            $gudang = Gudang::query()->with('cabang')->findOrFail($gudangId);

            // 2) Lock baris stok agregat per (gudang, variant)
            /** @var VariantStock|null $stock */
            $stock = VariantStock::query()
                ->where('gudang_id', $gudang->id)
                ->where('product_variant_id', $variantId)
                ->lockForUpdate()
                ->first();

            if (!$stock) {
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

            // 3) Normalisasi tanggal (422 bila invalid)
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

            // 4) Auto-generate lot_no bila kosong
            if ($lotNo === null || trim($lotNo) === '') {
                // Contoh pola: LOT-YYYYMMDD-G<gudang>-<4digit>
                $lotNo = sprintf('LOT-%s-G%02d-%04d', now()->format('Ymd'), $gudang->id, random_int(0, 9999));
            }

            // 5) Update agregat
            $stock->qty += (int) $qty;
            $stock->save();

            // 6) Buat layer lot
            $lot = StockLot::create([
                'cabang_id'          => $gudang->cabang_id,
                'gudang_id'          => $gudang->id,
                'product_variant_id' => $variantId,
                'lot_no'             => $lotNo,
                'received_at'        => $received,   // Carbon instance → aman untuk pgsql
                'expires_at'         => $expires,    // 'Y-m-d' atau null
                'qty_received'       => (int) $qty,
                'qty_remaining'      => (int) $qty,
                'unit_cost'          => $unitCost,
                // jika StockLot tidak punya kolom 'note/ref_type/ref_id', jangan set di sini
            ]);

            // 7) Ledger IN
            StockMovement::create([
                'cabang_id'          => $gudang->cabang_id,
                'gudang_id'          => $gudang->id,
                'product_variant_id' => $variantId,
                'stock_lot_id'       => $lot->id,
                'type'               => 'IN',
                'qty'                => (int) $qty,     // positif untuk IN
                'unit_cost'          => $unitCost,
                'ref_type'           => $refType,
                'ref_id'             => $refId,
                'note'               => $note ?? 'RECEIVE',
            ]);

            return $lot;
        });
    }

    /**
     * Pengeluaran stok per FIFO ketika penjualan dibayar.
     * Membuat alokasi lot untuk audit & COGS.
     */
    public function allocateFifoAndDeduct(
        int $gudangId,
        int $variantId,
        int $orderItemId,
        int $qty,
        ?string $note = null,
        ?string $refType = 'SALE',
        ?string $refId = null,
        ?int $cabangId = null, // opsional; jika null akan diambil dari gudang
    ): void {
        DB::transaction(function () use ($gudangId, $variantId, $orderItemId, $qty, $note, $refType, $refId, $cabangId) {
            if ($qty <= 0) {
                throw new RuntimeException('Qty keluaran harus > 0');
            }

            // Pastikan cabang_id
            if ($cabangId === null) {
                $gudang = Gudang::query()->with('cabang')->findOrFail($gudangId);
                $cabangId = (int) $gudang->cabang_id;
            }

            // Ambil lot tertua (received_at ASC, fallback created_at ASC)
            $lots = StockLot::query()
                ->where('gudang_id', $gudangId)
                ->where('product_variant_id', $variantId)
                ->where('qty_remaining', '>', 0)
                ->orderByRaw('COALESCE(received_at, created_at) ASC, id ASC')
                ->lockForUpdate()
                ->get();

            $remain = (int) $qty;

            foreach ($lots as $lot) {
                if ($remain <= 0) break;

                $take = min($remain, (int)$lot->qty_remaining);
                if ($take <= 0) continue;

                // Kurangi sisa lot
                $lot->qty_remaining -= $take;
                $lot->save();

                // Ledger OUT (qty negatif)
                StockMovement::create([
                    'cabang_id' => $cabangId,
                    'gudang_id' => $gudangId,
                    'product_variant_id' => $variantId,
                    'stock_lot_id' => $lot->id,
                    'type' => 'OUT',
                    'qty' => -$take,
                    'unit_cost' => $lot->unit_cost,
                    'ref_type' => $refType,
                    'ref_id' => $refId ?? (string)$orderItemId,
                    'note' => $note ?? 'SALE',
                ]);

                // Jejak alokasi lot ke item order
                OrderItemLotAllocation::create([
                    'order_item_id' => $orderItemId,
                    'stock_lot_id' => $lot->id,
                    'qty_allocated' => $take,
                    'unit_cost' => $lot->unit_cost,
                ]);

                $remain -= $take;
            }

            if ($remain > 0) {
                throw new RuntimeException('Stok tidak mencukupi per FIFO (lot habis).');
            }

        // Turunkan agregat variant_stocks
            /** @var VariantStock $stock */
            $stock = VariantStock::query()
                ->where('gudang_id', $gudangId)
                ->where('product_variant_id', $variantId)
                ->lockForUpdate()
                ->firstOrFail();

            if ($stock->qty < (int)$qty) {
                throw new RuntimeException('Stok agregat kurang (inkonsisten).');
            }

            $stock->qty -= (int)$qty;
            $stock->save();
        });
    }
}
