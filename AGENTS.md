# Agent Contract

This repository is the practical Golden Sample for `usofm/DEXT_AI_CODING_PACK`.

## Source priority
1. Current Dext source at the pinned compatibility SHA.
2. Official Dext skills/docs and official examples.
3. `DEXT_AI_CODING_PACK`.
4. Local starter conventions.

## Mandatory Dext-native rules
- Prefer native Dext APIs before introducing generic Delphi wrappers.
- Domain/Application code does not depend on Dext Web transport concerns.
- HTTP endpoint units are thin transport adapters.
- Persistence uses Dext Entity ORM: `TDbContext`, `IDbSet<T>`, Smart Properties, Specifications and Dext query APIs.
- Do not add a manual `TFDQuery` repository for ordinary CRUD that Dext Entity already handles.
- FireDAC remains the underlying database technology, but application persistence flows through Dext Entity.
- PostgreSQL 17/18 is the single database target for this starter.
- Register the context with `.AddDbContext<TAppDbContext>(...)`.
- Configure PostgreSQL with `.UsePostgreSQL(...).WithPooling(True)`.
- ORM results use Dext `IList<T>`.
- Detached/updated entities must call `.Update(Entity)` before `SaveChanges`.
- Financial entities use `FmtBcdType` / `TBcd` and `[Precision(28, 10)]`; PostgreSQL uses `NUMERIC(28,10)`.
- Use native Dext JWT types (`IJwtTokenHandler`, `TJwtTokenHandler`, `TClaimsBuilder`) and route `.RequireAuthorization` metadata.
- Use typed Dext DI; never resolve application services from request context when typed injection works.
- Use `{id}` route syntax, never `:id`.
- Keep `Dext.Web` last among Dext helper units where class-helper order matters.
- Never commit real credentials, JWT secrets or production connection strings.

## Mandatory evidence before changing framework code
Before changing persistence, auth, routing, DI or Swagger behavior:
1. inspect the matching file under `DEXT_AI_CODING_PACK/skills` or prompts;
2. inspect the official Dext example referenced by the Pack;
3. verify the exact API against the pinned Dext source when uncertain.

Do not replace Dext-native mechanisms with custom abstractions merely because the abstraction is familiar from another framework.
