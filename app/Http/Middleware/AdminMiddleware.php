<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AdminMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        // Cek apakah user sudah login DAN role-nya adalah admin
        if (auth()->check() && auth()->user()->role === 'admin') {
            return $next($request); // Silakan lewat
        }

        // Jika dia customer (atau belum login) tapi iseng mengetik URL admin, tendang ke halaman beranda
        return redirect('/'); 
    }
}