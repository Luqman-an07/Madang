<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue';
import { Link, usePage, router } from '@inertiajs/vue3';

const page = usePage();
const user = computed(() => page.props.auth?.user || { name: 'Admin', role: 'Staff' });

// --- State Sidebar (TIDAK BERUBAH) ---
const isSidebarOpen = ref(false); 
const isMinified = ref(localStorage.getItem('sidebar-minified') === 'true'); 
const isMasterDataOpen = ref(false);
const isLogoutModalOpen = ref(false);

watch(isMinified, (val) => {
    localStorage.setItem('sidebar-minified', val);
});

const toggleSidebar = () => {
    isMinified.value = !isMinified.value;
    isMasterDataOpen.value = false;
};

const toggleMasterData = (e) => {
    e.stopPropagation();
    isMasterDataOpen.value = !isMasterDataOpen.value;
};

const closeMenus = (e) => {
    if (!e.target.closest('.master-data-container')) {
        isMasterDataOpen.value = false;
    }
};

onMounted(() => window.addEventListener('click', closeMenus));
onUnmounted(() => window.removeEventListener('click', closeMenus));

const handleLogout = () => {
    router.post(route('logout'));
};

const initials = computed(() => user.value.name.charAt(0).toUpperCase());

// --- State Navbar Baru ---
const currentTime = ref(new Date().toLocaleDateString('id-ID', { 
    weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' 
}));
</script>

