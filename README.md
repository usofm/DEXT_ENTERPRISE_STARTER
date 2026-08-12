# DEXT_ENTERPRISE_STARTER

Golden enterprise starter for **Delphi 12 + Dext + Firebird 5 + UniDAC**.

This repository is the practical companion to `usofm/DEXT_AI_CODING_PACK` and is intended to validate real AI-assisted Dext development against a production-style architecture.

## Compatibility Anchor

```text
Dext upstream: cesarliws/dext
Audited SHA:   412ed29207d2d1dc5d4a259a7739a615aed0c626
Delphi:        12+
Database:      Firebird 5
Data access:   UniDAC
```

Do not silently copy syntax from a newer Dext `main` without reviewing compatibility first.

## Architecture

```text
src/
├── DextEnterpriseStarter.dpr
├── App.Startup.pas
├── Shared/
│   └── Financial.Bcd.pas
├── Infrastructure/
│   ├── Database.Config.pas
│   └── Database.ConnectionFactory.pas
└── Features/
    └── Accounts/
        ├── Domain/
        │   └── Accounts.Models.pas
        ├── Application/
        │   ├── Accounts.Contracts.pas
        │   └── Accounts.Service.pas
        ├── Infrastructure/
        │   └── Accounts.UniRepository.pas
        └── Api/
            └── Accounts.Endpoints.pas

database/
├── 01_schema.sql
└── 02_seed.sql

tests/
├── DextEnterpriseStarter.Tests.dpr
└── Accounts.Service.Tests.pas
```

## Core Rules

- Feature-first structure.
- Business rules live in Application/Domain, never in HTTP handlers.
- UniDAC is isolated under Infrastructure.
- API endpoints are thin transport adapters.
- Financial data uses Firebird `NUMERIC(28,10)` and Delphi `TBcd`.
- Dext route parameters use `{id}`, never `:id`.
- Use Dext generic handler DI / constructor injection; never request service-locator patterns.
- `Dext.Web` should remain last among Dext helper units in `uses` where helper resolution matters.
- DTOs are records.
- Secrets never belong in source control.

## First Feature

The initial sample feature is `Accounts`:

```text
GET  /health
GET  /api/accounts
GET  /api/accounts/{id}
POST /api/accounts
```

It intentionally demonstrates:

- DI boundaries
- service/repository separation
- Firebird identity columns
- UniDAC parameterized SQL
- `TBcd` round-trip handling
- thin Minimal API endpoints

## Setup

1. Install Delphi 12, Dext and UniDAC.
2. Create a Firebird 5 database.
3. Run `database/01_schema.sql` then `database/02_seed.sql`.
4. Copy `config/appsettings.example.json` to `config/appsettings.json`.
5. Configure database/JWT secrets.
6. Add the Dext and UniDAC source/package paths to the Delphi project search path.
7. Build `src/DextEnterpriseStarter.dpr`.

## Security Note

The starter deliberately does **not** commit a working JWT secret. Authentication configuration should be bound from configuration/environment variables before production use.

## Next Expansion Targets

- strongly typed configuration loader
- JWT authentication middleware and login feature
- Swagger/OpenAPI setup
- Problem Details exception mapping
- request validation
- transactions / Unit of Work
- integration tests against Firebird
- CI build on a Windows Delphi runner
- audit logging
- health/readiness checks
- multi-tenancy profile
