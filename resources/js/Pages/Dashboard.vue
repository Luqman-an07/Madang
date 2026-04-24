<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head } from '@inertiajs/vue3';
</script>

<template>
    <AdminLayout>
        <Head title="Dashboard Admin" />

        <div class="mb-8">
            <h1 class="text-2xl sm:text-3xl font-serif font-bold text-solafide-text">Dashboard</h1>
            <p class="text-gray-500 font-medium mt-1">Ringkasan operasional Dapur Solafide & Pawon Soemito hari ini.</p>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            
            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 flex items-center gap-4">
                <div class="h-14 w-14 rounded-full bg-orange-100 text-orange-600 flex items-center justify-center flex-shrink-0">
                    <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <div>
                    <p class="text-sm font-bold text-gray-500">Menunggu DP</p>
                    <p class="text-2xl font-extrabold text-solafide-text">5</p>
                </div>
            </div>

            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 flex items-center gap-4">
                <div class="h-14 w-14 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center flex-shrink-0">
                    <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 002-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path></svg>
                </div>
                <div>
                    <p class="text-sm font-bold text-gray-500">PO Diproses</p>
                    <p class="text-2xl font-extrabold text-solafide-text">12</p>
                </div>
            </div>

            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 flex items-center gap-4">
                <div class="h-14 w-14 rounded-full bg-green-100 text-green-600 flex items-center justify-center flex-shrink-0">
                    <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4"></path></svg>
                </div>
                <div>
                    <p class="text-sm font-bold text-gray-500">Menu Aktif</p>
                    <p class="text-2xl font-extrabold text-solafide-text">24</p>
                </div>
            </div>

            <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 flex items-center gap-4">
                <div class="h-14 w-14 rounded-full bg-solafide-gold bg-opacity-20 text-yellow-700 flex items-center justify-center flex-shrink-0">
                    <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <div>
                    <p class="text-sm font-bold text-gray-500">Bulan Ini</p>
                    <p class="text-xl font-extrabold text-solafide-text">Rp 4.5Jt</p>
                </div>
            </div>

        </div>

        <div class="bg-white rounded-2xl p-8 shadow-sm border border-gray-100 text-center">
            <h3 class="text-lg font-bold text-gray-400 mb-2">Selamat Datang di Area Manajemen</h3>
            <p class="text-gray-500">Silakan gunakan menu di sebelah kiri untuk mengelola master data produk atau mengecek pesanan pelanggan.</p>
        </div>

    </AdminLayout>
</template>