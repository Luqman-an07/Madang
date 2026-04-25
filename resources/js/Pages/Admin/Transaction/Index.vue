<script setup>
import AdminLayout from '@/Layouts/AdminLayout.vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({ transactions: Array, orders: Array });

// --- State UI ---
const isModalOpen = ref(false);
const editMode = ref(false);
const isDeleteModalOpen = ref(false);
const isStatusModalOpen = ref(false);
const isBulkDelete = ref(false);
const itemToDelete = ref(null);
const activeActionMenu = ref(null);

// --- State Filter ---
const searchQuery = ref('');
const statusFilter = ref('all');
const sortField = ref('created_at'); 
const sortOrder = ref('desc');  
const selectedIds = ref([]);
const bulkStatusTarget = ref(null);

const form = useForm({
    id: null,
    order_id: '',
    payment_type: 'full_payment',
    gross_amount: 0,
    status: 'pending',
});

// --- Statistik Dynamic Badges ---
const countAll = computed(() => props.transactions.length);
const countSettlement = computed(() => props.transactions.filter(t => t.status === 'settlement').length);
const countPending = computed(() => props.transactions.filter(t => t.status === 'pending').length);
const countFailed = computed(() => props.transactions.filter(t => ['expire', 'deny'].includes(t.status)).length);

// --- Logika Filter & Sorting ---
const filteredTransactions = computed(() => {
    let result = [...props.transactions];
    if (searchQuery.value) {
        result = result.filter(t => 
            t.midtrans_order_id.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
            t.order?.customer_name?.toLowerCase().includes(searchQuery.value.toLowerCase())
        );
    }
    if (statusFilter.value !== 'all') {
        result = result.filter(t => t.status === statusFilter.value);
    }
    result.sort((a, b) => {
        let modifier = sortOrder.value === 'asc' ? 1 : -1;
        if (a[sortField.value] < b[sortField.value]) return -1 * modifier;
        if (a[sortField.value] > b[sortField.value]) return 1 * modifier;
        return 0;
    });
    return result;
});

// --- Helper & UI Logics ---
const formatRupiah = (val) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(val);
const formatDate = (val) => new Date(val).toLocaleDateString('id-ID', { day: 'numeric', month: 'short', year: 'numeric' });

const toggleSort = (field) => {
    if (sortField.value === field) sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
    else { sortField.value = field; sortOrder.value = 'asc'; }
};

const toggleSelectAll = (e) => {
    selectedIds.value = e.target.checked ? filteredTransactions.value.map(t => t.id) : [];
};

// --- Actions: Modal Form ---
const openModal = (data = null) => {
    editMode.value = !!data;
    if (data) {
        form.id = data.id;
        form.order_id = data.order_id;
        form.payment_type = data.payment_type;
        form.gross_amount = data.gross_amount;
        form.status = data.status;
    } else {
        form.reset();
    }
    isModalOpen.value = true;
};

const submit = () => {
    const routeName = editMode.value ? route('transactions.update', form.id) : route('transactions.store');
    form[editMode.value ? 'put' : 'post'](routeName, { onSuccess: () => isModalOpen.value = false });
};

// --- Actions: Bulk Status ---
const executeBulkStatus = (status) => {
    bulkStatusTarget.value = status;
    isStatusModalOpen.value = true;
};

const handleBulkStatus = () => {
    router.patch(route('transactions.bulkStatus'), {
        ids: selectedIds.value,
        status: bulkStatusTarget.value
    }, { 
        onSuccess: () => { 
            isStatusModalOpen.value = false; 
            selectedIds.value = []; 
        } 
    });
};

// --- Actions: Hapus (Single & Bulk) ---
const confirmDelete = (trx) => {
    isBulkDelete.value = false;
    itemToDelete.value = trx;
    isDeleteModalOpen.value = true;
    activeActionMenu.value = null; // Tutup menu aksi
};

const confirmBulkDelete = () => {
    if (selectedIds.value.length === 0) return;
    isBulkDelete.value = true;
    isDeleteModalOpen.value = true;
};

const executeDelete = () => {
    if (isBulkDelete.value) {
        // Mode Hapus Massal
        router.delete(route('transactions.bulkDestroy'), {
            data: { ids: selectedIds.value },
            onSuccess: () => { 
                isDeleteModalOpen.value = false; 
                selectedIds.value = []; 
            }
        });
    } else {
        // Mode Hapus Tunggal
        router.delete(route('transactions.destroy', itemToDelete.value.id), {
            onSuccess: () => { 
                isDeleteModalOpen.value = false; 
                itemToDelete.value = null;
            }
        });
    }
};

