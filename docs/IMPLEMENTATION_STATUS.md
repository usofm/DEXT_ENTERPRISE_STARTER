# Implementation Status

## Implemented

- Delphi 13 target
- Dext `WebApplication` bootstrap
- typed Dext Minimal API endpoint modules
- typed Dext DI registrations
- native Dext Entity ORM persistence
- `TAppDbContext : TDbContext`
- `IDbSet<TAccount>` entity set
- Dext Smart Properties (`Int64Type`, `StringType`, `FmtBcdType`)
- Dext Entity mapping attributes including `[Precision(28, 10)]`
- PostgreSQL 17/18 through Dext `.UsePostgreSQL(...)`
- Dext/FireDAC connection pooling through `.WithPooling(True)`
- Accounts CRUD with `Add`, `Find`, `ToList`, `Update`, `Remove`, `SaveChanges`
- `Prototype.Entity<TAccount>` typed query for duplicate-code lookup
- exact PostgreSQL `NUMERIC(28,10)` / Delphi `TBcd` financial path
- native Dext JWT handler registration (`IJwtTokenHandler`, `TJwtTokenHandler`)
- native `TClaimsBuilder`
- native Dext route authorization metadata
- Swagger/OpenAPI bootstrap with Bearer scheme
- environment-based runtime configuration
- DUnitX tests for database-independent account rules
- PowerShell API smoke test
- GitHub static quality guards
- Dext-native alignment document and AI agent contract

## Removed during Dext-native refactor

The first starter revision used generic Delphi infrastructure that obscured Dext's own architecture. The following were intentionally removed:

- custom `IDbConnectionFactory`
- manual `TFDConnection` factory
- manual `TFDQuery` Accounts repository
- `IAccountRepository` abstraction for ordinary CRUD
- repository fake tests
- custom JWT service wrapper
- provider-specific application persistence code

FireDAC remains the underlying PostgreSQL transport used by Dext Entity; it is no longer the primary application-level persistence API.

## Evidence anchor

Dext code patterns are designed against:

`cesarliws/dext@412ed29207d2d1dc5d4a259a7739a615aed0c626`

Primary evidence used for this refactor includes official Dext ORM, Web, DI and Auth skills plus the Smart Properties and TaskFlow examples at that revision.

See `docs/DEXT_NATIVE_ALIGNMENT.md`.

## Not yet compile-validated in CI

This public repository does not currently have a licensed Delphi 13 compiler runner available to GitHub-hosted CI. Therefore the Pascal project is **not yet claimed as compiler-validated**.

Before a production-ready release:

1. clone on a Windows machine with Delphi 13;
2. use Dext matching the pinned SHA;
3. ensure FireDAC PostgreSQL support and `libpq.dll` are available;
4. build `src/DextEnterpriseStarter.dpr`;
5. build and run `tests/DextEnterpriseStarter.Tests.dpr`;
6. run the PostgreSQL migrations against PostgreSQL 17;
7. run API smoke tests;
8. repeat the database/runtime validation against PostgreSQL 18;
9. feed any general Dext API correction back into `DEXT_AI_CODING_PACK`.

A successful static GitHub Action means architecture guards passed; it is not a substitute for a Delphi compiler build.
