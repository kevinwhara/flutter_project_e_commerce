# Execution Plan: Laravel 13 Sanctum API Development

Dokumen ini berisi rencana eksekusi dan strategi git push untuk implementasi Restful API e-commerce menggunakan **Laravel 13** dan **Sanctum** berdasarkan acuan `docs/API-REFERENCE.md`.

---

## 1. Ringkasan & Tujuan Project

Mengimplementasikan API backend lengkap untuk kebutuhan e-commerce dan pembelajaran Full-Stack, meliputi:
- **Authentication**: Register, Login, Logout (Laravel Sanctum Token-based Authentication).
- **User Management**: List Users, Detail User, Create User, Update User + Upload Avatar, Delete User + Hapus Avatar.
- **Product Management**: List Products, Detail Product, Create Product + Upload Image, Update Product + Image, Delete Product + Hapus Image.
- **Access Level Security**: Middleware kustom (`accessLevel`) untuk membatasi endpoint tertentu hanya bagi user dengan `access_level > 0`.
- **Response Standard**: Format JSON konsisten sesuai spec HTTP Status Code 200, 201, 401, 403, 404, dan 422.

---

## 2. Rencana Tahapan Eksekusi Codebase

### Tahap 1: Database & Model Setup
1. **Modifikasi Tabel `users`**:
   - Buat migrasi untuk menambahkan kolom `avatar` (nullable string) dan `access_level` (integer, default 0).
2. **Buat Tabel `products`**:
   - Skema: `id`, `name` (string), `description` (text, nullable), `price` (decimal 15,2), `stock` (integer), `category` (string, nullable), `image` (string, nullable), `timestamps`.
3. **Update Model `User`**:
   - Sertakan trait `HasApiTokens`.
   - Update `#[Fillable]` & `casts` untuk `avatar` dan `access_level`.
4. **Buat Model & Factory `Product`**:
   - Model `Product` dengan `#[Fillable]` & `casts`.
   - Factory `ProductFactory` untuk kebutuhan testing.
5. **Storage Symlink**:
   - Jalankan `php artisan storage:link` agar file upload publik di `storage/app/public` dapat diakses via URL `http://localhost:8000/storage/...`.

### Tahap 2: Middleware Access Level
1. **Buat Middleware `EnsureAccessLevel`** (alias route: `accessLevel`):
   - Mengecek apakah user terautentikasi memiliki `access_level > 0`.
   - Jika `access_level <= 0`, kembalikan JSON HTTP 403:
     ```json
     { "message": "Unauthorized" }
     ```

### Tahap 3: Form Requests & Custom Exception Handling
1. **Form Requests**:
   - `RegisterRequest`: Validasi `name`, `email` (unique), `password` (confirmed).
   - `LoginRequest`: Validasi `email`, `password`.
   - `StoreUserRequest` & `UpdateUserRequest`: Validasi data user & upload `avatar` (image, max 2MB).
   - `StoreProductRequest` & `UpdateProductRequest`: Validasi data produk & upload `image` (image, max 2MB).
2. **Exception Handling / Custom Response 404**:
   - Penyesuaian response `ModelNotFoundException` agar mengembalikan pesan `"User not found"` / `"Product not found"` sesuai spesifikasi.

### Tahap 4: Controllers & Eloquent API Resources
1. **`AuthController`**:
   - `register()`: Buat user baru, buat token Sanctum, return response 201 (`user`, `access_token`, `token_type`).
   - `login()`: Cek kredensial, return 200 (`access_token`, `token_type`) atau 401 (`"message": "Invalid credentials"`).
   - `logout()`: Revoke token yang sedang aktif, return 200 (`"message": "Logged out successfully"`).
2. **`UserController`**:
   - `index()`: Mengembalikan daftar user (dengan URL avatar publik).
   - `show($id)`: Mengembalikan detail user atau 404 `"User not found"`.
   - `store()`: Membuat user tanpa auto-login.
   - `update($id)`: Update data & avatar (hapus avatar lama jika ada gambar baru). Support method spoofing `_method: PUT` pada request multipart form-data.
   - `destroy($id)`: Menghapus user dan file avatar terkait dari storage.
