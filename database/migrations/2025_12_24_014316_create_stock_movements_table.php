<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('stock_movements', function (Blueprint $t) {
            $t->bigIncrements('id');
            $t->unsignedBigInteger('cabang_id');
            $t->unsignedBigInteger('gudang_id');
            $t->unsignedBigInteger('product_variant_id');
            $t->unsignedBigInteger('stock_lot_id')->nullable();

            $t->enum('type', ['IN','OUT','ADJ']);
            $t->integer('qty');                 // positif untuk IN, negatif untuk OUT, sesuai type
            $t->decimal('unit_cost', 18, 2)->nullable();

            $t->string('ref_type', 100)->nullable();  // 'PURCHASE','SALE','ADJUSTMENT',dst
            $t->string('ref_id', 100)->nullable();
            $t->string('note', 255)->nullable();

            $t->timestamps();

            $t->index(['gudang_id','product_variant_id','created_at']);
        });
    }
    public function down(): void {
        Schema::dropIfExists('stock_movements');
    }
};
