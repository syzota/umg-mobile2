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

```dart
home: supabase.auth.currentSession != null
    ? HomePage(...)
    : LoginPage(...),
```
```dart
await supabase.auth.signInWithPassword(email: email, password: password);

await supabase.auth.signUp(email: email, password: password);

await supabase.auth.signOut();
```

### CRUD dengan Supabase

Seluruh operasi data dilakukan langsung ke database Supabase (PostgreSQL), bukan List lokal:

- **Create** – Data album baru diinsert ke tabel `albums` beserta upload cover image ke Supabase Storage bucket `covers`.
- **Read** – Data album diambil dari Supabase, diurutkan berdasarkan `created_at` terbaru, dan ditampilkan dalam bentuk glass card.
- **Update** – Data album yang sudah ada dapat diedit, termasuk mengganti cover image.
- **Delete** – Hapus data album dari database dengan konfirmasi dialog.

```dart
final response = await supabase
    .from('albums')
    .select()
    .order('created_at', ascending: false);

await supabase.from('albums').insert(data);

await supabase.from('albums').update(data).eq('id', id);

await supabase.from('albums').delete().eq('id', id);
```

### Cover Image (Supabase Storage)

Cover image dipilih dari galeri perangkat menggunakan `image_picker`, diupload ke Supabase Storage bucket `covers`, dan public URL-nya disimpan di kolom `image_url` pada tabel `albums`. Gambar ditampilkan menggunakan `Image.network` dari URL tersebut.

```dart
final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
final bytes = await selectedImage!.readAsBytes();
await supabase.storage.from('covers').uploadBinary(fileName, bytes);
return supabase.storage.from('covers').getPublicUrl(fileName);
```

### Dark Mode & Light Mode

Tema dapat di-toggle kapan saja dari semua halaman menggunakan icon di navbar. State tema dikelola di `MyApp` (`main.dart`) dan diteruskan ke seluruh halaman melalui callback `onToggleTheme`. Setiap halaman menggunakan `Theme.of(context).brightness` untuk mendeteksi tema aktif dan menyesuaikan tampilan background, glass container, dan warna teks.

```dart
void toggleTheme() {
  setState(() {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
  });
}
```

### Genre Filtering

Filter kategori menggunakan state `selectedCategory` dan `.where()` untuk menyaring data berdasarkan genre. Tersedia 6 kategori: All Genres, Pop, Rock, R&B, Jazz, Hip Hop.

```dart
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredItems = selectedCategory == "All Genres"
        ? items
        : items.where((item) => item["kategori"] == selectedCategory).toList();
```

### Form Validation Detail ⍟

<img width="1824" height="2150" alt="image" src="https://github.com/user-attachments/assets/3d4c9a81-c883-4fb1-bfbb-372c4495fe97" />

Setiap field memiliki validasi yang spesifik dan berbeda-beda, bukan sekadar cek kosong. Validasi dijalankan saat tombol Save/Login/Register ditekan menggunakan `GlobalKey<FormState>` dan `_formKey.currentState!.validate()`.

**Album Name & Artist Name**
```dart
validator: (v) {
  if (v == null || v.trim().isEmpty) return "Album name cannot be empty";
  if (v.trim().length < 2) return "Minimal 2 karakter";
  return null;
},
```

**Contract Value** — hanya menerima angka bulat positif dengan batas maksimum
```dart
validator: (v) {
  if (v == null || v.trim().isEmpty) return "Contract value wajib diisi";
  final parsed = int.tryParse(v.trim());
  if (parsed == null) return "Hanya angka bulat";
  if (parsed <= 0) return "Nilai harus lebih dari 0";
  if (parsed > 999999999) return "Nilai terlalu besar";
  return null;
},
```

**Email** — wajib menggunakan format `@gmail.com`
```dart
validator: (v) {
  if (v == null || v.trim().isEmpty) return "Email tidak boleh kosong";
  if (!v.trim().endsWith("@gmail.com"))
    return "Harus menggunakan email @gmail.com";
  return null;
},
```

**Password** — minimal 6 karakter
```dart
validator: (v) {
  if (v == null || v.isEmpty) return "Password tidak boleh kosong";
  if (v.length < 6) return "Password minimal 6 karakter";
  return null;
},
```

**Konfirmasi Password** — harus cocok dengan password
```dart
validator: (v) {
  if (v != passwordController.text) return "Password tidak cocok";
  return null;
},
```

**Cover Image** — wajib dipilih, dicek secara manual di luar form validator
```dart
setState(() {
  imageError = selectedImage == null && existingImageUrl == null;
});
if (imageError) return; // batalkan proses simpan
```

**Genre** — wajib dipilih dari dropdown
```dart
validator: (v) => v == null ? "Genre must be selected" : null,
```

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

<table>
  <tr>
    <td><img width="400" alt="image" src="https://github.com/user-attachments/assets/c3ae7385-2375-4481-85fb-28704600d4b8" /></td>
    <td><img width="400" alt="image" src="https://github.com/user-attachments/assets/1cfc3e9a-124c-40b8-a6d7-6904e50eb342" /></td>
  </tr>
</table>

### Home Page ⍟

<img width="1824" height="2150" alt="image" src="https://github.com/user-attachments/assets/7b2c0f3b-932c-493c-8280-a70be5813249" />

