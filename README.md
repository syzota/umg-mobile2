<img width="1919" height="477" alt="image" src="https://github.com/user-attachments/assets/15e9bd5b-981e-4c76-a432-87384035120d" />

<h1 align="center">✮ Universal Music Group: Management Mobile</h1>
<p align="center">
  <i>A Flutter-based mobile application developed for Mobile Programming Course. was made by Putri Syafana Afrillia (NIM: 2409116015).</i>
</p>

## **Introduction** ★

Projek ini merupakan aplikasi mobile berbasis Flutter yang dikembangkan sebagai mini project mata kuliah Mobile Programming. Aplikasi ini berfungsi sebagai sistem manajemen data album dengan fitur CRUD (Create, Read, Update, Delete) yang terintegrasi penuh dengan **Supabase** sebagai backend database dan storage, dilengkapi autentikasi pengguna, filtering berdasarkan genre musik, serta dukungan Dark Mode dan Light Mode.

---

## **App Hands-On** ⸝⸝.ᐟ⋆.ᐟ

### Features Checklist ᯓ★

**Fitur Wajib:**
- [x] Create Data (Tambah Album ke Supabase)
- [x] Read Data (Menampilkan Daftar Album dari Supabase)
- [x] Update Data (Edit Album di Supabase)
- [x] Delete Data (Hapus Album dari Supabase)
- [x] Navigasi Halaman (HomePage ↔ FormPage)
- [x] Minimal 3 Field Input (Nama Album, Artist, Contract Value, Genre, Cover Image)
- [x] Data disimpan dan diambil dari Supabase (bukan List lokal)

**Nilai Tambah:**
- [x] Login & Register menggunakan Supabase Auth
- [x] Dark Mode & Light Mode
- [x] File `.env` untuk menyimpan Supabase URL dan API Key

---

## Tools and Tech Stack ᯓ★

Seluruh pengembangan aplikasi dilakukan menggunakan Flutter SDK dengan pendekatan declarative UI berbasis widget. Proyek ini terintegrasi dengan Supabase sebagai backend untuk database, storage, dan autentikasi.

### Core Technologies ⍟

- [x] **Flutter** – UI toolkit utama untuk membangun antarmuka aplikasi berbasis widget.
- [x] **Dart** – Bahasa pemrograman utama untuk mengelola logika aplikasi dan state.
- [x] **Supabase** – Backend as a Service untuk database (PostgreSQL), storage, dan autentikasi.
- [x] **Material Design** – Sistem desain untuk tampilan UI yang konsisten dan responsif.

### Frameworks & Libraries ⍟

- [x] **supabase_flutter** – Integrasi Supabase dengan Flutter untuk CRUD, Auth, dan Storage.
- [x] **flutter_dotenv** – Menyimpan environment variable (URL & API Key Supabase) secara aman di file `.env`.
- [x] **image_picker** – Digunakan untuk memilih gambar dari galeri perangkat dan menguploadnya ke Supabase Storage.
- [x] **google_fonts** – Digunakan untuk menerapkan font Jersey 20 pada seluruh aplikasi.
- [x] **intl** – Digunakan untuk formatting nilai kontrak dalam mata uang USD menggunakan `NumberFormat`.
- [x] **Navigator (Flutter Routing)** – Digunakan untuk perpindahan halaman antar halaman.
- [x] **StatefulWidget** – Digunakan untuk manajemen state pada fitur CRUD, filtering, dan tema.

### Development Tools ⍟

- [x] **VS Code** – Code editor utama dalam pengembangan aplikasi.
- [x] **Flutter SDK** – Digunakan untuk build, run, dan debugging aplikasi.
- [x] **Android Emulator / Physical Device** – Digunakan untuk pengujian aplikasi.
- [x] **Flutter DevTools** – Digunakan untuk debugging dan monitoring performa aplikasi.
- [x] **Supabase Dashboard** – Digunakan untuk manajemen database, storage bucket, dan Row Level Security (RLS).
- [x] **Git & GitHub** – Version control dan pengumpulan source code.

---

## Implemented Features ᯓ★

### Authentication (Supabase Auth)

Aplikasi dilengkapi sistem autentikasi menggunakan Supabase Auth. Pengguna wajib login sebelum dapat mengakses data. Session login disimpan secara otomatis sehingga pengguna tidak perlu login ulang setiap membuka aplikasi.

- **Register** – Pendaftaran akun baru menggunakan email `@gmail.com` dan password minimal 6 karakter, dilengkapi konfirmasi password.
- **Login** – Masuk menggunakan email dan password yang sudah terdaftar.
- **Logout** – Keluar dari sesi dengan konfirmasi dialog.
- **Session Check** – Aplikasi otomatis mengarahkan ke HomePage jika sudah login, atau ke LoginPage jika belum.

### CRUD dengan Supabase

Seluruh operasi data dilakukan langsung ke database Supabase (PostgreSQL), bukan List lokal:

