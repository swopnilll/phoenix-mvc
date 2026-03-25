# Phoenix/Elixir Learning Project

A hands-on learning project for developers coming from JavaScript/Node.js background.

## Prerequisites

- Elixir 1.15+
- PostgreSQL (via Docker)
- Node.js (for assets)

## Getting Started

```bash
# 1. Start PostgreSQL (uses port 5433 to avoid conflicts)
docker-compose up -d

# 2. Install dependencies
mix deps.get

# 3. Setup database (create + migrate + seed)
mix ecto.setup

# 4. Start the server
mix phx.server
```

Visit [http://localhost:5001](http://localhost:5001)

## Project Structure

```
lib/
├── hello_web/           # Web layer (HTTP, HTML, LiveViews)
│   ├── router.ex        # URL routing
│   └── live/            # LiveView components
│
└── hello/               # Business logic layer
    ├── catalog.ex       # Products context
    ├── catalog/
    │   ├── product.ex   # Product schema
    │   └── policy.ex    # Authorization rules
    ├── accounts.ex      # Users context
    └── accounts/
        └── user.ex      # User schema
```

## Seed Users (for testing authorization)

| ID | Name         | Role    | Can View Products | Can Delete |
|----|--------------|---------|-------------------|------------|
| 1  | Alice Admin  | admin   | Yes               | Yes        |
| 2  | Mike Manager | manager | Yes               | No         |
| 3  | Gary Guest   | guest   | No                | No         |

---

## Notes: Table of Contents

### Intro

| # | Topic | File |
|---|-------|------|
| 1 | Phoenix File Structure | [notes/intro/1.md](notes/intro/1.md) |

### Phoenix LiveView

| # | Topic | File |
|---|-------|------|
| 1 | React to Phoenix - Mental Model | [notes/intermediate/1.md](notes/intermediate/1.md) |
| 2 | Routing in Phoenix (LiveView) | [notes/intermediate/2.md](notes/intermediate/2.md) |
| 3 | Database Calls and LiveView | [notes/intermediate/3.md](notes/intermediate/3.md) |
| 4 | File Upload in LiveView | [notes/intermediate/4.md](notes/intermediate/4.md) |

### Ecto & Database

| # | Topic | File |
|---|-------|------|
| 5 | Complete Guide to Ecto Tables | [notes/intermediate/5.md](notes/intermediate/5.md) |

### Authorization

| # | Topic | File |
|---|-------|------|
| 6 | Bodyguard Authorization (for JS Devs) | [notes/intermediate/6.md](notes/intermediate/6.md) |

### Architecture

| # | Topic | File |
|---|-------|------|
| 7 | Phoenix Context Pattern | [notes/intermediate/7.md](notes/intermediate/7.md) |
| 8 | Understanding @spec in Elixir (Type Specifications) | [notes/intermediate/8.md](notes/intermediate/8.md) |

---

## Useful Commands

| Command | Description |
|---------|-------------|
| `mix phx.server` | Start dev server |
| `mix ecto.migrate` | Run pending migrations |
| `mix ecto.reset` | Drop + create + migrate + seed |
| `mix ecto.gen.migration name` | Generate a migration |
| `mix phx.gen.schema Context.Schema table fields...` | Generate schema + migration |
| `iex -S mix` | Interactive Elixir shell with app loaded |

## Docker

```bash
docker-compose up -d      # Start PostgreSQL
docker-compose down       # Stop
docker-compose down -v    # Stop and remove data
```
