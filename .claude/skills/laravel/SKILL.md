# Laravel Development Skill

Guidelines for developing Laravel applications following best practices.

---

## Laravel Conventions

### Directory Structure

| Directory | Purpose |
|-----------|---------|
| `app/Console` | Artisan commands |
| `app/Exceptions` | Exception handlers |
| `app/Http/Controllers` | HTTP controllers |
| `app/Http/Middleware` | Request middleware |
| `app/Http/Requests` | Form request validation |
| `app/Models` | Eloquent models |
| `app/Providers` | Service providers |
| `app/Services` | Business logic (custom) |
| `app/Actions` | Single-action classes (custom) |
| `database/migrations` | Database migrations |
| `database/factories` | Model factories |
| `database/seeders` | Database seeders |
| `resources/views` | Blade templates |
| `routes/web.php` | Web routes |
| `routes/api.php` | API routes |

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Controllers | PascalCase + Controller | `UserController` |
| Models | Singular PascalCase | `User`, `BlogPost` |
| Tables | Plural snake_case | `users`, `blog_posts` |
| Migrations | Snake_case with timestamp | `2024_01_01_create_users_table` |
| Form Requests | PascalCase + Request | `StoreUserRequest` |
| Events | Past tense PascalCase | `UserCreated` |
| Listeners | PascalCase | `SendWelcomeEmail` |
| Jobs | PascalCase | `ProcessPayment` |

---

## Controllers

### Resource Controller

```php
<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Http\Requests\StorePostRequest;
use App\Http\Requests\UpdatePostRequest;
use App\Models\Post;
use Illuminate\Http\RedirectResponse;
use Illuminate\View\View;

final class PostController extends Controller
{
    public function index(): View
    {
        $posts = Post::query()
            ->with('author')
            ->latest()
            ->paginate(15);

        return view('posts.index', compact('posts'));
    }

    public function create(): View
    {
        return view('posts.create');
    }

    public function store(StorePostRequest $request): RedirectResponse
    {
        Post::create($request->validated());

        return redirect()
            ->route('posts.index')
            ->with('success', 'Post created successfully.');
    }

    public function show(Post $post): View
    {
        return view('posts.show', compact('post'));
    }

    public function edit(Post $post): View
    {
        return view('posts.edit', compact('post'));
    }

    public function update(UpdatePostRequest $request, Post $post): RedirectResponse
    {
        $post->update($request->validated());

        return redirect()
            ->route('posts.show', $post)
            ->with('success', 'Post updated successfully.');
    }

    public function destroy(Post $post): RedirectResponse
    {
        $post->delete();

        return redirect()
            ->route('posts.index')
            ->with('success', 'Post deleted successfully.');
    }
}
```

### API Controller

```php
<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StorePostRequest;
use App\Http\Resources\PostResource;
use App\Models\Post;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

final class PostController extends Controller
{
    public function index(): AnonymousResourceCollection
    {
        $posts = Post::query()
            ->with('author')
            ->latest()
            ->paginate(15);

        return PostResource::collection($posts);
    }

    public function store(StorePostRequest $request): PostResource
    {
        $post = Post::create($request->validated());

        return new PostResource($post);
    }

    public function show(Post $post): PostResource
    {
        return new PostResource($post->load('author', 'comments'));
    }

    public function destroy(Post $post): JsonResponse
    {
        $post->delete();

        return response()->json(null, 204);
    }
}
```

---

## Form Requests

```php
<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

final class StorePostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // Or: return $this->user()->can('create', Post::class);
    }

    /**
     * @return array<string, array<int, string>>
     */
    public function rules(): array
    {
        return [
            'title' => ['required', 'string', 'max:255'],
            'body' => ['required', 'string', 'min:100'],
            'published_at' => ['nullable', 'date'],
            'category_id' => ['required', 'exists:categories,id'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'body.min' => 'The post body must be at least 100 characters.',
        ];
    }
}
```

---

## Eloquent Models

### Model Definition

```php
<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

final class Post extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $fillable = [
        'title',
        'slug',
        'body',
        'published_at',
        'author_id',
        'category_id',
    ];

    protected $casts = [
        'published_at' => 'datetime',
        'is_featured' => 'boolean',
    ];

    // Relationships

    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class, 'author_id');
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function comments(): HasMany
    {
        return $this->hasMany(Comment::class);
    }

    // Scopes

    public function scopePublished($query)
    {
        return $query->whereNotNull('published_at')
            ->where('published_at', '<=', now());
    }

    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }

    // Accessors

    public function getExcerptAttribute(): string
    {
        return str($this->body)->limit(150)->toString();
    }

    // Mutators

    protected function title(): Attribute
    {
        return Attribute::make(
            set: fn (string $value) => [
                'title' => $value,
                'slug' => str($value)->slug()->toString(),
            ],
        );
    }
}
```

