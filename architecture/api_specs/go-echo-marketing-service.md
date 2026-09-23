# go-echo-marketing-service — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/go-echo-marketing-service` (local working tree, read-only inspection, 2026-09-23).

## Overview

| Item | Value |
|---|---|
| Purpose | ⚠️ unverified. The local working tree has **no source code**. |
| Framework | ⚠️ unverified (the name suggests Go and Echo, but there are no `.go` files, no `go.mod` and no helm files) |
| Base path / port | ⚠️ unverified |
| Env var names | None found. `.gitignore` only ignores `.env`, `*.env`, `*.env.*` and `local.env`. |
| External calls | None found |
| Background jobs | None found |

Contents of the local checkout (branch `main`):
- `README.md`: the unmodified default GitLab project template. It does not describe the service. Remote origin: `gitlab.devlab.dev/xsifi/insurverse/backend/go-echo-marketing-service`.
- `.gitignore`

The packed refs list remote branches `origin/dev`, `origin/dev2`, `origin/uat2` and `origin/main`. No git commands were allowed for this documentation pass, so **the code on `dev`, `dev2` or `uat2` was not inspected**.

## Auth & Middleware

None. There is no code.

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| — | — | — | — | No route registration code exists in the local working tree |

Total: 0 endpoints.

## Endpoints

None.

## DB Usage

| Table / function | Read / write | Endpoints |
|---|---|---|
| — | — | — |

## Notes / ⚠️ unverified items

1. ⚠️ **The spec is empty because the checked-out `main` has only a README.** To document this service, someone needs to check out `origin/dev`, `origin/dev2` or `origin/uat2` in a separate worktree, then re-run this documentation pass.
2. The marketing functions that are actually deployed appear to live in a separate Node.js service: `/Users/kritsanawathaniyanon/Code/Go/nodejs-express-marketing-service`. It has its own `helm/helm-uat-isv.yaml`, `controllers/` and `migration/`. That service is out of scope for this spec and should get its own document.
3. Marketing consent APIs (for example `GET .../consent/marketing`) are handled in `go-e-api` (see `go-e-api/test/consent/consent_marketing_test.go`), not in this repo.
