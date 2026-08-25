# PRD Lengkap — E-Commerce App (Flutter)
**Fase 1–7 | Basis: modul tutorial IDN Boarding School (5 bab)**

---

## 0. Ringkasan Eksekutif

Modul asli (5 bab: Login, Account, Cart, Homepage, Chat) dirancang sebagai
latihan UI terisolasi per halaman — tiap bab bisa didemo sendiri-sendiri
tanpa saling terhubung secara data. Itu cukup untuk latihan widget, tapi
tidak cukup untuk disebut aplikasi. Tiga cacat struktural modul asli yang
PRD ini perbaiki secara sadar (bukan diam-diam):

1. **Tidak ada state yang mengalir antar halaman.** Cart di Homepage dan
   Cart di halaman Cart adalah dua data yang berbeda kalau diikuti apa
   adanya. Diperbaiki di Fase 7.
2. **Navigasi tidak konsisten** — kadang widget langsung sebagai children
   PageView, kadang `pushNamed`, kadang argumen di-comment out (bug nyata
   di kode chat detail modul asli). Diperbaiki di Fase 4 dan 5.
3. **Duplikasi widget builder method** (`_buildXxx()` yang return `Widget`
   di dalam State class) ditulis ulang di HAMPIR SETIAP bab. Ini bukan gaya
   penulisan yang netral — ini anti-pattern yang mencegah Flutter
   melakukan const-optimization dan bikin rebuild tidak perlu. PRD ini
   tidak mengikuti pola itu di fase manapun.

**Keputusan scope:** PRD ini tetap TANPA backend nyata (sesuai modul asli
yang eksplisit bilang "tanpa fungsi backend" di banyak tempat). Yang
dibedakan dari modul asli adalah data mengalir dengan benar secara lokal
(in-memory, lewat Provider), bukan simulasi API.

---

## 1. Arsitektur & Keputusan Teknis Lintas Fase

| Aspek | Keputusan | Alasan |
|---|---|---|
| State management | `provider` package, diperkenalkan di Fase 7 tapi disiapkan strukturnya dari Fase 0 | Modul asli tidak punya ini sama sekali — tanpa ini app-nya kumpulan demo, bukan aplikasi |
| Widget composition | Semua elemen berulang jadi `StatelessWidget`/`StatefulWidget` file terpisah, TIDAK PERNAH method `_buildXxx()` | Konsisten di semua fase, lihat poin 3 di atas |
| Warna & style | Terpusat di `lib/theme/` sejak Fase 0 | Modul asli hardcode `Color(0xFF4C53A5)` berulang di puluhan tempat |
| Routing | Named routes untuk SEMUA halaman turunan (detail produk, detail chat, dst) dengan argumen yang benar-benar terkirim | Modul asli meng-comment-out argumen di ChatDetail — bug nyata yang diwariskan kalau diikuti mentah |
| Data dummy | Satu sumber (`lib/data/dummy_data.dart`) untuk produk, chat, kategori | Modul asli mendefinisikan list dummy terpisah di tiap widget file — tidak bisa dipakai ulang |

---

## 2. Fase 0 — Fondasi Project

**Tujuan:** Semua fase berikutnya punya pijakan yang sama, supaya tidak ada
"nanti direfactor" yang menumpuk.

### Scope
- Struktur folder: `lib/pages`, `lib/widgets`, `lib/theme`, `lib/data`, `lib/models`, `lib/providers` (folder kosong dulu, diisi Fase 7)
- `pubspec.yaml`: curved_navigation_bar ^1.0.6, badges ^3.1.2, flutter_rating_bar ^4.0.1, clippy_flutter ^2.0.0-nullsafety.1, provider (versi stabil terbaru)
- `lib/theme/app_colors.dart`, `lib/theme/app_text_styles.dart`

### Acceptance Criteria
- [ ] `flutter pub get` sukses tanpa error versi
- [ ] `app_colors.dart` minimal punya: primary, secondary, background, error, textPrimary, textSecondary
- [ ] Tidak ada file lain di project yang berisi literal hex color

