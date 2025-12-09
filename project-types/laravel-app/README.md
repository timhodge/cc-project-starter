# Laravel App Project Type

Setup and quality gates for Laravel application development.

## Status: Functional

This project type is ready for use.

## Quick Start

1. Run onboarding to configure project settings
2. Create Laravel project: `composer create-project laravel/laravel .`
3. Copy config files from `config/` to project root
4. Run `./init.sh` to set up the development environment
5. Run `./analyze.sh` to check quality gates

## Quality Gates

| Tool | Purpose | Config File |
|------|---------|-------------|
| php -l | PHP syntax check | - |
| Laravel Pint | Code style (PSR-12 + Laravel conventions) | pint.json |
| PHPStan + Larastan | Static analysis (Level 8) | phpstan.neon |
| Pest / PHPUnit | Tests | phpunit.xml |

## Scaffolding

Unlike other project types, Laravel scaffolding is created via Laravel's own installer:

```bash
# Option 1: Composer
composer create-project laravel/laravel .

# Option 2: Laravel Installer
laravel new project-name
```

After creating the project, copy the config files:
- `config/phpstan.neon` → project root
- `config/pint.json` → project root

## Development

Start the development server:

```bash
./init.sh
# or
php artisan serve
```

For frontend assets (Vite):

```bash
npm run dev
```

## Configuration Files

### phpstan.neon

Configured with Larastan for Laravel-aware static analysis:
- Understands Eloquent models and relationships
- Knows about facades and service container
- Handles Laravel's magic methods

### pint.json

Laravel Pint configuration:
- Laravel preset (PSR-12 base + Laravel conventions)
- `declare_strict_types` rule enabled
- Ordered imports

## Composer Scripts

Add these to your `composer.json`:

```json
{
  "scripts": {
    "lint": "pint --test",
    "lint:fix": "pint",
    "phpstan": "phpstan analyse",
    "test": "pest --parallel",
    "check": ["@lint", "@phpstan", "@test"]
  }
}
```

Then run all checks with:

```bash
composer check
```

## Recommended Dev Dependencies

```bash
composer require --dev laravel/pint larastan/larastan pestphp/pest pestphp/pest-plugin-laravel
```

## Directory Structure

Standard Laravel structure:

```
your-app/
├── app/
│   ├── Console/
│   ├── Exceptions/
│   ├── Http/
│   │   ├── Controllers/
│   │   └── Middleware/
│   ├── Models/
│   └── Providers/
├── bootstrap/
├── config/
├── database/
│   ├── factories/
│   ├── migrations/
│   └── seeders/
├── public/
├── resources/
│   ├── css/
│   ├── js/
│   └── views/
├── routes/
├── storage/
├── tests/
│   ├── Feature/
│   └── Unit/
├── artisan
├── composer.json
├── phpstan.neon
├── pint.json
└── phpunit.xml
```

## Testing

Laravel comes with PHPUnit, but we recommend Pest for a better DX:

```bash
# Install Pest
composer require --dev pestphp/pest pestphp/pest-plugin-laravel
php artisan pest:install

# Run tests
vendor/bin/pest
# or
php artisan test
```

## Database

### SQLite (Development)

Default for easy setup:

```env
DB_CONNECTION=sqlite
# DB_DATABASE is auto-configured to database/database.sqlite
```

### MySQL/PostgreSQL (Production)

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=your_database
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

## Deployment

See `templates/github-actions/laravel-deploy.yml` for deployment automation.
