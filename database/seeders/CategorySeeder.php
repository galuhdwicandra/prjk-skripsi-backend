<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;
use Illuminate\Support\Str;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        $defaults = [
            'Yummy Class', 'Tasty Class', 'Flavourful Class', 'Tube Class'
        ];

        foreach ($defaults as $nama) {
            Category::query()->firstOrCreate(
                ['slug' => Str::slug($nama)],
                [
                    'nama'      => $nama,
                    'deskripsi' => null,
                    'is_active' => true,
                ]
            );
        }
    }
}
