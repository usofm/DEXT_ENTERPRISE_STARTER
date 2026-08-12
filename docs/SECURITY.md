# Security Profile

The starter uses environment variables for secrets and provides a development-only login implementation.

## Production requirements

Before production:

- replace `TDevelopmentAuthService` with a database/identity-backed implementation;
- hash passwords using a modern password hashing algorithm; never store plaintext passwords;
- rotate JWT signing secrets and keep them outside source control;
- configure explicit issuer/audience values;
- add request validation and authorization policies;
- configure CORS narrowly;
- enable trusted-proxy/forwarded-header rules only for known proxies;
- add rate limiting for login and sensitive operations;
- emit RFC 9457 Problem Details without leaking stack traces;
- use TLS at the reverse proxy/application boundary;
- use a non-SYSDBA Firebird application account with least privilege.

`DEXT_DEV_ADMIN_USERNAME` and `DEXT_DEV_ADMIN_PASSWORD` exist only to make local smoke testing possible. They are not the production identity model.
