<script setup>
import GuestLayout from '@/Layouts/GuestLayout.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, computed, watch } from 'vue';

const form = useForm({
    name: '',
    email: '',
    phone: '',
    password: '',
    password_confirmation: '',
});

// 1. Validasi Format Email Real-time
const isEmailFormatValid = ref(null);

watch(() => form.email, (newVal) => {
    if (newVal === '') {
        isEmailFormatValid.value = null; 
        return;
    }
    // Regex standar untuk mendeteksi format email (contoh@domain.com)
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    isEmailFormatValid.value = regex.test(newVal);
});

// 2. Validasi Nomor Telepon
const isPhoneValid = computed(() => {
    if (form.phone.length === 0) return null;
    return form.phone.length >= 12;
});

const validatePhoneInput = (event) => {
    // Hanya izinkan angka
    form.phone = event.target.value.replace(/\D/g, '');
};

// 3. State Toggle Password
const showPassword = ref(false);
const showConfirmPassword = ref(false);

// 4. Logika Kekuatan Password
const passwordRequirements = computed(() => {
    const pw = form.password;
    return {
        length: pw.length >= 8,
        uppercase: /[A-Z]/.test(pw),
        lowercase: /[a-z]/.test(pw),
        number: /\d/.test(pw)
    };
});

const passwordStrength = computed(() => {
    const reqs = passwordRequirements.value;
    let score = 0;
    if (reqs.length) score++;
    if (reqs.uppercase) score++;
    if (reqs.lowercase) score++;
    if (reqs.number) score++;
    return score;
});

const strengthColor = computed(() => {
    if (passwordStrength.value <= 1) return 'bg-red-500';
    if (passwordStrength.value === 2) return 'bg-orange-500';
    if (passwordStrength.value === 3) return 'bg-yellow-400';
    return 'bg-green-500';
});

// 5. Konfirmasi Password Cocok
const isPasswordMatch = computed(() => {
    if (form.password_confirmation.length === 0) return null;
    return form.password === form.password_confirmation && form.password.length > 0;
});

// 6. State Modal Proses & Sukses
const isSubmitting = ref(false);
const isSuccess = ref(false);

const submit = () => {
    // Cegah submit jika syarat belum terpenuhi secara frontend
    if (isEmailFormatValid.value === false || !isPhoneValid.value || passwordStrength.value < 4 || !isPasswordMatch.value) {
        alert("Mohon pastikan format email, nomor telepon, dan keamanan password sudah sesuai persyaratan.");
        return;
    }

    form.post(route('register'), {
        onStart: () => {
            isSubmitting.value = true;
        },
        onSuccess: () => {
            isSuccess.value = true;
        },
        onError: () => {
            isSubmitting.value = false;
        }
    });
};
</script>

