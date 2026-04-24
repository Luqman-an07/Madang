import defaultTheme from 'tailwindcss/defaultTheme';
import forms from '@tailwindcss/forms';

/** @type {import('tailwindcss').Config} */
export default {
    content: [
        './vendor/laravel/framework/src/Illuminate/Pagination/resources/views/*.blade.php',
        './storage/framework/views/*.php',
        './resources/views/**/*.blade.php',
        './resources/js/**/*.vue',
    ],

    theme: {
        extend: {
            fontFamily: {
                sans: ['Figtree', ...defaultTheme.fontFamily.sans],
                serif: ['"Playfair Display"', ...defaultTheme.fontFamily.serif],
            },
            colors: {
                'solafide-bg': '#FFFBEB', // Latar belakang Cream Soft
                'solafide-gold': '#F4D35E', // Warna kuning emas Header/Footer
                'solafide-primary': '#FF8A48', // Oranye tombol pesanan
                'solafide-text': '#2D241E', // Cokelat gelap untuk teks (nyaman di mata)
            }
        },
    },

    plugins: [forms],
};