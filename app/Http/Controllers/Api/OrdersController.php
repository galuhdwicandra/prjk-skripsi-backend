<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\OrderSetCashPositionRequest;
use App\Http\Requests\Orders\IndexOrdersRequest;
use App\Http\Requests\Orders\ReprintReceiptRequest;
use App\Http\Requests\Orders\ResendWARequest;
use App\Http\Requests\Orders\UpdateOrderItemsRequest;
use App\Models\Order;
use App\Services\OrderService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class OrdersController extends Controller
{
    public function __construct(private OrderService $service)
    {}

    public function index(IndexOrdersRequest $req)
    {
        $this->authorize('viewAny', Order::class);
        $user      = $req->user();
        $paginator = $this->service->list(
            $req->validated(),
            $user->role === 'superadmin' ? null : $user->cabang_id
        );
        // Jika $paginator instanceof LengthAwarePaginator, kembalikan langsung agar shape sesuai harapan frontend
        return response()->json($paginator);
    }

    public function show(Request $req, Order $order)
    {
        $this->authorize('view', $order);

        $order->load([
            'payments',
            'items.lotAllocations.stockLot' => function ($q) {
                $q->select([
                    'id',
                    'cabang_id',
                    'gudang_id',
                    'product_variant_id',
                    'lot_no',
                    'received_at',
                    'expires_at',
                    'qty_received',
                    'qty_remaining',
                    'unit_cost',
                    'created_at',
                    'updated_at',
                ]);
            },
        ]);

        $order->items->each(function ($item) {
            $item->setAttribute(
                'fifo_allocations',
                $item->lotAllocations->map(function ($allocation) {
                    $lot = $allocation->stockLot;

                    return [
                        'id'            => $allocation->id,
                        'order_item_id' => $allocation->order_item_id,
                        'stock_lot_id'  => $allocation->stock_lot_id,
                        'qty_allocated' => (int) $allocation->qty_allocated,
                        'unit_cost'     => $allocation->unit_cost,
                        'lot'           => $lot ? [
                            'id'            => $lot->id,
                            'lot_no'        => $lot->lot_no,
                            'received_at'   => optional($lot->received_at)->toDateString(),
                            'expires_at'    => optional($lot->expires_at)->toDateString(),
                            'qty_received'  => (int) $lot->qty_received,
                            'qty_remaining' => (int) $lot->qty_remaining,
                            'unit_cost'     => $lot->unit_cost,
                        ] : null,
                    ];
                })->values()
            );

            unset($item->lotAllocations);
        });

        return response()->json(['data' => $order]);
    }

    public function updateItems(UpdateOrderItemsRequest $req, Order $order)
    {
        $this->authorize('update', $order);
        $updated = $this->service->updateItems($order, $req->validated(), $req->user()->id);
        return response()->json(['message' => 'Order updated', 'data' => $updated]);
    }

    public function reprint(ReprintReceiptRequest $req, Order $order)
    {
        $this->authorize('reprint', $order);
        $payload = $this->service->reprintReceipt($order, $req->validated()['format'] ?? null, $req->user()->id);
        return response()->json(['message' => 'Receipt generated', 'data' => $payload]);
    }

    public function setCashPosition(OrderSetCashPositionRequest $req, Order $order)
    {
        $this->authorize('setCashPosition', $order);

        $v = $req->validated();

        return DB::transaction(function () use ($order, $v) {
            $before               = $order->cash_position;
            $order->cash_position = $v['cash_position']; // CUSTOMER | CASHIER | SALES | ADMIN
            $order->save();

            if (class_exists(\App\Models\OrderChangeLog::class)) {
                \App\Models\OrderChangeLog::create([
                    'order_id'    => $order->id,
                    'actor_id'    => Auth::id(),
                    'action'      => 'SET_CASH_POSITION',
                    'diff_json'   => ['before' => $before, 'after' => $order->cash_position],
                    'occurred_at' => now(),
                ]);
            }

            return response()->json($order->fresh(['items', 'payments']));
        });
    }

    public function resendWA(ResendWARequest $req, Order $order)
    {
        $this->authorize('resendWA', $order);
        $payload = $this->service->resendWA(
            $order,
            $req->validated()['phone'],
            $req->validated()['message'] ?? null,
            $req->user()->id
        );
        return response()->json(['message' => 'WA link created', 'data' => $payload]);
    }
}
