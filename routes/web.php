<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\Admin\CategoryController;
use App\Http\Controllers\Admin\ProductController;
use App\Http\Controllers\Admin\TransactionController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

/*
|--------------------------------------------------------------------------
| Public Routes
|--------------------------------------------------------------------------
*/

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
})->name('welcome');


/*
|--------------------------------------------------------------------------
| Customer Routes (Authenticated Users)
|--------------------------------------------------------------------------
*/
Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('/home', function () {
        return Inertia::render('Home');
    })->name('home');

    // Profile Management (Shared by Admin & Customer)
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});


/*
|--------------------------------------------------------------------------
| Admin Routes (Restricted Access)
|--------------------------------------------------------------------------
*/
Route::middleware(['auth', 'verified', 'admin'])
    ->prefix('admin') // URL akan menjadi /admin/...
    ->group(function () {

        // Dashboard Admin
        Route::get('/dashboard', function () {
            return Inertia::render('Dashboard');
        })->name('dashboard');

        // Master Data: Kelola Kategori

        Route::controller(CategoryController::class)->group(function () {
            Route::patch('/categories/bulk-status', 'bulkStatus')->name('categories.bulkStatus');
            Route::delete('/categories/bulk', 'bulkDestroy')->name('categories.bulkDestroy');
            Route::patch('/categories/{category}/status', 'updateStatus')->name('categories.updateStatus');

            Route::get('/categories', 'index')->name('categories.index');
            Route::post('/categories', 'store')->name('categories.store');
            Route::put('/categories/{category}', 'update')->name('categories.update');
            Route::delete('/categories/{category}', 'destroy')->name('categories.destroy');
        });

        // Master Data: Kelola Produk/Menu
        Route::patch('/products/bulk-status', [ProductController::class, 'bulkStatus'])->name('products.bulkStatus');
        Route::delete('/products/bulk', [ProductController::class, 'bulkDestroy'])->name('products.bulkDestroy');
        Route::patch('/products/{product}/status', [ProductController::class, 'updateStatus'])->name('products.updateStatus');
        Route::resource('/products', ProductController::class)->names([
            'index' => 'products.index',
            'store' => 'products.store',
            'update' => 'products.update',
            'destroy' => 'products.destroy',
        ]);

        // Custom Routes (Harus di atas resource)
        Route::patch('/transactions/bulk-status', [TransactionController::class, 'bulkStatus'])->name('transactions.bulkStatus');
        Route::delete('/transactions/bulk', [TransactionController::class, 'bulkDestroy'])->name('transactions.bulkDestroy');

        // Resource Route
        Route::resource('/transactions', TransactionController::class)->names([
            'index' => 'transactions.index',
            'store' => 'transactions.store',
            'update' => 'transactions.update',
            'destroy' => 'transactions.destroy',
        ]);
    });

/*
|--------------------------------------------------------------------------
| Auth Routes (Breeze Defaults)
|--------------------------------------------------------------------------
*/
require __DIR__ . '/auth.php';
