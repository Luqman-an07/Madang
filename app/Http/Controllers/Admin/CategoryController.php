<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;

class CategoryController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Category/Index', [
            'categories' => Category::latest()->get()
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:100',
            'brand' => 'required|in:solafide,pawon_soemito',
            'is_active' => 'required|boolean', // Tambahkan validasi ini
        ]);

        Category::create([
            'name' => $request->name,
            'slug' => Str::slug($request->name) . '-' . rand(10, 99),
            'brand' => $request->brand,
            'is_active' => $request->is_active, // Simpan status
        ]);

        return redirect()->back()->with('message', 'Kategori berhasil ditambahkan!');
    }

    public function update(Request $request, Category $category)
    {
        $request->validate([
            'name' => 'required|string|max:100',
            'brand' => 'required|in:solafide,pawon_soemito',
            'is_active' => 'required|boolean', // Tambahkan validasi ini
        ]);

        $category->update([
            'name' => $request->name,
            'slug' => Str::slug($request->name) . '-' . rand(10, 99),
            'brand' => $request->brand,
            'is_active' => $request->is_active, // Update status
        ]);

        return redirect()->back()->with('message', 'Kategori diperbarui!');
    }

    public function destroy(Category $category)
    {
        $category->delete();
        return redirect()->back()->with('message', 'Kategori dihapus!');
    }

    public function bulkDestroy(Request $request)
    {
        $request->validate([
            'ids' => 'required|array',
            'ids.*' => 'exists:categories,id'
        ]);

        Category::whereIn('id', $request->ids)->delete();

        return redirect()->back()->with('message', count($request->ids) . ' Kategori berhasil dihapus!');
    }

    // ==========================================================
    // FUNGSI BARU UNTUK STATUS ACTIVE/INACTIVE KATEGORI
    // ==========================================================

    public function updateStatus(Category $category)
    {
        $category->update([
            'is_active' => !$category->is_active
        ]);

        return redirect()->back()->with('message', 'Status kategori berhasil diubah!');
    }

    public function bulkStatus(Request $request)
    {
        $request->validate([
            'ids' => 'required|array',
            'ids.*' => 'exists:categories,id',
            'is_active' => 'required|boolean',
        ]);

        Category::whereIn('id', $request->ids)->update([
            'is_active' => $request->is_active
        ]);

        return redirect()->back()->with('message', 'Status kategori terpilih berhasil diubah!');
    }
}
