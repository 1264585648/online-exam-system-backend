# Baseline

Facts taken from this repository's source on `main` at fork initialization. Not inferred from memory.

## Identity

- Upstream: https://github.com/Alanosy/online-exam-system-backend
- Upstream default branch: `master`
- This fork default branch: `main`
- Maven coordinates: `cn.org.alan:exam:1.0-SNAPSHOT` (`pom.xml`)
- Single Maven module. No `<modules>` list. There is a sibling directory `online-exam-agent/` (Python agent) that is not part of the Spring Boot jar.

## Runtime

- Java compiler target: `1.8` (`pom.xml` `java.version`, `maven.compiler.source`, `maven.compiler.target`)
- Spring Boot parent: `2.1.3.RELEASE`
- Default Spring profile: `dev` (`src/main/resources/application.yml`)
- Default HTTP port: `8080` (`application-dev.yml` `server.port`)

## Persistence and middleware

- Database: MySQL. Driver `mysql:mysql-connector-java` version property `8.0.33`. JDBC URL in `application-dev.yml` uses database `db_exam`, host `127.0.0.1`, port `3306`.
- Connection pool: `com.alibaba:druid-spring-boot-3-starter` `1.2.20` (declared even though Boot is 2.1.3).
- ORM: MyBatis-Plus `3.5.5` (`mybatis-plus-boot-starter`).
- Redis: `spring-boot-starter-data-redis` plus `spring-session-data-redis`. Host `127.0.0.1`, port `6379`. Dev profile has no Redis password. Prod profile sets a Redis password in `application-prod.yml`.
- Official SQL: `sql/db_exam.sql` (Navicat dump, source MySQL 5.7.44, schema `db_exam`). Companion notes: `sql/db_exam_sql.txt`, `sql/Docker部分配置命令.md`. The dump does not contain `CREATE DATABASE`; it assumes database `db_exam` already exists.

## File storage and third-party services

- Active storage selector: `online-exam.storage.type` = `minio` in both `application-dev.yml` and `application-prod.yml`.
- MinIO client dependency: `io.minio:minio:7.0.1`. Bean `MinioUtil` is created only when storage type is `minio`. Config keys: `minio.endpoint`, `minio.accesskey`, `minio.secretKey`, `minio.bucket`. Dev endpoint `http://127.0.0.1:9000`.
- Aliyun OSS dependency `aliyun-sdk-oss` and `AliOSSUtil` exist, loaded only when storage type is `aliyun`.
- AI chat: `online-exam.chat-platform.type` = `coze` in `application-dev.yml`. `CozeUtil` loads only for `coze`. `DifyUtil` loads only for `dify`. LLM/Milvus fields are commented out in `LLMUtil` and are not required to boot.
- Other flags in `application-dev.yml`: `online-exam.login.captcha.enabled=true`, `online-exam.auto-scoring.enabled=true`, `online-exam.agent.scoring-enabled=false`, `system.register.enabled=true`.

## Environment variables

Upstream `application-dev.yml` / `application-prod.yml` hard-code credentials. Those files are upstream-committed and are not the Docker runtime path.

Docker profile `application-docker.yml` reads:

- `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`
- `REDIS_HOST`, `REDIS_PORT`
- `MINIO_ENDPOINT`, `MINIO_ACCESS_KEY`, `MINIO_SECRET_KEY`, `MINIO_BUCKET`
- `JWT_SECRET`
- `CAPTCHA_ENABLED` (Compose default `false` so demo SQL accounts can log in)
- `COZE_TOKEN`, `COZE_BOT`, `COZE_BASE_URL` (placeholders; AI scoring is off)

## Default accounts

From `sql/db_exam.sql` `t_user` and the upstream README (passwords are the project's published demo passwords, stored as BCrypt in SQL):

| user_name | real_name | role_id | README password |
| --- | --- | --- | --- |
| admin | 管理员 | 3 | 123456 |
| teacher | 教师测试账号 | 2 | 123456 |
| student | 学生测试账号 | 1 | 123456 |

## API surface used by the baseline deploy

- Health: `GET /health` (added for Compose; permitted without auth)
- Login: `POST /api/auths/login` body `{username, password}`
- Question paging: `GET /api/questions/paging`
- Exam paging: `GET /api/exams/paging` (teacher/admin)

## Docker image note

The previous `Dockerfile` used `openjdk:17` while `pom.xml` compiles to 1.8. The current `Dockerfile` builds with `maven:3.8.8-eclipse-temurin-8` and runs on `eclipse-temurin:8-jre-jammy`.
