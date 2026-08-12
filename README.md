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

## Implemented

- Feature-first / Clean Architecture-inspired layout
- Thin Dext Minimal API endpoint modules
- Typed Dext dependency injection
- Firebird 5 identity schema
- UniDAC connection factory and parameterized repository
- Financial `NUMERIC(28,10)` + Delphi `TBcd`
- JWT middleware bootstrap using Dext auth APIs
- Development login feature with credentials supplied only by environment variables
- Swagger/OpenAPI with Bearer authentication scheme
- Environment-based runtime configuration
- DUnitX application-service tests with an in-memory repository
- PowerShell API smoke test
- GitHub static quality guards
- AI agent contract linked conceptually to `DEXT_AI_CODING_PACK`

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
        └── Api/

database/
├── 01_schema.sql
└── 02_seed.sql

tests/
├── DextEnterpriseStarter.Tests.dpr
├── Accounts.Fakes.pas
└── Accounts.Service.Tests.pas

scripts/
└── smoke.ps1
```

## Core Rules

- Business rules live in Application/Domain, never in HTTP handlers.
- UniDAC is isolated under Infrastructure.
- API endpoints are thin transport adapters.
- Financial data uses Firebird `NUMERIC(28,10)` and Delphi `TBcd`.
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

## Environment

Use `.env.example` as the variable reference. The application currently reads process environment variables directly.

Important variables include:

```text
DEXT_DB_DATABASE
DEXT_DB_PASSWORD
DEXT_JWT_SECRET
DEXT_DEV_ADMIN_USERNAME
DEXT_DEV_ADMIN_PASSWORD
```

Never commit the real values.

## Database Setup

1. Create a Firebird 5 database.
2. Run `database/01_schema.sql`.
3. Run `database/02_seed.sql`.
4. Use a least-privilege application database user for production; do not deploy with SYSDBA.

## Delphi Build

Install/configure:

- Delphi 12+
- Dext matching the pinned SHA
- UniDAC with Firebird/InterBase provider
- DUnitX

Then build:

```text
src/DextEnterpriseStarter.dpr
tests/DextEnterpriseStarter.Tests.dpr
```

This repository currently has static GitHub CI but not a licensed Delphi compiler runner. Therefore successful GitHub CI is **not** a substitute for a real Delphi build. See `docs/IMPLEMENTATION_STATUS.md`.

## Smoke Test

After starting the API with environment variables configured:

```powershell
./scripts/smoke.ps1
```

The script checks health, login, authenticated identity and account listing.

## Security

Read `docs/SECURITY.md` before treating this as production-ready. `TDevelopmentAuthService` is intentionally a local-development identity provider and must be replaced by a real user/identity implementation for production.

## Next Milestones

- compile and run on the real Delphi 12 + UniDAC development machine
- fix any compiler/API mismatches found during that validation
- add RFC 9457 Problem Details exception mapping
- add DTO validation
- introduce explicit transaction / Unit-of-Work patterns for multi-write business operations
- add Firebird integration tests
- add audit logging
- add readiness/dependency health checks
- add optional multi-tenancy profile
- add Windows self-hosted Delphi CI when a licensed runner is available

Any general Dext rule discovered during real compilation should be fed back into `DEXT_AI_CODING_PACK`.
