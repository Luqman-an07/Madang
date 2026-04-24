<script setup>
import { Head, Link } from '@inertiajs/vue3';
import GuestLayout from '@/Layouts/GuestLayout.vue';

// Kita gunakan GuestLayout karena Navbar & Footer sama, 
// namun nanti Navbar akan kita buat dinamis.
</script>

<template>
    <GuestLayout>
        <Head title="Beranda Pelanggan" />

        <div class="w-full max-w-7xl mx-auto px-6 py-12">
            <div class="flex flex-col md:flex-row items-center gap-8 mb-16 bg-white bg-opacity-40 p-8 rounded-3xl shadow-sm border border-white">
                <div class="w-full md:w-1/3">
                    <div class="aspect-video bg-solafide-text rounded-2xl overflow-hidden shadow-lg">
                        <div class="w-full h-full flex items-center justify-center text-solafide-gold opacity-50 italic">
                            Foto Unggulan
                        </div>
                    </div>
                </div>
                <div class="w-full md:w-2/3 text-center md:text-left">
                    <h1 class="text-3xl md:text-4xl font-serif font-bold mb-4">
                        Madang dan Lego Legi hadir dalam satu platform!
                    </h1>
                    <p class="text-lg leading-relaxed opacity-90 font-medium">
                        Dari produk makanan hingga minuman yang lezat, semua dibuat dengan bahan berkualitas tinggi dan penuh cinta.
                    </p>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                
                <div class="bg-[#FFDAB9] rounded-[3rem] p-10 flex flex-col items-center text-center shadow-xl border-2 border-orange-100 hover:scale-[1.02] transition-transform duration-300">
                    <div class="h-32 mb-6 flex items-center justify-center">
                        <span class="text-4xl font-serif font-bold italic">Madang</span>
                    </div>
                    <h2 class="text-2xl font-serif font-bold italic mb-4">Produk Makanan dan Minuman yang Lezat~</h2>
                    <p class="text-lg mb-10 font-medium opacity-80">Makanan, Minuman, (dibuat dengan pesanan)</p>
                    
                    <div class="flex flex-wrap justify-center gap-4">
                        <Link href="#" class="bg-solafide-primary text-white font-bold py-3 px-8 rounded-full shadow-md hover:bg-orange-600 transition">LIHAT MENU</Link>
                        <Link href="#" class="bg-solafide-primary text-white font-bold py-3 px-8 rounded-full shadow-md hover:bg-orange-600 transition">MULAI PESAN</Link>
                    </div>
                </div>

                <div class="bg-[#CCEEFF] rounded-[3rem] p-10 flex flex-col items-center text-center shadow-xl border-2 border-blue-100 hover:scale-[1.02] transition-transform duration-300">
                    <div class="h-32 mb-6 flex items-center justify-center">
                        <div class="w-24 h-24 bg-white rounded-full flex items-center justify-center shadow-md italic font-bold text-blue-400">LOGO</div>
                    </div>
                    <h2 class="text-2xl font-serif font-bold italic mb-4">Sesedap Masakan Ibu~</h2>
                    <p class="text-lg mb-10 font-medium opacity-80">Traditional food, Main course, savory</p>
                    
                    <div class="flex flex-wrap justify-center gap-4">
                        <Link href="#" class="bg-blue-500 text-white font-bold py-3 px-8 rounded-full shadow-md hover:bg-blue-600 transition">LIHAT MENU</Link>
                        <Link href="#" class="bg-blue-500 text-white font-bold py-3 px-8 rounded-full shadow-md hover:bg-blue-600 transition">MULAI PESAN</Link>
                    </div>
                </div>

            </div>
        </div>
    </GuestLayout>
</template>