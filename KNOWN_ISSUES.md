# Known issues

- Upstream `application-dev.yml` and `application-prod.yml` already contain live-looking credentials. This phase did not delete them, because that would rewrite upstream config, and did not copy those values into new files. Rotate them before any shared deploy. Docker uses `application-docker.yml` and `.env` instead.
- `pom.xml` depends on `druid-spring-boot-3-starter` while the parent is Spring Boot `2.1.3.RELEASE`. Not upgraded this phase. Watch classpath/startup if the pool starter is pulled onto the runtime path.
- No `src/test` tree exists. `mvn test` has nothing to execute. That is recorded, not skipped.
- Docker profile disables captcha by default (`CAPTCHA_ENABLED=false`) so the published demo accounts can log in. Upstream default remains `true` in `application-dev.yml`.
- AI scoring, Coze, Dify, Milvus, and `online-exam-agent` are not part of the baseline Compose stack.

- Login log insert omitted `device` when User-Agent was missing, and `t_log.device` is NOT NULL. `extractDeviceType` now returns `Unknown` instead of null so login can finish. No table change.

- Docker image did not contain `src/main/resources/ipdata/ip2region.xdb` at the relative path `IPUtils` expects. Dockerfile now copies that file. Login still works without it; place falls back to empty/暂无信息.
