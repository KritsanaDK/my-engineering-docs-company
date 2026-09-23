# Branch inventory vs origin/main — 2026-09-23 (git merge-tree / git cherry)

## ahead/merges/behind/in uat-isv/conflicts/other authors
```
go-e-api                         fix/fx-01-e-api                   ahead=1   merges=0   behind=0    in_uat-isv=yes      files=3   helm-prod=0  conflicts=0  others=none                                                                                                            2026-09-23
go-e-api                         hotfix/ws1-policy-issue           ahead=1   merges=0   behind=15   in_uat-isv=yes      files=1   helm-prod=0  conflicts=0  others=none                                                                                                            2026-08-05
go-echo-analytics-service        fix/fx-01-analytics               ahead=1   merges=0   behind=0    in_uat-isv=yes      files=1   helm-prod=0  conflicts=0  others=none                                                                                                            2026-09-23
go-echo-analytics-service        hotfix/ws9-ops                    ahead=1   merges=0   behind=2    in_uat-isv=yes      files=1   helm-prod=0  conflicts=0  others=none                                                                                                            2026-08-07
go-echo-backoffice-service       hotfix/ws8-backoffice             ahead=5   merges=2   behind=2    in_uat-isv=yes      files=7   helm-prod=0  conflicts=0  others=voranun,                                                                                                        2026-09-07
go-echo-lead-policy-service      fix/fx-01-lead-policy             ahead=1   merges=0   behind=0    in_uat-isv=yes      files=2   helm-prod=0  conflicts=0  others=none                                                                                                            2026-09-23
go-echo-lead-policy-service      hotfix/ws1-policy-issue           ahead=5   merges=0   behind=13   in_uat-isv=yes      files=10  helm-prod=0  conflicts=0  others=none                                                                                                            2026-08-24
go-echo-lead-policy-service      hotfix/ws3-cmi                    ahead=1   merges=0   behind=13   in_uat-isv=yes      files=5   helm-prod=0  conflicts=0  others=none                                                                                                            2026-08-06
go-echo-notification-service     fix/fx-01-notification            ahead=6   merges=1   behind=4    in_uat-isv=yes      files=4   helm-prod=0  conflicts=1  others=none                                                                                                            2026-09-23
go-echo-notification-service     hotfix/ws9-ops                    ahead=1   merges=0   behind=120  in_uat-isv=yes      files=1   helm-prod=0  conflicts=1  others=none                                                                                                            2026-08-07
go-echo-purchase-service         hotfix/ws1-policy-issue           ahead=13  merges=2   behind=21   in_uat-isv=yes      files=5   helm-prod=0  conflicts=0  others=none                                                                                                            2026-09-22
go-echo-purchase-service         hotfix/ws5-invoice                ahead=1   merges=0   behind=51   in_uat-isv=partial  files=3   helm-prod=0  conflicts=0  others=none                                                                                                            2026-08-07
go-echo-purchase-service         hotfix/ws7-renew                  ahead=5   merges=0   behind=51   in_uat-isv=yes      files=4   helm-prod=0  conflicts=0  others=none                                                                                                            2026-08-07
go-echo-uam-service              fix/fx-01-uam                     ahead=5   merges=0   behind=0    in_uat-isv=partial  files=11  helm-prod=0  conflicts=0  others=none                                                                                                            2026-09-23
go-echo-uam-service              hotfix/oic                        ahead=76  merges=43  behind=15   in_uat-isv=partial  files=18  helm-prod=0  conflicts=2  others=Sirawit Nakyam,napat-k-t8,napat.k@horixon-t8.com,panita.p,thanadol.d,voranun,voranunb,                          2026-09-14
go-echo-uam-service              hotfix/oic-cmi                    ahead=1   merges=0   behind=417  in_uat-isv=partial  files=1   helm-prod=0  conflicts=1  others=X10,                                                                                                            2025-09-08
go-echo-uam-service              hotfix/oic-uat                    ahead=77  merges=43  behind=15   in_uat-isv=partial  files=19  helm-prod=0  conflicts=2  others=Sirawit Nakyam,napat-k-t8,napat.k@horixon-t8.com,panita.p,thanadol.d,voranun,voranunb,                          2026-09-22
go-echo-uam-service              hotfix/ws5-invoice                ahead=1   merges=0   behind=68   in_uat-isv=partial  files=2   helm-prod=0  conflicts=1  others=none                                                                                                            2026-08-07
go-echo-uam-service              hotfix/ws6-saleforce-endoesement  ahead=3   merges=0   behind=68   in_uat-isv=yes      files=4   helm-prod=0  conflicts=1  others=none                                                                                                            2026-09-07
go-echo-uam-service              hotfix/ws7-renew                  ahead=2   merges=1   behind=0    in_uat-isv=partial  files=4   helm-prod=0  conflicts=0  others=none                                                                                                            2026-09-22
go-echo-uam-service              hotfix/ws8-backoffice             ahead=1   merges=0   behind=65   in_uat-isv=yes      files=1   helm-prod=0  conflicts=0  others=none                                                                                                            2026-08-07
go-echo-uam-service              hotfix/ws9-ops                    ahead=1   merges=0   behind=68   in_uat-isv=yes      files=4   helm-prod=0  conflicts=1  others=none                                                                                                            2026-08-07
go-fiber-policy-service          hotfix/oic                        ahead=74  merges=49  behind=10   in_uat-isv=partial  files=14  helm-prod=0  conflicts=0  others=attapon.j.os@horixon-t8.com,napat.k@horixon-t8.com,panita.p,panita.p.os,siripornk,thanadol.d,voranun,voranunb,  2026-09-14
go-fiber-policy-service          hotfix/oic-uat                    ahead=86  merges=51  behind=10   in_uat-isv=partial  files=14  helm-prod=0  conflicts=0  others=attapon.j.os@horixon-t8.com,napat.k@horixon-t8.com,panita.p,panita.p.os,siripornk,thanadol.d,voranun,voranunb,  2026-09-14
go-fiber-policy-service          hotfix/ws3-cmi-oic                ahead=53  merges=44  behind=77   in_uat-isv=yes      files=41  helm-prod=1  conflicts=9  others=attapon.j.os@horixon-t8.com,napat.k@horixon-t8.com,panita.p,panita.p.os,thanadol.d,voranun,                     2026-08-24
go-oauth2-server                 fix/fx-01-oauth2                  ahead=1   merges=0   behind=0    in_uat-isv=yes      files=1   helm-prod=0  conflicts=0  others=none                                                                                                            2026-09-23
isv-test                         fix/fx-01-isv-test                ahead=1   merges=0   behind=0    in_uat-isv=yes      files=4   helm-prod=0  conflicts=0  others=none                                                                                                            2026-09-23
node_iia_service                 hotfix/ws4-caim                   ahead=1   merges=0   behind=0    in_uat-isv=yes      files=13  helm-prod=0  conflicts=0  others=none                                                                                                            2026-08-07
nodejs-express-premium-service   fix/fx-01-premium                 ahead=1   merges=0   behind=0    in_uat-isv=yes      files=1   helm-prod=0  conflicts=0  others=none                                                                                                            2026-09-23
nodejs-express-premium-service   hotfix/oic                        ahead=16  merges=5   behind=0    in_uat-isv=yes      files=6   helm-prod=0  conflicts=0  others=none                                                                                                            2026-09-10
nodejs-express-premium-service   hotfix/oic-uat                    ahead=92  merges=67  behind=0    in_uat-isv=partial  files=15  helm-prod=0  conflicts=0  others=Pat,Sirawit Nakyam,napat.k@horixon-t8.com,nuchpol.a@horixon-t8.com,panita.p,panita.p.os,thanadol.d,voranunb,    2026-09-14
nodejs-express-premium-service   hotfix/ws6-saleforce-endoesement  ahead=2   merges=0   behind=61   in_uat-isv=partial  files=2   helm-prod=0  conflicts=1  others=none                                                                                                            2026-08-07
python-fastapi-document-service  fix/fx-01-document                ahead=1   merges=0   behind=0    in_uat-isv=yes      files=1   helm-prod=0  conflicts=0  others=none                                                                                                            2026-09-23
python-fastapi-document-service  hotfix/ws1-policy-issue           ahead=2   merges=0   behind=13   in_uat-isv=yes      files=3   helm-prod=0  conflicts=1  others=none                                                                                                            2026-09-22
nextjs-webapp                    hotfix/oic                        ahead=21  merges=0   behind=22   in_uat-isv=yes      files=21  helm-prod=0  conflicts=0  others=none                                                                                                            2026-09-22
nextjs-webapp                    hotfix/oic-uat                    ahead=49  merges=15  behind=22   in_uat-isv=partial  files=25  helm-prod=0  conflicts=0  others=kIttabeth,panita.p,voranunb,                                                                                    2026-09-14
```

