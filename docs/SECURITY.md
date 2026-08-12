# Security Profile

The starter uses native Dext JWT primitives and environment variables for secrets. The included credential validator is development-only.

## Current Dext security path

```text
TJwtTokenHandler / IJwtTokenHandler
        ↓
TClaimsBuilder
        ↓
UseJwtAuthentication(...)
        ↓
.RequireAuthorization / .RequireAuthorization('Admin')
```

Do not replace this path with a custom JWT wrapper unless a verified requirement cannot be satisfied by Dext.

## Production requirements

Before production:

- replace `TDevelopmentAuthService` with a database/identity-backed implementation;
- hash passwords using a modern password hashing algorithm; never store plaintext passwords;
- rotate JWT signing secrets and keep them outside source control;
- configure explicit issuer/audience values;
- add request validation and explicit authorization policies;
- configure CORS narrowly;
- enable trusted-proxy/forwarded-header rules only for known proxies;
- add rate limiting for login and sensitive operations;
- emit RFC 9457 Problem Details without leaking stack traces;
- use TLS at the reverse proxy/application boundary;
- use a least-privilege PostgreSQL application role;
- keep the PostgreSQL connection string out of source control;
- do not expose authenticated/private responses through unsafe response caching.

`DEXT_DEV_ADMIN_USERNAME` and `DEXT_DEV_ADMIN_PASSWORD` exist only to make local smoke testing possible. They are not the production identity model.
