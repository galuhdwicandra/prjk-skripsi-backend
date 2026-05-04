<?php
namespace App\Services;

use App\Models\Delivery;
use App\Models\DeliveryEvent;
use App\Models\Order;
use App\Models\User;
use App\Services\CheckoutService;
use Illuminate\Filesystem\FilesystemAdapter;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\ValidationException;

class DeliveryService
{
    /** Status terminal */
    private const TERMINAL = ['DELIVERED', 'FAILED', 'CANCELLED'];

    /** Valid state machine */
    private const TRANSITIONS = [
        'REQUESTED' => ['ASSIGNED', 'CANCELLED'],
        'ASSIGNED'  => ['PICKED_UP', 'ON_ROUTE', 'CANCELLED'],
        'PICKED_UP' => ['ON_ROUTE', 'CANCELLED'],
        'ON_ROUTE'  => ['DELIVERED', 'FAILED', 'CANCELLED'],
        'DELIVERED' => [],
        'FAILED'    => [],
        'CANCELLED' => [],
    ];

    public function createForOrder(int $orderId, string $type, array $payload): Delivery
    {
        $order = Order::with('cabang')->findOrFail($orderId);

        return DB::transaction(function () use ($order, $type, $payload) {
            $delivery = new Delivery([
                'order_id'         => $order->id,
                'type'             => $type,
                'status'           => 'REQUESTED',
                'pickup_address'   => $payload['pickup_address'] ?? null,
                'delivery_address' => $payload['delivery_address'] ?? null,
                'pickup_lat'       => $payload['pickup_lat'] ?? null,
                'pickup_lng'       => $payload['pickup_lng'] ?? null,
                'delivery_lat'     => $payload['delivery_lat'] ?? null,
                'delivery_lng'     => $payload['delivery_lng'] ?? null,
                'requested_at'     => now(),
            ]);
            $delivery->save();

            // event awal
            DeliveryEvent::create([
                'delivery_id' => $delivery->id,
                'status'      => 'REQUESTED',
                'note'        => 'Delivery requested',
                'occurred_at' => now(),
            ]);

            return $delivery;
        });
    }

    public function autoAssign(Delivery $delivery): Delivery
    {
        // ambil kurir di cabang order, urutkan by jumlah tugas aktif
        $cabangId = $delivery->order->cabang_id;

        $candidate = User::role('kurir')
            ->where('cabang_id', $cabangId)
            ->withCount(['deliveries as active_deliveries_count' => function ($q) {
                $q->whereNotIn('status', self::TERMINAL);
            }])
            ->orderBy('active_deliveries_count', 'asc')
            ->orderBy('id', 'asc')
            ->first();

        if (! $candidate) {
            throw ValidationException::withMessages(['assigned_to' => 'Tidak ada kurir tersedia di cabang ini.']);
        }

        return $this->assign($delivery, $candidate->id);
    }

    public function assign(Delivery $delivery, int $userId): Delivery
    {
        if (in_array($delivery->status, ['DELIVERED', 'FAILED', 'CANCELLED'], true)) {
            throw ValidationException::withMessages(['status' => 'Tidak bisa assign pada task yang sudah selesai.']);
        }

        return DB::transaction(function () use ($delivery, $userId) {
            $delivery->assigned_to = $userId;
            // jika masih REQUESTED, ubah ke ASSIGNED
            if ($delivery->status === 'REQUESTED') {
                $delivery->status = 'ASSIGNED';
                DeliveryEvent::create([
                    'delivery_id' => $delivery->id,
                    'status'      => 'ASSIGNED',
                    'note'        => "Assigned to user #{$userId}",
                    'occurred_at' => now(),
                ]);
            }
            $delivery->save();

            return $delivery->fresh();
        });
    }

