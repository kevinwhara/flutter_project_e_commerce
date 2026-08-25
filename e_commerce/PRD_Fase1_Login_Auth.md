# PRD — Fase 1: Login & Auth Flow

**Project:** E-Commerce App (Flutter)
**Fase:** 1 dari 7
**Prasyarat:** Fase 0 selesai (struktur folder, `app_colors.dart`, `app_text_styles.dart`, dependencies sudah terpasang)
**Status target:** Bisa didemo berdiri sendiri — app buka langsung ke Login, bisa pindah ke Register, keduanya submit-able dengan validasi, tanpa backend nyata.

---

## 1. Tujuan

Modul asli hanya mendefinisikan Login Page dan menyebut Sign Up sebagai link tanpa halaman nyata (`1.3.5. Buat halaman RegisterPage` cuma disebut sebagai tugas, tidak dispesifikasi). Itu cacat: Login yang linknya menuju halaman kosong bukan auth flow, itu setengah fitur. Fase ini menutup gap tersebut dan sekaligus memperbaiki dua kelemahan modul asli:

1. Validasi email di modul pakai regex lemah (`^[^@]+@[^@]+\.[^@]+`) — lolos untuk input tidak masuk akal seperti `a@b.c`. Fase ini tidak mewajibkan regex RFC-lengkap (itu overkill), tapi harus menolak kasus jelas-jelas rusak: tanpa TLD, spasi di dalam email, domain kosong.
2. Modul asli membangun `_buildXxx()` sebagai method yang return `Widget` di dalam State class. Fase ini **tidak mengikuti pola itu** — form field jadi widget class terpisah, reusable, dan bisa `const`.

## 2. Scope

**Masuk:**
- `LoginPage` — form email + password, validasi, tombol Login, link ke Register
- `RegisterPage` — form nama, email, password, confirm password, validasi, tombol Register, link balik ke Login
- Routing dasar di `main.dart`: `initialRoute` ke Login, named routes ke Register dan ke `HomePage` (placeholder kosong — diisi Fase 4)
- Show/hide password toggle di kedua form (ini di modul asli masuk kategori "Tugas Pengembangan" bab lain, tapi logisnya harus ada dari awal karena user akan langsung notice ketiadaannya saat testing manual)

**Tidak masuk (sengaja, bukan lupa):**
- Autentikasi nyata / backend / API call — form hanya validasi lokal, submit sukses = navigasi ke HomePage placeholder
- Persistent session (SharedPreferences, token, dll) — itu butuh backend, belum relevan
- Forgot Password — tidak disebut di modul asli sama sekali, jangan tambah scope yang tidak diminta
- State management global (Provider/Riverpod) — itu Fase 7. Fase ini pakai `StatefulWidget` lokal saja.

## 3. User Stories

| # | Sebagai | Saya ingin | Supaya |
|---|---|---|---|
| 1 | User baru | mendaftar dengan nama, email, password | punya akun untuk masuk ke app |
| 2 | User terdaftar | login dengan email + password | masuk ke Homepage |
| 3 | User | melihat pesan error spesifik saat input salah | tahu persis apa yang perlu diperbaiki, bukan pesan generik |
| 4 | User | toggle show/hide password | bisa mengecek input sebelum submit |
| 5 | User di Login | tap "Don't have an account? Sign Up" | pindah ke Register tanpa reload state Login |
| 6 | User di Register | tap link balik | pindah ke Login |

## 4. Functional Requirements

### 4.1 LoginPage

| ID | Requirement |
|---|---|
| L-01 | Form berisi field Email dan Password, dibungkus `Form` + `GlobalKey<FormState>` |
| L-02 | Field Email: prefix icon email, validasi tidak kosong, validasi format (tolak tanpa `@`, tanpa domain, tanpa TLD, mengandung spasi) |
| L-03 | Field Password: prefix icon lock, `obscureText` default true, suffix icon toggle show/hide, validasi tidak kosong dan minimal 6 karakter |
| L-04 | Tombol Login: `ElevatedButton`, disabled-state opsional tidak wajib, `onPressed` memanggil `_formKey.currentState!.validate()` — jika valid, `Navigator.pushReplacementNamed(context, '/home')` |
| L-05 | Link "Don't have an account? Sign Up" → `Navigator.pushNamed(context, '/register')` (pakai `pushNamed` bukan `pushReplacementNamed`, supaya tombol back masih bisa balik ke Login) |
| L-06 | Warna dan style ambil dari `app_colors.dart` / `app_text_styles.dart` — tidak ada `Color(0xFF...)` hardcoded di file ini |

### 4.2 RegisterPage

| ID | Requirement |
|---|---|
| R-01 | Form berisi field Nama, Email, Password, Confirm Password |
| R-02 | Field Nama: validasi tidak kosong, minimal 3 karakter |
| R-03 | Field Email: validasi sama seperti L-02 |
| R-04 | Field Password: validasi sama seperti L-03 |
| R-05 | Field Confirm Password: validasi tidak kosong DAN harus identik dengan field Password (re-check tiap kali Password berubah, bukan cuma saat submit — pakai `controller.addListener` atau validasi ulang form saat text berubah) |
| R-06 | Tombol Register: jika valid, tampilkan `SnackBar` "Registrasi berhasil" lalu `Navigator.pushReplacementNamed(context, '/login')` — TIDAK langsung ke Home, karena secara logis user harus login setelah daftar (modul asli tidak mendefinisikan behavior ini, jadi ini keputusan desain yang perlu didokumentasikan, bukan diasumsikan) |
| R-07 | Link balik ke Login → `Navigator.pop(context)` jika halaman ini dibuka dari Login (bukan `pushNamed` lagi, supaya tidak menumpuk route) |

