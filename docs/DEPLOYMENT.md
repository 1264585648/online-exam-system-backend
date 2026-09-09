# Deployment

## One command

Check out both forks as siblings:

```text
online-exam-system-backend/
online-exam-system-frontend/
```

From the backend repo:

```bash
cp .env.example .env
# edit .env; do not commit it
docker compose up -d
```

Compose starts only what this codebase actually needs to boot:

1. MySQL 5.7 (matches `sql/db_exam.sql`, dump source 5.7.44)
2. Redis 7
3. MinIO (storage type is `minio`)
4. backend (Spring Boot, profile `docker`)
5. frontend (built from the sibling frontend repo)

Milvus, Coze, Dify, and the Python `online-exam-agent` are not started. `online-exam.agent.scoring-enabled` is false and AI auto-scoring is off in the Docker profile.

## URLs

- Frontend: `http://127.0.0.1:8088` (`FRONTEND_PORT`)
- Backend: `http://127.0.0.1:8080` (`BACKEND_PORT`)
- Health: `GET /health` on the backend, also proxied by the frontend nginx

## Database init

First start mounts `sql/db_exam.sql` into MySQL `docker-entrypoint-initdb.d`. `MYSQL_DATABASE` creates `db_exam` first, then the dump creates tables and demo rows. The dump is not rewritten. If the named volume already exists, init does not rerun. To re-init, remove the `mysql-data` volume and start again.

## Minimal runtime fixes

- Added `application-docker.yml` so hosts, passwords, and JWT come from environment variables. Upstream `application-dev.yml` is left unchanged.
- Docker profile sets `CAPTCHA_ENABLED=false` by default. Upstream default is `true`. Captcha is stored in Redis and blocks scripted login. Set `CAPTCHA_ENABLED=true` to restore it.
- `GET /health` added and listed in `SecurityConfig` `permitAll`. No other security rules changed.
- Dockerfile now builds and runs Java 8, matching `pom.xml`.

## Secrets

Do not commit `.env`. `.env.example` has placeholders only. Upstream `application-*.yml` already contains live-looking credentials from the original repository. They are not copied into new files. Rotate those upstream credentials before any public deploy.
