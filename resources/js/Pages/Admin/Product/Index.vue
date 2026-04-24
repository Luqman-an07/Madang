<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({ products: Array, categories: Array });

// --- State Utama ---
const isModalOpen = ref(false);
const editMode = ref(false);
const isDeleteModalOpen = ref(false);
const isStatusModalOpen = ref(false);
const isBulkDelete = ref(false);
const productToDelete = ref(null);
const imagePreview = ref(null);
const activeActionMenu = ref(null);

// --- State Filter ---
const searchQuery = ref('');
const brandFilter = ref('all');
const statusFilter = ref('all');
const categoryFilter = ref('all');
const sortField = ref('name'); 
const sortOrder = ref('asc');  

// --- State Bulk Action ---
const selectedIds = ref([]);
const bulkStatusTarget = ref(null);

const form = useForm({
    id: null,
    category_id: '',
    name: '',
    base_price: 0,
    description: '',
    is_active: 1,
    image: null,
});

// ============================================================================
// LOGIKA BARU: MENGHITUNG STATISTIK UNTUK BADGE FILTER
// ============================================================================

// Hitung Brand
const countAllBrands = computed(() => props.products.length);
const countSolafide = computed(() => props.products.filter(p => p.category.brand === 'solafide').length);
const countPawon = computed(() => props.products.filter(p => p.category.brand === 'pawon_soemito').length);

// Hitung Status (Validasi dinamis: menyesuaikan brand & kategori yang dipilih)
const countAllStatus = computed(() => {
    let base = props.products;
    if (brandFilter.value !== 'all') base = base.filter(p => p.category.brand === brandFilter.value);
    if (categoryFilter.value !== 'all') base = base.filter(p => p.category_id === categoryFilter.value);
    return base.length;
});

const countActive = computed(() => {
    let base = props.products;
    if (brandFilter.value !== 'all') base = base.filter(p => p.category.brand === brandFilter.value);
    if (categoryFilter.value !== 'all') base = base.filter(p => p.category_id === categoryFilter.value);
    return base.filter(p => p.is_active === 1).length;
});

const countInactive = computed(() => {
    let base = props.products;
    if (brandFilter.value !== 'all') base = base.filter(p => p.category.brand === brandFilter.value);
    if (categoryFilter.value !== 'all') base = base.filter(p => p.category_id === categoryFilter.value);
    return base.filter(p => p.is_active === 0).length;
});

// ============================================================================

// --- Logika Filter & Sorting Utama ---
const filteredProducts = computed(() => {
    let result = [...props.products];

    if (searchQuery.value) {
        result = result.filter(p => p.name.toLowerCase().includes(searchQuery.value.toLowerCase()));
    }
    if (brandFilter.value !== 'all') {
        result = result.filter(p => p.category.brand === brandFilter.value);
    }
    if (statusFilter.value !== 'all') {
        result = result.filter(p => p.is_active === statusFilter.value);
    }
    // Filter Kategori Baru
    if (categoryFilter.value !== 'all') {
        result = result.filter(p => p.category_id === categoryFilter.value);
    }

    result.sort((a, b) => {
        let modifier = sortOrder.value === 'asc' ? 1 : -1;
        let valA = a[sortField.value];
        let valB = b[sortField.value];
        if (typeof valA === 'string') return modifier * valA.localeCompare(valB);
        return modifier * (valA - valB);
    });

    return result;
});

// --- Logic Bulk Action Contextual ---
const hasActiveSelected = computed(() => {
    return selectedIds.value.some(id => props.products.find(p => p.id === id)?.is_active === 1);
});
const hasInactiveSelected = computed(() => {
    return selectedIds.value.some(id => props.products.find(p => p.id === id)?.is_active === 0);
});

