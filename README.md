# Sistem Manajemen D'Solafide & Pawon Soemito

Proyek ini adalah sistem informasi berbasis web yang dirancang untuk mengelola operasional bisnis kuliner, mulai dari manajemen inventaris produk hingga proses transaksi. Saat ini, pengembangan sistem difokuskan pada penguatan infrastruktur panel admin dan pengelolaan data master.

---

## 👤 Data Diri Pengembang
* **Nama** : Luqman Anas Naufal  
* **NIM** : 220101094  
* **Kelas** : SI 22 A3  
* **Instansi** : Universitas Duta Bangsa Surakarta  

---

## 🚀 Status Proyek: Master Data (Admin Panel)
Pengembangan saat ini telah mencapai tahap **Admin Master Data**. Fokus utama pada fase ini adalah membangun fondasi data yang kokoh dengan antarmuka (UI) yang modern dan pengalaman pengguna (UX) yang intuitif.

### Fitur yang Sudah Diimplementasikan:

#### 1. Manajemen Kategori (Category Management)
* **CRUD Lengkap**: Tambah, edit, lihat, dan hapus data kategori produk.
* **Smart Filter**: Filter berdasarkan brand (Solafide/Pawon Soemito) dilengkapi dengan *dynamic badges* (menampilkan jumlah data secara real-time).
* **Bulk Actions**: Fitur hapus masal dan aktivasi/nonaktivasi status kategori sekaligus.
* **Segmented Control UI**: Antarmuka pemilihan brand dan status yang modern menggunakan gaya *segmented switch*.

#### 2. Manajemen Produk (Product Management)
* **CRUD & Image Upload**: Pengelolaan produk lengkap dengan sistem unggah foto produk (preview sebelum simpan).
* **Cross-Filtering System**: Pencarian nama produk dikombinasikan dengan filter brand dan kategori dalam satu tampilan *Two-Tier Layout*.
* **Contextual Bulk Action**: Bar aksi masal yang muncul secara dinamis sesuai status produk yang dipilih (Aktif/Nonaktif).
* **Sorting Dinamis**: Tabel yang dapat diurutkan berdasarkan Nama atau Harga secara instan.

#### 3. Infrastruktur UI/UX Panel Admin
* **Advanced Sidebar**: Mendukung mode *minimize* dengan persistensi (mengingat pilihan admin lewat *local storage*) dan fitur *flyout menu* saat sidebar mengecil.
* **Modern Topbar/Navbar**: Tampilan navigasi atas yang bersih dengan indikator tanggal otomatis dan desain profil pengguna yang elegan.
* **Responsive Modal**: Sistem modal konfirmasi dan formulir yang mendukung penutupan via klik area luar (*backdrop*) untuk kemudahan akses.

---

## 🛠️ Teknologi yang Digunakan
* **Framework Backend**: Laravel 13
* **Framework Frontend**: Vue.js 3
* **Bridge**: Inertia.js (Modern Monolith)
* **Styling**: Tailwind CSS
* **Database**: MySQL / PostgreSQL