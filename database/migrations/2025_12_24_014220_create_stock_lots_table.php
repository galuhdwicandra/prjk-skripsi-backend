<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('stock_lots', function (Blueprint $t) {
            $t->bigIncrements('id');
            $t->unsignedBigInteger('cabang_id');
            $t->unsignedBigInteger('gudang_id');
            $t->unsignedBigInteger('product_variant_id');
            $t->string('lot_no', 100)->nullable();
            $t->timestamp('received_at')->nullable();
            $t->date('expires_at')->nullable();

            $t->integer('qty_received');
            $t->integer('qty_remaining');

            $t->decimal('unit_cost', 18, 2)->nullable();

            $t->timestamps();

            $t->index(['gudang_id', 'product_variant_id', 'received_at']);
            $t->index(['gudang_id', 'product_variant_id', 'expires_at']);
        });
    }
    public function down(): void
    {
        Schema::dropIfExists('stock_lots');
    }
};