### Query Builder Best Practices

```php
<?php
// Good: Eager load relationships
$posts = Post::with(['author', 'category'])->get();

// Good: Select specific columns
$posts = Post::select(['id', 'title', 'created_at'])->get();

// Good: Use query scopes
$posts = Post::published()->featured()->get();

// Good: Chunking for large datasets
Post::chunk(100, function ($posts) {
    foreach ($posts as $post) {
        // Process...
    }
});

// Good: Use cursor for memory efficiency
foreach (Post::cursor() as $post) {
    // Process...
}
```

---

## Services Pattern

### Service Class

```php
<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Post;
use App\Models\User;
use Illuminate\Support\Facades\DB;

final class PostService
{
    public function create(User $author, array $data): Post
    {
        return DB::transaction(function () use ($author, $data) {
            $post = $author->posts()->create($data);

            if (isset($data['tags'])) {
                $post->tags()->sync($data['tags']);
            }

            return $post->fresh(['author', 'tags']);
        });
    }

    public function update(Post $post, array $data): Post
    {
        return DB::transaction(function () use ($post, $data) {
            $post->update($data);

            if (isset($data['tags'])) {
                $post->tags()->sync($data['tags']);
            }

            return $post->fresh(['author', 'tags']);
        });
    }

    public function delete(Post $post): bool
    {
        return DB::transaction(function () use ($post) {
            $post->comments()->delete();
            return $post->delete();
        });
    }
}
```

### Using in Controller

```php
<?php

final class PostController extends Controller
{
    public function __construct(
        private readonly PostService $postService
    ) {}

    public function store(StorePostRequest $request): RedirectResponse
    {
        $post = $this->postService->create(
            auth()->user(),
            $request->validated()
        );

        return redirect()->route('posts.show', $post);
    }
}
```

---

## Actions Pattern

Single-purpose classes for specific operations:

```php
<?php

declare(strict_types=1);

namespace App\Actions;

use App\Models\User;
use Illuminate\Support\Facades\Hash;

final class CreateUser
{
    public function execute(array $data): User
    {
        return User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
        ]);
    }
}

// Usage
$user = app(CreateUser::class)->execute($validated);
```

---

## API Resources

```php
<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

final class PostResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'slug' => $this->slug,
            'excerpt' => $this->excerpt,
            'body' => $this->when($request->routeIs('api.posts.show'), $this->body),
            'published_at' => $this->published_at?->toIso8601String(),
            'author' => new UserResource($this->whenLoaded('author')),
            'comments_count' => $this->whenCounted('comments'),
            'created_at' => $this->created_at->toIso8601String(),
        ];
    }
}
```

---

## Migrations

```php
<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('posts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('author_id')->constrained('users')->cascadeOnDelete();
            $table->foreignId('category_id')->constrained()->cascadeOnDelete();
            $table->string('title');
            $table->string('slug')->unique();
            $table->text('body');
            $table->boolean('is_featured')->default(false);
            $table->timestamp('published_at')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index(['published_at', 'is_featured']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('posts');
    }
};
```

---

## Testing with Pest

### Feature Test

```php
<?php

use App\Models\Post;
use App\Models\User;

it('can list posts', function () {
    $posts = Post::factory()->count(3)->create();

    $response = $this->get(route('posts.index'));

    $response->assertOk();
    $response->assertViewHas('posts');
});

it('can create a post', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)->post(route('posts.store'), [
        'title' => 'Test Post',
        'body' => str_repeat('Test content. ', 20),
        'category_id' => Category::factory()->create()->id,
    ]);

    $response->assertRedirect(route('posts.index'));
    $this->assertDatabaseHas('posts', ['title' => 'Test Post']);
});

it('validates required fields', function () {
    $user = User::factory()->create();

    $response = $this->actingAs($user)->post(route('posts.store'), []);

    $response->assertSessionHasErrors(['title', 'body', 'category_id']);
});

it('requires authentication to create', function () {
    $response = $this->post(route('posts.store'), []);

    $response->assertRedirect(route('login'));
});
```

### Unit Test

```php
<?php

use App\Models\Post;

it('generates excerpt from body', function () {
    $post = Post::factory()->make([
        'body' => str_repeat('Lorem ipsum dolor sit amet. ', 50),
    ]);

    expect($post->excerpt)->toHaveLength(150 + 3); // 150 + "..."
});

it('generates slug from title', function () {
    $post = Post::factory()->create([
        'title' => 'Hello World Post',
    ]);

    expect($post->slug)->toBe('hello-world-post');
});
```

