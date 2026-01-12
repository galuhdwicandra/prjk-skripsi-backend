<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('order_item_lot_allocations', function (Blueprint $t) {
            $t->bigIncrements('id');
            $t->unsignedBigInteger('order_item_id');
            $t->unsignedBigInteger('stock_lot_id');
            $t->integer('qty_allocated');
            $t->decimal('unit_cost', 18, 2)->nullable();
            $t->timestamps();

            $t->index(['order_item_id','stock_lot_id']);
        });
    }
    public function down(): void {
        Schema::dropIfExists('order_item_lot_allocations');
    }
};