3. **`ProductController`**:
   - `index()`: Daftar produk (Public auth:sanctum).
   - `show($id)`: Detail produk (auth:sanctum + `accessLevel`).
   - `store()`: Buat produk + upload gambar (auth:sanctum + `accessLevel`).
   - `update($id)`: Update produk + ganti gambar (auth:sanctum + `accessLevel`, `_method: PUT`).
   - `destroy($id)`: Hapus produk & file gambar (auth:sanctum + `accessLevel`).

### Tahap 5: API Routing Configuration
1. **Konfigurasi `routes/api.php`**:
   - Route Public: `POST /register`, `POST /login`, `POST /users`.
   - Route Protected (`auth:sanctum`): `POST /logout`, `GET /users`, `GET /users/{id}`, `PUT /users/{id}`, `DELETE /users/{id}`, `GET /products`.
   - Route Protected Level (`auth:sanctum` & `accessLevel`): `GET /products/{id}`, `POST /products`, `PUT /products/{id}`, `DELETE /products/{id}`.

### Tahap 6: Automated Testing (Pest) & Formatting
1. **Pest Feature Tests**:
   - `tests/Feature/AuthTest.php`: Test register, login (valid/invalid), logout.
   - `tests/Feature/UserTest.php`: Test User CRUD, 404 response, avatar upload & deletion.
   - `tests/Feature/ProductTest.php`: Test Product CRUD, accessLevel middleware (403 forbidden check), image upload & deletion.
2. **Code Formatting**:
   - Run `vendor/bin/pint --dirty --format agent` untuk memastikan standar kode PHP 8.4 Laravel.

---

## 3. Rencana & Strategi Git Push

### Informasi Branch
- **Current Branch**: `kevin`
- **Remote**: `origin` (`https://github.com/kevinwhara/flutter_project_e_commerce.git`)

### Strategi Commit (Atomic Commits)
Setiap tahapan akan dicommit secara bertahap dengan format Conventional Commits agar histori repository bersih dan terstruktur:

1. **Commit 1: Setup Database & Models**
   ```bash
   git add database/ app/Models/
   git commit -m "feat(database): add user avatar/access_level and create products table migration"
   ```
2. **Commit 2: Access Level Middleware**
   ```bash
   git add app/Http/Middleware/ bootstrap/app.php
   git commit -m "feat(middleware): add accessLevel middleware for authorization checks"
   ```
3. **Commit 3: Authentication API**
   ```bash
   git add app/Http/Controllers/AuthController.php app/Http/Requests/ routes/api.php
   git commit -m "feat(auth): implement register, login, and logout endpoints with sanctum"
   ```
4. **Commit 4: User Management API**
   ```bash
   git add app/Http/Controllers/UserController.php app/Http/Requests/ app/Http/Resources/ routes/api.php
   git commit -m "feat(user): implement user CRUD endpoints and avatar upload"
   ```
5. **Commit 5: Product Management API**
   ```bash
   git add app/Http/Controllers/ProductController.php app/Http/Requests/ app/Http/Resources/ routes/api.php
   git commit -m "feat(product): implement product CRUD endpoints with image upload and accessLevel"
   ```
6. **Commit 6: Automated Tests**
   ```bash
   git add tests/
   git commit -m "test: add pest tests for auth, user, and product endpoints"
   ```
7. **Commit 7: Final Documentation & Sync**
   ```bash
   git add docs/
   git commit -m "docs: add api execution plan and update reference"
   ```

### Langkah Execution Command Git Push
Setelah seluruh tahapan selesai dikembangkan dan pengujian Pest Lolos 100%:
```bash
git push origin kevin
```

---

## 4. Rencana Verifikasi (Verification Plan)

1. **Automated Unit & Feature Tests**:
   - Run `php artisan test --compact` untuk memastikan seluruh skenario auth, authorization 403, 404 handling, dan CRUD file upload sukses tanpa error.
2. **Pint Code Style Verification**:
   - Run `vendor/bin/pint --dirty --format agent`.
