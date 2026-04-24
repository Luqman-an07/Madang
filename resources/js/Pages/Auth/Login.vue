<script setup>
import GuestLayout from '@/Layouts/GuestLayout.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, watch } from 'vue';

defineProps({
    canResetPassword: {
        type: Boolean,
    },
    status: {
        type: String,
    },
});

const form = useForm({
    email: '',
    password: '',
    remember: false,
});

// 1. Logika Validasi Format Email (Hanya mengecek format @ dan .com)
const isEmailFormatValid = ref(null);

watch(() => form.email, (newVal) => {
    if (newVal === '') {
        isEmailFormatValid.value = null; 
        return;
    }
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    isEmailFormatValid.value = regex.test(newVal);
});

// 2. State untuk Tampilkan/Sembunyikan Password
const showPassword = ref(false);

const togglePassword = () => {
    showPassword.value = !showPassword.value;
};

// Logika Submit
const submit = () => {
    form.post(route('login'), {
        onFinish: () => form.reset('password'),
    });
};
</script>

<template>
    <GuestLayout>
        <Head title="Masuk" />

        <div class="w-full flex justify-center py-12 px-4 sm:px-6 lg:px-8">
            <div class="w-full max-w-2xl bg-[#FFDAB9] rounded-3xl p-8 sm:p-12 shadow-xl border-2 border-orange-200">
                
                <h2 class="text-3xl sm:text-4xl font-serif font-bold text-center text-solafide-text mb-10">
                    Selamat Datang Kembali!
                </h2>

                <div v-if="status" class="mb-4 font-medium text-sm text-green-600 text-center">
                    {{ status }}
                </div>

                <form @submit.prevent="submit" class="space-y-6 max-w-md mx-auto">
                    <div>
                        <div class="relative">
                            <input
                                id="email"
                                type="email"
                                class="w-full rounded-full border-2 px-6 py-3 font-semibold text-solafide-text bg-white bg-opacity-70 focus:bg-white focus:ring-solafide-primary transition-all duration-300"
                                :class="{
                                    'border-solafide-text': isEmailFormatValid === null && !form.errors.email,
                                    'border-green-500': isEmailFormatValid === true && !form.errors.email,
                                    'border-red-500': isEmailFormatValid === false || form.errors.email
                                }"
                                v-model="form.email"
                                placeholder="Email"
                                required
                                autofocus
                                autocomplete="username"
                            />
                            
                            <div v-if="isEmailFormatValid === true && !form.errors.email" class="absolute inset-y-0 right-0 flex items-center pr-5">
                                <svg class="h-6 w-6 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                </svg>
                            </div>
                        </div>
                        
                        <p v-if="isEmailFormatValid === false" class="mt-2 text-sm text-red-600 font-medium px-4">
                            Format email sepertinya belum tepat.
                        </p>
                        <p v-if="form.errors.email" class="mt-2 text-sm text-red-600 font-medium px-4">
                            {{ form.errors.email }}
                        </p>
                    </div>

                    <div>
                        <div class="relative flex items-center">
                            <input
                                id="password"
                                :type="showPassword ? 'text' : 'password'"
                                class="w-full rounded-full border-2 px-6 py-3 pr-12 font-semibold text-solafide-text bg-white bg-opacity-70 focus:bg-white focus:ring-solafide-primary transition-all duration-300"
                                :class="form.errors.password ? 'border-red-500' : 'border-solafide-text'"
                                v-model="form.password"
                                placeholder="Password"
                                required
                                autocomplete="current-password"
                            />
                            
                            <button 
                                type="button" 
                                @click="togglePassword"
                                class="absolute right-4 text-solafide-text hover:text-solafide-primary focus:outline-none transition-colors"
                            >
                                <svg v-if="showPassword" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                                </svg>
                                
                                <svg v-else class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"></path>
                                </svg>
                            </button>
                        </div>
                        <p v-if="form.errors.password" class="mt-2 text-sm text-red-600 font-medium px-4">
                            {{ form.errors.password }}
                        </p>
                    </div>

                    <div class="text-center">
                        <span class="text-solafide-text font-semibold">Belum punya akun? </span>
                        <Link :href="route('register')" class="text-blue-700 font-bold hover:underline">
                            Daftar dulu ya!
                        </Link>
                    </div>

                    <div class="flex items-center justify-between pt-6 gap-4">
                        <Link
                            v-if="canResetPassword"
                            :href="route('password.request')"
                            class="text-blue-700 font-bold text-center hover:underline leading-tight"
                        >
                            Lupa<br>Password?
                        </Link>
                        
                        <div v-else></div>

                        <button
                            type="submit"
                            :disabled="form.processing"
                            class="bg-solafide-primary text-white font-bold uppercase tracking-wider py-3 px-10 rounded-full shadow-md transition duration-300 flex items-center justify-center gap-2"
                            :class="form.processing ? 'opacity-75 cursor-not-allowed' : 'hover:bg-orange-500 hover:shadow-lg hover:-translate-y-1'"
                        >
                            <svg v-if="form.processing" class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                            </svg>
                            <span v-if="!form.processing">Masuk</span>
                            <span v-else>Memproses...</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </GuestLayout>
</template>