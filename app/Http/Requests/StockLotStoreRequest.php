<?php

// app/Http/Requests/StockLotStoreRequest.php
namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StockLotStoreRequest extends FormRequest
{
    public function authorize(): bool
    {
        // sesuaikan policy Anda
        return $this->user()?->can('create', \App\Models\StockLot::class) ?? false;
    }

    protected function prepareForValidation(): void
    {
        // Normalisasi tipe data
        if ($this->has('received_at')) {
            $dt = $this->date('received_at'); // Carbon|null
            if ($dt) $this->merge(['received_at' => $dt->toDateTimeString()]);
        }
        if ($this->has('expires_at')) {
            $d = $this->date('expires_at');
            if ($d) $this->merge(['expires_at' => $d->toDateString()]);
        }
    }

    public function rules(): array
    {
        return [
            'cabang_id'          => ['required', 'integer', 'min:1'],
            'gudang_id'          => ['required', 'integer', 'min:1'],
            'product_variant_id' => ['required', 'integer', 'min:1'],

            // Jika kolom lot_no bertipe VARCHAR (rekomendasi)
            'lot_no'             => ['required', 'string', 'max:50'],

            'received_at'        => ['required', 'date'],
            'expires_at'         => ['nullable', 'date', 'after_or_equal:received_at'],

            'qty_received'       => ['required', 'integer', 'min:1'],
            'unit_cost'          => ['nullable', 'numeric', 'min:0'],
        ];
    }
}
