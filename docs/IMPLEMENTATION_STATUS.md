# Implementation Status

## Implemented

- feature-first project structure
- Dext Minimal API endpoint modules
- Dext typed DI registrations
- Delphi 13 target
- FireDAC PostgreSQL connection factory and parameterized repository
- PostgreSQL 17/18 schema using identity keys
- `NUMERIC(28,10)` / `TBcd` financial path
- JWT middleware bootstrap using Dext auth source API
- development login feature using environment-provided credentials
- Swagger/OpenAPI bootstrap with Bearer scheme
- DUnitX application-service tests with in-memory repository
- PowerShell API smoke test
- GitHub static quality guards
- AI agent contract

## Evidence anchor

Dext code patterns are designed against:

`cesarliws/dext@412ed29207d2d1dc5d4a259a7739a615aed0c626`

## Not yet compile-validated in CI

This public repository does not currently have a licensed Delphi 13 compiler runner available to GitHub-hosted CI. Therefore the Pascal project has **not** been claimed as CI compile-validated.

Before calling a release production-ready, perform a Delphi 13 build on a Windows machine with:

- Dext source/packages matching the pinned SHA;
- FireDAC PostgreSQL driver available;
- PostgreSQL native client (`libpq.dll`) available or configured through `DEXT_DB_VENDORLIB`;
- DUnitX available;
- PostgreSQL 17 or PostgreSQL 18 available for integration testing.

Any compiler/API mismatch found there must be fixed in this starter and, if it reveals a general Dext knowledge issue, fed back into `DEXT_AI_CODING_PACK`.

## Next validation milestone

1. Clone on the real Delphi 13 development machine.
2. Build the application.
3. Build and run DUnitX tests.
4. Run `database/postgresql/01_schema.sql` and `02_seed.sql` against a clean PostgreSQL database.
5. Start API with `.env.example` values adapted to the machine.
6. Run `scripts/smoke.ps1`.
7. Repeat database validation against PostgreSQL 17 and PostgreSQL 18.
8. Record compile/runtime fixes as Golden Sample evidence.
