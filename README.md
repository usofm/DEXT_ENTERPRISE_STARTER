# DEXT_ENTERPRISE_STARTER

Golden enterprise starter for **Delphi 13 + Dext + PostgreSQL 17/18**, using **Dext Entity ORM over FireDAC**.

This repository is the practical companion to `usofm/DEXT_AI_CODING_PACK`. Its purpose is not to wrap Dext in a generic Delphi architecture; it is to demonstrate a production-oriented application that still looks and behaves like native Dext code.

## Compatibility Anchor

```text
Dext upstream: cesarliws/dext
Audited SHA:   412ed29207d2d1dc5d4a259a7739a615aed0c626
Delphi:        13
ORM:           Dext Entity
DB transport:  FireDAC (through Dext Entity)
Database:      PostgreSQL 17 / PostgreSQL 18
```

## Dext-native design

The persistence path is intentionally:

```text
Dext Endpoint
    ↓
Application Service
    ↓
TAppDbContext
    ↓
IDbSet<TAccount>
    ↓
Dext Entity ORM / Smart Properties
    ↓
FireDAC PostgreSQL driver
    ↓
PostgreSQL 17/18
```

Ordinary CRUD must not bypass Dext Entity with a custom `TFDQuery` repository.

## Implemented

- Dext `WebApplication` bootstrap
- thin typed Minimal API endpoint modules
- typed Dext dependency injection
- native Dext `TDbContext` / `IDbSet<T>` persistence
- native Dext Smart Properties (`Int64Type`, `StringType`, `FmtBcdType`)
- entity mapping with `[Table]`, `[PK]`, `[AutoInc]`, `[Required]`, `[MaxLength]`, `[Precision]`, `[CreatedAt]`, `[UpdatedAt]`
- PostgreSQL configured with `.UsePostgreSQL(...).WithPooling(True)`
- full Accounts CRUD using `Add`, `Find`, `ToList`, `Update`, `Remove`, `SaveChanges`
- type-safe duplicate lookup using `Prototype.Entity<T>` and `.Where(...)`
- exact financial `NUMERIC(28,10)` ↔ `FmtBcdType/TBcd`
- native Dext JWT services: `IJwtTokenHandler`, `TJwtTokenHandler`, `TClaimsBuilder`
- route authorization via `.RequireAuthorization`
- Swagger/OpenAPI Bearer metadata
- environment-based secrets/configuration
- DUnitX tests for database-independent business rules
- PowerShell API smoke test
- GitHub static quality guards enforcing Dext-native architecture

## Architecture

```text
src/
├── DextEnterpriseStarter.dpr
├── App.Startup.pas
├── Shared/
│   ├── App.Environment.pas
│   └── Financial.Bcd.pas
├── Infrastructure/
│   └── App.DbContext.pas
└── Features/
    ├── Auth/
    │   ├── Application/
    │   └── Api/
    └── Accounts/
        ├── Domain/
        │   └── Accounts.Models.pas
        ├── Application/
        │   ├── Accounts.Contracts.pas
        │   ├── Accounts.Rules.pas
        │   └── Accounts.Service.pas
        └── Api/
            └── Accounts.Endpoints.pas

database/
└── postgresql/
    ├── 01_schema.sql
    └── 02_seed.sql
```

## Entity example

```pascal
[Table('accounts')]
TAccount = class
private
  FId: Int64Type;
  FCode: StringType;
  FName: StringType;
  FBalance: FmtBcdType;
public
  [PK, AutoInc]
  property Id: Int64Type read FId write FId;

  [Required, MaxLength(30)]
  property Code: StringType read FCode write FCode;

  [Required, MaxLength(200)]
  property Name: StringType read FName write FName;

  [Required, Precision(28, 10)]
  property Balance: FmtBcdType read FBalance write FBalance;
end;
```

## DbContext example

```pascal
TAppDbContext = class(TDbContext)
private
  function GetAccounts: IDbSet<TAccount>;
public
  property Accounts: IDbSet<TAccount> read GetAccounts;
end;

function TAppDbContext.GetAccounts: IDbSet<TAccount>;
begin
  Result := Entities<TAccount>;
end;
```

## PostgreSQL registration

```pascal
Services
  .AddDbContext<TAppDbContext>(ConfigureDatabase)
  .AddScoped<IAccountService, TAccountService>;

procedure TAppStartup.ConfigureDatabase(Options: TDbContextOptions);
begin
  Options
    .UsePostgreSQL(TAppEnvironment.DatabaseConnectionString)
    .WithPooling(True);
end;
```

Environment:

```text
DEXT_DB_CONNECTION_STRING=host=localhost;port=5432;db=enterprise;user=app_user;password=change-me
```

The value is passed directly to Dext Entity's `UsePostgreSQL` configuration.

## Accounts CRUD patterns

```text
Create:  Db.Accounts.Add(Entity)    -> Db.SaveChanges
Read:    Db.Accounts.Find(Id)
List:    Db.Accounts.ToList
Query:   Db.Accounts.Where(Prototype.Entity<TAccount>.Code = ...).ToList
Update:  Db.Accounts.Update(Entity) -> Db.SaveChanges
Delete:  Db.Accounts.Remove(Entity) -> Db.SaveChanges
```

The explicit `Update(Entity)` call is intentional and follows current Dext guidance for detached/update flows.

## Endpoints

```text
GET    /health
POST   /api/auth/login
GET    /api/auth/me                 authenticated
GET    /api/accounts                authenticated
GET    /api/accounts/{id}           authenticated
POST   /api/accounts                Admin
PUT    /api/accounts/{id}           Admin
DELETE /api/accounts/{id}           Admin
GET    /swagger
GET    /swagger.json
```

## Database Setup

Run:

```text
database/postgresql/01_schema.sql
database/postgresql/02_seed.sql
```

PostgreSQL financial columns use `NUMERIC(28,10)`.

## Delphi Build

Install/configure:

- Delphi 13
- Dext matching the pinned SHA
- FireDAC PostgreSQL support
- PostgreSQL native client (`libpq.dll`) when required by the local FireDAC setup
- DUnitX

Build:

```text
src/DextEnterpriseStarter.dpr
tests/DextEnterpriseStarter.Tests.dpr
```

The public GitHub CI performs static architecture checks. A real Delphi 13 compile remains the authoritative compiler validation.

## Evidence chain

Framework decisions in this starter must follow:

```text
Official Dext source/examples
        ↓
DEXT_AI_CODING_PACK
        ↓
DEXT_ENTERPRISE_STARTER
```

See `docs/DEXT_NATIVE_ALIGNMENT.md` for the explicit mapping between the starter and upstream Dext patterns.
