# Complex Website Project Type

Setup for multi-stack website projects with separate frontend and backend.

## Status: Functional

This project type is ready for use.

## Quick Start

1. Run onboarding to determine frontend and backend stacks
2. Create directory structure (monorepo with `/frontend` and `/backend`)
3. Initialize each stack with its respective tools
4. Run `./init.sh` to set up both environments
5. Run `./analyze.sh` to check quality gates for both stacks

## Supported Stacks

### Frontend Options
| Framework | Command | Port |
|-----------|---------|------|
| Next.js | `npx create-next-app frontend` | 3000 |
| Nuxt | `npx nuxi init frontend` | 3000 |
| Astro | `npm create astro@latest frontend` | 4321 |
| Vite (React/Vue) | `npm create vite@latest frontend` | 5173 |

### Backend Options
| Framework | Command | Port |
|-----------|---------|------|
| Laravel | `composer create-project laravel/laravel backend` | 8000 |
| Express | `mkdir backend && cd backend && npm init` | 8000 |
| NestJS | `npx @nestjs/cli new backend` | 3001 |
| Headless WordPress | WordPress installation | 8000 |

## Directory Structure

Recommended monorepo structure:

```
your-project/
├── frontend/           # Frontend application
│   ├── src/
│   ├── package.json
│   └── ...
├── backend/            # Backend API
│   ├── app/            # Laravel
│   ├── src/            # Node.js
│   ├── package.json    # or composer.json
│   └── ...
├── init.sh             # Combined setup script
├── analyze.sh          # Combined quality gates
└── README.md
```

Alternative directory names are supported:
- Frontend: `frontend/`, `client/`, `web/`
- Backend: `backend/`, `api/`, `server/`

## Quality Gates by Stack

### Frontend (TypeScript/JavaScript)

| Tool | Purpose |
|------|---------|
| TypeScript | Type checking |
| ESLint | Linting |
| Prettier | Code formatting |
| Vitest/Jest | Unit tests |

### Backend: Laravel

| Tool | Purpose |
|------|---------|
| php -l | Syntax check |
| Laravel Pint | Code style |
| PHPStan + Larastan | Static analysis |
| Pest/PHPUnit | Tests |

### Backend: Node.js

| Tool | Purpose |
|------|---------|
| TypeScript | Type checking |
| ESLint | Linting |
| Jest/Vitest | Tests |

## Development

The `init.sh` script:
1. Detects frontend and backend directories
2. Installs dependencies for both
3. Sets up environment files
4. Provides instructions for starting both servers

Since you typically need two terminals (one for frontend, one for backend), the script offers options:
- Start frontend only
- Start backend only
- Manual start (shows commands)

### Using a Process Manager

For convenience, consider using `concurrently`:

```bash
# In project root
npm init -y
npm install --save-dev concurrently

# Add to package.json scripts:
{
  "scripts": {
    "dev": "concurrently \"cd frontend && npm run dev\" \"cd backend && php artisan serve\""
  }
}
```

## API Communication

### Environment Variables

Frontend `.env`:
```env
NEXT_PUBLIC_API_URL=http://localhost:8000/api
# or
VITE_API_URL=http://localhost:8000/api
```

Backend `.env` (CORS):
```env
# Laravel
FRONTEND_URL=http://localhost:3000

# Express
CORS_ORIGIN=http://localhost:3000
```

### CORS Configuration

**Laravel** (`config/cors.php`):
```php
'allowed_origins' => [env('FRONTEND_URL', 'http://localhost:3000')],
```

**Express**:
```javascript
app.use(cors({ origin: process.env.CORS_ORIGIN }));
```

## Deployment

Complex websites often deploy to different platforms:

| Component | Typical Deployment |
|-----------|-------------------|
| Next.js/Nuxt | Vercel, Netlify |
| Astro | Vercel, Netlify, Cloudflare |
| Laravel API | RunCloud, Forge, AWS |
| Node.js API | Railway, Render, AWS |

See `templates/github-actions/` for deployment examples.