Halaman utama menampilkan daftar album dalam glass card. Setiap card menampilkan cover image, nama album, chip genre, nama artist, dan nilai kontrak. Data diambil dari Supabase menggunakan `fetchAlbums()` di `initState`. Tersedia `RefreshIndicator` untuk pull-to-refresh.

### Form Page (Add / Edit Album) ⍟

<img width="1824" height="2150" alt="image" src="https://github.com/user-attachments/assets/4e3cd51e-6442-4946-b9fb-fb5718d18fd1" />

FormPage digunakan untuk menambahkan data baru dan mengedit data yang sudah ada. Cover image dipilih dari galeri dan diupload ke Supabase Storage. Saat edit, cover image lama tetap ditampilkan sebagai preview dan bisa diganti.

### Browser Customize Personalized ⍟

Nama tab dan icon browser dapat dikonfigurasi melalui `web/index.html` untuk mengubah `<title>` dan `web/favicon.png` untuk mengganti logo tab browser.

```html
<title>Universal Music Group</title>
<link rel="icon" type="image/png" href="favicon.png">
```

## Widgets ᯓ★

### Structural Widgets ⍟

- [x] **Scaffold** – Struktur dasar halaman yang menyediakan body, floatingActionButton, dan extendBodyBehindAppBar.
- [x] **Stack** – Menumpuk widget background image, overlay, dan konten utama secara berlapis.
- [x] **SafeArea** – Memastikan konten tidak tertutup notch atau status bar perangkat.
- [x] **Column** – Menyusun widget secara vertikal pada setiap halaman.
- [x] **Row** – Menyusun widget secara horizontal, digunakan pada navbar dan card.
- [x] **Expanded** – Mengisi sisa ruang yang tersedia, digunakan pada list dan form.
- [x] **Flexible** – Memberi fleksibilitas ukuran pada teks di dalam Row agar tidak overflow.

### Layout & Decoration Widgets ⍟

- [x] **Container** – Widget serbaguna untuk padding, margin, warna, dan dekorasi.
- [x] **ClipRRect** – Memotong widget dengan sudut melengkung untuk efek glassmorphism.
- [x] **BackdropFilter** – Menerapkan efek blur pada background untuk tampilan glassmorphism.
- [x] **DecoratedBox / BoxDecoration** – Menambahkan border, warna, dan border radius pada container.
- [x] **Padding** – Menambahkan jarak di dalam widget.
- [x] **SizedBox** – Memberi jarak tetap antar widget atau mengatur ukuran widget.
- [x] **Center** – Menempatkan widget di tengah parent.
- [x] **Align** – Menempatkan widget sesuai alignment tertentu (misalnya kanan atas).

### Input Widgets ⍟

- [x] **TextFormField** – Input teks dengan dukungan validasi, digunakan pada semua form field.
- [x] **DropdownButtonFormField** – Dropdown untuk memilih genre, terintegrasi dengan validasi form.
- [x] **ElevatedButton** – Tombol utama untuk Login, Register, dan Save Data.
- [x] **IconButton** – Tombol icon untuk toggle tema, logout, edit, dan delete.
- [x] **GestureDetector** – Mendeteksi tap pada category chip dan tombol navigasi.

### Display Widgets ⍟

- [x] **Text** – Menampilkan teks dengan berbagai styling (font Jersey 20, letterSpacing, shadows).
- [x] **Icon** – Menampilkan icon Material Design di navbar, card, dan form.
- [x] **Image.network** – Menampilkan cover image dari URL Supabase Storage.
- [x] **Image.file** – Menampilkan preview cover image dari file lokal sebelum diupload.
- [x] **CircularProgressIndicator** – Indikator loading saat proses fetch data atau simpan data.
- [x] **CircleAvatar** – Menampilkan avatar bulat di navbar.

### List & Scroll Widgets ⍟

- [x] **ListView.builder** – Menampilkan daftar album secara efisien dengan lazy loading.
- [x] **SingleChildScrollView** – Membuat konten form bisa di-scroll jika melebihi layar.
- [x] **RefreshIndicator** – Memungkinkan pull-to-refresh untuk memuat ulang data dari Supabase.

### Dialog & Feedback Widgets ⍟

- [x] **AlertDialog** – Dialog konfirmasi untuk aksi hapus data dan logout.
- [x] **SnackBar** – Menampilkan pesan singkat untuk error, sukses, atau validasi.
- [x] **ScaffoldMessenger** – Mengelola tampilan SnackBar secara global.

### Custom / Reusable Widgets ⍟

- [x] **GlassContainer** (`widgets/glass_container.dart`) – Glassmorphism container reusable dengan dukungan Dark/Light mode.
- [x] **AppBackground** (`widgets/app_background.dart`) – Background image + overlay reusable untuk semua halaman.
- [x] **AppTextField** (`widgets/app_text_field.dart`) – Text field reusable dengan styling konsisten dan validasi fleksibel.
- [x] **AppPasswordField** (`widgets/app_password_field.dart`) – Password field reusable dengan toggle visibility built-in.

---

<p align="center">
  <i>© 2026 - UMG Mobile by Putri. All rights reserved.</i>
</p>

---