<template>
    <GuestLayout>
        <Head title="Daftar Akun" />

        <div class="w-full flex justify-center py-12 px-4 sm:px-6 lg:px-8 relative">
            <div class="w-full max-w-2xl bg-[#FFDAB9] rounded-3xl p-8 sm:p-12 shadow-xl border-2 border-orange-200">
                
                <h2 class="text-3xl sm:text-4xl font-serif font-bold text-center text-solafide-text mb-10">
                    Daftar dulu ya...
                </h2>

                <form @submit.prevent="submit" class="space-y-6 max-w-lg mx-auto">
                    
                    <div>
                        <input id="name" type="text" v-model="form.name" placeholder="Nama Lengkap" required autofocus autocomplete="name"
                            class="w-full rounded-full border-2 border-solafide-text px-6 py-3 font-semibold text-solafide-text bg-white focus:ring-solafide-primary transition-all" />
                        <p v-if="form.errors.name" class="mt-2 text-sm text-red-600 font-medium px-4">{{ form.errors.name }}</p>
                    </div>

                    <div>
                        <div class="relative">
                            <input id="email" type="email" v-model="form.email" placeholder="Email" required autocomplete="username"
                                class="w-full rounded-full border-2 px-6 py-3 font-semibold text-solafide-text bg-white focus:ring-solafide-primary transition-all duration-300"
                                :class="{
                                    'border-solafide-text': isEmailFormatValid === null && !form.errors.email,
                                    'border-green-500': isEmailFormatValid === true && !form.errors.email,
                                    'border-red-500': isEmailFormatValid === false || form.errors.email
                                }" />
                                
                            <div v-if="isEmailFormatValid === true && !form.errors.email" class="absolute inset-y-0 right-0 flex items-center pr-5">
                                <svg class="h-6 w-6 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                                </svg>
                            </div>
                        </div>
                        
                        <p v-if="isEmailFormatValid === false" class="mt-2 text-sm text-red-600 font-medium px-4">
                            Format email sepertinya belum tepat.
                        </p>
                        <p v-if="form.errors.email" class="mt-2 text-sm text-red-600 font-medium px-4">{{ form.errors.email }}</p>
                    </div>

                    <div>
                        <input id="phone" type="text" v-model="form.phone" @input="validatePhoneInput" placeholder="No. WhatsApp" required
                            class="w-full rounded-full border-2 px-6 py-3 font-semibold text-solafide-text bg-white focus:ring-solafide-primary transition-all"
                            :class="isPhoneValid === false ? 'border-red-500' : 'border-solafide-text'" />
                        <p v-if="isPhoneValid === false" class="mt-2 text-sm text-red-600 font-medium px-4">Minimal 12 angka ya.</p>
                        <p v-if="form.errors.phone" class="mt-2 text-sm text-red-600 font-medium px-4">{{ form.errors.phone }}</p>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        
                        <div>
                            <div class="relative flex items-center">
                                <input id="password" :type="showPassword ? 'text' : 'password'" v-model="form.password" placeholder="Password" required
                                    class="w-full rounded-full border-2 border-solafide-text px-6 py-3 pr-12 font-semibold text-solafide-text bg-white focus:ring-solafide-primary transition-all" />
                                
                                <button type="button" @click="showPassword = !showPassword" class="absolute right-4 text-gray-500 hover:text-solafide-primary focus:outline-none">
                                    <svg v-if="showPassword" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                                    <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"></path></svg>
                                </button>
                            </div>
                            <div v-if="form.password.length > 0" class="mt-2 px-2">
                                <div class="flex gap-1 h-1.5 w-full rounded-full overflow-hidden bg-white">
                                    <div class="h-full transition-all duration-300" :class="strengthColor" :style="`width: ${(passwordStrength / 4) * 100}%`"></div>
                                </div>
                                <p class="text-xs mt-1 font-medium text-solafide-text opacity-80 text-center">
                                    <span :class="passwordRequirements.length ? 'text-green-600 font-bold' : ''">Min. 8 Karakter</span> • 
                                    <span :class="passwordRequirements.uppercase && passwordRequirements.lowercase ? 'text-green-600 font-bold' : ''">Huruf Besar & Kecil</span> • 
                                    <span :class="passwordRequirements.number ? 'text-green-600 font-bold' : ''">Angka</span>
                                </p>
                            </div>
                        </div>

                        <div>
                            <div class="relative flex items-center">
                                <input id="password_confirmation" :type="showConfirmPassword ? 'text' : 'password'" v-model="form.password_confirmation" placeholder="Konfirmasi Password" required
                                    class="w-full rounded-full border-2 px-6 py-3 pr-12 font-semibold text-solafide-text bg-white focus:ring-solafide-primary transition-all"
                                    :class="isPasswordMatch === true ? 'border-green-500' : 'border-solafide-text'" />
                                
                                <div class="absolute right-4 flex items-center gap-2">
                                    <svg v-if="isPasswordMatch === true" class="w-5 h-5 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path></svg>
                                    
                                    <button type="button" @click="showConfirmPassword = !showConfirmPassword" class="text-gray-500 hover:text-solafide-primary focus:outline-none">
                                        <svg v-if="showConfirmPassword" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                                        <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"></path></svg>
                                    </button>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="flex justify-center pt-6">
                        <button type="submit" :disabled="form.processing"
                            class="bg-solafide-primary text-white font-bold uppercase tracking-wider py-3 px-16 rounded-full shadow-md transition duration-300"
                            :class="form.processing ? 'opacity-75 cursor-not-allowed' : 'hover:bg-orange-500 hover:shadow-lg hover:-translate-y-1'">
                            DAFTAR
                        </button>
                    </div>

                    <div class="text-center mt-4">
                        <span class="text-solafide-text font-semibold">Sudah punya akun? </span>
                        <Link :href="route('login')" class="text-blue-700 font-bold hover:underline">Masuk aja.</Link>
                    </div>
                </form>
            </div>
        </div>

        <div v-if="isSubmitting" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-60 transition-opacity backdrop-blur-sm px-4">
            <div class="bg-solafide-bg text-solafide-text rounded-3xl p-8 max-w-sm w-full shadow-2xl text-center border-2 border-solafide-gold transform transition-all">
                
                <div v-if="!isSuccess" class="flex flex-col items-center justify-center gap-4">
                    <svg class="animate-spin h-10 w-10 text-solafide-primary" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    <h2 class="text-xl font-serif font-bold">Memproses Pendaftaran...</h2>
                </div>

                <div v-else class="flex flex-col items-center justify-center gap-4">
                    <div class="h-12 w-12 rounded-full bg-green-100 flex items-center justify-center">
                        <svg class="h-8 w-8 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
                        </svg>
                    </div>
                    <h2 class="text-xl font-serif font-bold text-green-600">Berhasil Mendaftar!</h2>
                    <p class="text-sm font-medium">Mengarahkan ke halaman utama...</p>
                </div>

            </div>
        </div>

    </GuestLayout>
</template>