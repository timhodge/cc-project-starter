# Security Patterns

Reusable security patterns for PHP projects. Implement these based on your project's needs.

---

## Form Protection

### 1. CSRF Token Protection

Generate and validate tokens to prevent cross-site request forgery.

```php
<?php
declare(strict_types=1);

/**
 * Generate a CSRF token (call once per session).
 */
function generate_csrf_token(): string {
    if (!isset($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

/**
 * Validate a CSRF token (constant-time comparison).
 */
function validate_csrf_token(?string $token): bool {
    if ($token === null || !isset($_SESSION['csrf_token'])) {
        return false;
    }
    return hash_equals($_SESSION['csrf_token'], $token);
}

// In your form:
// <input type="hidden" name="csrf_token" value="<?= htmlspecialchars(generate_csrf_token()) ?>">

// On form submission:
if (!validate_csrf_token($_POST['csrf_token'] ?? null)) {
    http_response_code(403);
    exit('Invalid request');
}
```

### 2. Honeypot Field

Hidden field that bots fill out but humans don't see.

```php
<?php
// In your form (CSS hides this from humans):
// <div style="position: absolute; left: -9999px;">
//     <input type="text" name="website_url" tabindex="-1" autocomplete="off">
// </div>

// On submission:
if (!empty($_POST['website_url'])) {
    // Bot detected - silently reject
    http_response_code(200); // Don't reveal detection
    exit;
}
```

### 3. Form Timing Check

Reject submissions that happen too fast (bots) or too slow (replay attacks).

```php
<?php
// When rendering the form:
$form_token = bin2hex(random_bytes(16));
$_SESSION['form_tokens'][$form_token] = time();
// <input type="hidden" name="form_token" value="<?= $form_token ?>">

// On submission:
$token = $_POST['form_token'] ?? '';
$min_time = 3;    // Minimum seconds to fill form
$max_time = 3600; // Maximum seconds (1 hour)

if (!isset($_SESSION['form_tokens'][$token])) {
    http_response_code(400);
    exit('Invalid form');
}

$elapsed = time() - $_SESSION['form_tokens'][$token];
unset($_SESSION['form_tokens'][$token]); // One-time use

if ($elapsed < $min_time) {
    // Too fast - likely a bot
    http_response_code(200);
    exit;
}

if ($elapsed > $max_time) {
    // Too slow - form expired
    http_response_code(400);
    exit('Form expired. Please refresh and try again.');
}
```

---

## Rate Limiting

### IP-Based Rate Limiting (File Storage)

Simple rate limiting without a database.

```php
<?php
declare(strict_types=1);

final class RateLimiter {
    private const STORAGE_DIR = '/tmp/rate_limits';

    public function __construct(
        private int $maxRequests = 10,
        private int $windowSeconds = 60
    ) {
        if (!is_dir(self::STORAGE_DIR)) {
            mkdir(self::STORAGE_DIR, 0700, true);
        }
    }

    public function check(string $ip): bool {
        $file = self::STORAGE_DIR . '/' . md5($ip);
        $now = time();

        // Read existing requests
        $requests = [];
        if (file_exists($file)) {
            $data = file_get_contents($file);
            $requests = $data ? json_decode($data, true) ?? [] : [];
        }

        // Filter to requests within window
        $requests = array_filter(
            $requests,
            fn($timestamp) => $timestamp > ($now - $this->windowSeconds)
        );

        // Check limit
        if (count($requests) >= $this->maxRequests) {
            return false;
        }

        // Add current request
        $requests[] = $now;
        file_put_contents($file, json_encode($requests), LOCK_EX);

        return true;
    }
}

// Usage:
$limiter = new RateLimiter(maxRequests: 10, windowSeconds: 60);
$ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';

if (!$limiter->check($ip)) {
    http_response_code(429);
    exit('Too many requests. Please try again later.');
}
```

---

## Input Validation & Sanitization

### Escape Output (Always)

```php
<?php
// HTML context
echo htmlspecialchars($userInput, ENT_QUOTES, 'UTF-8');

// URL context
echo urlencode($userInput);

// JavaScript context (in data attribute)
echo htmlspecialchars(json_encode($userInput), ENT_QUOTES, 'UTF-8');
```

### Validate Input Types

```php
<?php
// Email
$email = filter_var($_POST['email'] ?? '', FILTER_VALIDATE_EMAIL);
if ($email === false) {
    $errors[] = 'Invalid email address';
}

// Integer
$quantity = filter_var($_POST['quantity'] ?? '', FILTER_VALIDATE_INT, [
    'options' => ['min_range' => 1, 'max_range' => 100]
]);
if ($quantity === false) {
    $errors[] = 'Quantity must be between 1 and 100';
}

// URL
$url = filter_var($_POST['website'] ?? '', FILTER_VALIDATE_URL);

// Sanitize string (remove tags, encode special chars)
$name = filter_var($_POST['name'] ?? '', FILTER_SANITIZE_SPECIAL_CHARS);
```

### Validate Against Allowlist

```php
<?php
$allowed_actions = ['view', 'edit', 'delete'];
$action = $_GET['action'] ?? '';

if (!in_array($action, $allowed_actions, true)) {
    http_response_code(400);
    exit('Invalid action');
}
```

---

## Environment Configuration

### Store Secrets Outside Web Root

