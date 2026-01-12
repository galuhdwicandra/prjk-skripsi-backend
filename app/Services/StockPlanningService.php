<?php

namespace App\Services;

use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class StockPlanningService
{
    /**
     * Estimasi ROP sederhana:
     * ROP = ceil(AvgDailyDemand * lead_time_days) + (safety_stock ?: 0)
     * AvgDailyDemand dari histori 30 hari terakhir pada gudang+variant.
     */
    public function estimateReorderPoint(int $gudangId, int $variantId, int $lookbackDays = 30): ?int
    {
        $from = Carbon::now()->subDays($lookbackDays)->startOfDay();
        $to   = Carbon::now()->endOfDay();

        // Ambil qty terjual dari order_items join orders (status PAID) pada gudang tsb
        $sold = (int) DB::table('order_items as oi')
            ->join('orders as o', 'o.id', '=', 'oi.order_id')
            ->where('o.gudang_id', $gudangId)
            ->where('oi.variant_id', $variantId)
            ->where('o.status', 'PAID')
            ->whereBetween('o.paid_at', [$from, $to])
            ->sum('oi.qty');

        $days = max(1, $lookbackDays);
        $avgDaily = $sold / $days;

        $vs = DB::table('variant_stocks')
            ->where('gudang_id', $gudangId)
            ->where('product_variant_id', $variantId)
            ->first();

        $lt = (int) ($vs->lead_time_days ?? 0);
        $ss = (int) ($vs->safety_stock ?? 0);

        if ($lt <= 0 && $ss <= 0 && $avgDaily <= 0) {
            return null; // tidak cukup data
        }

        return (int) ceil(($avgDaily * max(0, $lt)) + max(0, $ss));
    }
}