<template>
    <div class="min-h-screen bg-[#F8F9FA] flex font-sans text-solafide-text">
        
        <aside 
            :class="[
                isSidebarOpen ? 'translate-x-0' : '-translate-x-full',
                isMinified ? 'lg:w-20' : 'lg:w-72',
                'z-[60]' 
            ]"
            class="fixed lg:static inset-y-0 left-0 bg-[#2D241E] text-white transition-all duration-300 ease-in-out lg:translate-x-0 flex flex-col shadow-2xl"
        >
            <div class="h-20 flex items-center px-4 bg-[#1A1511] border-b border-gray-800 overflow-hidden">
                <div class="flex items-center gap-3 min-w-[200px]">
                    <div class="h-10 w-10 rounded-xl bg-solafide-gold flex-shrink-0 flex items-center justify-center font-black text-solafide-text shadow-lg">M</div>
                    <div v-if="!isMinified" class="transition-opacity duration-300">
                        <p class="text-lg font-serif font-bold italic text-solafide-gold leading-none">Madang</p>
                        <p class="text-[10px] uppercase tracking-widest text-gray-400 font-bold">Admin Panel</p>
                    </div>
                </div>
            </div>

            <nav :class="isMinified ? 'overflow-visible' : 'overflow-y-auto overflow-x-hidden'" class="flex-1 px-3 py-6 space-y-2 custom-scrollbar">
                <div class="relative group">
                    <Link :href="route('dashboard')" class="flex items-center gap-4 px-3 py-3 rounded-xl transition-all duration-200" :class="route().current('dashboard') ? 'bg-solafide-primary text-white shadow-lg' : 'text-gray-400 hover:bg-gray-800 hover:text-white'">
                        <svg class="w-6 h-6 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" /></svg>
                        <span v-if="!isMinified" class="font-bold whitespace-nowrap text-sm">Dashboard</span>
                    </Link>
                    <span v-if="isMinified" class="absolute left-16 top-1/2 -translate-y-1/2 bg-solafide-primary text-white text-[10px] font-black uppercase tracking-widest px-3 py-2 rounded-lg opacity-0 group-hover:opacity-100 pointer-events-none transition-all duration-200 z-[100] shadow-2xl whitespace-nowrap border border-white/10">Dashboard</span>
                </div>

                <div class="pt-4 pb-2 px-3">
                    <div v-if="!isMinified" class="text-[10px] font-black text-gray-500 uppercase tracking-[0.2em]">Manajemen</div>
                    <hr v-else class="border-gray-800">
                </div>

                <div class="relative group master-data-container">
                    <button @click="toggleMasterData" class="w-full flex items-center justify-between px-3 py-3 rounded-xl transition-all duration-200" :class="[(route().current('categories.*') || isMasterDataOpen) ? 'bg-gray-800 text-white' : 'text-gray-400 hover:bg-gray-800 hover:text-white', isMinified ? 'justify-center' : '']">
                        <div class="flex items-center gap-4">
                            <svg class="w-6 h-6 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4" /></svg>
                            <span v-if="!isMinified" class="font-bold whitespace-nowrap text-sm">Master Data</span>
                        </div>
                        <svg v-if="!isMinified" :class="isMasterDataOpen ? 'rotate-180' : ''" class="w-4 h-4 transition-transform duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" /></svg>
                    </button>
                    <span v-if="isMinified && !isMasterDataOpen" class="absolute left-16 top-1/2 -translate-y-1/2 bg-gray-700 text-white text-[10px] font-black uppercase tracking-widest px-3 py-2 rounded-lg opacity-0 group-hover:opacity-100 pointer-events-none transition-all duration-200 z-[100] shadow-2xl whitespace-nowrap border border-white/10">Master Data</span>
                    <div v-if="isMinified && isMasterDataOpen" class="absolute left-full top-0 ml-4 w-52 bg-[#1A1511] rounded-2xl shadow-2xl border border-gray-800 py-2 z-[110] animate-in fade-in slide-in-from-left-2 duration-200">
                        <div class="px-4 py-2 border-b border-gray-800 mb-1">
                            <span class="text-[10px] font-black uppercase text-solafide-gold tracking-widest">Master Data</span>
                        </div>
                        <Link :href="route('categories.index')" class="block px-4 py-2.5 text-sm font-bold text-gray-400 hover:text-white hover:bg-gray-800 transition">Kelola Kategori</Link>
                        <Link :href="route('products.index')" class="block px-4 py-2.5 text-sm font-bold text-gray-400 hover:text-white hover:bg-gray-800 transition">Kelola Produk</Link>
                    </div>
                    <div v-if="isMasterDataOpen && !isMinified" class="mt-2 ml-6 space-y-1 border-l border-gray-700 pl-4 transition-all duration-300">
                        <Link :href="route('categories.index')" class="block py-2 px-3 text-sm font-semibold rounded-lg transition-colors" :class="route().current('categories.*') ? 'text-solafide-gold' : 'text-gray-400 hover:text-white'">Kelola Kategori</Link>
                        <Link :href="route('products.index')" class="block py-2 px-3 text-sm font-semibold rounded-lg transition-colors" :class="route().current('products.*') ? 'text-solafide-gold' : 'text-gray-400 hover:text-white'">Kelola Produk</Link>
                    </div>
                </div>

                <div class="relative group">
                    <button @click="isLogoutModalOpen = true" class="w-full flex items-center gap-4 px-3 py-3 rounded-xl text-red-400 hover:bg-red-500 hover:text-white transition-all mt-4">
                        <svg class="w-6 h-6 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" /></svg>
                        <span v-if="!isMinified" class="font-bold whitespace-nowrap text-sm">Logout</span>
                    </button>
                    <span v-if="isMinified" class="absolute left-16 top-1/2 -translate-y-1/2 bg-red-600 text-white text-[10px] font-black uppercase tracking-widest px-3 py-2 rounded-lg opacity-0 group-hover:opacity-100 pointer-events-none transition-all duration-200 z-[100] shadow-2xl whitespace-nowrap border border-white/10">Keluar</span>
                </div>
            </nav>

            <div class="p-4 border-t border-gray-800">
                <button @click="toggleSidebar" class="w-full flex items-center justify-center p-2 rounded-lg bg-gray-800 hover:bg-gray-700 text-gray-400 hover:text-white transition-all">
                    <svg :class="{'rotate-180': isMinified}" class="w-6 h-6 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7" /></svg>
                </button>
            </div>
        </aside>

        <div class="flex-1 flex flex-col min-h-screen overflow-hidden">
            
            <header class="h-20 bg-white/80 backdrop-blur-md border-b border-gray-200 flex items-center justify-between px-8 z-30 sticky top-0">
                <div class="flex items-center gap-6">
                    <button @click="isSidebarOpen = true" class="lg:hidden p-2 rounded-lg bg-gray-100 text-gray-600 hover:bg-solafide-primary hover:text-white transition-all">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" /></svg>
                    </button>
                    
                    <div class="hidden md:block">
                        <p class="text-[10px] font-black text-solafide-primary uppercase tracking-[0.2em] mb-0.5">Sistem Manajemen</p>
                        <h2 class="text-lg font-serif font-bold text-solafide-text leading-tight capitalize">
                            {{ route().current().split('.')[0] }}
                        </h2>
                    </div>
                </div>

                <div class="flex items-center gap-4 md:gap-8">
                    <div class="hidden xl:flex items-center gap-2 text-gray-400">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                        <span class="text-xs font-bold">{{ currentTime }}</span>
                    </div>

                    <div class="flex items-center gap-4 group cursor-pointer border-l border-gray-200 pl-4 md:pl-8">
                        <div class="text-right leading-tight hidden sm:block">
                            <p class="text-sm font-black text-solafide-text group-hover:text-solafide-primary transition-colors">{{ user.name }}</p>
                            <p class="text-[9px] text-gray-400 font-black uppercase tracking-widest">{{ user.role }}</p>
                        </div>
                        
                        <div class="relative">
                            <div class="h-11 w-11 rounded-2xl bg-solafide-text text-solafide-gold flex items-center justify-center font-bold shadow-lg transform group-hover:rotate-6 transition-all duration-300">
                                {{ initials }}
                            </div>
                            <div class="absolute -bottom-1 -right-1 h-4 w-4 bg-green-500 border-4 border-white rounded-full"></div>
                        </div>
                    </div>
                </div>
            </header>

            <main class="flex-1 overflow-y-auto p-6 md:p-10">
                <slot />
            </main>
        </div>

        <div v-if="isLogoutModalOpen" class="fixed inset-0 z-[150] flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
            <div class="bg-white rounded-[2.5rem] w-full max-w-sm p-10 shadow-2xl text-center scale-in border border-white">
                <div class="w-20 h-20 bg-red-100 text-red-500 rounded-3xl flex items-center justify-center mx-auto mb-6 rotate-12">
                    <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" /></svg>
                </div>
                <h2 class="text-2xl font-serif font-bold text-solafide-text mb-2">Akhiri Sesi?</h2>
                <p class="text-sm text-gray-500 font-medium mb-10">Pastikan semua pekerjaan Anda telah tersimpan sebelum keluar.</p>
                <div class="flex gap-4">
                    <button @click="isLogoutModalOpen = false" class="flex-1 px-4 py-3 font-bold text-gray-400 hover:underline transition">Batal</button>
                    <button @click="handleLogout" class="flex-1 px-4 py-4 bg-red-500 text-white rounded-2xl font-black uppercase tracking-widest shadow-lg shadow-red-200 hover:bg-red-600 transition">Keluar</button>
                </div>
            </div>
        </div>

        <div v-if="isSidebarOpen" @click="isSidebarOpen = false" class="fixed inset-0 bg-black/50 z-[90] lg:hidden"></div>
    </div>
</template>

<style scoped>
/* Animasi & Scrollbar Tetap Sesuai Permintaan */
.scale-in { animation: scaleIn 0.2s cubic-bezier(0.34, 1.56, 0.64, 1); }
@keyframes scaleIn { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }
.custom-scrollbar::-webkit-scrollbar { width: 4px; }
.custom-scrollbar::-webkit-scrollbar-thumb { background: #4B3F35; border-radius: 10px; }
</style>