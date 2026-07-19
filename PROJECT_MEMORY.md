# PROJECT_MEMORY.md

## Purpose

This repository deploys `chenyme/grok2api` to Zeabur as a thin wrapper around
the official upstream container image.

## Durable Decisions

- Do not maintain a fork of upstream `grok2api` source code here.
- Keep application updates upstream-driven by rebuilding the wrapper image from
  a pinned upstream `ghcr.io/chenyme/grok2api` release image.
- Keep real secrets only in Zeabur environment variables.
- Keep persistent runtime data on a Zeabur disk mounted at `/app/data`.

## Current Deployment Shape

- Base image: `ghcr.io/chenyme/grok2api:v3.0.4`.
- Current pinned upstream version: `v3.0.4` (released 2026-07-18).
- Wrapper entrypoint writes `/run/grok2api/config.yaml` from environment
  variables, then delegates to upstream `/usr/local/bin/grok2api-entrypoint`.
- Single-instance storage starts with SQLite plus local media under `/app/data`.

## Validation

- Local validation should build the wrapper image, run it with generated test
  secrets, and check `GET /healthz`.
- Production validation should check Zeabur deployment status and public
  `GET /healthz`.
