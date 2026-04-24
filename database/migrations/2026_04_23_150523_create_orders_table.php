<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->string('order_number')->unique();
            $table->foreignId('user_id')->constrained();
            $table->enum('status', [
                'pending_quote',
                'awaiting_dp',
                'processing',
                'awaiting_full_payment',
                'completed',
                'cancelled_by_customer',
                'cancelled_by_admin',
                'refunded'
            ])->default('pending_quote');
            $table->text('shipping_address');
            $table->dateTime('required_date');
            $table->integer('subtotal')->default(0);
            $table->integer('shipping_cost')->default(0);
            $table->integer('grand_total')->default(0);
            $table->text('custom_notes')->nullable();
            $table->text('rejection_reason')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
