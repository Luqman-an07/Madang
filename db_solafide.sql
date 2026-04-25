-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 25, 2026 at 03:24 AM
-- Server version: 8.0.30
-- PHP Version: 8.3.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_solafide`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `brand` enum('solafide','pawon_soemito') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'solafide',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `brand`, `is_active`, `slug`, `created_at`, `updated_at`) VALUES
(5, 'Wedding Cake', 'solafide', 1, 'wedding-cake-62', '2026-04-23 11:57:37', '2026-04-23 20:36:33'),
(6, 'Nasi Kuning', 'pawon_soemito', 1, 'nasi-kuning-88', '2026-04-23 20:35:44', '2026-04-23 20:36:33');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` smallint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_04_23_150522_create_categories_table', 1),
(5, '2026_04_23_150522_create_products_table', 1),
(6, '2026_04_23_150523_create_orders_table', 1),
(7, '2026_04_23_150524_create_order_items_table', 1),
(8, '2026_04_23_150525_create_transactions_table', 1),
(9, '2026_04_23_181436_add_brand_to_categories_table', 2),
(10, '2026_04_24_033052_add_is_active_to_categories_table', 3);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint UNSIGNED NOT NULL,
  `order_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `status` enum('pending_quote','awaiting_dp','processing','awaiting_full_payment','completed','cancelled_by_customer','cancelled_by_admin','refunded') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending_quote',
  `shipping_address` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `required_date` datetime NOT NULL,
  `subtotal` int NOT NULL DEFAULT '0',
  `shipping_cost` int NOT NULL DEFAULT '0',
  `grand_total` int NOT NULL DEFAULT '0',
  `custom_notes` text COLLATE utf8mb4_unicode_ci,
  `rejection_reason` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `user_id`, `status`, `shipping_address`, `required_date`, `subtotal`, `shipping_cost`, `grand_total`, `custom_notes`, `rejection_reason`, `created_at`, `updated_at`) VALUES
(1, 'ORD-QYW125', 2, 'awaiting_full_payment', 'Jln. Cikutra Timur No. 230, Sukabumi 69538, Maluku', '2026-05-04 00:49:46', 900000, 15000, 915000, 'Excepturi unde sunt error doloribus labore est.', NULL, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(2, 'ORD-SLO568', 2, 'processing', 'Dk. Zamrud No. 165, Magelang 70461, Kaltim', '2026-04-25 05:39:59', 1000000, 15000, 1015000, 'Quod amet sit dolores laudantium accusantium et.', NULL, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(3, 'ORD-QGC326', 1, 'awaiting_full_payment', 'Jln. Imam No. 693, Surabaya 60774, Lampung', '2026-04-27 07:27:52', 1400000, 25000, 1425000, 'Non qui est aut quisquam.', NULL, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(4, 'ORD-VWP836', 2, 'awaiting_full_payment', 'Jln. Tambak No. 978, Ambon 84289, Sulsel', '2026-04-25 09:41:18', 250000, 25000, 275000, 'Ipsum ad esse fuga.', NULL, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(5, 'ORD-UNB163', 1, 'processing', 'Ds. Pasteur No. 618, Yogyakarta 79013, Kaltara', '2026-04-30 06:57:57', 75000, 25000, 100000, 'Ea voluptas eum odio est quod minima voluptas.', NULL, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(6, 'ORD-RVM511', 1, 'awaiting_full_payment', 'Gg. Surapati No. 386, Mataram 47154, Kaltim', '2026-05-05 20:34:53', 100000, 15000, 115000, NULL, NULL, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(7, 'ORD-BQU265', 1, 'awaiting_dp', 'Jln. Radio No. 645, Surakarta 95277, Banten', '2026-04-26 21:48:58', 100000, 15000, 115000, 'Aut distinctio doloremque id ut soluta.', NULL, '2026-04-24 19:40:02', '2026-04-24 19:40:02'),
(8, 'ORD-RZC277', 2, 'processing', 'Ki. Sumpah Pemuda No. 969, Medan 95851, Sumsel', '2026-05-01 20:49:26', 450000, 35000, 485000, 'Vero ratione nam aut velit sit sint hic.', NULL, '2026-04-24 19:40:02', '2026-04-24 19:40:02'),
(9, 'ORD-RMO266', 2, 'awaiting_full_payment', 'Ds. Karel S. Tubun No. 229, Sorong 40508, Kaltim', '2026-05-07 17:21:52', 300000, 15000, 315000, 'Doloremque minima blanditiis ipsa ad voluptatem pariatur a.', NULL, '2026-04-24 19:40:02', '2026-04-24 19:40:02'),
(10, 'ORD-HLH607', 2, 'awaiting_full_payment', 'Kpg. Sampangan No. 652, Lubuklinggau 38674, Jambi', '2026-05-02 01:41:41', 475000, 15000, 490000, 'Nemo sed at itaque magni omnis odit assumenda.', NULL, '2026-04-24 19:40:02', '2026-04-24 19:40:02');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint UNSIGNED NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `product_id` bigint UNSIGNED NOT NULL,
  `quantity` int NOT NULL,
  `price` int NOT NULL,
  `subtotal` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price`, `subtotal`, `created_at`, `updated_at`) VALUES