    public function updateStatus(Delivery $delivery, string $nextStatus, ?string $note = null, ?UploadedFile $photo = null): Delivery
    {
        // validasi transisi
        $allowed = self::TRANSITIONS[$delivery->status] ?? [];
        if (! in_array($nextStatus, $allowed, true)) {
            throw ValidationException::withMessages([
                'status' => "Transisi status tidak valid: {$delivery->status} → {$nextStatus}",
            ]);
        }

        return DB::transaction(function () use ($delivery, $nextStatus, $note, $photo) {
            $photoUrl = null;
            if ($photo instanceof UploadedFile) {
                $path = $photo->store("deliveries/{$delivery->id}/events", 'public');

                /** @var FilesystemAdapter $public */
                $public   = Storage::disk('public');
                $photoUrl = $public->url($path);
            }

            DeliveryEvent::create([
                'delivery_id' => $delivery->id,
                'status'      => $nextStatus,
                'note'        => $note,
                'photo_url'   => $photoUrl,
                'occurred_at' => now(),
            ]);

            $delivery->status = $nextStatus;

            if (in_array($nextStatus, self::TERMINAL, true)) {
                $delivery->completed_at = now();
            }

            $delivery->save();

            // COD sync ketika delivered
            if ($nextStatus === 'DELIVERED') {
                $this->maybeSyncCOD($delivery);

                /** @var FeeService $feeService */
                $feeService = app(FeeService::class);
                $feeService->generateForDeliveredDelivery($delivery->fresh(['order']));
            }

            return $delivery->fresh(['events', 'courier', 'order']);
        });
    }

    public function addEvent(Delivery $delivery, string $status, ?string $note = null, ?UploadedFile $photo = null): DeliveryEvent
    {
        $photoUrl = null;
        if ($photo instanceof UploadedFile) {
            $path = $photo->store("deliveries/{$delivery->id}/events", 'public');

            /** @var FilesystemAdapter $public */
            $public   = Storage::disk('public');
            $photoUrl = $public->url($path);
        }

        return DeliveryEvent::create([
            'delivery_id' => $delivery->id,
            'status'      => $status,
            'note'        => $note,
            'photo_url'   => $photoUrl,
            'occurred_at' => now(),
        ]);
    }

    protected function maybeSyncCOD(Delivery $delivery): void
    {
        // lock order untuk konsistensi
        $order = $delivery->order()->lockForUpdate()->first();

        // contoh logika umum: hanya jika metode COD & belum lunas
        if (($order->payment_method ?? null) === 'COD') {
            $unpaid = max(0.0, (float) $order->grand_total - (float) $order->paid_total);
            if ($unpaid > 0) {
                /** @var CheckoutService $checkout */
                $checkout = app(CheckoutService::class);

                // Salurkan lewat jalur resmi → akan record payment + recompute + set PAID + kurangi stok + generate fee
                $checkout->addPayment($order, [
                    'method'       => 'CASH',
                    'amount'       => $unpaid,
                    'status'       => 'SUCCESS',
                    'paid_at'      => now(),
                    'payload_json' => [
                        // opsional: mapping holder kas bila kamu pakai CashService mirror
                        // 'holder_id' => $someHolderId,
                        'note' => 'Auto COD on delivered',
                    ],
                ]);
            }
        }
    }

