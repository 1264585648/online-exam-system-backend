# License audit

This is a factual record, not a claim of zero copyright risk.

## Confirmed

- Root `LICENSE` is MIT, copyright Alan 2024. The file is unchanged by this fork initialization.
- `pom.xml` parent is Spring Boot, which uses Apache License 2.0. That is a dependency license, not the project license.
- README section "版权声明" ends with a link labeled Apache License 2.0 pointing at `https://github.com/macrozheng/mall/blob/master/LICENSE`. The same README also says the project's own `LICENSE` is MIT. Both statements are present. Neither was deleted.
- Source headers sampled under `src/main/java` attribute authors such as Alan and other named contributors. No `NOTICE` file exists.

## Needs Review

- README historical pointer to `macrozheng/mall` Apache License 2.0. Need a human pass to see whether any mall source was copied, or whether the link is only leftover template text. This audit did not delete or rewrite that section.
- `sql/db_exam.sql` is a Navicat data dump containing demo user rows and hashed passwords. Treat it as project data shipped by upstream, not as a third-party library license.
- Upstream `application-dev.yml` and `application-prod.yml` contain credential-like values (OSS, Coze, Dify, LLM, JWT, MinIO, database). License-unrelated, but they must not be treated as safe to publish.
- Dependency `druid-spring-boot-3-starter` name does not match Spring Boot 2.1.3. License is still Alibaba's, but the artifact choice needs review before a Boot upgrade (not done this phase).

## No Issue Found

- No additional `NOTICE` file that contradicts the root MIT license.
- Docker and CI files added in this phase are original to this fork setup and do not copy mall source.
- MinIO, Redis, MySQL, and nginx images are pulled at runtime and are not vendored into the repo.