(1, 1, 13, 1, 100000, 100000, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(2, 1, 12, 2, 250000, 500000, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(3, 1, 13, 3, 100000, 300000, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(4, 2, 12, 4, 250000, 1000000, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(5, 3, 13, 4, 100000, 400000, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(6, 3, 12, 4, 250000, 1000000, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(7, 4, 12, 1, 250000, 250000, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(8, 5, 10, 1, 75000, 75000, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(9, 6, 13, 1, 100000, 100000, '2026-04-24 19:40:01', '2026-04-24 19:40:01'),
(10, 7, 13, 1, 100000, 100000, '2026-04-24 19:40:02', '2026-04-24 19:40:02'),
(11, 8, 10, 2, 75000, 150000, '2026-04-24 19:40:02', '2026-04-24 19:40:02'),
(12, 8, 13, 3, 100000, 300000, '2026-04-24 19:40:02', '2026-04-24 19:40:02'),
(13, 9, 10, 4, 75000, 300000, '2026-04-24 19:40:02', '2026-04-24 19:40:02'),
(14, 10, 10, 1, 75000, 75000, '2026-04-24 19:40:02', '2026-04-24 19:40:02'),
(15, 10, 13, 4, 100000, 400000, '2026-04-24 19:40:02', '2026-04-24 19:40:02');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint UNSIGNED NOT NULL,
  `category_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `base_price` int NOT NULL DEFAULT '0',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `category_id`, `name`, `slug`, `description`, `base_price`, `image`, `is_active`, `created_at`, `updated_at`) VALUES
(10, 5, 'Cake Kecil', 'cake-kecil-878', NULL, 75000, 'products/tiokYPmz7Yr1teUIPn10cxo1wfEVEACu8xezQP2M.png', 1, '2026-04-23 19:56:11', '2026-04-23 19:59:53'),
(12, 5, 'Cake Besar', 'cake-besar-178', NULL, 250000, 'products/DuLNQhOGyMSDmML0VG8aGoynRerQmpQcnyIetZSs.png', 0, '2026-04-23 19:58:02', '2026-04-23 20:12:12'),
(13, 6, 'Nasi Kuning Kecil', 'nasi-kuning-kecil-869', NULL, 100000, 'products/iR0eJOTVjNJ2bTHWZFl2Wp8gwoZgRUEdwK9Q2gqk.png', 1, '2026-04-23 20:37:24', '2026-04-23 20:37:24');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('KPZgvr3xNX5kGjf8hc20AV6DQ5L6P0vKdQg73KuV', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiIyeU0yR3VpUTJncFVPYWhMN0FsdFdXaDExRnhWT3dXUHRQRERwSkF3IiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwXC9hZG1pblwvdHJhbnNhY3Rpb25zIiwicm91dGUiOiJ0cmFuc2FjdGlvbnMuaW5kZXgifSwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119LCJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI6MX0=', 1777087384),
('lv0WUGjj61ZBiho149gP4L5MHDi7WArsGo5cq0Sz', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJIcTZ0N1V3OEZEZzV2VjVkclRVSGZXUFEyb0pVNHBDaWthdEg5Rkp2IiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==', 1777003780);

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` bigint UNSIGNED NOT NULL,
  `order_id` bigint UNSIGNED NOT NULL,
  `midtrans_order_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_type` enum('dp','pelunasan','full_payment') COLLATE utf8mb4_unicode_ci NOT NULL,
  `gross_amount` int NOT NULL,
  `snap_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','settlement','expire','deny') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `order_id`, `midtrans_order_id`, `payment_type`, `gross_amount`, `snap_token`, `status`, `created_at`, `updated_at`) VALUES
(4, 5, 'TRX-69EC321272533', 'full_payment', 100000, '7e25940f1ea0b310610855adf9b3b499', 'settlement', '2026-04-24 20:16:34', '2026-04-24 20:23:04'),
(5, 7, 'TRX-69EC332CB1FE5', 'dp', 50000, '4debe549a353d88b03bd8769da904a10', 'pending', '2026-04-24 20:21:16', '2026-04-24 20:21:16');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('admin','customer') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'customer',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `phone`, `role`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'admin@solafide.com', NULL, '$2y$12$aDjPqS.mgPjEwbJGsb1yyOx4lphhqro2qOlSuVX2C0CMwy0ESimyy', '081234567890', 'admin', NULL, '2026-04-23 08:11:32', '2026-04-23 08:11:32'),
(2, 'customer', 'customer@solafide.com', NULL, '$2y$12$IA/kM6oaD5Um0p33VdaJj.Ts77Yslewg4hQpvO1hwe/KtrUPQl.4S', '089876543210', 'customer', NULL, '2026-04-23 08:11:32', '2026-04-23 08:11:32');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_slug_unique` (`slug`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `orders_order_number_unique` (`order_number`),
  ADD KEY `orders_user_id_foreign` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_order_id_foreign` (`order_id`),
  ADD KEY `order_items_product_id_foreign` (`product_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `products_slug_unique` (`slug`),
  ADD KEY `products_category_id_foreign` (`category_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `transactions_midtrans_order_id_unique` (`midtrans_order_id`),
  ADD KEY `transactions_order_id_foreign` (`order_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
