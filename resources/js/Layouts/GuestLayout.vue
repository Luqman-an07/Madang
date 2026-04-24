<script setup>
import Navbar from '@/Components/Navbar.vue';
import Footer from '@/Components/Footer.vue';
</script>

<template>
    <div class="min-h-screen flex flex-col bg-solafide-bg text-solafide-text font-sans">
        <Navbar />

        <main class="flex-grow flex items-center justify-center">
            <slot />
        </main>

        <!-- <Footer /> -->
    </div>
</template>