// --- Fungsi Cepat Set Lunas Tunggal ---
const setLunasTunggal = (trx) => {
    // Kita manfaatkan route bulkStatus yang sudah ada dengan mengirim 1 ID saja
    router.patch(route('transactions.bulkStatus'), {
        ids: [trx.id],
        status: 'settlement'
    }, { 
        preserveScroll: true,
        onSuccess: () => {
            activeActionMenu.value = null; 
        }
    });
};

// --- Menutup Dropdown Saat Klik di Luar ---
const closeMenus = (e) => {
    if (!e.target.closest('.action-menu')) activeActionMenu.value = null;
};

onMounted(() => window.addEventListener('click', closeMenus));
onUnmounted(() => window.removeEventListener('click', closeMenus));
</script>

<template>
    <AdminLayout>
        <Head title="Kelola Transaksi" />

        <div class="flex flex-col lg:flex-row justify-between items-start lg:items-center gap-4 mb-8">
            <div>
                <h1 class="text-3xl font-serif font-bold text-solafide-text">Data Transaksi</h1>
                <p class="text-sm text-gray-500 font-medium">Laporan pembayaran dan status Midtrans.</p>
            </div>
            <button @click="openModal()" class="bg-solafide-primary text-white px-8 py-3.5 rounded-2xl font-black text-xs uppercase tracking-widest shadow-xl hover:-translate-y-1 transition-all">
                + Tambah Transaksi
            </button>
        </div>

        <div class="bg-white p-5 rounded-[2rem] shadow-sm border border-gray-100 mb-6 flex flex-col gap-5">
            <div class="relative flex-1">
                <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-gray-400">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
                </span>
                <input v-model="searchQuery" type="text" placeholder="Cari Order ID atau Pelanggan..." class="w-full pl-12 pr-4 py-3.5 rounded-2xl border-none bg-gray-50 focus:ring-2 focus:ring-solafide-primary transition text-sm" />
            </div>

            <div class="flex flex-wrap items-center justify-between gap-4 border-t border-gray-50 pt-4">
                <div class="flex bg-gray-100 p-1 rounded-xl">
                    <button @click="statusFilter = 'all'" :class="statusFilter === 'all' ? 'bg-white shadow text-solafide-primary' : 'text-gray-400'" class="px-5 py-2 rounded-lg text-[10px] font-black uppercase transition flex items-center gap-2">
                        Semua <span class="bg-gray-200 text-gray-500 px-1.5 py-0.5 rounded text-[8px]">{{ countAll }}</span>
                    </button>
                    <button @click="statusFilter = 'settlement'" :class="statusFilter === 'settlement' ? 'bg-white shadow text-green-600' : 'text-gray-400'" class="px-5 py-2 rounded-lg text-[10px] font-black uppercase transition flex items-center gap-2">
                        Lunas <span class="bg-green-100 text-green-600 px-1.5 py-0.5 rounded text-[8px]">{{ countSettlement }}</span>
                    </button>
                    <button @click="statusFilter = 'pending'" :class="statusFilter === 'pending' ? 'bg-white shadow text-orange-500' : 'text-gray-400'" class="px-5 py-2 rounded-lg text-[10px] font-black uppercase transition flex items-center gap-2">
                        Pending <span class="bg-orange-100 text-orange-600 px-1.5 py-0.5 rounded text-[8px]">{{ countPending }}</span>
                    </button>
                </div>
            </div>
        </div>

        <div v-if="selectedIds.length > 0" class="mb-6 animate-in slide-in-from-top-4">
            <div class="bg-solafide-text p-4 rounded-2xl flex items-center justify-between shadow-xl border border-gray-800">
                <span class="text-white font-bold text-sm pl-4">{{ selectedIds.length }} Transaksi Terpilih</span>
                <div class="flex gap-2">
                    <button @click="executeBulkStatus('settlement')" class="bg-green-600 text-white px-4 py-2 rounded-xl text-[10px] font-black uppercase">Set Lunas</button>
                    <button @click="isBulkDelete = true; isDeleteModalOpen = true" class="bg-red-600 text-white px-4 py-2 rounded-xl text-[10px] font-black uppercase">Hapus</button>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-[2.5rem] shadow-sm border border-gray-100 overflow-visible">
            <table class="w-full text-left">
                <thead class="bg-gray-50/50 border-b border-gray-100">
                    <tr class="text-[10px] font-black uppercase text-gray-400 tracking-widest">
                        <th class="pl-8 py-6 w-10"><input type="checkbox" @change="toggleSelectAll" class="rounded border-gray-300 text-solafide-primary" /></th>
                        <th class="px-6 py-6">Order ID</th>
                        <th class="px-6 py-6">Tipe Bayar</th>
                        <th class="px-6 py-6 text-right">Total</th>
                        <th class="px-6 py-6 text-center">Status</th>
                        <th class="pr-8 py-6 text-right">Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-50 font-bold text-sm">
                    <tr v-for="trx in filteredTransactions" :key="trx.id" class="hover:bg-gray-50/50 transition">
                        <td class="pl-8 py-5"><input type="checkbox" v-model="selectedIds" :value="trx.id" class="rounded border-gray-300 text-solafide-primary" /></td>
                        <td class="px-6 py-5 font-bold text-solafide-text text-sm capitalize">
                            {{ trx.order?.user?.name || 'User Tidak Ditemukan' }}
                        </td>
                        <td class="px-6 py-5 uppercase text-[10px] text-gray-500">{{ trx.payment_type }}</td>
                        <td class="px-6 py-5 text-right text-solafide-primary">{{ formatRupiah(trx.gross_amount) }}</td>
                        <td class="px-6 py-5 text-center">
                            <span :class="{
                                'bg-green-50 text-green-600 ring-green-100': trx.status === 'settlement',
                                'bg-orange-50 text-orange-600 ring-orange-100': trx.status === 'pending',
                                'bg-red-50 text-red-600 ring-red-100': ['expire', 'deny'].includes(trx.status)
                            }" class="px-3 py-1 rounded-full text-[9px] uppercase tracking-widest ring-1 ring-inset">
                                {{ trx.status }}
                            </span>
                        </td>
                        <td class="pr-8 py-5 text-right action-menu overflow-visible">
    <div class="relative inline-block">
        <button @click.stop="activeActionMenu = activeActionMenu === trx.id ? null : trx.id" class="p-2 hover:bg-gray-100 rounded-xl transition-all">
            <svg class="w-5 h-5 text-gray-400 group-hover:text-solafide-text" fill="currentColor" viewBox="0 0 20 20"><path d="M10 6a2 2 0 110-4 2 2 0 010 4zM10 12a2 2 0 110-4 2 2 0 010 4zM10 18a2 2 0 110-4 2 2 0 010 4z" /></svg>
        </button>
        
        <div v-if="activeActionMenu === trx.id" class="absolute right-0 mt-2 w-40 bg-white rounded-2xl shadow-xl border border-gray-100 z-[100] py-2 overflow-hidden animate-in fade-in slide-in-from-top-2 duration-200">
            <button v-if="trx.status !== 'settlement'" @click="setLunasTunggal(trx)" class="w-full text-left px-4 py-2.5 text-sm font-bold text-green-600 hover:bg-green-50 flex items-center gap-3 transition">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg> Set Lunas
            </button>
            
            <button @click="openModal(trx)" class="w-full text-left px-4 py-2.5 text-sm font-bold text-gray-700 hover:bg-gray-50 flex items-center gap-3 transition">
                <svg class="w-4 h-4 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" /></svg> Edit
            </button>
            <hr class="my-1 border-gray-100">
            <button @click="confirmDelete(trx)" class="w-full text-left px-4 py-2.5 text-sm font-bold text-red-600 hover:bg-red-50 flex items-center gap-3 transition">
                <svg class="w-4 h-4 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg> Hapus
            </button>
        </div>
    </div>