```
/var/www/
├── .env                 # Secrets here (NOT web accessible)
├── html/                # Web root
│   ├── index.php
│   └── ...
└── src/                 # PHP classes (NOT web accessible)
```

### Load Environment Variables Safely

```php
<?php
declare(strict_types=1);

final readonly class Config {
    public string $apiKey;
    public string $dbPassword;

    public function __construct() {
        $this->apiKey = self::requireEnv('API_KEY');
        $this->dbPassword = self::requireEnv('DB_PASSWORD');
    }

    private static function requireEnv(string $name): string {
        // Check $_ENV first (populated by php.ini variables_order)
        if (isset($_ENV[$name]) && $_ENV[$name] !== '') {
            return $_ENV[$name];
        }

        // Fall back to getenv()
        $value = getenv($name);
        if ($value !== false && $value !== '') {
            return $value;
        }

        throw new RuntimeException("Missing required environment variable: {$name}");
    }
}
```

---

## HTTP Security Headers

Add to your `.htaccess` or PHP response:

```php
<?php
// Prevent clickjacking
header('X-Frame-Options: SAMEORIGIN');

// Prevent MIME type sniffing
header('X-Content-Type-Options: nosniff');

// Enable XSS filter (legacy browsers)
header('X-XSS-Protection: 1; mode=block');

// Control referrer information
header('Referrer-Policy: strict-origin-when-cross-origin');

// Restrict browser features
header('Permissions-Policy: geolocation=(), microphone=(), camera=()');

// Content Security Policy (customize as needed)
// header("Content-Security-Policy: default-src 'self'; script-src 'self' https://cdn.example.com");
```

---

## User-Agent Validation

Block known bad actors and headless browsers.

```php
<?php
function is_suspicious_user_agent(string $ua): bool {
    $ua_lower = strtolower($ua);

    // Block empty user agents
    if (trim($ua) === '') {
        return true;
    }

    // Block headless browsers
    $headless_patterns = [
        'headless',
        'phantomjs',
        'selenium',
        'puppeteer',
        'playwright',
    ];

    foreach ($headless_patterns as $pattern) {
        if (str_contains($ua_lower, $pattern)) {
            return true;
        }
    }

    // Block very old browsers (likely bots spoofing)
    if (preg_match('/MSIE [1-8]\./', $ua)) {
        return true;
    }

    return false;
}

$ua = $_SERVER['HTTP_USER_AGENT'] ?? '';
if (is_suspicious_user_agent($ua)) {
    http_response_code(403);
    exit;
}
```

---

## Defensive Superglobal Access

Always validate and type-check superglobals.

```php
<?php
// Bad - trusts superglobal
$host = $_SERVER['HTTP_HOST'];

// Good - defensive access
$host = isset($_SERVER['HTTP_HOST']) && is_string($_SERVER['HTTP_HOST'])
    ? $_SERVER['HTTP_HOST']
    : 'localhost';

// For POST data
$email = isset($_POST['email']) && is_string($_POST['email'])
    ? trim($_POST['email'])
    : '';
```

---

## Database Security

### Prepared Statements (Always)

```php
<?php
// Bad - SQL injection vulnerable
$query = "SELECT * FROM users WHERE email = '{$_POST['email']}'";

// Good - prepared statement
$stmt = $pdo->prepare('SELECT * FROM users WHERE email = :email');
$stmt->execute(['email' => $_POST['email']]);
```

### Escape for LIKE Queries

```php
<?php
function escape_like(string $value): string {
    return addcslashes($value, '%_\\');
}

$search = escape_like($_GET['q'] ?? '');
$stmt = $pdo->prepare('SELECT * FROM products WHERE name LIKE :search');
$stmt->execute(['search' => "%{$search}%"]);
```

---

## File Upload Security

```php
<?php
$allowed_types = ['image/jpeg', 'image/png', 'image/webp'];
$max_size = 5 * 1024 * 1024; // 5MB

if (!isset($_FILES['upload'])) {
    exit('No file uploaded');
}

$file = $_FILES['upload'];

// Check for upload errors
if ($file['error'] !== UPLOAD_ERR_OK) {
    exit('Upload failed');
}

// Validate file size
if ($file['size'] > $max_size) {
    exit('File too large');
}

// Validate MIME type (check actual content, not just extension)
$finfo = new finfo(FILEINFO_MIME_TYPE);
$mime = $finfo->file($file['tmp_name']);

if (!in_array($mime, $allowed_types, true)) {
    exit('Invalid file type');
}

// Generate safe filename
$extension = match($mime) {
    'image/jpeg' => 'jpg',
    'image/png' => 'png',
    'image/webp' => 'webp',
    default => throw new RuntimeException('Unexpected MIME type'),
};

$safe_name = bin2hex(random_bytes(16)) . '.' . $extension;
$destination = '/var/www/uploads/' . $safe_name;

if (!move_uploaded_file($file['tmp_name'], $destination)) {
    exit('Failed to save file');
}
```

---

## Summary Checklist

- [ ] CSRF tokens on all forms
- [ ] Honeypot field on public forms
- [ ] Form timing validation
- [ ] Rate limiting on sensitive endpoints
- [ ] Input validation and sanitization
- [ ] Output escaping (context-aware)
- [ ] Prepared statements for all queries
- [ ] Environment variables for secrets
- [ ] Secrets stored outside web root
- [ ] Security headers configured
- [ ] File upload validation (type, size, content)
- [ ] Defensive superglobal access