---

## Events and Listeners

### Event

```php
<?php

declare(strict_types=1);

namespace App\Events;

use App\Models\User;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

final class UserRegistered
{
    use Dispatchable;
    use SerializesModels;

    public function __construct(
        public readonly User $user
    ) {}
}
```

### Listener

```php
<?php

declare(strict_types=1);

namespace App\Listeners;

use App\Events\UserRegistered;
use App\Mail\WelcomeEmail;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Support\Facades\Mail;

final class SendWelcomeEmail implements ShouldQueue
{
    public function handle(UserRegistered $event): void
    {
        Mail::to($event->user->email)->send(
            new WelcomeEmail($event->user)
        );
    }
}
```

---

## Jobs

```php
<?php

declare(strict_types=1);

namespace App\Jobs;

use App\Models\Post;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

final class ProcessPostImages implements ShouldQueue
{
    use Dispatchable;
    use InteractsWithQueue;
    use Queueable;
    use SerializesModels;

    public int $tries = 3;

    public int $backoff = 60;

    public function __construct(
        private readonly Post $post
    ) {}

    public function handle(): void
    {
        // Process images...
    }

    public function failed(\Throwable $exception): void
    {
        // Handle failure...
    }
}
```

---

## Middleware

```php
<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

final class EnsureUserIsAdmin
{
    public function handle(Request $request, Closure $next): Response
    {
        if (! $request->user()?->is_admin) {
            abort(403, 'Unauthorized');
        }

        return $next($request);
    }
}
```

---

## Configuration

### Environment Variables

```php
<?php
// config/services.php
return [
    'stripe' => [
        'key' => env('STRIPE_KEY'),
        'secret' => env('STRIPE_SECRET'),
        'webhook_secret' => env('STRIPE_WEBHOOK_SECRET'),
    ],
];

// Usage
$key = config('services.stripe.key');
```

### Custom Config

```php
<?php
// config/app-settings.php
return [
    'posts_per_page' => env('POSTS_PER_PAGE', 15),
    'cache_ttl' => env('CACHE_TTL', 3600),
];
```

---

## Common Patterns

### Repository Pattern (Optional)

```php
<?php

declare(strict_types=1);

namespace App\Repositories;

use App\Models\Post;
use Illuminate\Pagination\LengthAwarePaginator;

final class PostRepository
{
    public function __construct(
        private readonly Post $model
    ) {}

    public function paginate(int $perPage = 15): LengthAwarePaginator
    {
        return $this->model
            ->with('author')
            ->latest()
            ->paginate($perPage);
    }

    public function findBySlug(string $slug): ?Post
    {
        return $this->model
            ->where('slug', $slug)
            ->first();
    }
}
```

### Data Transfer Objects

```php
<?php

declare(strict_types=1);

namespace App\DataTransferObjects;

final readonly class CreatePostData
{
    public function __construct(
        public string $title,
        public string $body,
        public int $categoryId,
        public ?array $tags = null,
        public ?\DateTimeInterface $publishedAt = null,
    ) {}

    public static function fromRequest(StorePostRequest $request): self
    {
        return new self(
            title: $request->validated('title'),
            body: $request->validated('body'),
            categoryId: $request->validated('category_id'),
            tags: $request->validated('tags'),
            publishedAt: $request->validated('published_at'),
        );
    }
}
```

---

## Performance Tips

### Eager Loading

```php
<?php
// Always eager load relationships you'll use
$posts = Post::with(['author', 'category', 'tags'])->get();

// Conditional eager loading
$posts = Post::with(['comments' => function ($query) {
    $query->where('approved', true)->latest();
}])->get();
```

### Caching

```php
<?php
use Illuminate\Support\Facades\Cache;

// Simple caching
$posts = Cache::remember('featured_posts', 3600, function () {
    return Post::featured()->with('author')->get();
});

// Cache tags (Redis/Memcached only)
$posts = Cache::tags(['posts'])->remember('all_posts', 3600, fn () =>
    Post::all()
);

// Clear cache on update
Cache::tags(['posts'])->flush();
```

### Database Optimization

```php
<?php
// Use query builder for bulk operations
Post::where('published_at', '<', now()->subYear())->delete();

// Avoid N+1 with withCount
$posts = Post::withCount('comments')->get();
// Access: $post->comments_count

// Use chunk for large datasets
Post::chunk(200, function ($posts) {
    foreach ($posts as $post) {
        // Process...
    }
});
```