## Net effect of a virtual merge into main
```
go-e-api                         fix/fx-01-e-api                   adds_3_files
go-e-api                         hotfix/ws1-policy-issue           adds_1_files
go-echo-analytics-service        fix/fx-01-analytics               adds_1_files
go-echo-analytics-service        hotfix/ws9-ops                    adds_1_files
go-echo-backoffice-service       hotfix/ws8-backoffice             adds_7_files
go-echo-lead-policy-service      fix/fx-01-lead-policy             adds_2_files
go-echo-lead-policy-service      hotfix/ws1-policy-issue           adds_10_files
go-echo-lead-policy-service      hotfix/ws3-cmi                    adds_5_files
go-echo-notification-service     fix/fx-01-notification            CONFLICT(1)
go-echo-notification-service     hotfix/ws9-ops                    CONFLICT(1)
go-echo-purchase-service         hotfix/ws1-policy-issue           adds_5_files
go-echo-purchase-service         hotfix/ws5-invoice                adds_3_files
go-echo-purchase-service         hotfix/ws7-renew                  adds_4_files
go-echo-uam-service              fix/fx-01-uam                     adds_11_files
go-echo-uam-service              hotfix/oic                        CONFLICT(2)
go-echo-uam-service              hotfix/oic-cmi                    CONFLICT(1)
go-echo-uam-service              hotfix/oic-uat                    CONFLICT(2)
go-echo-uam-service              hotfix/ws5-invoice                CONFLICT(1)
go-echo-uam-service              hotfix/ws6-saleforce-endoesement  CONFLICT(1)
go-echo-uam-service              hotfix/ws7-renew                  adds_4_files
go-echo-uam-service              hotfix/ws8-backoffice             adds_1_files
go-echo-uam-service              hotfix/ws9-ops                    CONFLICT(1)
go-fiber-policy-service          hotfix/oic                        adds_14_files
go-fiber-policy-service          hotfix/oic-uat                    adds_14_files
go-fiber-policy-service          hotfix/ws3-cmi-oic                CONFLICT(9)
go-oauth2-server                 fix/fx-01-oauth2                  adds_1_files
isv-test                         fix/fx-01-isv-test                adds_4_files
node_iia_service                 hotfix/ws4-caim                   adds_13_files
nodejs-express-premium-service   fix/fx-01-premium                 adds_1_files
nodejs-express-premium-service   hotfix/oic                        adds_6_files
nodejs-express-premium-service   hotfix/oic-uat                    adds_15_files
nodejs-express-premium-service   hotfix/ws6-saleforce-endoesement  CONFLICT(1)
python-fastapi-document-service  fix/fx-01-document                adds_1_files
python-fastapi-document-service  hotfix/ws1-policy-issue           CONFLICT(1)
nextjs-webapp                    hotfix/oic                        adds_21_files
nextjs-webapp                    hotfix/oic-uat                    adds_25_files
```
