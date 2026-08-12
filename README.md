# DEXT_ENTERPRISE_STARTER

Golden enterprise starter for **Delphi 13 + Dext + FireDAC + PostgreSQL 17/18**.

This repository is the practical companion to `usofm/DEXT_AI_CODING_PACK` and is intended to validate real AI-assisted Dext development against a production-style architecture.

## Compatibility Anchor

```text
Dext upstream: cesarliws/dext
Audited SHA:   412ed29207d2d1dc5d4a259a7739a615aed0c626
Delphi:        13
Data access:   FireDAC
Database:      PostgreSQL 17 / PostgreSQL 18
```

The starter intentionally targets one database family to keep the Golden Sample focused, deterministic, and easy to validate.

## Implemented

- Feature-first / Clean Architecture-inspired layout
- Thin Dext Minimal API endpoint modules
- Typed Dext dependency injection
- FireDAC PostgreSQL connection factory
- PostgreSQL 17/18 schema using identity keys
- Financial `NUMERIC(28,10)` + Delphi `TBcd`
- JWT middleware bootstrap using Dext auth APIs
- Development login feature with credentials supplied only by environment variables
- Swagger/OpenAPI with Bearer authentication scheme
- Environment-based runtime configuration
- DUnitX application-service tests with an in-memory repository
- PowerShell API smoke test
- GitHub static quality guards
- AI agent contract linked to `DEXT_AI_CODING_PACK`

See `docs/IMPLEMENTATION_STATUS.md` for validation status and known limits.

## Architecture

```text
src/
├── DextEnterpriseStarter.dpr
├── App.Startup.pas
├── Shared/
│   ├── App.Environment.pas
│   └── Financial.Bcd.pas
├── Infrastructure/
│   ├── Database.Config.pas
│   ├── Database.ConnectionFactory.pas
│   └── Security.Jwt.pas
└── Features/
    ├── Auth/
    │   ├── Application/
    │   └── Api/
    └── Accounts/
        ├── Domain/
        ├── Application/
        ├── Infrastructure/
        │   └── Accounts.FireDACRepository.pas
        └── Api/

database/
└── postgresql/
    ├── 01_schema.sql
    └── 02_seed.sql
```

## PostgreSQL Configuration

```text
DEXT_DB_SERVER=localhost
DEXT_DB_PORT=5432
DEXT_DB_DATABASE=enterprise
DEXT_DB_USERNAME=app_user
DEXT_DB_PASSWORD=change-me
DEXT_DB_CHARSET=UTF8
DEXT_DB_VENDORLIB=C:/PostgreSQL/bin/libpq.dll
```

`DEXT_DB_VENDORLIB` is optional when FireDAC can already locate `libpq.dll`.

## Core Rules

- Business rules live in Application/Domain, never in HTTP handlers.
- FireDAC is isolated under Infrastructure.
- API endpoints are thin transport adapters.
- Financial data uses PostgreSQL `NUMERIC(28,10)` and Delphi `TBcd` end-to-end.
- Do not use `Double` or `Currency` as authoritative financial storage types.
- Dext route parameters use `{id}`, never `:id`.
- Use Dext generic handler DI / constructor injection; never request service-locator patterns.
- Keep `Dext.Web` last among Dext helper units where class-helper order matters.
- DTOs are records.
- Secrets never belong in source control.

## Endpoints

```text
GET  /health
POST /api/auth/login
GET  /api/auth/me
GET  /api/accounts
GET  /api/accounts/{id}
POST /api/accounts
GET  /swagger
GET  /swagger.json
```

## Database Setup

Run:

```text
database/postgresql/01_schema.sql
database/postgresql/02_seed.sql
```

Use a least-privilege PostgreSQL application role in production.

## Delphi Build

Install/configure:

- Delphi 13
- Dext matching the pinned SHA
- FireDAC PostgreSQL driver
- PostgreSQL native client (`libpq.dll`)
- DUnitX

Build:

```text
src/DextEnterpriseStarter.dpr
tests/DextEnterpriseStarter.Tests.dpr
```

The public GitHub CI currently performs static checks; it is not a substitute for compiling with a licensed Delphi 13 installation.

## Validation Matrix

The Golden Starter should be validated against:

```text
Delphi 13 + FireDAC + PostgreSQL 17
Delphi 13 + FireDAC + PostgreSQL 18
```

Any general Dext rule discovered during real compilation should be fed back into `DEXT_AI_CODING_PACK`.
