<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Transaction extends Model
{
    protected $fillable = [
        'order_id',
        'midtrans_order_id',
        'payment_type',
        'gross_amount',
        'snap_token',
        'status'
    ];

    // Relasi ke tabel Order (Pastikan Anda sudah punya model Order)
    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }
}
