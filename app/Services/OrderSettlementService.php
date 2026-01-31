<?php

namespace App\Services;

use App\Models\Order;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class OrderSettlementService
{
    public function finalizePaid(int $orderId, ?int $paymentId = null): Order
    {
        return DB::transaction(function () use ($orderId) {
            /** @var Order $order */
            $order = Order::lockForUpdate()->findOrFail($orderId);

            // idempotent guard: kalau sudah PAID, jangan potong stok lagi
            if ($order->status === 'PAID') {
                return $order;
            }

            // pastikan benar-benar lunas (recompute paid_total dari DB)
            $paid = (float) $order->payments()
                ->where('status', 'SUCCESS')
                ->sum('amount');

            $order->paid_total = $paid;

            if ($paid < (float) $order->grand_total) {
                // belum lunas → jangan potong stok
                $order->status = 'UNPAID';
                $order->paid_at = null;
                $order->save();
                return $order;
            }

            // lunas → set PAID
            $order->status = 'PAID';
            $order->paid_at = Carbon::now();
            $order->save();

            // potong stok (sekali)
            $salesInv = app(SalesInventoryService::class);
            $items = $order->items()->get(['id','variant_id','qty']);

            foreach ($items as $it) {
                $salesInv->deductOnPaid(
                    gudangId: (int) $order->gudang_id,
                    variantId: (int) $it->variant_id,
                    qty: (float) $it->qty,
                    note: 'SALE#' . (string) $order->kode,
                    orderItemId: (int) $it->id,
                    orderKode: (string) $order->kode
                );
            }

            return $order;
        });
    }
}
