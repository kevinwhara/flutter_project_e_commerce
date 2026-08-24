<?php

use App\Models\Product;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

uses(RefreshDatabase::class);

test('authenticated user can list products', function () {
    $user = User::factory()->create(['access_level' => 0]);
    Product::factory()->count(3)->create();

    $response = $this->actingAs($user, 'sanctum')
        ->getJson('/api/products');

    $response->assertStatus(200)
        ->assertJsonCount(3, 'data');
});

test('user with access_level 0 cannot view product detail', function () {
    $user = User::factory()->create(['access_level' => 0]);
    $product = Product::factory()->create();

    $response = $this->actingAs($user, 'sanctum')
        ->getJson("/api/products/{$product->id}");

    $response->assertStatus(403)
        ->assertJson([
            'message' => 'Unauthorized',
        ]);
});

test('user with access_level 1 can view product detail', function () {
    $admin = User::factory()->create(['access_level' => 1]);
    $product = Product::factory()->create(['name' => 'Laptop ASUS']);

    $response = $this->actingAs($admin, 'sanctum')
        ->getJson("/api/products/{$product->id}");

    $response->assertStatus(200)
        ->assertJsonPath('data.name', 'Laptop ASUS');
});

test('getting non-existent product returns 404', function () {
    $admin = User::factory()->create(['access_level' => 1]);

    $response = $this->actingAs($admin, 'sanctum')
        ->getJson('/api/products/99999');

    $response->assertStatus(404)
        ->assertJson([
            'message' => 'Product not found',
        ]);
});

test('user with access_level 1 can create product with image', function () {
    Storage::fake('public');

    $admin = User::factory()->create(['access_level' => 1]);
    $image = UploadedFile::fake()->image('laptop.jpg');

    $response = $this->actingAs($admin, 'sanctum')
        ->postJson('/api/products', [
            'name' => 'Laptop ASUS',
            'description' => 'Gaming laptop',
            'price' => 12500000,
            'stock' => 10,
            'category' => 'Electronics',
            'image' => $image,
        ]);

    $response->assertStatus(201)
        ->assertJsonPath('data.name', 'Laptop ASUS')
        ->assertJsonPath('data.stock', 10);

    $product = Product::first();
    $this->assertNotNull($product->image);
    Storage::disk('public')->assertExists($product->image);
});

test('user with access_level 1 can update product and change image', function () {
    Storage::fake('public');

    $admin = User::factory()->create(['access_level' => 1]);
    $oldImage = UploadedFile::fake()->image('old.jpg');
    $oldPath = $oldImage->store('products', 'public');

    $product = Product::factory()->create([
        'name' => 'Old Product',
        'image' => $oldPath,
    ]);

    $newImage = UploadedFile::fake()->image('new.jpg');

    $response = $this->actingAs($admin, 'sanctum')
        ->postJson("/api/products/{$product->id}", [
            '_method' => 'PUT',
            'name' => 'Updated Product',
            'image' => $newImage,
        ]);

    $response->assertStatus(200)
        ->assertJsonPath('data.name', 'Updated Product');

    $product->refresh();
    Storage::disk('public')->assertMissing($oldPath);
    Storage::disk('public')->assertExists($product->image);
});

test('user with access_level 1 can delete product and its image', function () {
    Storage::fake('public');

    $admin = User::factory()->create(['access_level' => 1]);
    $image = UploadedFile::fake()->image('product.jpg');
    $path = $image->store('products', 'public');

    $product = Product::factory()->create(['image' => $path]);

    $response = $this->actingAs($admin, 'sanctum')
        ->deleteJson("/api/products/{$product->id}");

    $response->assertStatus(200)
        ->assertJson([
            'message' => 'Product deleted',
        ]);

    $this->assertDatabaseMissing('products', ['id' => $product->id]);
    Storage::disk('public')->assertMissing($path);
});
