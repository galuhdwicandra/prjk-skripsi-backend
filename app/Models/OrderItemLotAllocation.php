<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class OrderItemLotAllocation extends Model
{
    protected $fillable = ['order_item_id', 'stock_lot_id', 'qty_allocated', 'unit_cost'];
}