// --- Helpers & Actions (TETAP SAMA SEPERTI SEBELUMNYA) ---
const formatRupiah = (val) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(val);
const toggleSort = (field) => { if (sortField.value === field) sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'; else { sortField.value = field; sortOrder.value = 'asc'; } };
const toggleSelectAll = (e) => { selectedIds.value = e.target.checked ? filteredProducts.value.map(p => p.id) : []; };

const openModal = (data = null) => {
    editMode.value = !!data;
    imagePreview.value = data ? `/storage/${data.image}` : null;
    if (data) {
        form.id = data.id; form.category_id = data.category_id; form.name = data.name; form.base_price = data.base_price; form.description = data.description; form.is_active = data.is_active;
    } else { form.reset(); }
    isModalOpen.value = true;
};

const toggleSingleStatus = (product) => { router.patch(route('products.updateStatus', product.id), {}, { preserveScroll: true, onSuccess: () => activeActionMenu.value = null }); };
const confirmDelete = (product) => { isBulkDelete.value = false; productToDelete.value = product; isDeleteModalOpen.value = true; activeActionMenu.value = null; };
const openBulkStatusModal = (status) => { bulkStatusTarget.value = status; isStatusModalOpen.value = true; };
const executeBulkStatus = () => { router.patch(route('products.bulkStatus'), { ids: selectedIds.value, is_active: bulkStatusTarget.value }, { onSuccess: () => { isStatusModalOpen.value = false; selectedIds.value = []; } }); };

const executeDelete = () => {
    if (isBulkDelete.value) {
        router.delete(route('products.bulkDestroy'), { data: { ids: selectedIds.value }, onSuccess: () => { isDeleteModalOpen.value = false; selectedIds.value = []; } });
    } else {
        router.delete(route('products.destroy', productToDelete.value.id), { onSuccess: () => isDeleteModalOpen.value = false });
    }
};

const submit = () => {
    if (editMode.value) {
        router.post(route('products.update', form.id), { _method: 'put', ...form.data(), image: form.image }, { onSuccess: () => isModalOpen.value = false });
    } else { form.post(route('products.store'), { onSuccess: () => isModalOpen.value = false }); }
};

const handleImageChange = (e) => { const file = e.target.files[0]; if (file) { form.image = file; imagePreview.value = URL.createObjectURL(file); } };
const closeAllMenus = (e) => { if (!e.target.closest('.action-menu')) activeActionMenu.value = null; };

onMounted(() => window.addEventListener('click', closeAllMenus));
onUnmounted(() => window.removeEventListener('click', closeAllMenus));
</script>

<template>
    <AdminLayout>
        <Head title="Kelola Produk" />

        <div class="flex flex-col lg:flex-row justify-between items-start lg:items-center gap-4 mb-8">
            <div>
                <h1 class="text-3xl font-serif font-bold text-solafide-text">Daftar Produk</h1>
                <p class="text-sm text-gray-500 font-medium">Atur ketersediaan dan informasi produk Anda.</p>
            </div>
            <button @click="openModal()" class="bg-solafide-primary text-white px-8 py-3.5 rounded-2xl font-black text-xs uppercase tracking-[0.15em] shadow-xl hover:-translate-y-1 transition-all flex items-center gap-3">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4" /></svg>
                Produk Baru
            </button>
        </div>

        <div class="bg-white p-5 rounded-[2rem] shadow-sm border border-gray-100 mb-6 flex flex-col gap-5">
            
            <div class="flex flex-col md:flex-row gap-4">
                <div class="flex-1 relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-gray-400">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
                    </span>
                    <input v-model="searchQuery" type="text" placeholder="Cari berdasarkan nama produk..." class="w-full pl-12 pr-4 py-3.5 rounded-2xl border-2 border-gray-50 bg-gray-50 focus:bg-white focus:border-solafide-primary transition text-sm outline-none font-medium" />
                </div>

                <div class="w-full md:w-72">
                    <select v-model="categoryFilter" class="w-full px-5 py-3.5 rounded-2xl border-2 border-gray-50 bg-gray-50 focus:bg-white focus:border-solafide-primary transition text-sm font-bold text-gray-600 outline-none appearance-none cursor-pointer bg-no-repeat bg-[right_1rem_center]" style="background-image: url('data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 fill=%22none%22 viewBox=%220 0 24 24%22 stroke=%22%239CA3AF%22 stroke-width=%222%22%3E%3Cpath stroke-linecap=%22round%22 stroke-linejoin=%22round%22 d=%22M19 9l-7 7-7-7%22/%3E%3C/svg%3E'); background-size: 1.25rem;">
                        <option value="all">Semua Kategori Menu</option>
                        <option v-for="cat in categories" :key="cat.id" :value="cat.id">
                            {{ cat.name }} ({{ cat.brand === 'solafide' ? 'Solafide' : 'Pawon' }})
                        </option>
                    </select>
                </div>
            </div>

            <hr class="border-gray-100">

            <div class="flex flex-col xl:flex-row items-start xl:items-center justify-between gap-5">
                
                <div class="flex items-center gap-3 w-full xl:w-auto">
                    <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest hidden sm:block">Brand:</span>
                    <div class="flex bg-gray-100 p-1.5 rounded-2xl w-full sm:w-auto overflow-x-auto custom-scrollbar">
                        <button @click="brandFilter = 'all'" :class="brandFilter === 'all' ? 'bg-white shadow text-solafide-primary' : 'text-gray-400 hover:text-gray-600'" class="px-5 py-2 rounded-xl text-[10px] font-black uppercase transition tracking-widest flex items-center gap-2 whitespace-nowrap">
                            Semua <span :class="brandFilter === 'all' ? 'bg-orange-100 text-orange-600' : 'bg-gray-200 text-gray-500'" class="px-2 py-0.5 rounded-md text-[9px]">{{ countAllBrands }}</span>
                        </button>
                        <button @click="brandFilter = 'solafide'" :class="brandFilter === 'solafide' ? 'bg-white shadow text-orange-600' : 'text-gray-400 hover:text-gray-600'" class="px-5 py-2 rounded-xl text-[10px] font-black uppercase transition tracking-widest flex items-center gap-2 whitespace-nowrap">
                            Solafide <span :class="brandFilter === 'solafide' ? 'bg-orange-100 text-orange-600' : 'bg-gray-200 text-gray-500'" class="px-2 py-0.5 rounded-md text-[9px]">{{ countSolafide }}</span>
                        </button>
                        <button @click="brandFilter = 'pawon_soemito'" :class="brandFilter === 'pawon_soemito' ? 'bg-white shadow text-blue-600' : 'text-gray-400 hover:text-gray-600'" class="px-5 py-2 rounded-xl text-[10px] font-black uppercase transition tracking-widest flex items-center gap-2 whitespace-nowrap">
                            Pawon <span :class="brandFilter === 'pawon_soemito' ? 'bg-blue-100 text-blue-600' : 'bg-gray-200 text-gray-500'" class="px-2 py-0.5 rounded-md text-[9px]">{{ countPawon }}</span>
                        </button>
                    </div>
                </div>

                <div class="flex items-center gap-3 w-full xl:w-auto">
                    <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest hidden sm:block">Status:</span>
                    <div class="flex bg-gray-100 p-1.5 rounded-2xl w-full sm:w-auto overflow-x-auto custom-scrollbar">
                        <button @click="statusFilter = 'all'" :class="statusFilter === 'all' ? 'bg-white shadow text-solafide-text' : 'text-gray-400 hover:text-gray-600'" class="px-5 py-2 rounded-xl text-[10px] font-black uppercase transition tracking-widest flex items-center gap-2 whitespace-nowrap">
                            Semua <span :class="statusFilter === 'all' ? 'bg-gray-200 text-solafide-text' : 'bg-gray-200 text-gray-500'" class="px-2 py-0.5 rounded-md text-[9px]">{{ countAllStatus }}</span>
                        </button>
                        <button @click="statusFilter = 1" :class="statusFilter === 1 ? 'bg-green-500 text-white shadow-lg shadow-green-200' : 'text-gray-400 hover:text-green-600'" class="px-5 py-2 rounded-xl text-[10px] font-black uppercase transition tracking-widest flex items-center gap-2 whitespace-nowrap">
                            Aktif <span :class="statusFilter === 1 ? 'bg-white text-green-600' : 'bg-gray-200 text-gray-500'" class="px-2 py-0.5 rounded-md text-[9px]">{{ countActive }}</span>
                        </button>
                        <button @click="statusFilter = 0" :class="statusFilter === 0 ? 'bg-red-500 text-white shadow-lg shadow-red-200' : 'text-gray-400 hover:text-red-600'" class="px-5 py-2 rounded-xl text-[10px] font-black uppercase transition tracking-widest flex items-center gap-2 whitespace-nowrap">
                            Nonaktif <span :class="statusFilter === 0 ? 'bg-white text-red-600' : 'bg-gray-200 text-gray-500'" class="px-2 py-0.5 rounded-md text-[9px]">{{ countInactive }}</span>
                        </button>
                    </div>
                </div>

            </div>
        </div>

        <div v-if="selectedIds.length > 0" class="mb-6 animate-in slide-in-from-top-4 duration-300">
            <div class="bg-solafide-text p-4 rounded-2xl flex items-center justify-between shadow-xl border border-gray-800">
                <div class="flex items-center gap-4 pl-4 border-l-4 border-solafide-gold">
                    <span class="text-white font-bold text-sm">{{ selectedIds.length }} Produk Terpilih</span>
                </div>
                <div class="flex items-center gap-3">
                    <button v-if="hasInactiveSelected" @click="openBulkStatusModal(1)" class="bg-white/10 text-white hover:bg-green-500 px-5 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all border border-white/10">Aktifkan</button>
                    
                    <button v-if="hasActiveSelected" @click="openBulkStatusModal(0)" class="bg-white/10 text-white hover:bg-red-500 px-5 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all border border-white/10">Nonaktifkan</button>
                    
                    <button @click="isBulkDelete = true; isDeleteModalOpen = true" class="bg-red-600 text-white px-5 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest shadow-lg hover:bg-red-700 transition-all ml-2">Hapus Terpilih</button>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-[2.5rem] shadow-sm border border-gray-100 overflow-visible">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-gray-50/50 border-b border-gray-100">
                        <th class="pl-8 py-6 w-10">
                            <input type="checkbox" @change="toggleSelectAll" :checked="selectedIds.length === filteredProducts.length && filteredProducts.length > 0" class="rounded border-gray-300 text-solafide-primary focus:ring-solafide-primary cursor-pointer" />
                        </th>
                        <th class="px-6 py-6 text-[10px] font-black uppercase text-gray-400 tracking-[0.2em]">Info Produk</th>
                        <th @click="toggleSort('name')" class="px-6 py-6 text-[10px] font-black uppercase text-gray-400 tracking-[0.2em] cursor-pointer hover:text-solafide-primary transition-colors group">
                            <div class="flex items-center gap-2">
                                Nama 
                                <svg :class="[sortField === 'name' ? 'opacity-100 text-solafide-primary' : 'opacity-0 group-hover:opacity-100', sortOrder === 'desc' ? 'rotate-180' : '']" class="w-3 h-3 transition-all" fill="currentColor" viewBox="0 0 20 20"><path d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" /></svg>
                            </div>
                        </th>
                        <th class="px-6 py-6 text-[10px] font-black uppercase text-gray-400 tracking-[0.2em]">Kategori</th>
                        <th @click="toggleSort('base_price')" class="px-6 py-6 text-[10px] font-black uppercase text-gray-400 tracking-[0.2em] cursor-pointer hover:text-solafide-primary transition-colors text-right group">
                             <div class="flex items-center justify-end gap-2">
                                Harga
                                <svg :class="[sortField === 'base_price' ? 'opacity-100 text-solafide-primary' : 'opacity-0 group-hover:opacity-100', sortOrder === 'desc' ? 'rotate-180' : '']" class="w-3 h-3 transition-all" fill="currentColor" viewBox="0 0 20 20"><path d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" /></svg>
                             </div>
                        </th>
                        <th class="px-6 py-6 text-[10px] font-black uppercase text-gray-400 tracking-[0.2em] text-center">Status</th>
                        <th class="pr-8 py-6 text-[10px] font-black uppercase text-gray-400 tracking-[0.2em] text-right">Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                    <tr v-for="product in filteredProducts" :key="product.id" :class="selectedIds.includes(product.id) ? 'bg-orange-50/40' : 'hover:bg-gray-50/30'" class="transition-all group">
                        <td class="pl-8 py-5">
                            <input type="checkbox" v-model="selectedIds" :value="product.id" class="rounded border-gray-300 text-solafide-primary focus:ring-solafide-primary cursor-pointer" />
                        </td>
                        <td class="px-6 py-5">
                            <div class="flex items-center gap-4">
                                <img :src="`/storage/${product.image}`" class="w-16 h-16 object-cover rounded-2xl shadow-sm border-2 border-white ring-1 ring-gray-100" />
                                <div>
                                    <span class="text-[9px] font-black text-solafide-gold uppercase tracking-widest block mb-1">PROD-{{ product.id }}</span>
                                    <p class="text-xs text-gray-400 font-medium line-clamp-1 max-w-[150px]">{{ product.description || 'Tanpa deskripsi' }}</p>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-5 font-bold text-solafide-text text-sm capitalize">{{ product.name }}</td>
                        <td class="px-6 py-5">
                            <span class="text-[9px] font-black uppercase text-gray-500 bg-gray-100 px-3 py-1 rounded-full tracking-widest">{{ product.category.name }}</span>
                        </td>
                        <td class="px-6 py-5 font-bold text-solafide-primary text-right text-sm">{{ formatRupiah(product.base_price) }}</td>
                        <td class="px-6 py-5 text-center">
                            <div class="flex justify-center">
                                <span :class="product.is_active ? 'text-green-600 bg-green-50 ring-green-100' : 'text-red-600 bg-red-50 ring-red-100'" class="px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-widest ring-1 ring-inset shadow-sm">
                                    {{ product.is_active ? 'Aktif' : 'Inactive' }}
                                </span>
                            </div>
                        </td>
                        <td class="pr-8 py-5 text-right action-menu">
                            <div class="relative inline-block">
                                <button @click.stop="activeActionMenu = activeActionMenu === product.id ? null : product.id" class="p-2 hover:bg-gray-100 rounded-xl transition-all">
                                    <svg class="w-5 h-5 text-gray-400 group-hover:text-solafide-text" fill="currentColor" viewBox="0 0 20 20"><path d="M10 6a2 2 0 110-4 2 2 0 010 4zM10 12a2 2 0 110-4 2 2 0 010 4zM10 18a2 2 0 110-4 2 2 0 010 4z" /></svg>
                                </button>
                                <div v-if="activeActionMenu === product.id" class="absolute right-0 mt-2 w-48 bg-white rounded-2xl shadow-2xl border border-gray-100 z-[100] py-2 animate-in fade-in slide-in-from-top-2 duration-200">
                                    <button @click="openModal(product)" class="w-full text-left px-5 py-3 text-xs font-black uppercase text-gray-600 hover:bg-gray-50 flex items-center gap-3 transition">
                                        <svg class="w-4 h-4 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" /></svg> Edit
                                    </button>
                                    <button @click="toggleSingleStatus(product)" class="w-full text-left px-5 py-3 text-xs font-black uppercase text-gray-600 hover:bg-gray-50 flex items-center gap-3 transition">
                                        <svg :class="product.is_active ? 'text-red-500' : 'text-green-500'" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4" /></svg> 
                                        {{ product.is_active ? 'Nonaktifkan' : 'Aktifkan' }}
                                    </button>
                                    <hr class="my-1 border-gray-100">
                                    <button @click="confirmDelete(product)" class="w-full text-left px-5 py-3 text-xs font-black uppercase text-red-600 hover:bg-red-50 flex items-center gap-3 transition">
                                        <svg class="w-4 h-4 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg> Hapus
                                    </button>
                                </div>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div v-if="isModalOpen" @click.self="isModalOpen = false" class="fixed inset-0 z-[120] flex items-center justify-center bg-black/40 backdrop-blur-sm p-4 overflow-y-auto">
            <div class="bg-white rounded-[2rem] w-full max-w-4xl shadow-2xl scale-in flex flex-col border border-white/50 my-auto">
                
                <div class="bg-gray-50/80 px-8 py-6 border-b border-gray-100 flex items-center justify-between sticky top-0 z-10 rounded-t-[2rem]">
                    <div>
                        <h2 class="text-xl font-serif font-bold text-solafide-text">
                            {{ editMode ? 'Edit Produk' : 'Produk Baru' }}
                        </h2>
                        <p class="text-xs text-gray-500 font-medium mt-1">Lengkapi informasi detail produk kuliner di bawah ini.</p>
                    </div>
                    <button type="button" @click="isModalOpen = false" class="p-2 bg-white rounded-full text-gray-400 hover:text-red-500 hover:bg-red-50 transition shadow-sm border border-gray-100">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
                    </button>
                </div>

                <form @submit.prevent="submit" class="p-8">
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                        
                        <div class="space-y-6">
                            <div>
                                <label class="flex items-center gap-2 text-[10px] font-black uppercase text-gray-400 tracking-widest mb-2 ml-1">
                                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" /></svg>
                                    Nama Produk
                                </label>
                                <input v-model="form.name" type="text" class="w-full border-2 border-gray-100 rounded-2xl px-5 py-3 focus:ring-4 focus:ring-solafide-primary/10 focus:border-solafide-primary transition outline-none font-bold text-sm" placeholder="Misal: Ayam Bakar Madu" required />
                            </div>

                            <div>
                                <label class="block text-[10px] font-black uppercase text-gray-400 tracking-widest mb-2 ml-1">Pilih Kategori</label>
                                <select v-model="form.category_id" class="w-full border-2 border-gray-100 rounded-2xl px-5 py-3 focus:ring-4 focus:ring-solafide-primary/10 focus:border-solafide-primary transition outline-none font-bold text-sm text-gray-700 appearance-none bg-no-repeat bg-[right_1.25rem_center]" style="background-image: url('data:image/svg+xml,%3Csvg xmlns=%22http://www.w3.org/2000/svg%22 fill=%22none%22 viewBox=%220 0 24 24%22 stroke=%22%239CA3AF%22 stroke-width=%222%22%3E%3Cpath stroke-linecap=%22round%22 stroke-linejoin=%22round%22 d=%22M19 9l-7 7-7-7%22/%3E%3C/svg%3E'); background-size: 1.25rem;" required>
                                    <option value="" disabled>-- Pilih Kategori --</option>
                                    <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }} ({{ cat.brand === 'solafide' ? 'Solafide' : 'Pawon' }})</option>
                                </select>
                            </div>

                            <div>
                                <label class="block text-[10px] font-black uppercase text-gray-400 tracking-widest mb-2 ml-1">Harga Dasar (Rp)</label>
                                <div class="relative">
                                    <span class="absolute inset-y-0 left-0 flex items-center pl-5 font-black text-gray-400">Rp</span>
                                    <input v-model="form.base_price" type="number" class="w-full border-2 border-gray-100 rounded-2xl pl-12 pr-5 py-3 focus:ring-4 focus:ring-solafide-primary/10 focus:border-solafide-primary transition outline-none font-bold text-sm" placeholder="0" required />
                                </div>
                            </div>

                            <div>
                                <label class="block text-[10px] font-black uppercase text-gray-400 tracking-widest mb-2 ml-1">Deskripsi Produk</label>
                                <textarea v-model="form.description" rows="3" class="w-full border-2 border-gray-100 rounded-2xl px-5 py-3 focus:ring-4 focus:ring-solafide-primary/10 focus:border-solafide-primary transition outline-none font-medium text-sm text-gray-600 placeholder-gray-300" placeholder="Tuliskan deskripsi singkat mengenai produk ini..."></textarea>
                            </div>
                        </div>

                        <div class="space-y-6">
                            
                            <div>
                                <label class="block text-[10px] font-black uppercase text-gray-400 tracking-widest mb-2 ml-1">Foto Produk</label>
                                <div class="border-2 border-dashed border-gray-200 rounded-[2rem] p-3 text-center hover:border-solafide-primary hover:bg-solafide-primary/5 transition-colors cursor-pointer relative overflow-hidden group h-56 flex flex-col items-center justify-center bg-gray-50/50">
                                    
                                    <img v-if="imagePreview" :src="imagePreview" class="w-full h-full object-cover rounded-3xl shadow-sm" />
                                    
                                    <div v-else class="flex flex-col items-center justify-center space-y-3">
                                        <div class="w-14 h-14 bg-white rounded-full shadow-sm flex items-center justify-center text-gray-400 group-hover:text-solafide-primary group-hover:scale-110 transition-transform">
                                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                                        </div>
                                        <div>
                                            <p class="text-[11px] font-bold text-gray-500 uppercase tracking-widest">Klik untuk Upload</p>
                                            <p class="text-[9px] text-gray-400 font-medium mt-1">Maks. 2MB (JPG/PNG)</p>
                                        </div>
                                    </div>
                                    
                                    <input type="file" @change="handleImageChange" class="absolute inset-0 opacity-0 cursor-pointer w-full h-full" :required="!editMode" accept="image/png, image/jpeg, image/jpg" />
                                </div>
                            </div>

                            <div>
                                <label class="block text-[10px] font-black uppercase text-gray-400 tracking-widest mb-2 ml-1">Status Ketersediaan</label>
                                <div class="flex bg-gray-100 p-1 rounded-2xl border border-gray-200/50">
                                    <button type="button" @click="form.is_active = 1" :class="form.is_active === 1 ? 'bg-white shadow-sm text-green-600 border-gray-200/50' : 'text-gray-400 border-transparent hover:text-gray-600'" class="flex-1 py-3 rounded-xl border font-black text-xs uppercase tracking-widest transition-all flex items-center justify-center gap-2">
                                        <svg v-if="form.is_active === 1" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg>
                                        Aktif
                                    </button>
                                    <button type="button" @click="form.is_active = 0" :class="form.is_active === 0 ? 'bg-white shadow-sm text-red-600 border-gray-200/50' : 'text-gray-400 border-transparent hover:text-gray-600'" class="flex-1 py-3 rounded-xl border font-black text-xs uppercase tracking-widest transition-all flex items-center justify-center gap-2">
                                        <svg v-if="form.is_active === 0" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" /></svg>
                                        Inactive
                                    </button>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="flex flex-col sm:flex-row items-center justify-end gap-4 pt-8 mt-6 border-t border-gray-100">
                        <button type="button" @click="isModalOpen = false" class="w-full sm:w-auto px-8 py-3.5 font-bold text-sm text-gray-400 hover:text-gray-600 hover:bg-gray-50 rounded-xl transition">
                            Batal
                        </button>
                        <button type="submit" :disabled="form.processing" class="w-full sm:w-auto px-10 py-3.5 bg-solafide-text text-solafide-gold rounded-xl font-black text-xs uppercase tracking-[0.15em] shadow-xl hover:shadow-orange-900/20 hover:-translate-y-0.5 active:translate-y-0 transition-all disabled:opacity-70 flex items-center justify-center gap-2">
                            {{ editMode ? 'Update Produk' : 'Simpan Produk' }}
                            <svg v-if="!form.processing" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg>
                            <svg v-else class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div v-if="isStatusModalOpen" class="fixed inset-0 z-[140] flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
            <div class="bg-white rounded-[2.5rem] w-full max-w-sm p-10 shadow-2xl text-center scale-in border border-white">
                <div :class="bulkStatusTarget === 1 ? 'bg-green-100 text-green-500' : 'bg-red-100 text-red-500'" class="w-20 h-20 rounded-3xl flex items-center justify-center mx-auto mb-6 rotate-12 transition-colors">
                    <svg v-if="bulkStatusTarget === 1" class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg>
                    <svg v-else class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>
                </div>
                <h2 class="text-2xl font-serif font-bold text-solafide-text mb-2">Update Status?</h2>
                <p class="text-sm text-gray-500 font-medium mb-10 tracking-tight">Setel <span class="font-bold text-solafide-text">{{ selectedIds.length }} produk</span> terpilih menjadi <span :class="bulkStatusTarget === 1 ? 'text-green-600' : 'text-red-600'" class="font-black uppercase">{{ bulkStatusTarget === 1 ? 'Aktif' : 'Inactive' }}</span>.</p>
                <div class="flex gap-4">
                    <button @click="isStatusModalOpen = false" class="flex-1 px-4 py-3 font-bold text-gray-400 hover:underline">Batal</button>
                    <button @click="executeBulkStatus" class="flex-1 px-4 py-4 bg-solafide-text text-solafide-gold rounded-2xl font-black uppercase text-[10px] tracking-widest shadow-xl">Ya, Update</button>
                </div>
            </div>
        </div>

        <div v-if="isDeleteModalOpen" class="fixed inset-0 z-[140] flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
            <div class="bg-white rounded-[2.5rem] w-full max-w-sm p-10 shadow-2xl text-center scale-in border border-white">
                <div class="w-20 h-20 bg-red-100 text-red-500 rounded-3xl flex items-center justify-center mx-auto mb-6 rotate-12">
                    <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                </div>
                <h2 class="text-2xl font-serif font-bold text-solafide-text mb-2">{{ isBulkDelete ? 'Hapus Massal?' : 'Hapus Produk?' }}</h2>
                <p v-if="isBulkDelete" class="text-sm text-gray-500 font-medium mb-10 tracking-tight">Hapus <span class="font-bold text-red-600">{{ selectedIds.length }} produk</span> yang dipilih secara permanen.</p>
                <p v-else class="text-sm text-gray-500 font-medium mb-10 tracking-tight">Hapus <span class="font-bold text-solafide-text">"{{ productToDelete?.name }}"</span> selamanya.</p>
                <div class="flex gap-4">
                    <button @click="isDeleteModalOpen = false; isBulkDelete = false" class="flex-1 px-4 py-3 font-bold text-gray-400 hover:underline">Batal</button>
                    <button @click="executeDelete" class="flex-1 px-4 py-4 bg-red-500 text-white rounded-2xl font-black uppercase text-[10px] tracking-widest shadow-lg">Ya, Hapus</button>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<style scoped>
.scale-in { animation: scaleIn 0.2s cubic-bezier(0.34, 1.56, 0.64, 1); }
@keyframes scaleIn { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }
</style>