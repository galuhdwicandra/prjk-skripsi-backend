<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class StockLot extends Model
{
    protected $fillable = [
        'cabang_id',
        'gudang_id',
        'product_variant_id',
        'lot_no',            // simpan "LOT-2025..." di sini bila VARCHAR
        'received_at',
        'expires_at',
        'qty_received',
        'qty_remaining',
        'unit_cost',
    ];

    protected $casts = [
        'received_at'   => 'datetime',
        'expires_at'    => 'date',
        'qty_received'  => 'integer',
        'qty_remaining' => 'integer',
        'unit_cost'     => 'decimal:2',
    ];

    public function variant(): BelongsTo
    {
        return $this->belongsTo(ProductVariant::class, 'product_variant_id');
    }
    public function gudang(): BelongsTo
    {
        return $this->belongsTo(Gudang::class, 'gudang_id');
    }
    public function cabang(): BelongsTo
    {
        return $this->belongsTo(Cabang::class, 'cabang_id');
    }
}
