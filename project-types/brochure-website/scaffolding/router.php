<?php

declare(strict_types=1);

/**
 * PHP Built-in Server Router
 *
 * This file provides clean URL routing for local development using PHP's built-in server.
 * The built-in server doesn't support .htaccess, so this router handles URL rewriting.
 *
 * Usage:
 *   php -S localhost:8000 router.php
 *
 * IMPORTANT: This file should NOT be deployed to production.
 * Add to your deployment exclusion list or .gitignore for production builds.
 *
 * @see https://www.php.net/manual/en/features.commandline.webserver.php
 */

// Get the requested URI
$uri = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?? '/');

// Serve static files directly (CSS, JS, images)
$staticExtensions = ['css', 'js', 'jpg', 'jpeg', 'png', 'gif', 'svg', 'webp', 'ico', 'woff', 'woff2', 'ttf', 'eot'];
$extension = pathinfo($uri, PATHINFO_EXTENSION);

if (in_array(strtolower($extension), $staticExtensions, true)) {
    // Check if file exists in src directory
    $filePath = __DIR__ . '/src' . $uri;
    if (file_exists($filePath)) {
        return false; // Let PHP built-in server handle it
    }
}

// Handle clean URLs - map requests to PHP files
$srcDir = __DIR__ . '/src';

// Remove leading slash and .php extension if present
$path = ltrim($uri, '/');
$path = preg_replace('/\.php$/', '', $path);

// Default to index if path is empty
if ($path === '' || $path === '/') {
    $path = 'index';
}

// Try to find the PHP file
$phpFile = $srcDir . '/' . $path . '.php';

if (file_exists($phpFile)) {
    // Change to src directory so relative includes work correctly
    chdir($srcDir);
    require $phpFile;
    return true;
}

// Try as a directory with index.php
$indexFile = $srcDir . '/' . $path . '/index.php';
if (file_exists($indexFile)) {
    chdir($srcDir . '/' . $path);
    require $indexFile;
    return true;
}

// 404 - File not found
http_response_code(404);
echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found</title>
    <style>
        body {
            font-family: system-ui, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background: #f5f5f5;
        }
        .error {
            text-align: center;
            padding: 2rem;
        }
        h1 { color: #333; margin-bottom: 0.5rem; }
        p { color: #666; }
        a { color: #2563eb; }
    </style>
</head>
<body>
    <div class="error">
        <h1>404 - Page Not Found</h1>
        <p>The requested page could not be found.</p>
        <p><a href="/">Return to homepage</a></p>
    </div>
</body>
</html>';
return true;
