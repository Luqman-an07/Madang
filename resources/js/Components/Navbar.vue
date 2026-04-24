<script setup>
import { Link, usePage } from '@inertiajs/vue3';
import { computed, ref, onMounted, onUnmounted } from 'vue';

const page = usePage();
const user = computed(() => page.props.auth?.user);

// --- Logika Dropdown ---
const isDropdownOpen = ref(false);
const toggleDropdown = () => (isDropdownOpen.value = !isDropdownOpen.value);

// Menutup dropdown jika klik di luar elemen
const closeDropdown = (e) => {
    if (!e.target.closest('#user-menu-button') && !e.target.closest('#user-dropdown')) {
        isDropdownOpen.value = false;
    }
};

onMounted(() => window.addEventListener('click', closeDropdown));
onUnmounted(() => window.removeEventListener('click', closeDropdown));

// --- Logika Inisial Nama ---
const getInitials = (name) => {
    if (!name) return 'U';
    return name.charAt(0).toUpperCase();
};
</script>

<template>
    <header class="bg-solafide-gold py-4 px-6 md:px-16 flex justify-between items-center shadow-md relative z-[100]">
        <div class="flex items-center gap-3">
            <Link :href="user ? route('home') : route('welcome')" class="text-2xl font-serif font-bold italic tracking-wider text-solafide-text">
                Madang
            </Link>
            <div class="hidden sm:block text-[10px] leading-tight font-bold uppercase border-l-2 border-solafide-text pl-3 opacity-80">
                Lego<br>Legi
            </div>
        </div>

        <nav class="hidden md:flex gap-8 font-bold text-sm uppercase tracking-wide">
            <Link :href="user ? route('home') : route('welcome')" class="hover:text-solafide-primary transition" :class="{ 'text-solafide-primary': route().current('home') || route().current('welcome') }">Home</Link>
            <Link href="#" class="hover:text-solafide-primary transition">Daftar Menu</Link>
            <Link v-if="user" href="#" class="hover:text-solafide-primary transition">Pesananmu</Link>
            <!-- <Link href="#" class="hover:text-solafide-primary transition">Tentang Kami</Link> -->
        </nav>

        <div class="flex items-center">
            <Link v-if="!user" :href="route('login')" class="font-bold text-sm uppercase text-solafide-text border-2 border-solafide-text px-6 py-2 rounded-full hover:bg-solafide-text hover:text-solafide-gold transition duration-300">
                Masuk
            </Link>

            <div v-else class="relative">
                <button 
                    @click.stop="toggleDropdown"
                    id="user-menu-button"
                    class="flex items-center gap-3 p-1 pr-3 rounded-full hover:bg-white hover:bg-opacity-30 transition-all duration-200 group"
                >
                    <div class="h-10 w-10 rounded-full bg-solafide-text text-solafide-gold flex items-center justify-center font-bold text-lg shadow-md group-hover:scale-105 transition-transform">
                        {{ getInitials(user.name) }}
                    </div>
                    
                    <div class="hidden md:flex flex-col items-start leading-none">
                        <span class="text-sm font-bold text-solafide-text">{{ user.name }}</span>
                        <span class="text-[9px] uppercase tracking-widest opacity-60 font-black">Pelanggan</span>
                    </div>

                    <svg class="w-4 h-4 transition-transform duration-200" :class="{ 'rotate-180': isDropdownOpen }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                    </svg>
                </button>

                <transition
                    enter-active-class="transition ease-out duration-100"
                    enter-from-class="transform opacity-0 scale-95"
                    enter-to-class="transform opacity-100 scale-100"
                    leave-active-class="transition ease-in duration-75"
                    leave-from-class="transform opacity-100 scale-100"
                    leave-to-class="transform opacity-0 scale-95"
                >
                    <div v-if="isDropdownOpen" id="user-dropdown" class="absolute right-0 mt-2 w-56 bg-white rounded-2xl shadow-xl border border-gray-100 overflow-hidden py-2">
                        <div class="px-4 py-3 border-b border-gray-50 mb-1">
                            <p class="text-xs text-gray-500 font-medium">Masuk sebagai:</p>
                            <p class="text-sm font-bold truncate">{{ user.email }}</p>
                        </div>

                        <Link :href="route('profile.edit')" class="flex items-center gap-3 px-4 py-3 text-sm font-semibold text-gray-700 hover:bg-solafide-bg transition">
                            <svg class="w-5 h-5 opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" /></svg>
                            Setting Profile
                        </Link>

                        <Link :href="route('logout')" method="post" as="button" class="w-full flex items-center gap-3 px-4 py-3 text-sm font-bold text-red-600 hover:bg-red-50 transition border-t border-gray-50">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" /></svg>
                            Keluar
                        </Link>
                    </div>
                </transition>
            </div>
        </div>
    </header>
</template>