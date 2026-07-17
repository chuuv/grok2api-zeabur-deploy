# grok2api Zeabur Deploy

This repository is a thin deployment wrapper for `chenyme/grok2api`.

It intentionally does not vendor or modify the upstream Go/React source. The
runtime image is inherited from the official upstream container image, and this
repository only generates the required `config.yaml` from deployment environment
variables so Zeabur can run the service without a single-file config mount.

## Update Policy

- Default base image: `ghcr.io/chenyme/grok2api:latest`.
- To follow upstream manually, redeploy this service when the upstream image is
  updated.
- If you need a stability window, pin `GROK2API_BASE_IMAGE` in `Dockerfile` to a
  specific upstream release tag, then move the tag forward during maintenance.
- Do not copy upstream application source code into this repository unless there
  is an explicit decision to maintain a fork.

## Required Environment Variables

Set these in Zeabur. Do not commit real values.

```text
GROK2API_JWT_SECRET=<hex/random string with at least 32 chars>
GROK2API_CREDENTIAL_ENCRYPTION_KEY=<base64 encoded 32-byte key>
GROK2API_BOOTSTRAP_ADMIN_USERNAME=admin
GROK2API_BOOTSTRAP_ADMIN_PASSWORD=<strong password>
GROK2API_PUBLIC_API_BASE_URL=https://<public-domain>
```

Recommended defaults:

```text
GROK2API_SECURE_COOKIES=true
GROK2API_DATABASE_DRIVER=sqlite
GROK2API_SQLITE_PATH=./data/backend.db
GROK2API_RUNTIME_STORE_DRIVER=memory
GROK2API_MEDIA_PATH=./data/media
```

## Storage

Mount a persistent disk at `/app/data`.

The SQLite database is stored at `/app/data/backend.db`, and local media is
stored under `/app/data/media`.

## First Login

After the first admin is created, change the admin password in the UI. Upstream
recommends removing `bootstrapAdmin` from `config.yaml`; for this wrapper, keep
the environment variable protected in Zeabur and do not expose the admin route
without network controls.
