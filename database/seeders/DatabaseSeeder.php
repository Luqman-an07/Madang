<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Category;
use App\Models\Product;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Tambah Admin & Customer
        User::create([
            'name' => 'Admin Solafide',
            'email' => 'admin@solafide.com',
            'password' => bcrypt('password'),
            'role' => 'admin',
            'phone' => '081234567890'
        ]);

        User::create([
            'name' => 'customer',
            'email' => 'customer@solafide.com',
            'password' => bcrypt('password'),
            'role' => 'customer',
            'phone' => '089876543210'
        ]);

        // 2. Tambah Kategori
        $cat1 = Category::create(['name' => 'Nasi Kotak', 'slug' => 'nasi-kotak']);
        $cat2 = Category::create(['name' => 'Cake Custom', 'slug' => 'cake-custom']);
        $cat3 = Category::create(['name' => 'Nasi Tumpeng', 'slug' => 'nasi-tumpeng']);

        // 3. Tambah 5 Produk Dummy
        Product::create([
            'category_id' => $cat1->id,
            'name' => 'Nasi Box Ayam Bakar Madu',
            'slug' => Str::slug('Nasi Box Ayam Bakar Madu'),
            'description' => 'Nasi, Ayam Bakar Madu, Sambal Terasi, Lalapan, Kerupuk.',
            'base_price' => 25000,
        ]);

        Product::create([
            'category_id' => $cat1->id,
            'name' => 'Nasi Box Daging Rendang',
            'slug' => Str::slug('Nasi Box Daging Rendang'),
            'description' => 'Nasi, Rendang Daging, Sayur Nangka, Sambal Ijo.',
            'base_price' => 30000,
        ]);

        Product::create([
            'category_id' => $cat2->id,
            'name' => 'Kue Tart Ulang Tahun 20cm',
            'slug' => Str::slug('Kue Tart Ulang Tahun 20cm'),
            'description' => 'Kue tart custom dengan buttercream lembut.',
            'base_price' => 150000,
        ]);

        Product::create([
            'category_id' => $cat3->id,
            'name' => 'Tumpeng Mini Special',
            'slug' => Str::slug('Tumpeng Mini Special'),
            'description' => 'Tumpeng ukuran personal dengan 5 macam lauk.',
            'base_price' => 35000,
        ]);

        Product::create([
            'category_id' => $cat2->id,
            'name' => 'Bentoo Cake Custom',
            'slug' => Str::slug('Bentoo Cake Custom'),
            'description' => 'Kue mini ukuran 10cm dalam box styrofoam.',
            'base_price' => 50000,
        ]);
    }
}
