<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class OrderItemLotAllocation extends Model
{
    protected $fillable = [
        'order_item_id',
        'stock_lot_id',
        'qty_allocated',
        'unit_cost',
    ];

    protected $casts = [
        'qty_allocated' => 'integer',
        'unit_cost' => 'decimal:2',
    ];

    public function orderItem(): BelongsTo
    {
        return $this->belongsTo(OrderItem::class, 'order_item_id');
    }

    public function stockLot(): BelongsTo
    {
        return $this->belongsTo(StockLot::class, 'stock_lot_id');
    }
}