- **Create** – Data album baru diinsert ke tabel `albums` beserta upload cover image ke Supabase Storage bucket `covers`.
- **Read** – Data album diambil dari Supabase, diurutkan berdasarkan `created_at` terbaru, dan ditampilkan dalam bentuk glass card.
- **Update** – Data album yang sudah ada dapat diedit, termasuk mengganti cover image.
- **Delete** – Hapus data album dari database dengan konfirmasi dialog.

### Cover Image (Supabase Storage)

Cover image dipilih dari galeri perangkat menggunakan `image_picker`, diupload ke Supabase Storage bucket `covers`, dan public URL-nya disimpan di kolom `image_url` pada tabel `albums`. Gambar ditampilkan menggunakan `Image.network` dari URL tersebut.

### Dark Mode & Light Mode

Tema dapat di-toggle kapan saja dari semua halaman menggunakan icon di navbar. State tema dikelola di `MyApp` (`main.dart`) dan diteruskan ke seluruh halaman melalui callback `onToggleTheme`. Setiap halaman menggunakan `Theme.of(context).brightness` untuk mendeteksi tema aktif dan menyesuaikan tampilan background, glass container, dan warna teks.

### Genre Filtering

Filter kategori menggunakan state `selectedCategory` dan `.where()` untuk menyaring data berdasarkan genre. Tersedia 6 kategori: All Genres, Pop, Rock, R&B, Jazz, Hip Hop.

### Form Validation

Setiap field memiliki validasi spesifik:
- **Album Name & Artist** – Tidak boleh kosong, minimal 2 karakter.
- **Contract Value** – Hanya angka bulat, nilai harus lebih dari 0 dan tidak melebihi 999.999.999.
- **Email** – Wajib format `@gmail.com`.
- **Password** – Minimal 6 karakter.
- **Cover Image** – Wajib dipilih dari galeri.
- **Genre** – Wajib dipilih dari dropdown.

---

## Library Structure ⊹ ࣪ ˖ ✔

```
lib/
├── main.dart              # Entry point, inisialisasi Supabase & tema
├── home.dart              # Halaman utama (List, Filter, Delete)
├── form.dart              # Form tambah & edit data album
├── login.dart             # Halaman login
├── register.dart          # Halaman register
└── widgets/
    ├── glass_container.dart    # Reusable glassmorphism container
    ├── app_background.dart     # Reusable background + overlay
    ├── app_text_field.dart     # Reusable text field dengan validasi
    └── app_password_field.dart # Reusable password field dengan toggle visibility
```

---

## Supabase Setup ⍟

### Tabel `albums`

```sql
create table albums (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade,
  nama text not null,
  label text not null,
  harga numeric not null,
  kategori text not null,
  image_url text,
  created_at timestamp with time zone default now()
);
```

Row Level Security (RLS) diaktifkan — setiap user hanya dapat mengakses data miliknya sendiri.

### Storage Bucket `covers`

Bucket publik untuk menyimpan cover image album. Dilengkapi 4 policy: SELECT (public), INSERT, UPDATE, DELETE (authenticated).

### Environment Variables (`.env`)

```
SUPABASE_URL=https://xxxxxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
```

File `.env` didaftarkan di `pubspec.yaml` sebagai asset dan ditambahkan ke `.gitignore` agar tidak ter-push ke GitHub.

---

## Program Flows ⭑ & Graphical User Interface (GUI) —͟͟͞͞★

### Login & Register Page ⍟

Halaman pertama yang ditampilkan jika pengguna belum login. Menggunakan `Supabase.auth.signInWithPassword()` untuk login dan `Supabase.auth.signUp()` untuk registrasi. Dilengkapi validasi format email `@gmail.com` dan toggle visibility password.

### Home Page ⍟

Halaman utama menampilkan daftar album dalam glass card. Setiap card menampilkan cover image, nama album, chip genre, nama artist, dan nilai kontrak. Data diambil dari Supabase menggunakan `fetchAlbums()` di `initState`. Tersedia `RefreshIndicator` untuk pull-to-refresh.

### Form Page (Add / Edit Album) ⍟

FormPage digunakan untuk menambahkan data baru dan mengedit data yang sudah ada. Cover image dipilih dari galeri dan diupload ke Supabase Storage. Saat edit, cover image lama tetap ditampilkan sebagai preview dan bisa diganti.

### Glassmorphism UI ⍟

Seluruh container menggunakan efek glassmorphism dengan `BackdropFilter` dan `ImageFilter.blur()`. Widget `GlassContainer` dibuat reusable dan mendukung Dark/Light mode — dark mode menggunakan warna putih transparan, light mode menggunakan warna biru tua transparan (`Color.fromARGB(255, 2, 8, 64)`).

### Browser Customize Personalized ⍟

Nama tab dan icon browser dapat dikonfigurasi melalui `web/index.html` untuk mengubah `<title>` dan `web/favicon.png` untuk mengganti logo tab browser.

```html
<title>Universal Music Group</title>
<link rel="icon" type="image/png" href="favicon.png">
```

---

<p align="center">
  <i>© 2026 - UMG Mobile by Putri. All rights reserved.</i>
</p>