### Prompt Fase 0
```
Buatkan struktur project Flutter untuk e-commerce app dengan folder
lib/pages, lib/widgets, lib/theme, lib/data, lib/models, lib/providers
(providers boleh kosong untuk saat ini).

Tambahkan pubspec.yaml dependencies:
- curved_navigation_bar: ^1.0.6
- badges: ^3.1.2
- flutter_rating_bar: ^4.0.1
- clippy_flutter: ^2.0.0-nullsafety.1
- provider: (versi stabil terbaru yang kompatibel)

Buat lib/theme/app_colors.dart berisi class AppColors dengan konstanta:
primary (0xFF4C53A5), secondary (0xFF6B7CDA), background (0xFFEDECF2),
error (warna merah standar), textPrimary, textSecondary.

Buat lib/theme/app_text_styles.dart berisi class AppTextStyles dengan
style untuk: heading, subheading, body, caption — masing-masing pakai
AppColors, bukan hex literal.

Jangan buat halaman apapun dulu di fase ini — cukup fondasi.
```

---

## 3. Fase 1 — Login & Auth Flow

*(Sudah dibahas detail sebelumnya — ringkasan di sini, PRD lengkap ada di file terpisah PRD_Fase1_Login_Auth.md)*

### Scope
LoginPage, RegisterPage, `AuthTextField` & `AuthButton` reusable widget,
routing dasar `/login`, `/register`, `/home` (placeholder).

### Acceptance Criteria (ringkas)
- [ ] Validasi email/password berfungsi, termasuk edge case format salah
- [ ] Confirm password di Register match-check real-time
- [ ] Login sukses → `/home`, tombol back tidak bisa balik
- [ ] Register sukses → SnackBar lalu ke `/login`, bukan langsung `/home`
- [ ] Tidak ada method `_buildXxxField()`

### Prompt Fase 1
```
Buat LoginPage dan RegisterPage di lib/pages sesuai berikut:

STRUKTUR FILE:
- lib/pages/login_page.dart
- lib/pages/register_page.dart
- lib/widgets/auth_text_field.dart (StatelessWidget: label, icon,
  controller, validator, isPassword bool untuk toggle show/hide)
- lib/widgets/auth_button.dart (StatelessWidget: label, onPressed)

LOGIN:
- Form + GlobalKey<FormState>, field Email dan Password pakai AuthTextField
- Validasi email: tolak kosong, tanpa '@', tanpa domain/TLD, mengandung spasi
- Validasi password: tolak kosong, minimal 6 karakter
- Password toggle show/hide
- Tombol Login: validate() dulu, valid → pushReplacementNamed ke '/home'
- Link Sign Up → pushNamed ke '/register' (bukan replacement)

REGISTER:
- Field: Nama (min 3 karakter), Email, Password, Confirm Password
- Confirm Password validasi ulang tiap kali text berubah, harus match
- Tombol Register: valid → SnackBar "Registrasi berhasil" →
  pushReplacementNamed ke '/login' (BUKAN ke home)
- Link balik ke Login → Navigator.pop(context)

ATURAN KERAS:
- Semua warna/style dari lib/theme/app_colors.dart dan app_text_styles.dart
- JANGAN buat method _buildXxxField() — semua field instance AuthTextField
- Setup main.dart: initialRoute '/login', routes '/login', '/register',
  '/home' (HomePage sementara Scaffold kosong)

Tunjukkan cara test manual: submit kosong, email format salah, confirm
password beda, login valid, register valid.
```

---

## 4. Fase 2 — Cart Page (mandiri)

**Kenapa sebelum Homepage:** Homepage nanti embed CartPage sebagai salah
satu tab PageView. Kalau Cart belum solid sebagai unit mandiri, integrasi
di Fase 4 akan menumpuk bug dari dua arah sekaligus.

