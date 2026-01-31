<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use App\Models\Payment;
use App\Models\Order;
use Carbon\Carbon;
use App\Services\OrderSettlementService;

class PaymentWebhookController extends Controller
{
    public function invoice(Request $req)
    {
        $expected = (string) env('XENDIT_CALLBACK_TOKEN');
        $token    = (string) $req->header('X-Callback-Token', '');

        if ($expected !== '' && !hash_equals($expected, $token)) {
            abort(403, 'Invalid callback token');
        }

        $payload = $req->all();
        $status  = strtoupper((string)($payload['status'] ?? ''));
        $extId   = (string)($payload['external_id'] ?? '');

        if ($extId === '') {
            throw ValidationException::withMessages(['external_id' => 'Missing external_id']);
        }

        return DB::transaction(function () use ($status, $extId, $payload) {
            $payment = Payment::lockForUpdate()
                ->where('method', 'XENDIT')
                ->where('ref_no', $extId)
                ->first();

            if (!$payment) abort(404, 'Payment not found');

            $order = Order::lockForUpdate()->findOrFail($payment->order_id);

            if ($status === 'PAID') {
                // Idempotent: kalau payment sudah SUCCESS, tidak perlu update lagi
                if ($payment->status !== 'SUCCESS') {
                    $payment->status = 'SUCCESS';
                    $payment->paid_at = Carbon::now();
                    $payment->payload_json = $payload;
                    $payment->save();
                }

                app(OrderSettlementService::class)->finalizePaid($order->id, $payment->id);
            } elseif (in_array($status, ['EXPIRED', 'VOID', 'FAILED'], true)) {
                if ($payment->status !== 'FAILED') {
                    $payment->status = 'FAILED';
                    $payment->payload_json = $payload;
                    $payment->save();
                }
            }

            return response()->json(['ok' => true]);
        });
    }
}