### 4.3 Shared Component

| ID | Requirement |
|---|---|
| S-01 | Buat `lib/widgets/auth_text_field.dart` — satu `StatelessWidget` reusable untuk semua field (label, icon, controller, validator, obscureText opsional, toggle opsional) dipakai di Login dan Register. Ini menghindari duplikasi `_buildEmailField()` / `_buildPasswordField()` yang di modul asli ditulis ulang tiap halaman. |
| S-02 | Buat `lib/widgets/auth_button.dart` — `StatelessWidget` untuk tombol submit (label, onPressed) dipakai Login dan Register |

## 5. Data Model (lokal, sementara)

Tidak ada model persist. Cukup `Map` sederhana kalau dibutuhkan untuk simulasi:

```dart
// Tidak disimpan kemana pun di fase ini — hanya lewat form controllers.
// Model User sungguhan baru relevan begitu backend/Fase 7 masuk.
```

Catatan: jangan bikin `class User { ... }` yang tidak dipakai di fase ini. Itu premature abstraction — bikin nanti saat benar-benar ada tempat menyimpannya.

## 6. Routing (main.dart)

```
initialRoute: '/login'
routes:
  '/login'    → LoginPage
  '/register' → RegisterPage
  '/home'     → HomePage (placeholder Scaffold kosong, diisi Fase 4)
```

## 7. Acceptance Criteria

- [ ] Submit Login dengan email/password kosong → muncul error di kedua field, tidak navigasi
- [ ] Submit Login dengan email format salah (`test`, `test@`, `test@a`) → error format, tidak navigasi
- [ ] Submit Login dengan input valid → navigasi ke `/home`, dan tombol back TIDAK bisa balik ke Login (karena `pushReplacementNamed`)
- [ ] Submit Register dengan Confirm Password ≠ Password → error di field Confirm, tidak navigasi
- [ ] Submit Register valid → SnackBar muncul, lalu pindah ke `/login`
- [ ] Toggle show/hide password mengubah `obscureText` tanpa kehilangan isi field
- [ ] Tidak ada hex color yang di-hardcode di luar `app_colors.dart`
- [ ] Tidak ada method `_buildXxxField()` yang return Widget — semua field pakai `AuthTextField`

## 8. Out of Scope — eksplisit, agar tidak scope creep saat implementasi

- Validasi kekuatan password (uppercase/symbol requirement) — tidak diminta modul asli
- Loading state / spinner saat submit — tidak ada operasi async nyata di fase ini
- Error dari server — tidak ada server

---

## Prompt untuk Fase 1

```
Buat LoginPage dan RegisterPage di lib/pages sesuai PRD berikut:

STRUKTUR FILE:
- lib/pages/login_page.dart
- lib/pages/register_page.dart
- lib/widgets/auth_text_field.dart (StatelessWidget reusable: label, icon,
  controller, validator, isPassword bool untuk toggle show/hide)
- lib/widgets/auth_button.dart (StatelessWidget reusable: label, onPressed)

LOGIN PAGE:
- Form dengan GlobalKey<FormState>, field Email dan Password pakai AuthTextField
- Validasi email: tolak kosong, tolak tanpa '@', tolak tanpa domain/TLD, tolak
  yang mengandung spasi
- Validasi password: tolak kosong, minimal 6 karakter
- Password punya toggle show/hide (obscureText default true)
- Tombol Login: validate() dulu, kalau valid Navigator.pushReplacementNamed
  ke '/home'
- Link "Don't have an account? Sign Up" pakai Navigator.pushNamed ke '/register'
  (bukan pushReplacementNamed)

REGISTER PAGE:
- Field: Nama (min 3 karakter), Email (validasi sama seperti Login),
  Password (min 6 karakter), Confirm Password
- Confirm Password harus match Password — validasi ulang saat text berubah,
  bukan cuma saat submit
- Tombol Register: kalau valid, tampilkan SnackBar "Registrasi berhasil",
  lalu Navigator.pushReplacementNamed ke '/login' (BUKAN ke home — user
  harus login dulu setelah daftar)
- Link balik ke Login pakai Navigator.pop(context)

ATURAN KERAS:
- Semua warna dan text style HARUS dari lib/theme/app_colors.dart dan
  app_text_styles.dart yang sudah dibuat di Fase 0 — jangan hardcode
  Color(0xFF...) di file manapun
- JANGAN buat method seperti _buildEmailField() yang return Widget di dalam
  State class — semua field harus instance dari AuthTextField
- Setup routing di main.dart: initialRoute '/login', named routes '/login',
  '/register', '/home' (HomePage sementara Scaffold kosong dengan Text
  'Home Placeholder')

Setelah selesai, tunjukkan cara saya test manual acceptance criteria berikut:
1. Submit kosong di kedua form → harus muncul error tanpa navigasi
2. Email format salah (test, test@, test@a) → harus ditolak
3. Confirm password beda dari password → harus ditolak
4. Login valid → masuk home, tombol back tidak bisa balik ke login
5. Register valid → snackbar muncul, lalu pindah ke login (bukan home)
```
