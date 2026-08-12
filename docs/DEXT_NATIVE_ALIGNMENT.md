# Dext Native Alignment

This file records why the starter is considered Dext-native and which upstream patterns each local design follows.

## Compatibility anchor

```text
cesarliws/dext@412ed29207d2d1dc5d4a259a7739a615aed0c626
```

## Persistence

Official Dext guidance:

```text
TDbContext
IDbSet<T>
AddDbContext<TContext>
UsePostgreSQL(...)
WithPooling(True)
Prototype.Entity<T>
IList<T>
Update(Entity) before SaveChanges
```

Starter implementation:

```text
src/Infrastructure/App.DbContext.pas
src/Features/Accounts/Domain/Accounts.Models.pas
src/Features/Accounts/Application/Accounts.Service.pas
src/App.Startup.pas
```

### Intentional non-pattern

The starter does **not** create a manual `TFDQuery` repository for standard Accounts CRUD. FireDAC is used beneath Dext Entity rather than as an application-facing persistence API.

Raw FireDAC/SQL is allowed only for a use case Dext Entity does not cover well, and such code must remain an explicit infrastructure exception.

## Entity mapping

The Accounts entity follows Dext Entity mapping conventions:

- `[Table]`
- `[PK, AutoInc]`
- `[Required]`
- `[MaxLength]`
- `[Precision(28, 10)]`
- `[CreatedAt]`
- `[UpdatedAt]`
- `Int64Type`
- `StringType`
- `FmtBcdType`

Financial values therefore remain exact from PostgreSQL `NUMERIC(28,10)` through Dext/FireDAC to Delphi `TBcd` semantics.

## Web endpoints

Accounts endpoints use typed Minimal API generic injection:

```text
MapGet<IAccountService, IResult>
MapGet<IAccountService, Int64, IResult>
MapPost<TCreateAccountRequest, IAccountService, IResult>
MapPut<TUpdateAccountRequest, IAccountService, Int64, IResult>
MapDelete<IAccountService, Int64, IResult>
```

Route parameters use `{id}`.

Authorization uses Dext route metadata:

```text
.RequireAuthorization
.RequireAuthorization('Admin')
```

## Authentication

The starter uses native Dext auth types instead of a local JWT abstraction:

```text
IJwtTokenHandler
TJwtTokenHandler
TClaimsBuilder
JwtOptions(...)
UseJwtAuthentication(...)
RequireAuthorization
```

## Source precedence

When a local implementation and an example differ:

1. pinned Dext source wins;
2. current official Dext skill/docs win over stale example README syntax;
3. DEXT_AI_CODING_PACK drift rules apply;
4. local code is changed to match the verified framework contract.

## CI invariants

Static CI should fail if the starter loses its Dext-native identity. It checks for:

- `TDbContext`
- `IDbSet<TAccount>`
- `FmtBcdType`
- `[Precision(28, 10)]`
- `AddDbContext<TAppDbContext>`
- `UsePostgreSQL`
- `WithPooling(True)`
- `Prototype.Entity<TAccount>`
- `.Update(Account)`
- `IJwtTokenHandler`
- `.RequireAuthorization`

It also rejects ordinary manual persistence patterns such as `TFDQuery` inside the starter's Accounts feature.
