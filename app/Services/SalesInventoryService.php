<?php

namespace App\Services;

use App\Services\VariantStockService;

class SalesInventoryService
{
    public function __construct(private VariantStockService $stockService) {}

    /**
     * Kurangi stok ketika order berstatus PAID.
     * - Jika $orderItemId diberikan → gunakan FIFO (alokasi lot) via VariantStockService::allocateFifoAndDeduct().
     * - Jika tidak → fallback ke penyesuaian agregat (compat lama).
     *
     * @param int         $gudangId
     * @param int         $variantId
     * @param float       $qty
     * @param string|null $note         Contoh: 'SALE#INV-001'
     * @param int|null    $orderItemId  Wajib untuk FIFO + jejak alokasi lot
     * @param string|null $orderKode    Opsional, untuk catatan ledger (ex: INV-001)
     * @param int|null    $cabangId     Opsional; jika null akan diambil dari gudang
     */
    public function deductOnPaid(
        int $gudangId,
        int $variantId,
        float $qty,
        ?string $note = null,
        ?int $orderItemId = null,
        ?string $orderKode = null,
        ?int $cabangId = null,
    ): void {
        // turunkan ke integer jika stok integral di tabel kamu
        $amount = (int) ceil($qty);

        // Jika ada konteks item order → gunakan FIFO + alokasi lot
        if ($orderItemId !== null) {
            $this->stockService->allocateFifoAndDeduct(
                gudangId: $gudangId,
                variantId: $variantId,
                orderItemId: $orderItemId,
                qty: $amount,
                note: $note ?? ($orderKode ? ('SALE#' . $orderKode) : 'SALE'),
                refType: 'SALE',
                refId: (string) $orderItemId,
                cabangId: $cabangId, // jika null, service akan resolve dari gudang
            );
            return;
        }

        // Fallback legacy: hanya adjust agregat (tanpa jejak lot)
        $stock = \App\Models\VariantStock::query()
            ->where('gudang_id', $gudangId)
            ->where('product_variant_id', $variantId)
            ->firstOrFail();

        $this->stockService->adjust($stock, 'decrease', $amount, $note ?? ($orderKode ? ('SALE#' . $orderKode) : 'SALE'));
        // Catatan: jejak ledger OUT + lot allocation tidak dibuat pada fallback ini.
    }
}