### Perbedaan dari modul asli
Modul asli bikin CartItemSamples dengan `for`-loop 4 item hardcoded,
qty ditampilkan sebagai `Text("01")` statis, tombol +/- tanpa fungsi
("Tugas Pengembangan 3.3.5"). Itu bukan cart, itu gambar cart. Fase ini
langsung bikin qty dan delete fungsional dari awal — karena kalau
ditunda ke "tugas pengembangan", integrasi ke Homepage (Fase 4) dan
Provider (Fase 7) akan lebih menyakitkan.

### Scope
- `lib/models/cart_item.dart` — model sederhana (id, nama, harga, gambar, qty)
- `lib/pages/cart_page.dart` — StatefulWidget, state lokal `List<CartItem>` (akan dipindah ke Provider di Fase 7, TAPI interface-nya sudah harus siap dipindah, bukan ditulis ulang total)
- `lib/widgets/cart_app_bar.dart`, `cart_bottom_nav_bar.dart`, `cart_item_tile.dart`
- Total harga dihitung dari state aktif, bukan angka statis

### Acceptance Criteria
- [ ] Tombol + menambah qty, tombol − mengurangi (tidak bisa di bawah 1)
- [ ] Tombol delete benar-benar menghapus item dari list (state berubah, UI update)
- [ ] Total harga di bottom bar otomatis reflect perubahan qty/delete
- [ ] Data cart didefinisikan di `lib/data/dummy_data.dart`, bukan di dalam widget file
- [ ] Tidak ada method `_buildXxx()` untuk widget berulang

### Prompt Fase 2
```
Buat CartPage dan model pendukungnya:

- lib/models/cart_item.dart: class CartItem dengan id, name, price,
  imageUrl, quantity (mutable untuk qty)
- lib/data/dummy_data.dart: List<CartItem> dummyCartItems (4 item awal)
- lib/pages/cart_page.dart: StatefulWidget, simpan List<CartItem> di
  state (copy dari dummyCartItems), akan dipindah ke Provider nanti
  jadi buat method _incrementQty, _decrementQty, _removeItem sebagai
  method State yang jelas terpisah dari logic UI
- lib/widgets/cart_app_bar.dart: StatelessWidget, tombol back +
  judul "Cart" + icon titik tiga (popup menu sederhana, boleh dummy)
- lib/widgets/cart_bottom_nav_bar.dart: StatelessWidget, terima total
  price sebagai parameter (dihitung dari sum qty*price di CartPage,
  BUKAN angka statis), tombol Checkout (dummy, tampilkan SnackBar
  "Checkout belum tersedia" saat ditekan)
- lib/widgets/cart_item_tile.dart: StatelessWidget per item, terima
  CartItem + callback onIncrement, onDecrement, onDelete — gambar
  dari asset lokal 'images/carts/{id}.jpg', tombol +/- dan delete
  benar-benar memanggil callback, bukan visual dummy

ATURAN KERAS: jangan buat _buildCartItem() sebagai method — harus
CartItemTile sebagai widget class terpisah yang di-loop pakai
ListView.builder atau .map() dari data state.

Tunjukkan cara test manual: tambah qty lalu cek total naik, kurangi
qty sampai 1 lalu cek tidak bisa ke 0, hapus item lalu cek hilang
dari list dan total ikut turun.
```

---

## 5. Fase 3 — Account Page

### Perbedaan dari modul asli
Modul asli: dialog logout langsung `pushNamed` ke `/loginPage` tanpa
membersihkan route stack — artinya tombol back setelah logout masih
bisa balik ke Account Page yang seharusnya sudah tidak bisa diakses.
Ini bug keamanan-UX kecil tapi nyata. Diperbaiki di sini.

### Scope
- `lib/pages/account_page.dart`
- `lib/widgets/profile_header.dart` (gradient, foto, nama, email)
- `lib/widgets/setting_item.dart` (StatelessWidget, BUKAN method)
- `lib/pages/change_password_page.dart` (form dasar, validasi saja)
- Dialog logout dengan SnackBar "Logout Successful" lalu `pushNamedAndRemoveUntil` ke `/login`

