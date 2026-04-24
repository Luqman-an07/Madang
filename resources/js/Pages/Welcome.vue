<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import GuestLayout from '@/Layouts/GuestLayout.vue';
import { ref } from 'vue';

const currentSlide = ref(0);
const slides = [
    '/storage/dummy-cake1.jpg',
    '/storage/dummy-cake2.jpg',
    '/storage/dummy-cake3.jpg'
];

const showLoginModal = ref(false);

const handleMulaiPesan = () => {
    showLoginModal.value = true;
    setTimeout(() => {
        router.visit(route('login'));
    }, 2000);
};
</script>

<template>
    <GuestLayout>
        <Head title="Beranda | Madang" />

        <div class="w-full flex-grow flex flex-col-reverse md:flex-row items-center justify-center px-6 md:px-20 py-12 md:py-20 gap-10 md:gap-20">
            <div class="w-full md:w-1/2 flex flex-col items-center">
                <div class="relative w-full max-w-md aspect-square bg-solafide-text rounded-3xl overflow-hidden shadow-2xl flex items-center justify-center text-solafide-gold">
                    <span class="font-serif text-2xl opacity-50">Visual Produk</span>
                </div>
                <div class="flex gap-3 mt-6">
                    <button v-for="(slide, index) in slides" :key="index" 
                        class="w-4 h-4 rounded-full transition-colors duration-300"
                        :class="currentSlide === index ? 'bg-solafide-text' : 'bg-gray-300'"
                        @click="currentSlide = index">
                    </button>
                </div>
            </div>

            <div class="w-full md:w-1/2 text-center md:text-left flex flex-col items-center md:items-start">
                <h1 class="text-4xl md:text-6xl font-serif font-extrabold leading-tight mb-6">
                    Madang <br>
                    <span class="text-2xl md:text-4xl font-sans font-medium">dan</span> <br>
                    Lego Legi
                </h1>
                <p class="text-lg md:text-xl font-medium mb-10 max-w-md leading-relaxed opacity-90">
                    Dari produk makanan hingga minuman yang lezat – semua dibuat dengan bahan berkualitas tinggi dan penuh cinta.
                </p>
                <button @click="handleMulaiPesan" class="bg-solafide-primary text-white text-lg font-bold uppercase tracking-wider py-4 px-10 rounded-full shadow-lg hover:shadow-xl hover:bg-orange-500 transform hover:-translate-y-1 transition duration-300">
                    Mulai Pesan
                </button>
            </div>
        </div>

        <div v-if="showLoginModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-60 transition-opacity backdrop-blur-sm px-4">
            <div class="bg-solafide-bg text-solafide-text rounded-3xl p-8 max-w-lg w-full shadow-2xl text-center border-2 border-solafide-gold transform transition-all">
                <h2 class="text-2xl md:text-3xl font-serif font-bold leading-tight mb-6">
                    Mau lanjut pesan?<br>Masuk ke akunmu dulu ya...
                </h2>
                <div class="flex items-center justify-center gap-4 bg-white bg-opacity-50 py-4 px-6 rounded-2xl">
                    <svg class="animate-spin h-6 w-6 text-solafide-primary" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    <p class="font-medium text-lg">Kamu bakal diarahkan ke halaman login...</p>
                </div>
            </div>
        </div>
    </GuestLayout>
</template>