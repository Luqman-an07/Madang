<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\User;
use App\Models\Product;
use Faker\Factory as Faker;

class OrderSeeder extends Seeder
{
    public function run(): void
    {
        $faker = Faker::create('id_ID');

        // Mengambil semua user dan produk yang ada di database
        $users = User::all();
        $products = Product::all();

        // Jika tabel users atau products masih kosong, hentikan seeder
        if ($users->isEmpty() || $products->isEmpty()) {
            $this->command->info('Data Users atau Products masih kosong. Buat minimal 1 data terlebih dahulu.');
            return;
        }

        // Membuat 10 data order dummy
        for ($i = 0; $i < 10; $i++) {
            $shippingCost = $faker->randomElement([15000, 25000, 35000]);
            $subtotal = 0;

            $order = Order::create([
                'order_number' => 'ORD-' . strtoupper($faker->bothify('???###')),
                'user_id' => $users->random()->id,
                'status' => $faker->randomElement(['awaiting_dp', 'awaiting_full_payment', 'processing']),
                'shipping_address' => $faker->address,
                'required_date' => $faker->dateTimeBetween('now', '+2 weeks'),
                'subtotal' => 0, // Akan diupdate setelah item dihitung
                'shipping_cost' => $shippingCost,
                'grand_total' => 0, // Akan diupdate setelah item dihitung
                'custom_notes' => $faker->optional()->sentence,
            ]);

            // Membuat 1 sampai 3 item untuk setiap order
            $itemCount = rand(1, 3);
            for ($j = 0; $j < $itemCount; $j++) {
                $product = $products->random();
                $qty = rand(1, 4);
                $price = $product->base_price; // Mengambil harga dari tabel products
                $itemSubtotal = $qty * $price;

                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $product->id,
                    'quantity' => $qty,
                    'price' => $price,
                    'subtotal' => $itemSubtotal,
                ]);

                $subtotal += $itemSubtotal;
            }

            // Update total di tabel orders
            $order->update([
                'subtotal' => $subtotal,
                'grand_total' => $subtotal + $shippingCost,
            ]);
        }
    }
}
