<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    // Daftarkan semua kolom yang boleh diisi melalui form/request
    protected $fillable = [
        'name',
        'slug',
        'brand',
        'is_active'
    ];
}