</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div v-if="isModalOpen" @click.self="isModalOpen = false" class="fixed inset-0 z-[120] flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
            <div class="bg-white rounded-[2rem] w-full max-w-lg shadow-2xl scale-in overflow-hidden border border-white/50">
                <div class="bg-gray-50/80 px-8 py-6 border-b border-gray-100 flex items-center justify-between">
                    <h2 class="text-xl font-serif font-bold text-solafide-text">{{ editMode ? 'Edit Transaksi' : 'Transaksi Baru' }}</h2>
                    <button @click="isModalOpen = false" class="p-2 bg-white rounded-full text-gray-400">X</button>
                </div>
                <form @submit.prevent="submit" class="p-8 space-y-6">
                    <div>
                        <label class="block text-[10px] font-black uppercase text-gray-400 mb-2 ml-1">Pilih Order</label>
                        <select v-model="form.order_id" class="w-full border-2 border-gray-100 rounded-2xl px-5 py-3 outline-none" required :disabled="editMode">
                            <option value="">-- Pilih Order --</option>
                            <option v-for="order in orders" :key="order.id" :value="order.id">
                                {{ order.order_number }} - {{ order.user?.name }} (Rp {{ formatRupiah(order.grand_total) }})
                            </option>                        
                        </select>
                    </div>
                    
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-[10px] font-black uppercase text-gray-400 mb-2 ml-1">Tipe Pembayaran</label>
                            <div class="flex flex-col bg-gray-100 p-1 rounded-2xl border border-gray-200/50">
                                <button type="button" @click="form.payment_type = 'dp'" :class="form.payment_type === 'dp' ? 'bg-white shadow-sm' : 'text-gray-400'" class="py-2 rounded-xl text-[10px] font-black uppercase transition-all">DP</button>
                                <button type="button" @click="form.payment_type = 'full_payment'" :class="form.payment_type === 'full_payment' ? 'bg-white shadow-sm' : 'text-gray-400'" class="py-2 rounded-xl text-[10px] font-black uppercase transition-all">Full</button>
                            </div>
                        </div>
                        <div>
                            <label class="block text-[10px] font-black uppercase text-gray-400 mb-2 ml-1">Nominal (Rp)</label>
                            <input v-model="form.gross_amount" type="number" class="w-full border-2 border-gray-100 rounded-2xl px-5 py-3 outline-none" required />
                        </div>
                    </div>

                    <div class="flex items-center justify-end gap-4 pt-4 border-t border-gray-50">
                        <button type="button" @click="isModalOpen = false" class="font-bold text-sm text-gray-400">Batal</button>
                        <button type="submit" class="bg-solafide-text text-solafide-gold px-8 py-3.5 rounded-xl font-black text-[11px] uppercase shadow-xl hover:-translate-y-0.5 transition-all">
                            Simpan Data
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div v-if="isDeleteModalOpen" @click.self="isDeleteModalOpen = false" class="fixed inset-0 z-[130] flex items-center justify-center bg-black/40 backdrop-blur-sm p-4 text-center">
            <div class="bg-white rounded-[2.5rem] w-full max-w-sm p-10 shadow-2xl scale-in">
                <div class="w-20 h-20 bg-red-100 text-red-500 rounded-3xl flex items-center justify-center mx-auto mb-6 rotate-12">!</div>
                <h2 class="text-2xl font-serif font-bold text-solafide-text mb-2">Hapus Data?</h2>
                <p class="text-sm text-gray-500 mb-10">Tindakan ini tidak bisa dibatalkan.</p>
                <div class="flex gap-4">
                    <button @click="isDeleteModalOpen = false" class="flex-1 font-bold text-gray-400">Batal</button>
                    <button @click="executeDelete" class="flex-1 bg-red-500 text-white py-4 rounded-2xl font-black uppercase">Ya, Hapus</button>
                </div>
            </div>
        </div>

        <div v-if="isStatusModalOpen" @click.self="isStatusModalOpen = false" class="fixed inset-0 z-[140] flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
            <div class="bg-white rounded-[2.5rem] w-full max-w-sm p-10 shadow-2xl text-center scale-in border border-white">
                <div class="bg-green-100 text-green-500 w-20 h-20 rounded-3xl flex items-center justify-center mx-auto mb-6 rotate-12 transition-colors">
                    <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg>
                </div>
                <h2 class="text-2xl font-serif font-bold text-solafide-text mb-2">Update Status?</h2>
                <p class="text-sm text-gray-500 font-medium mb-10 tracking-tight">Tandai <span class="font-bold text-solafide-text">{{ selectedIds.length }} transaksi</span> terpilih menjadi <span class="text-green-600 font-black uppercase">LUNAS</span>?</p>
                <div class="flex gap-4">
                    <button @click="isStatusModalOpen = false" class="flex-1 px-4 py-3 font-bold text-gray-400 hover:underline">Batal</button>
                    <button @click="handleBulkStatus" class="flex-1 px-4 py-4 bg-solafide-text text-solafide-gold rounded-2xl font-black uppercase text-[10px] tracking-widest shadow-xl">Ya, Update</button>
                </div>
            </div>
        </div>

    </AdminLayout>
</template>

<style scoped>
.scale-in { animation: scaleIn 0.2s cubic-bezier(0.34, 1.56, 0.64, 1); }
@keyframes scaleIn { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }
</style>