### Acceptance Criteria
- [ ] Tap tiap item setting navigasi ke halaman yang benar (Profile, Change Password, Notifications, Help — boleh placeholder untuk yang belum ada halamannya, tapi harus ada route-nya, bukan `onTap: () {}` kosong)
- [ ] Logout: dialog konfirmasi → SnackBar → navigasi ke Login DAN tombol back tidak bisa balik ke Account
- [ ] Change Password: validasi new password ≠ current password (minimal cek tidak sama persis), confirm match

### Prompt Fase 3
```
Buat AccountPage dan pendukungnya:

- lib/widgets/profile_header.dart: StatelessWidget, terima nama+email
  sebagai parameter, gradient background primary→secondary, foto
  ClipOval dari asset
- lib/widgets/setting_item.dart: StatelessWidget (icon, title, onTap)
  dibungkus Card+ListTile — WAJIB class terpisah, bukan method
- lib/pages/account_page.dart: StatefulWidget, susun ProfileHeader +
  list SettingItem (Profile, Change Password, Notifications, Help,
  Logout). Item yang belum punya halaman nyata tetap punya route
  (boleh Scaffold placeholder), jangan onTap kosong.
- lib/pages/change_password_page.dart: form Current Password, New
  Password, Confirm Password. Validasi: New tidak boleh sama persis
  dengan Current (khusus untuk mencegah kesalahan user, bukan security
  check sungguhan karena tidak ada backend), Confirm harus match New.
- Dialog logout: AlertDialog konfirmasi → jika Ya, tampilkan SnackBar
  "Logout Successful" → setelah SnackBar (pakai Future.delayed 1 detik
  atau listener), panggil
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false)
  supaya seluruh route stack sebelumnya dibuang.

Tunjukkan cara test manual: tap tiap setting item cek navigasi benar,
logout lalu coba tombol back — pastikan tidak bisa balik ke Account.
```

---

## 6. Fase 4 — Homepage (titik integrasi pertama)

**Ini fase paling berisiko.** Modul asli embed CartPage dan AccountPage
langsung sebagai `children` PageView (bukan lewat routing), sementara
navigasi ke halaman turunan (detail produk, chat) pakai `pushNamed`.
Campuran ini tidak salah secara teknis — tapi harus jadi keputusan
sadar dengan aturan jelas, bukan konsistensi yang kebetulan.

### Aturan Navigasi (wajib dipegang, tidak boleh dilanggar di fase manapun setelah ini)
- **3 tab utama** (Home, Cart, Account): widget langsung sebagai `children` PageView + CurvedNavigationBar — TIDAK pakai Navigator sama sekali untuk pindah antar 3 ini
- **Semua halaman turunan** (detail produk, detail chat, change password, dst): SELALU named route lewat `Navigator.pushNamed` dengan argumen yang benar-benar dikirim lewat constructor, tidak pernah di-comment atau di-skip

### Scope
- `lib/pages/home_page.dart` — StatefulWidget, PageView + CurvedNavigationBar
- `lib/widgets/home_app_bar.dart`, `categories_widget.dart`, `items_widget.dart`
- Search bar UI (fungsional filter — lihat Fase 6, tapi struktur data disiapkan di sini)
- `lib/pages/product_detail_page.dart` — halaman baru yang TIDAK ada di modul asli tapi wajib ada, karena ItemsWidget nge-navigate ke `"itemsPage"` yang di modul asli tidak pernah didefinisikan isinya

### Acceptance Criteria
- [ ] 3 tab utama berpindah tanpa Navigator, PageController sinkron dengan CurvedNavigationBar index
- [ ] Tap produk di ItemsWidget → `pushNamed` ke ProductDetailPage dengan data produk terkirim lewat argumen (bukan placeholder kosong)
- [ ] Badge notifikasi di HomeAppBar tap → `pushNamed` ke ListChat (halaman dari Fase 5)
- [ ] CategoriesWidget dan ItemsWidget ambil data dari `lib/data/dummy_data.dart`, bukan didefinisikan ulang di dalam widget

