# P1 — origin/uat-isv vs (origin/main + origin/fix/fx-02-*) — 2026-09-28
Excluded paths: helm/helm-uat-isv.yaml, helm/helm-uat.yaml, .gitlab-ci.yml, .gitlab/*. No repo has any origin/main commit missing from uat-isv (all 0).

| repo | status | main commits missing | fx-02 branch & included? | app-code diff files (vs expected) | note |
|---|---|---|---|---|---|
| go-e-api | DRIFT (fx-02 missing) | 0 | fix/fx-02-e-api (2c) — NO | 3: internal/lead/repository/repository.go, internal/motor/repository/{repository,repository_test}.go | uat-isv == main exactly; fx-02 not merged |
| go-echo-analytics-service | DRIFT (fx-02 missing) | 0 | fix/fx-02-analytics (2c) — NO | 1: main.go | uat-isv == main; fx-02 not merged |
| go-echo-lead-policy-service | DRIFT (fx-02 missing) | 0 | fix/fx-02-lead-policy (8c) — NO | 7: helm/helm-prod.yaml, pkg/cmi/repository/cmi_repository(_test).go, pkg/cmi/service/cmi_service.go, utils/http_client(_test).go, utils/keycloak.go | uat-isv == main; fx-02 not merged |
| go-echo-notification-service | DRIFT (fx-02 missing) | 0 | fix/fx-02-notification (4c) — NO | 2: controllers/notificationController.go, controllers/notificationUser.go | uat-isv == main; fx-02 not merged |
| go-echo-purchase-service | DRIFT (fx-02 missing) | 0 | fix/fx-02-purchase (8c) — NO | 7: controllers/{buyer_account,buyer_account_test,coreController,paymentController}.go, go.mod, go.sum, models/LeadCoveragePremiumEntity.go | uat-isv == main; fx-02 not merged |
| go-echo-uam-service | DRIFT (fx-02 missing) | 0 | fix/fx-02-uam (14c) — NO; main is 5 commits ahead of fx-02 base | 15 (cmiRealtimeController, cmi_validate(+test), cmi_invalid_test, ekycController(+test), notificationController(+test), policyController, salesforceController, ...) | uat-isv == main; fx-02 not merged AND stale vs main (rebase/merge main first) |
| go-fiber-policy-service | DRIFT (fx-02 missing) | 0 | fix/fx-02-fiber-policy (3c) — NO; main 2 commits ahead of fx-02 base | 4: helm/helm-prod.yaml, internal/service/cmi_realtime.go, cmi_validate(_test).go | uat-isv == main; fx-02 not merged, stale vs main |
| go-oauth2-server | DRIFT (fx-02 missing) | 0 | fix/fx-02-oauth2 (2c) — NO | 1: internal/infrastructure/server/fiber.go | uat-isv == main; fx-02 not merged |
| isv-test | DRIFT (fx-02 missing) | 0 | fix/fx-02-isv-test (2c) — NO | 4: controller/short_link.go, service/renew_policy_service.go, usecase/shopee/usecase.go, util/short_link.go | uat-isv == main; fx-02 not merged |
| nodejs-express-premium-service | DRIFT (fx-02 missing) | 0 | fix/fx-02-premium (2c) — NO | 1: controllers/premium.controller.js | uat-isv == main; fx-02 not merged |
| python-fastapi-document-service | DRIFT (fx-02 missing) | 0 | fix/fx-02-document (2c) — NO | 2: internal/documents/usecase/endorse/impl(_test).go | uat-isv == main; fx-02 not merged |
| nextjs-webapp | DRIFT (extra) | 0 | fix/fx-02-nextjs-webapp (1c) — YES | 7: .dockerignore, .gcloudignore, Dockerfile.nginx, config/env/uat-isv.js, next.config.js, src/components/layouts/Navbar.tsx, src/pages/index.tsx | fx-02 included; extra = uat-isv build/env config + "stop root Loading loop / split car classes in buy menu" fix (Navbar/index/next.config) |
| go-echo-backoffice-service | DRIFT | 0 | none | 3: .gitignore, controllers/exportController.go (+113), router/router.go (+1) | "fix(promo): align promoController with main ... fix exportController table reference" — uat-isv-only export endpoint |
| go-echo-core-service | DRIFT | 0 | none | 4: .gitignore, controllers/dataController_test.go, helm/helm-uat2.yaml, province.json (+83,676 lines) | test for GetMenu + large province.json + helm-uat2 tweak; old uat-isv-only commits (14) |
| go-echo-ta-service | DRIFT | 0 | none | 4: .gitignore, database/sqlc/exec_tx.go, exec_tx_test.go, main.go | "fix(db): release pooled connection on panic and bound the pool (TA hang)" — uat-isv-only fix, not on main/fx-02 |
| go-fiber-queue-service | ALIGNED* | 0 | none | 2: .gitignore, configs/helm/helm-uat-isv.yaml | deploy config at non-standard path only |
| go-echo-amlo-service | ALIGNED* | 0 | none | 1: .gitignore | env-file ignore patterns only |
| go-echo-auth-service | ALIGNED* | 0 | none | 1: .gitignore | same |
| go-echo-file-service | ALIGNED* | 0 | none | 1: .gitignore | same |
| go-echo-saleforce-service | ALIGNED* | 0 | none | 1: .gitignore | same |
| java-spring-boot-jasper-report-service | ALIGNED* | 0 | none | 1: .gitignore | same |
| node-oic | ALIGNED* | 0 | none | 1: .gitignore | same |
| node_iia_service | ALIGNED* | 0 | none | 1: .gitignore | same |
| nodejs-express-marketing-service | ALIGNED* | 0 | none | 1: .gitignore | same |
| go-echo-consent-service | ALIGNED | 0 | none | 0 | |
| go-echo-home-service | ALIGNED | 0 | none | 0 | |
| go-echo-internal-service | ALIGNED | 0 | none | 0 | |
| go-echo-pa-service | ALIGNED | 0 | none | 0 | |
| c-oic-realtime, configuration, go-db-query, go-echo-marketing-service, go-echo-oic, go-echo-pt-maxme, isv-bible, ops-monitor | NO_UAT_ISV | - | - | - | no origin/uat-isv |

ALIGNED* = only .gitignore / deploy-config differences, no app code.
