<?php
namespace App\Http\Controllers\Api\Inventory;

use App\Http\Controllers\Controller;
use App\Models\StockLot;
use App\Services\VariantStockService;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class StockLotController extends Controller
{
    public function __construct(private VariantStockService $service)
    {}

    // GET /api/v1/stock-lots
    public function index(Request $r)
    {
        $this->authorize('viewAny', \App\Models\VariantStock::class);

        $q = StockLot::query()
            ->with([
                'variant:id,product_id,size,type,tester,sku,harga,is_active',
                'variant.product:id,nama',
                'gudang:id,nama',
                'cabang:id,nama',
            ])
            ->when($r->filled('cabang_id'), fn($x) => $x->where('cabang_id', $r->integer('cabang_id')))
            ->when($r->filled('gudang_id'), fn($x) => $x->where('gudang_id', $r->integer('gudang_id')))
            ->when($r->filled('product_variant_id'), fn($x) => $x->where('product_variant_id', $r->integer('product_variant_id')))
            ->when($r->filled('only_available'), function ($x) use ($r) {
                if ($r->boolean('only_available')) {
                    $x->where('qty_remaining', '>', 0);
                }
            })
            ->orderByRaw('COALESCE(received_at, created_at) ASC, id ASC');

        return response()->json([
            'data'    => $q->get(),
            'meta'    => [],
            'message' => 'OK',
            'errors'  => [],
        ]);
    }

    // POST /api/v1/stock-lots
    public function store(Request $r)
    {
        $this->authorize('create', \App\Models\VariantStock::class);

        $v = $r->validate([
            'cabang_id'          => ['required', 'integer'], // dipakai untuk kontrol akses/logika lain, TIDAK dikirim ke service
            'gudang_id'          => ['required', 'integer'],
            'product_variant_id' => ['required', 'integer'],
            'qty'                => ['required', 'integer', 'min:1'],
            'lot_no'             => ['nullable', 'string', 'max:100'],
            'received_at'        => ['required', 'date', 'date_format:Y-m-d'],
            'expires_at'         => ['nullable', 'date', 'date_format:Y-m-d', 'after_or_equal:received_at'],
            'unit_cost'          => ['nullable', 'numeric', 'min:0'],
            'note'               => ['nullable', 'string', 'max:255'],
            'ref_type'           => ['nullable', 'string', 'max:100'],
            'ref_id'             => ['nullable', 'string', 'max:100'],
        ]);

        // Guard ekstra agar kode LOT tidak pernah lolos sebagai tanggal
        if (is_string($v['received_at']) && str_starts_with($v['received_at'], 'LOT-')) {
            throw ValidationException::withMessages([
                'received_at' => ['received_at harus berupa tanggal format YYYY-MM-DD, bukan kode LOT.'],
            ]);
        }

        // Panggil service (service sudah mengelola transaksi DB)
        $lot = $this->service->receiveLot(
            (int) $v['gudang_id'],                                   // 1) gudangId
            (int) $v['product_variant_id'],                          // 2) variantId
            (int) $v['qty'],                                         // 3) qty
            $v['lot_no'] ?? null,                                    // 4) lotNo (boleh null → auto-generate di service)
            $v['received_at'],                                       // 5) receivedAt (YYYY-MM-DD)
            $v['expires_at'] ?? null,                                // 6) expiresAt (YYYY-MM-DD|null)
            isset($v['unit_cost']) ? (float) $v['unit_cost'] : null, // 7) unitCost
            $v['note'] ?? null,                                      // 8) note
            $v['ref_type'] ?? null,                                  // 9) refType
            $v['ref_id'] ?? null                                     // 10) refId
        );

        return response()->json(['data' => $lot], 201);
    }
}
