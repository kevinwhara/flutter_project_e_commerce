<?php

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

uses(RefreshDatabase::class);

test('authenticated user can list users', function () {
    $authUser = User::factory()->create();
    User::factory()->count(2)->create();

    $response = $this->actingAs($authUser, 'sanctum')
        ->getJson('/api/users');

    $response->assertStatus(200)
        ->assertJsonCount(3, 'data');
});

test('authenticated user can get user detail', function () {
    $user = User::factory()->create(['name' => 'Jane Doe']);

    $response = $this->actingAs($user, 'sanctum')
        ->getJson("/api/users/{$user->id}");

    $response->assertStatus(200)
        ->assertJsonPath('data.name', 'Jane Doe');
});

test('getting non-existent user returns 404', function () {
    $authUser = User::factory()->create();

    $response = $this->actingAs($authUser, 'sanctum')
        ->getJson('/api/users/99999');

    $response->assertStatus(404)
        ->assertJson([
            'message' => 'User not found',
        ]);
});

test('anyone can create user via POST /api/users', function () {
    $response = $this->postJson('/api/users', [
        'name' => 'New User',
        'email' => 'newuser@example.com',
        'password' => 'password123',
    ]);

    $response->assertStatus(201)
        ->assertJsonPath('name', 'New User')
        ->assertJsonPath('email', 'newuser@example.com')
        ->assertJsonPath('access_level', 0);
});

test('authenticated user can update profile and upload avatar', function () {
    Storage::fake('public');

    $user = User::factory()->create(['name' => 'Old Name']);
    $file = UploadedFile::fake()->image('avatar.jpg');

    $response = $this->actingAs($user, 'sanctum')
        ->postJson("/api/users/{$user->id}", [
            '_method' => 'PUT',
            'name' => 'Updated Name',
            'avatar' => $file,
        ]);

    $response->assertStatus(200)
        ->assertJsonPath('data.name', 'Updated Name');

    $user->refresh();
    $this->assertNotNull($user->avatar);
    Storage::disk('public')->assertExists($user->avatar);
});

test('authenticated user can delete user and avatar', function () {
    Storage::fake('public');

    $file = UploadedFile::fake()->image('avatar.jpg');
    $path = $file->store('avatars', 'public');

    $user = User::factory()->create(['avatar' => $path]);
    $authUser = User::factory()->create();

    $response = $this->actingAs($authUser, 'sanctum')
        ->deleteJson("/api/users/{$user->id}");

    $response->assertStatus(200)
        ->assertJson([
            'message' => 'User deleted',
        ]);

    $this->assertDatabaseMissing('users', ['id' => $user->id]);
    Storage::disk('public')->assertMissing($path);
});
