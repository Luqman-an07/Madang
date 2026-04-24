<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules;
use Illuminate\Validation\ValidationException;
use Inertia\Inertia;
use Inertia\Response;

class RegisteredUserController extends Controller
{
    /**
     * Display the registration view.
     */
    public function create(): Response
    {
        return Inertia::render('Auth/Register');
    }

    /**
     * Handle an incoming registration request.
     *
     * @throws ValidationException
     */
    public function store(Request $request): RedirectResponse
{
    // 1. Validasi Input
    $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|string|lowercase|email|max:255|unique:'.User::class,
        'phone' => 'required|string|min:12|max:20', // Validasi minimal 12 karakter
        'password' => ['required', 'confirmed', \Illuminate\Validation\Rules\Password::defaults()],
    ]);

    // 2. Simpan Data ke Database
    $user = User::create([
        'name' => $request->name,
        'email' => $request->email,
        'phone' => $request->phone,
        'password' => Hash::make($request->password),
        'role' => 'customer', // Menetapkan role default sebagai customer
    ]);

    // 3. Picu Event Registrasi
    event(new Registered($user));

    // 4. Login Otomatis Setelah Daftar
    Auth::login($user);

    // 5. Redirect ke Halaman home (Landing Page)
    // Sesuai diskusi pemisahan hak akses, customer diarahkan ke depan, bukan ke dashboard admin.
    return redirect(route('home', absolute: false));
}
}
