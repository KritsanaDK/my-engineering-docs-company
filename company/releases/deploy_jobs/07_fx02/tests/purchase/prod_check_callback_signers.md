# Prod pre-flight — who signs purchase `/callback` besides 2C2P (READ-ONLY, run by someone with Prod access)

Why: purchase `85c3261` / `6d7586e` (verify the callback JWT with `KEY_2C2P_SECRET`) breaks every caller that signs
with a different key. On `main` two services sign callbacks themselves:
- go-e-api `POST /api/v1/payment/success` (partner "EXMS-PaymentStatusUpdate") — HMAC-SHA256 with `PAYMENT_SECRET_KEY`
- go-echo-internal-service `POST /api/v1/payment/success` (backoffice manual payment) — `PAYMENT_SECRET_KEY`
In git, both helm-prod files set `PAYMENT_SECRET_KEY` to the sandbox key (sha256 prefix `17540080dbf7`), while Prod purchase
reads `KEY_2C2P_SECRET` from secret `2c2p` (helm-prod plain value hash prefix `be67b5871268`).

## 1. Are these paths used on Prod? (DB, read-only)
```sql
SELECT date_trunc('month', create_at)::date AS month, count(*)
FROM insurverse.log_openapi_interface
WHERE api_name = 'EXMS-PaymentStatusUpdate'
GROUP BY 1 ORDER BY 1 DESC LIMIT 6;
```
UAT for reference (2026-09-25): 668 calls, 365 in the last 30 days.

## 2. Do the keys match on Prod? (prints hashes only, never the value)
```bash
kubectl -n <prod-ns> get secret 2c2p -o jsonpath='{.data.KEY_2C2P_SECRET}' | base64 -d | shasum -a 256 | cut -c1-12
kubectl -n <prod-ns> get deploy <go-e-api payment deploy> -o json | jq -r '.spec.template.spec.containers[0].env[]|select(.name=="PAYMENT_SECRET_KEY")|.value' | tr -d '\n' | shasum -a 256 | cut -c1-12
kubectl -n <prod-ns> get deploy backend-internal-service -o json | jq -r '.spec.template.spec.containers[0].env[]|select(.name=="PAYMENT_SECRET_KEY")|.value' | tr -d '\n' | shasum -a 256 | cut -c1-12
```
If the first hash differs from the other two, enabling signature verification in purchase would reject every partner
payment-success notice and every backoffice manual payment (HTTP 400, no policy issued).

## Proposal for FX-02 (pending approval)
Take signature verification out of `fix/fx-02-purchase` (revert of 6d7586e). Re-enable only after go-e-api and
internal-service sign with the same key as Prod purchase (follow-up task, 3 repos together).
