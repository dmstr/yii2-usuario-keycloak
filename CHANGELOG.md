<!-- file generated with AI assistance: Claude Code - 2026-07-15 -->

# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.1.0]

### Added

- `SecurityController::$socialLoginMode` with three modes for handling an OIDC login callback
  when a local session already exists:
  - `legacy` *(default, backwards-compatible)* — connect the returned identity to the open
    session, unchanged from previous releases.
  - `guarded` *(recommended for SSO)* — connect only if the returned identity provably belongs
    to the same user (owner resolved by immutable `sub`, else by verified e-mail); otherwise log
    out the stale session and authenticate as the true identity, so a returned identity can never
    be bound to a foreign, still-open session. Enforces `email_verified` strictly (a missing
    claim counts as not verified) and populates `email`/`username` on the account row.
  - `authenticate` — always authenticate via the token identity; never connect-to-session.
- `init()` validation: an unknown `socialLoginMode` throws `InvalidConfigException` instead of
  silently falling back to `legacy`.

### Changed

- `JwtAutoProvisionAuth`: the social-account lookup now uses the natural key
  `(provider, client_id)` **before** any user is created. A `sub` already linked to a different
  user than the token's e-mail resolves to is refused with `409 Conflict` and logged, instead of
  silently authenticating the mislinked user or leaving behind a side-effect user. The account
  insert now also rolls back the transaction on `DbException`.

### Notes

- The default remains `legacy` for backwards compatibility; SSO deployments must opt in to
  `guarded`. The default is expected to flip to `guarded` in `6.0.0`.
