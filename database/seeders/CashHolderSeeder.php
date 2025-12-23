<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Cabang;
use App\Models\CashHolder;

class CashHolderSeeder extends Seeder
{
    public function run(): void
    {
        // Ambil semua cabang yang ada
        $branchIds = Cabang::query()->pluck('id');

        if ($branchIds->isEmpty()) {
            $this->command?->warn('Tidak ada data cabang. Seeder cash_holders dilewati.');
            return;
        }

        // Minimal 1 holder standar per cabang
        $defaultNames = ['Kasir', 'Brankas', 'Bank'];

        foreach ($branchIds as $branchId) {
            foreach ($defaultNames as $name) {
                // Idempoten: (cabang_id, name) sebagai kunci unik logis
                CashHolder::query()->updateOrCreate(
                    ['cabang_id' => $branchId, 'name' => $name],
                    ['balance'   => 0] // saldo awal 0; bisa Anda ubah jika perlu
                );
            }
        }
    }
}
