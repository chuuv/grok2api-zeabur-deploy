#!/bin/sh
set -eu

require_env() {
  name="$1"
  eval "value=\${$name:-}"
  if [ -z "$value" ]; then
    echo "missing required environment variable: $name" >&2
    exit 1
  fi
}

require_env GROK2API_JWT_SECRET
require_env GROK2API_CREDENTIAL_ENCRYPTION_KEY
require_env GROK2API_BOOTSTRAP_ADMIN_PASSWORD

: "${GROK2API_BOOTSTRAP_ADMIN_USERNAME:=admin}"
: "${GROK2API_PUBLIC_API_BASE_URL:=}"
: "${GROK2API_SECURE_COOKIES:=true}"
: "${GROK2API_DATABASE_DRIVER:=sqlite}"
: "${GROK2API_SQLITE_PATH:=./data/backend.db}"
: "${GROK2API_RUNTIME_STORE_DRIVER:=memory}"
: "${GROK2API_MEDIA_PATH:=./data/media}"

mkdir -p /run/grok2api /app/data /app/data/media

cat > /run/grok2api/config.yaml <<EOF
auth:
  secureCookies: ${GROK2API_SECURE_COOKIES}
secrets:
  jwtSecret: "${GROK2API_JWT_SECRET}"
  credentialEncryptionKey: "${GROK2API_CREDENTIAL_ENCRYPTION_KEY}"
bootstrapAdmin:
  username: "${GROK2API_BOOTSTRAP_ADMIN_USERNAME}"
  password: "${GROK2API_BOOTSTRAP_ADMIN_PASSWORD}"
frontend:
  publicApiBaseURL: "${GROK2API_PUBLIC_API_BASE_URL}"
  staticPath: "./frontend/dist"
database:
  driver: ${GROK2API_DATABASE_DRIVER}
  sqlite:
    path: "${GROK2API_SQLITE_PATH}"
runtimeStore:
  driver: ${GROK2API_RUNTIME_STORE_DRIVER}
media:
  driver: local
  local:
    path: "${GROK2API_MEDIA_PATH}"
EOF

exec /usr/local/bin/grok2api-entrypoint "$@"