### Prompt Fase 4
```
Buat HomePage dan pendukungnya, dengan aturan navigasi berikut yang
WAJIB diikuti:
- 3 tab utama (HomePageContent, CartPage, AccountPage) sebagai children
  PageView + CurvedNavigationBar, TIDAK pakai Navigator untuk berpindah
  antar 3 tab ini
- SEMUA halaman turunan (detail produk, detail chat) WAJIB pakai
  Navigator.pushNamed dengan argumen yang benar-benar dikirim lewat
  constructor — JANGAN comment out argumen atau hardcode data

FILE:
- lib/pages/home_page.dart: StatefulWidget, PageController +
  _currentIndex, body PageView dengan children [HomePageContent(),
  CartPage(), AccountPage()], bottomNavigationBar CurvedNavigationBar
  yang sinkron dengan _currentIndex via onPageChanged dan onTap
- lib/widgets/home_app_bar.dart: StatelessWidget, logo "EcoGlobal",
  badge notifikasi (pakai package badges) yang tap-nya
  Navigator.pushNamed(context, '/chat-list')
- lib/widgets/categories_widget.dart: StatelessWidget, ambil data
  kategori dari lib/data/dummy_data.dart (list nama+gambar), tampilkan
  horizontal scroll
- lib/widgets/items_widget.dart: StatelessWidget, GridView.count 2
  kolom, ambil data produk dari dummy_data.dart (id, nama, harga,
  gambar, diskon). Tap produk → Navigator.pushNamed(context,
  '/product-detail', arguments: product) — product adalah object
  model, bukan cuma nama string
- lib/models/product.dart: class Product (id, name, price, imageUrl,
  discountPercent, description)
- lib/pages/product_detail_page.dart: halaman BARU (tidak ada spek
  detailnya di modul asli, tapi wajib dibuat karena ItemsWidget
  menavigasi kesana) — terima Product lewat
  ModalRoute.of(context)!.settings.arguments, tampilkan gambar besar,
  nama, harga, deskripsi, tombol "Add to Cart" (untuk saat ini boleh
  SnackBar dummy "Ditambahkan ke keranjang" — integrasi nyata ke Cart
  state ada di Fase 7)
- Search bar: TextField dengan hint "Search here...", simpan sebagai
  StatefulWidget terpisah lib/widgets/search_bar_widget.dart, terima
  callback onChanged(String query) — fungsi filter aslinya diisi di
  Fase 6, sekarang cukup callback-nya siap dipanggil

Setup main.dart: tambahkan named route '/home' → HomePage (ganti
placeholder dari Fase 1), '/product-detail' → ProductDetailPage,
'/chat-list' → placeholder dulu (diisi Fase 5)

Tunjukkan cara test manual: pindah 3 tab tanpa lag/reset state,
tap produk cek data yang muncul di detail sama dengan yang ditekan
(bukan produk lain atau kosong).
```

---

## 7. Fase 5 — Chat Feature

### Bug modul asli yang WAJIB diperbaiki
Di modul asli (Bab 5), routing ChatDetail di-hardcode:
```dart
"ChatDetail": (context) => ChatScreen(contactName: 'Nike Official'),
```
dengan argumen asli di-comment out di pemanggilnya. Artinya SEMUA chat
yang diklik di ChatListPage akan membuka detail dengan nama "Nike
Official", tidak peduli chat mana yang ditekan. Ini bukan simplifikasi
yang wajar — ini bug yang lolos karena modulnya sendiri menyisakan kode
mati (`// arguments: {...}`) alih-alih menghapusnya. Fase ini
memperbaikinya sebagai requirement inti, bukan opsional.

### Scope
- `lib/pages/list_chat.dart`, `lib/pages/detail_chat.dart`
- Data chat dari `dummy_data.dart`
- Argumen contactName dan avatarAsset benar-benar terkirim ke ChatScreen

