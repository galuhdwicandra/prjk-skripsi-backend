<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class StockMovement extends Model
{
    protected $fillable = [
        'cabang_id',
        'gudang_id',
        'product_variant_id',
        'stock_lot_id',
        'type',
        'qty',
        'unit_cost',
        'ref_type',
        'ref_id',
        'note',
    ];
}
