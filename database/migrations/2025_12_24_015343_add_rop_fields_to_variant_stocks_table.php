<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::table('variant_stocks', function (Blueprint $t) {
            $t->integer('safety_stock')->nullable();
            $t->integer('lead_time_days')->nullable();     // dalam hari
            $t->integer('reorder_point')->nullable();      // opsional: materialized ROP
        });
    }
    public function down(): void
    {
        Schema::table('variant_stocks', function (Blueprint $t) {
            $t->dropColumn(['safety_stock', 'lead_time_days', 'reorder_point']);
        });
    }
};
