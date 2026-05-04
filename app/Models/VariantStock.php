<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;

class VariantStock extends Model
{
    protected $fillable = [
        'cabang_id',
        'gudang_id',
        'product_variant_id',
        'qty',
        'min_stok',
        'safety_stock',
        'lead_time_days',
        'reorder_point',
    ];

    protected $casts = [
        'cabang_id'          => 'integer',
        'gudang_id'          => 'integer',
        'product_variant_id' => 'integer',
        'qty'                => 'integer',
        'min_stok'           => 'integer',
        'safety_stock'       => 'integer',
        'lead_time_days'     => 'integer',
        'reorder_point'      => 'integer',
    ];

    protected $appends = [
        'is_low_stock',
        'reorder_point_eff',
        'is_below_rop',
    ];

    /*
    |--------------------------------------------------------------------------
    | Relations
    |--------------------------------------------------------------------------
    */

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

    /*
    |--------------------------------------------------------------------------
    | Scopes
    |--------------------------------------------------------------------------
    */

    public function scopeOfCabang(Builder $query, int $cabangId): Builder
    {
        return $query->where('cabang_id', $cabangId);
    }

    public function scopeOfGudang(Builder $query, int $gudangId): Builder
    {
        return $query->where('gudang_id', $gudangId);
    }

    public function scopeLowStock(Builder $query): Builder
    {
        return $query
            ->whereNotNull('min_stok')
            ->whereColumn('qty', '<', 'min_stok');
    }

    public function scopeBelowRop(Builder $query): Builder
    {
        return $query
            ->where(function (Builder $q) {
                $q->where(function (Builder $manual) {
                    $manual
                        ->whereNotNull('reorder_point')
                        ->whereColumn('qty', '<=', 'reorder_point');
                })
                    ->orWhere(function (Builder $fallback) {
                        $fallback
                            ->whereNull('reorder_point')
                            ->whereNotNull('min_stok')
                            ->whereColumn('qty', '<=', 'min_stok');
                    });
            });
    }

    /*
    |--------------------------------------------------------------------------
    | Accessors
    |--------------------------------------------------------------------------
    */

    public function getIsLowStockAttribute(): bool
    {
        if ($this->min_stok === null) {
            return false;
        }

        return (int) $this->qty < (int) $this->min_stok;
    }

    public function getReorderPointEffAttribute(): ?int
    {
        if ($this->reorder_point !== null) {
            return (int) $this->reorder_point;
        }

        if ($this->min_stok !== null) {
            return (int) $this->min_stok;
        }

        return null;
    }

    public function getIsBelowRopAttribute(): bool
    {
        $rop = $this->reorder_point_eff;

        if ($rop === null) {
            return false;
        }

        return (int) $this->qty <= (int) $rop;
    }
}