    public function buildSuratJalanHtml(Delivery $d): string
    {
        Log::info('SJ_HTML_BUILD_START', ['delivery_id' => $d->id]);

        $d->load([
            'order' => function ($qo) {
                $qo->select(
                    'id',
                    'kode',
                    'cabang_id',
                    'customer_id',
                    'customer_name',
                    'customer_phone',
                    'customer_address',
                    'subtotal',
                    'discount',
                    'grand_total',
                    'paid_total',
                    'status',
                    'created_at'
                )
                    ->with([
                        'items' => fn($qi) => $qi->select(
                            'id',
                            'order_id',
                            'name_snapshot',
                            'qty',
                            'price',
                            DB::raw('NULL::text AS note')
                        ),
                        'customer:id,nama,phone,alamat',
                        'cabang:id,nama,alamat,telepon',
                    ]);
            },
            'courier:id,name,phone',
        ]);

        Log::info('SJ_HTML_BUILD_DATA', [
            'delivery_id' => $d->id,
            'order_id'    => optional($d->order)->id,
            'order_kode'  => optional($d->order)->kode,
            'subtotal'    => optional($d->order)->subtotal,
            'discount'    => optional($d->order)->discount,
            'grand_total' => optional($d->order)->grand_total,
            'paid_total'  => optional($d->order)->paid_total,
            'status'      => optional($d->order)->status,
            'items_count' => optional($d->order?->items)->count() ?? 0,
        ]);

        $order   = $d->order;
        $branch  = $order?->cabang;
        $courier = $d->courier;

        $branchName  = $branch->nama ?? 'Cabang';
        $branchAddr  = $branch->alamat ?? '-';
        $branchPhone = $branch->telepon ?? '-';

        $sjNumber = $d->sj_number ?: $this->fallbackSJNumber($d);
        $now      = now()->format('Y-m-d H:i');
        $type     = strtoupper($d->type ?? 'DELIVERY');

        $orderCode = $order->kode ?? ('ORD#' . $order->id);
        $orderDate = optional($order->created_at)->format('Y-m-d H:i') ?? '-';

        $customerName = $order->customer_name ?? optional($order->customer)->nama ?? '-';

        $customerPhone = $order->customer_phone ?? optional($order->customer)->phone ?? '-';

        $customerAddress = $order->customer_address ?? optional($order->customer)->alamat ?? '-';

        $pickupAddr   = $d->pickup_address ?? $customerAddress;
        $deliveryAddr = $d->delivery_address ?? $customerAddress;

        $grand  = (float) ($order->grand_total ?? 0);
        $paid   = (float) ($order->paid_total ?? 0);
        $dueAmt = max($grand - $paid, 0);

        $paymentStatus = $dueAmt <= 0.00001 ? 'PAID' : ($paid > 0 ? 'PARTIAL' : 'UNPAID');
        $codInfo       = $dueAmt > 0 ? (' (COD: ' . $this->fmtMoney($dueAmt) . ')') : '';

// Items table
        $rows = '';
        foreach (($order->items ?? []) as $i => $it) {
            $rawName = $it->name_snapshot ?? $it->name ?? $it->product_name ?? $it->item_name ?? null;

            $name = $this->e(
                filled($rawName) ? (string) $rawName : ('Item #' . $it->id)
            );

            $qty   = (float) ($it->qty ?? 1);
            $note  = $this->e($it->note ?? '');
            $price = isset($it->price) ? $this->fmtMoney($it->price) : '';
            $sub   = isset($it->price) ? $this->fmtMoney(((float) $it->price) * $qty) : '';

            $rows .= "<tr>
        <td>" . ($i + 1) . "</td>
        <td>{$name}" . ($note ? "<br/><small>{$note}</small>" : "") . "</td>
        <td style='text-align:center'>" . rtrim(rtrim(number_format($qty, 2, ',', '.'), '0'), ',') . "</td>
        <td style='text-align:right'>{$price}</td>
        <td style='text-align:right'>{$sub}</td>
    </tr>";
        }

        $totals = '';
        if (isset($order->grand_total)) {
            $subtotal = isset($order->subtotal) ? $this->fmtMoney($order->subtotal) : '';
            $discount = isset($order->discount) ? $this->fmtMoney($order->discount) : '';
            $tax      = isset($order->tax) ? $this->fmtMoney($order->tax) : '';
            $service  = isset($order->service_fee) ? $this->fmtMoney($order->service_fee) : '';
            $grand    = $this->fmtMoney($order->grand_total ?? 0);
            $paid     = isset($order->paid_total) ? $this->fmtMoney($order->paid_total) : '';
            $dueAmt   = max(($order->grand_total ?? 0) - ($order->paid_total ?? 0), 0);
            $due      = $this->fmtMoney($dueAmt);

            $totals = "
    <tr><td colspan='3'></td><td>Subtotal</td><td style='text-align:right'>{$subtotal}</td></tr>
    <tr><td colspan='3'></td><td>Diskon</td><td style='text-align:right'>{$discount}</td></tr>" .
                ($tax !== '' ? "<tr><td colspan='3'></td><td>Pajak</td><td style='text-align:right'>{$tax}</td></tr>" : "") .
                ($service !== '' ? "<tr><td colspan='3'></td><td>Service</td><td style='text-align:right'>{$service}</td></tr>" : "") .
                "<tr><td colspan='3'></td><td><b>Grand Total</b></td><td style='text-align:right'><b>{$grand}</b></td></tr>
    <tr><td colspan='3'></td><td>Dibayar</td><td style='text-align:right'>{$paid}</td></tr>
    <tr><td colspan='3'></td><td>Sisa/COD</td><td style='text-align:right'>{$due}</td></tr>";
        }

        $qrText      = url("/deliveries/{$d->id}/note");
        $courierLine = $courier ? $this->e("{$courier->name} (WA: {$courier->phone})") : '-';

        $sjNumberEsc      = $this->e($sjNumber);
        $branchNameEsc    = $this->e($branchName);
        $branchAddrEsc    = $this->e($branchAddr);
        $branchPhoneEsc   = $this->e($branchPhone);
        $nowEsc           = $this->e($now);
        $typeEsc          = $this->e($type);
        $paymentStatusEsc = $this->e($paymentStatus);
        $codInfoEsc       = $this->e($codInfo);
        $orderCodeEsc     = $this->e($orderCode);
        $orderDateEsc     = $this->e($orderDate);
        $pickupAddrEsc    = $this->e($pickupAddr);
        $deliveryAddrEsc  = $this->e($deliveryAddr);
        $qrTextEsc        = $this->e($qrText);

        Log::info('SJ_HTML_BUILD_DONE', ['delivery_id' => $d->id]);
        return <<<HTML
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Surat Jalan {$sjNumberEsc}</title>
<style>
  body { font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, Arial; font-size: 12px; color: #111; }
  .wrap { max-width: 720px; margin: 0 auto; padding: 16px; }
  .row { display: flex; gap: 16px; }
  .col { flex: 1; }
  .header { border-bottom: 2px solid #000; margin-bottom: 8px; padding-bottom: 8px; }
  h1 { font-size: 16px; margin: 0; }
  table { width: 100%; border-collapse: collapse; margin-top: 8px; }
  th, td { border: 1px solid #ddd; padding: 6px; vertical-align: top; }
  th { background: #f3f4f6; text-align: left; }
  .meta { font-size: 12px; line-height: 1.6; }
  .muted { color: #666; }
  .sign { height: 64px; border-bottom: 1px dashed #999; margin-top: 24px; }
  .footnote { margin-top: 8px; font-size: 11px; color: #444; }
  .qr { font-size: 11px; color: #555; margin-top: 8px; }
  .btn-print { margin: 8px 0 16px; }
  @media print { .btn-print { display: none; } }
</style>
</head>
<body>
<div class="wrap">
  <div class="header row">
    <div class="col">
        <div><strong>{$branchNameEsc}</strong></div>
        <div class="muted">{$branchAddrEsc}</div>
        <div class="muted">Tel: {$branchPhoneEsc}</div>
    </div>
    <div class="col" style="text-align:right;">
      <h1>SURAT JALAN</h1>
        <div class="meta">No: <b>{$sjNumberEsc}</b></div>
        <div class="meta">Dicetak: {$nowEsc}</div>
    </div>
  </div>

  <button class="btn-print" onclick="window.print()">🖨 Cetak</button>

  <table>
    <tr>
        <th style="width: 25%;">Tipe</th><td>{$typeEsc}</td>
        <th style="width: 25%;">Status Pembayaran</th><td>{$paymentStatusEsc}{$codInfoEsc}</td>
    </tr>
    <tr>
        <th>Ref Order</th><td>{$orderCodeEsc} ({$orderDateEsc})</td>
        <th>Kurir</th><td>{$courierLine}</td>
    </tr>
    <tr>
        <th>Alamat Pickup</th><td>{$pickupAddrEsc}</td>
        <th>Alamat Delivery</th><td>{$deliveryAddrEsc}</td>
    </tr>
  </table>

  <table>
    <thead>
      <tr>
        <th style="width:40px;">No</th>
        <th>Item/Layanan</th>
        <th style="width:64px; text-align:center;">Qty</th>
        <th style="width:100px; text-align:right;">Harga</th>
        <th style="width:120px; text-align:right;">Subtotal</th>
      </tr>
    </thead>
    <tbody>
      {$rows}
      {$totals}
    </tbody>
  </table>

  <div class="row" style="margin-top: 12px;">
    <div class="col">
      <div><b>Checklist</b></div>
      <div class="muted">[ ] Jumlah paket cocok<br/>[ ] Segel/packaging aman<br/>[ ] Catatan khusus diikuti</div>
        <div class="qr">QR: {$qrTextEsc}</div>
    </div>
    <div class="col">
      <div><b>Tanda Terima</b></div>
      <div class="sign"></div>
      <div class="muted">Nama Jelas & Tanggal/Jam</div>
    </div>
  </div>

  <div class="footnote">
    S&K Ringkas: Klaim kerusakan/kehilangan maks 24 jam setelah terima. Hubungi CS Cabang jika ada kendala.
  </div>
</div>
</body>
</html>
HTML;
    }

    public function buildSuratJalanMessage(Delivery $d): string
    {
        Log::info('SJ_MSG_BUILD_START', ['delivery_id' => $d->id]);
        $d->load([
            'order' => function ($qo) {
                $qo->select('id', 'kode', 'cabang_id', 'subtotal', 'discount', 'grand_total', 'paid_total', 'status', 'created_at')
                    ->with([
                        'items' => fn($qi) => $qi->select(
                            'id',
                            'order_id',
                            'name_snapshot',
                            'qty',
                            'price',
                            DB::raw('NULL::text AS note')
                        ),
                        'customer:id,nama,phone,alamat',
                    ]);
            },
        ]);

        Log::info('SJ_MSG_BUILD_DATA', [
            'delivery_id' => $d->id,
            'order_id'    => optional($d->order)->id,
            'order_kode'  => optional($d->order)->kode,
            'grand_total' => optional($d->order)->grand_total,
            'paid_total'  => optional($d->order)->paid_total,
        ]);

        $order = $d->order;

        $sj    = $d->sj_number ?: $this->fallbackSJNumber($d);
        $type  = strtoupper($d->type ?? 'DELIVERY');
        $ocode = $order->kode ?? ('ORD#' . $order->id);
        $odate = optional($order->created_at)->format('Y-m-d H:i') ?? '-';

        $cust = $order->customer_name ?? optional($order->customer)->nama ?? '-';

        $cphone = $order->customer_phone ?? optional($order->customer)->phone ?? '-';

        $customerAddress = $order->customer_address ?? optional($order->customer)->alamat ?? '-';

        $pick = $d->pickup_address ?? $customerAddress;
        $drop = $d->delivery_address ?? $customerAddress;

        $grand = (float) ($order->grand_total ?? 0);
        $paid  = (float) ($order->paid_total ?? 0);
        $due   = max($grand - $paid, 0);
        $paySt = $due <= 0.00001 ? 'PAID' : ($paid > 0 ? 'PARTIAL' : 'UNPAID');
        $cod   = $due > 0 ? (' (COD: ' . $this->fmtMoney($due) . ')') : '';

        $items = $order->items ?? [];
        $summ  = $items ? implode(', ', array_map(function ($it) {
            $rawName = $it->name_snapshot ?? $it->name ?? $it->product_name ?? $it->item_name ?? 'Item';

            return $rawName . ' x' . rtrim(rtrim(number_format((float) ($it->qty ?? 1), 2, ',', '.'), '0'), ',');
        }, $items)) : '-';

        $noteUrl = url("/deliveries/{$d->id}/note");
        $maps    = $d->maps_url ?? '';
        $notes   = trim((string) ($d->notes ?? ''));

        $text = "Surat Jalan #{$sj}\n"
            . "Tipe: {$type}\n"
            . "Order: {$ocode} ({$odate})\n"
            . "Ambil: {$pick}\n"
            . "Kirim ke: {$drop}\n"
            . "Customer: {$cust} ({$cphone})\n"
            . "Item: {$summ}\n"
            . "Pembayaran: {$paySt}{$cod}\n"
            . ($noteUrl ? "Link SJ: {$noteUrl}\n" : "")
            . ($maps ? "Maps: {$maps}\n" : "")
            . ($notes ? "Catatan: {$notes}\n" : "")
            . "Terima kasih.";
        Log::info('SJ_MSG_BUILD_DONE', ['delivery_id' => $d->id]);
        return $text;
    }

    public function resendWASuratJalan(Delivery $d, ?string $overrideMessage = null): array
    {
        Log::info('SJ_WA_SEND_START', ['delivery_id' => $d->id]);

        $d->load([
            'courier:id,name,phone',
            'order' => function ($qo) {
                $qo->select('id', 'kode', 'cabang_id', 'subtotal', 'discount', 'grand_total', 'paid_total', 'status', 'created_at')
                    ->with([
                        'items' => fn($qi) => $qi->select(
                            'id',
                            'order_id',
                            DB::raw('name_snapshot AS name'),
                            'qty',
                            'price',
                            DB::raw('NULL::text AS note')
                        ),
                        'customer:id,nama,phone,alamat',
                    ]);
            },
        ]);

        Log::info('SJ_WA_SEND_DATA', [
            'delivery_id'   => $d->id,
            'courier_id'    => optional($d->courier)->id,
            'courier_phone' => optional($d->courier)->phone,
            'order_id'      => optional($d->order)->id,
            'order_kode'    => optional($d->order)->kode,
        ]);

        $courier = $d->courier;
        if (! $courier || ! $courier->phone) {
            return ['message' => 'Nomor WhatsApp kurir tidak tersedia'];
        }

        $phone = $this->sanitizePhone($courier->phone);
        $text  = $overrideMessage ?: $this->buildSuratJalanMessage($d);
        $waUrl = $this->buildWAUrl($phone, $text);

        // Audit aman (tanpa kolom occurred_at bila table kamu tidak punya)
        try {
            DB::table('audit_logs')->insert([
                'actor_type' => 'USER',
                'actor_id'   => Auth::id(),
                'action'     => 'DELIVERY_WA_SURAT_JALAN',
                'model'      => 'Delivery',
                'model_id'   => $d->id,
                'diff_json'  => json_encode(['wa_url' => $waUrl]),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        } catch (\Throwable $e) {
            // ignore log error
        }

        // Set nomor SJ saat pertama kali kirim (opsional)
        if (! $d->sj_number) {
            $d->sj_number    = $this->generateSJNumber($d);
            $d->sj_issued_at = now();
            $d->save();
        }

        return ['message' => 'OK', 'wa_url' => $waUrl];
    }

    /** ===== Helpers SJ/WA ===== */

    protected function sanitizePhone(?string $phone): string
    {
        $digits = preg_replace('/\D+/', '', (string) $phone);
        if (\Illuminate\Support\Str::startsWith($digits, '0')) {
            $digits = '62' . substr($digits, 1);
        }
        return $digits;
    }

    protected function buildWAUrl(string $phone, string $text): string
    {
        return 'https://wa.me/' . $phone . '?text=' . rawurlencode($text);
    }

    protected function fmtMoney(float | int $n): string
    {
        return 'Rp ' . number_format((float) $n, 0, ',', '.');
    }

    protected function e(string $s): string
    {
        return e($s);
    }

    protected function fallbackSJNumber(Delivery $d): string
    {
        $d->loadMissing(['order.cabang']);
        $nm = $d->order?->cabang?->nama ?? 'CABANG';
        // bikin 2–3 huruf kode dari nama cabang
        $code = strtoupper(substr(preg_replace('/[^A-Za-z]/', '', $nm), 0, 3)) ?: 'CBG';
        return 'SJ-' . $code . '-' . now()->format('Ymd') . '-' . str_pad((string) $d->id, 5, '0', STR_PAD_LEFT);
    }

    protected function generateSJNumber(Delivery $d): string
    {
        // Gampang & deterministik; kalau mau pakai counter, ganti di sini.
        return $this->fallbackSJNumber($d);
    }
}