### Acceptance Criteria
- [ ] Klik chat berbeda di list → detail chat menampilkan nama kontak yang SESUAI, bukan selalu sama
- [ ] Indikator belum dibaca di list hilang setelah chat dibuka (state lokal, tidak perlu persist)
- [ ] Kirim pesan di detail chat → bubble baru muncul di posisi kanan (isMe true), list auto-scroll ke bawah
- [ ] Tombol filter "Semua"/"Belum Dibaca" di ChatListPage benar-benar memfilter list

### Prompt Fase 5
```
Buat ChatListPage dan ChatScreen, dengan perbaikan wajib atas bug
modul asli: argumen contactName dan avatarAsset HARUS benar-benar
terkirim dari list ke detail, TIDAK boleh di-hardcode atau di-comment.

FILE:
- lib/models/chat_preview.dart: class ChatPreview (name, lastMessage,
  time, avatarAsset, isUnread bool)
- lib/data/dummy_data.dart: tambahkan List<ChatPreview> dummyChats
- lib/pages/list_chat.dart: StatefulWidget (state lokal untuk filter
  aktif dan status isUnread per item). AppBar "List Chat" + tombol
  search (boleh dummy). Tombol filter "Semua"/"Belum Dibaca" yang
  benar-benar mem-filter List<ChatPreview> yang ditampilkan
  (setState mengganti list yang dipakai ListView.builder).
  ListView.builder menampilkan ChatPreview: avatar (CircleAvatar dari
  AssetImage), nama, pesan terakhir, waktu, indikator merah jika
  isUnread. Tap item:
    Navigator.pushNamed(context, '/chat-detail', arguments: chat)
  lalu setState isUnread = false untuk item itu setelah kembali dari
  detail (pakai .then() pada Future dari pushNamed, atau await).

- lib/pages/detail_chat.dart: StatefulWidget ChatScreen menerima
  ChatPreview lewat ModalRoute.of(context)!.settings.arguments —
  AppBar menampilkan chat.name dan chat.avatarAsset ASLI dari data
  yang diklik, bukan hardcode string apapun.
  State: List<Map<String,dynamic>> messages (text, isMe, time) mulai
  dari 1-2 pesan dummy. TextEditingController untuk input. Fungsi
  _sendMessage(): kalau input tidak kosong, tambahkan ke messages
  dengan isMe true dan waktu sekarang (format HH:mm), clear input,
  setState. ListView.builder reverse:true untuk auto-scroll ke bawah.
  Bubble kanan (isMe true) warna berbeda dari bubble kiri.

Setup main.dart: ganti placeholder '/chat-list' dari Fase 4 jadi
ChatListPage sungguhan, tambahkan route '/chat-detail' → ChatScreen.

Tunjukkan cara test manual: klik chat A cek nama di detail = nama A,
kembali, klik chat B cek nama di detail = nama B (bukan sama dengan A).
Kirim pesan cek bubble muncul di kanan dengan waktu benar.
```

---

## 8. Fase 6 — Tugas Pengembangan Gabungan

**Kenapa dikumpulkan jadi satu fase, bukan dicicil per bab seperti modul
asli:** modul asli menaruh 3-8 "Tugas Pengembangan" di akhir SETIAP bab,
kebanyakan kosmetik (shadow, animasi, ikon). Mengerjakannya sambil masih
di tengah bab yang sama membuat kamu bolak-balik konteks. Dikumpulkan di
sini, dikerjakan setelah semua halaman inti (Fase 1-5) jalan dan
teruji.

### Scope (gabungan dari seluruh "Tugas Pengembangan" modul asli yang punya nilai fungsional nyata — yang murni kosmetik seperti "tambahkan shadow" atau "font italic" TIDAK dimasukkan karena tidak mengubah perilaku app, silakan kerjakan sendiri kalau punya waktu lebih)

