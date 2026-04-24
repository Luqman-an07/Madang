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
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('order_id')->constrained();
            $table->string('midtrans_order_id')->unique();
            $table->enum('payment_type', ['dp', 'pelunasan', 'full_payment']);
            $table->integer('gross_amount');
            $table->string('snap_token')->nullable();
            $table->enum('status', ['pending', 'settlement', 'expire', 'deny'])->default('pending');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};
