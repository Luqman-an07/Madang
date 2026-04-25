<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use App\Models\Order; // Untuk dropdown pilihan order
use Illuminate\Http\Request;
use Inertia\Inertia;

class TransactionController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Transaction/Index', [
            // Load transaksi beserta data order dan user-nya
            'transactions' => Transaction::with(['order.user'])->latest()->get(),
            // Load daftar order untuk pilihan dropdown di modal
            'orders' => Order::with('user')->get()
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'order_id' => 'required|exists:orders,id',
            'payment_type' => 'required|in:dp,pelunasan,full_payment',
            'gross_amount' => 'required|numeric|min:0',
            'status' => 'required|in:pending,settlement,expire,deny',
        ]);

        Transaction::create([
            'order_id' => $request->order_id,
            // Simulasi Midtrans Order ID otomatis
            'midtrans_order_id' => 'TRX-' . strtoupper(uniqid()),
            'payment_type' => $request->payment_type,
            'gross_amount' => $request->gross_amount,
            'status' => $request->status,
            'snap_token' => bin2hex(random_bytes(16)), // Simulasi token
        ]);

        return redirect()->back()->with('message', 'Transaksi berhasil dicatat!');
    }

    public function update(Request $request, Transaction $transaction)
    {
        $request->validate([
            'payment_type' => 'required|in:dp,pelunasan,full_payment',
            'gross_amount' => 'required|numeric|min:0',
            'status' => 'required|in:pending,settlement,expire,deny',
        ]);

        $transaction->update($request->only(['payment_type', 'gross_amount', 'status']));

        return redirect()->back()->with('message', 'Transaksi diperbarui!');
    }

    public function destroy(Transaction $transaction)
    {
        $transaction->delete();
        return redirect()->back()->with('message', 'Transaksi dihapus!');
    }

    // Fungsi Tambahan untuk Uji Kompetensi (Bulk Actions)
    public function bulkStatus(Request $request)
    {
        Transaction::whereIn('id', $request->ids)->update(['status' => $request->status]);
        return redirect()->back()->with('message', 'Status massal diperbarui!');
    }

    public function bulkDestroy(Request $request)
    {
        Transaction::whereIn('id', $request->ids)->delete();
        return redirect()->back()->with('message', 'Data terpilih berhasil dihapus!');
    }
}