| Asal Bab | Item | Kenapa masuk (bukan kosmetik) |
|---|---|---|
| Login | Show/hide password | Sudah masuk Fase 1 |
| Account | Snackbar logout + redirect | Sudah masuk Fase 3 |
| Cart | Qty +/- fungsional, delete fungsional | Sudah masuk Fase 2 |
| Cart | Coupon code input (tanpa backend, tapi input tervalidasi tidak kosong) | Fungsional minimal, bukan dummy visual |
| Homepage | Search benar-benar filter ItemsWidget | Fungsional, bukan UI kosong |
| Homepage | Highlight tab aktif di CurvedNavigationBar | UX nyata — tanpa ini user tidak tahu tab mana yang aktif |
| Chat | Indikator belum dibaca update real-time | Sudah masuk Fase 5 |

### Acceptance Criteria
- [ ] Ketik di search bar Homepage → ItemsWidget hanya tampilkan produk yang namanya match (case-insensitive, substring match cukup)
- [ ] Tab aktif di CurvedNavigationBar punya indikator visual berbeda dari tab tidak aktif
- [ ] Coupon code: input kosong tidak bisa "Apply", input terisi menampilkan SnackBar "Kupon diterapkan" (dummy, tanpa perhitungan diskon nyata karena tidak ada backend)

### Prompt Fase 6
```
Implementasikan fitur berikut pada halaman yang sudah ada:

1. SEARCH FILTER (Homepage): Ubah ItemsWidget menjadi StatefulWidget
   atau kelola state filter di HomePageContent. Saat search_bar_widget
   onChanged terpanggil, filter List<Product> yang ditampilkan
   berdasarkan substring match nama produk (case-insensitive). Kalau
   query kosong, tampilkan semua produk.

2. TAB AKTIF (Homepage): Modifikasi CurvedNavigationBar di home_page.dart
   supaya icon tab yang sedang aktif (_currentIndex) punya warna atau
   ukuran berbeda dari yang tidak aktif — gunakan properti items yang
   conditional berdasarkan index, bukan style statis.

3. COUPON CODE (Cart): Tambahkan TextField + tombol "Apply" di bawah
   tombol "Add Coupon Code" yang sudah ada. Validasi: tombol Apply
   disabled/tidak bereaksi kalau field kosong. Kalau terisi dan
   ditekan, tampilkan SnackBar "Kupon [kode] diterapkan" — tidak perlu
   hitung diskon nyata.

Tunjukkan cara test manual untuk masing-masing tiga fitur di atas.
```

---

## 9. Fase 7 — State Management (Provider) — WAJIB, bukan bonus

**Ini fase yang tidak ada sama sekali di modul asli**, dan tanpa fase
ini, semua fase sebelumnya menghasilkan 7 halaman yang kebetulan bisa
dibuka satu-satu, bukan aplikasi yang koheren. Kalau kamu berhenti di
Fase 6, produk yang di-"Add to Cart" dari ProductDetailPage tidak akan
pernah muncul di CartPage — itu bukan bug kecil, itu fitur inti
e-commerce yang tidak berfungsi.

### Scope
- `lib/providers/cart_provider.dart` — `ChangeNotifier`, menggantikan state lokal `List<CartItem>` yang sebelumnya ada di `CartPage`
- `lib/providers/auth_provider.dart` — status login sederhana (isLoggedIn bool, userName, userEmail), dipakai AccountPage dan HomePage
- Hubungkan `ProductDetailPage.onAddToCart` ke `CartProvider.addItem()` sungguhan
- Hubungkan `LoginPage` sukses ke `AuthProvider.login()`, `AccountPage` baca `AuthProvider` untuk nama/email di ProfileHeader

### Acceptance Criteria
- [ ] Tap "Add to Cart" di ProductDetailPage → buka tab Cart → produk benar-benar muncul di list, bukan cuma SnackBar
- [ ] Kalau produk yang sama di-add dua kali, qty bertambah (bukan duplikat item baru)
- [ ] Badge jumlah item (kalau ada di HomeAppBar/tab Cart) reflect jumlah asli dari CartProvider
- [ ] Login dengan nama tertentu → AccountPage ProfileHeader menampilkan nama itu, bukan data dummy statis
- [ ] Logout → CartProvider dan AuthProvider ter-reset (opsional didiskusikan: apakah cart harus kosong saat logout — dokumentasikan keputusannya, jangan diam-diam)

