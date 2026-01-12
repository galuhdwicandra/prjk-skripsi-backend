<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VariantStock extends Model
{
    protected $fillable = [
        'cabang_id',
        'gudang_id',
        'product_variant_id',
        'qty',
        'min_stok',
    ];

    protected $casts = [
        'qty' => 'integer',
        'min_stok' => 'integer',
    ];

    // RELATIONS
    public function cabang()
    {
        return $this->belongsTo(Cabang::class, 'cabang_id');
    }

    public function gudang()
    {
        return $this->belongsTo(Gudang::class, 'gudang_id');
    }

    public function variant()
    {
        return $this->belongsTo(ProductVariant::class, 'product_variant_id');
    }

    // SCOPES
    public function scopeOfCabang($q, $cabangId)
    {
        return $q->where('cabang_id', $cabangId);
    }

    public function scopeLowStock($q)
    {
        return $q->whereColumn('qty', '<', 'min_stok');
    }

    public function getIsLowStockAttribute(): bool
    {
        return $this->qty < $this->min_stok;
    }

    public function getReorderPointEffAttribute(): ?int
    {
        // Prioritas: gunakan kolom 'reorder_point' bila ada, fallback hitung dinamis
        if (!is_null($this->reorder_point)) return (int)$this->reorder_point;

        // Fallback kalkulasi ringan berdasar histori (lihat service di bawah)
        return app(\App\Services\StockPlanningService::class)
            ->estimateReorderPoint($this->gudang_id, $this->product_variant_id);
    }

    public function scopeBelowRop($q)
    {
        return $q->whereColumn('qty', '<=', 'reorder_point');
    }
}
