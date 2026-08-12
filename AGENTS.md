# Agent Contract

This repository is the practical golden sample for `usofm/DEXT_AI_CODING_PACK`.

## Source priority
1. Current Dext source at the pinned compatibility SHA.
2. Official Dext skills/docs.
3. DEXT_AI_CODING_PACK.
4. Local starter conventions.

## Mandatory architecture rules
- Feature-first folders.
- Domain/Application code does not depend on Dext Web.
- HTTP endpoint units are thin transport adapters.
- FireDAC is isolated in Infrastructure.
- PostgreSQL is the single database target for this starter.
- Financial values use `TBcd` and PostgreSQL `NUMERIC(28,10)`.
- Use typed Dext DI; never resolve application services from request context.
- Use `{id}` route syntax, never `:id`.
- Keep `Dext.Web` last among Dext helper units where class-helper order matters.
- Never commit real credentials, JWT secrets or production connection strings.