### Prompt Fase 7
```
Refactor CartPage dan AccountPage untuk pakai Provider, menggantikan
state lokal yang sebelumnya berdiri sendiri:

1. lib/providers/cart_provider.dart:
   class CartProvider extends ChangeNotifier dengan:
   - List<CartItem> _items (private)
   - List<CartItem> get items
   - double get totalPrice (computed dari sum qty*price)
   - int get itemCount
   - void addItem(Product product): kalau product.id sudah ada di
     _items, tambah qty; kalau belum, buat CartItem baru dengan qty 1.
     Panggil notifyListeners().
   - void incrementQty(String itemId), decrementQty(String itemId)
     (tidak boleh di bawah 1), removeItem(String itemId) — semua
     panggil notifyListeners()

2. lib/providers/auth_provider.dart:
   class AuthProvider extends ChangeNotifier dengan:
   - bool isLoggedIn, String? userName, String? userEmail
   - void login(String name, String email): set field, notifyListeners()
   - void logout(): reset semua field ke null/false, notifyListeners()

3. main.dart: bungkus MaterialApp dengan MultiProvider
   (ChangeNotifierProvider untuk CartProvider dan AuthProvider)

4. Ubah CartPage: hapus state List<CartItem> lokal, ganti dengan
   Consumer<CartProvider> atau context.watch<CartProvider>(). Semua
   pemanggilan _incrementQty dkk diganti manggil method di provider.

5. Ubah ProductDetailPage: tombol "Add to Cart" panggil
   context.read<CartProvider>().addItem(product) — hapus SnackBar
   dummy sebelumnya, ganti SnackBar yang muncul SETELAH addItem
   berhasil sebagai konfirmasi.

6. Ubah LoginPage: saat validate() sukses, panggil
   context.read<AuthProvider>().login(namaFromForm, emailFromForm) —
   catatan: karena LoginPage tidak simpan nama (cuma email+password),
   pakai email sebagai userName sementara, atau tambahkan field nama
   di Login kalau mau lebih akurat (putuskan salah satu dan sebutkan
   yang kamu pilih).

7. Ubah AccountPage/ProfileHeader: baca nama+email dari
   context.watch<AuthProvider>() alih-alih data dummy statis. Saat
   logout, panggil context.read<AuthProvider>().logout() sebelum
   navigasi ke Login.

Tunjukkan cara test manual paling penting: dari Homepage, buka detail
produk apapun, tap Add to Cart, pindah ke tab Cart TANPA reload app —
pastikan produk itu benar-benar ada di list dengan qty 1. Tap Add to
Cart produk yang sama sekali lagi dari halaman lain, cek qty di Cart
jadi 2, bukan muncul item duplikat.
```

---

## 10. Ringkasan Urutan & Ketergantungan

```
Fase 0 (Fondasi)
   ↓
Fase 1 (Login/Register) ──┐
   ↓                       │
Fase 2 (Cart mandiri)      │  ketiganya harus solid
   ↓                       │  sebelum Fase 4 karena
Fase 3 (Account)          │  di-embed langsung
   ↓                       │
Fase 4 (Homepage) ←────────┘  ← titik integrasi navigasi
   ↓
Fase 5 (Chat)
   ↓
Fase 6 (Tugas Pengembangan gabungan)
   ↓
Fase 7 (Provider — WAJIB agar app benar-benar terhubung)
```

**Jangan lompat fase.** Fase 4 secara eksplisit bergantung pada Fase
1-3 sudah lolos acceptance criteria masing-masing — kalau Cart di Fase
2 masih punya bug qty, bug itu akan ikut ter-embed ke Homepage dan
lebih susah dilacak sumbernya begitu sudah tercampur dengan PageView
dan Provider.
