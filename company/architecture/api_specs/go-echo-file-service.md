# go-echo-file-service — API Spec

## Overview

| Item | Value |
|---|---|
| Purpose | Upload files and images to Google Cloud Storage (GCS) and return a public URL. Two endpoints first check the image with Google Cloud Vision (label detection) to confirm it shows a car or a car side (tire or wheel). |
| Framework | Go + Echo v4 (`github.com/labstack/echo/v4`), module `go_echo_file_service` |
| Port | env `HTTP_PORT`, default `8080` (`main.go:27-30`; the Dockerfile sets `HTTP_PORT=8080` and has `EXPOSE 8080`) |
| Base path | `/api/v1/file` (built by `router.GenApiVersion` from `constants.ApiVersion = "v1"`, `router/router.go:31-33`) |
| Env var NAMES read by code | `HTTP_PORT`, `GCS_BUCKET` (falls back to the `constants.GCSBucket` constant when empty, `configs/config.go:12-17`) |
| Env var NAMES in helm values but unused by code | `ENV`, `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS` (no DB code exists in the service) |
| Credentials | GCP service-account file `key.json` in the working directory, loaded with `option.WithCredentialsFile("key.json")` (`webserver/filemanagment.go:31,52`) |
| External / third-party calls | **Google Cloud Storage** (`cloud.google.com/go/storage`): writes objects to the bucket, and at startup sets the bucket default object ACL to `AllUsers:READER`. **Google Cloud Vision** (`cloud.google.com/go/vision/apiv1`): `ImageAnnotatorClient.DetectLabels` with max 10 results. Returned public URL format: `https://storage.googleapis.com/<GCS_BUCKET>/<filename>` (`constants.GCSApi`). |
| Database | None |

Startup order (`main.go`): `config.GetConfigENV()`, then `webserver.FileHandler()` (GCS client + ACL), then `webserver.DetectHandler()` (Vision client), then CORS middleware, then routes, then `/healthcheck`.

## Auth & Middleware

- **No authentication** on any route. `middlewares/Validate.go` has a `ValidateToken` JWT middleware, but all of it is commented out and nothing uses it. `main.go` declares a swagger `BearerAuth` security definition that no route enforces.
- Global middleware: `middleware.CORS()` (Echo default: all origins allowed).
- There is no Recover middleware. Code paths that `panic` (invalid base64) or call `log.Fatalf` (Vision errors) can crash the request goroutine or the whole process. See Notes.
- Validator: `router.CustomValidator` wraps `github.com/go-playground/validator` and returns HTTP 400 on failure. `models.ImageBase64` has no `validate` tags, so validation never fails.

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| GET | `/healthcheck` | None | `main.go:35` (`healthcheck`) | Liveness check that returns plain text `OK` |
| GET | `/swagger/*` | None | `router/router.go:47` (`echoSwagger.WrapHandler`) | Swagger UI and doc JSON (from `docs/docs.go`) |
| POST | `/api/v1/file/upload` | None | `controllers/filemanage.go:41` (`UploadFile`) | Multipart upload of one or more files to GCS |
| POST | `/api/v1/file/uploadbase64` | None | `controllers/filemanage.go:116` (`UploadFileBase64`) | Upload one base64 data-URI image to GCS |
| POST | `/api/v1/file/uploadbase64/cardetect` | None | `controllers/detectcar.go:49` (`CarDetection`) | Uses Vision to check the image shows a car; uploads to GCS only if it does |
| POST | `/api/v1/file/uploadbase64/sidedetect` | None | `controllers/detectcar.go:77` (`SideDetection`) | Uses Vision to check the image shows a car side (car + tire/wheel); uploads to GCS only if it does |

Total: **6 routes**, 4 of them business routes.

## Endpoints

### Common response envelope — `models.JsonReturn` (`models/jsonModel.go:3-8`)

| Field | Type | Notes |
|---|---|---|
| `title` | string | Always `"Success"` on the 200 path |
| `status` | int | Mirrors the HTTP status (`200`) |
| `description` | string | Always `""` (never set) |
| `result` | any | Content depends on the endpoint |

---

### GET `/healthcheck`

- Purpose: liveness probe.
- Params: none.
- Success: `200 text/plain` → `OK`
- Errors: none.
- DB: none. Outbound: none.

### GET `/swagger/*`

- Purpose: serves the swaggo UI and `doc.json`, generated into `docs/docs.go`.
- The swagger annotations still hold template values (`@host petstore.swagger.io`, `@BasePath /v2`, "Swagger Example API"). The doc metadata does not match the real service. ⚠️
- DB: none. Outbound: none.

---

### POST `/api/v1/file/upload`

- Purpose: upload one or more files (any type) to the GCS bucket.
- Content-Type: `multipart/form-data`
- Form fields:

| Name | Type | Required | Validation |
|---|---|---|---|
| `file` | file (repeatable) | yes, in practice | None. If the field is missing, the loop runs zero times and `result` is `[]`. |

- Object naming: `<UnixNano>.<original extension>` (the extension is the text after the last `.` in the original filename) (`filemanage.go:59-62`).
- Success `200`:

```json
{
  "title": "Success",
  "status": 200,
  "description": "",
  "result": [
    { "imageUrl": "https://storage.googleapis.com/<GCS_BUCKET>/1726000000000000000.jpg" }
  ]
}
```

- Errors:

| Status | Body | Cause |
|---|---|---|
| 400 / 500 (Echo default error JSON `{"message": "..."}`) | error from `c.MultipartForm()` | Request is not multipart or cannot be parsed |
| 500 `{"message":"Internal Server Error"}` | `io.Copy: ...` / `Writer.Close: ...` | GCS write failed (the Go error is returned directly, so Echo maps it to 500) |

- DB: none.
- Outbound: GCS `Bucket.Object(name).NewWriter` (object write).

---

### POST `/api/v1/file/uploadbase64`

- Purpose: upload one base64 data-URI image to GCS.
- Content-Type: `application/json`
- Request body (`models.ImageBase64`):

```json
{ "imagebase64": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA..." }
```

| Field | Type | Required | Validation |
|---|---|---|---|
| `imagebase64` | string | yes, in practice | No tag. Must be a data URI `data:<type>/<ext>;base64,<payload>`. The extension comes from the MIME subtype (`filemanage.go:85-88`). |

- Object naming: `<UnixNano>_<16 random [a-z0-9]>.<ext>` (`filemanage.go:95`).
- Success `200`:

```json
{
  "title": "Success",
  "status": 200,
  "description": "",
  "result": { "imageUrl": "https://storage.googleapis.com/<GCS_BUCKET>/1726000000000000000_ab12cd34ef56gh78.png" }
}
```

- Errors:

| Status | Body (text/plain) | Cause |
|---|---|---|
| 400 | `Bad Request` | `c.Bind` failed (malformed JSON) |
| 400 | validator message | `c.Validate` (in practice never fails, because there are no tags) |
| 500 / connection reset | none (panic) | Input without a `,` or without `/` in the header (index out of range), or invalid base64 (`panic(err)`). No Recover middleware is registered. ⚠️ |

- A GCS write error is only printed with `fmt.Println`. The handler still returns 200 with a URL that may not exist. ⚠️
- DB: none. Outbound: GCS object write.

---

### POST `/api/v1/file/uploadbase64/cardetect`

- Purpose: run Vision label detection on the image. If a label `Car` or `vehicle` is found (exact, case-sensitive match on `label.Description`), upload the image to GCS and return its URL.
- Request body: same as `/uploadbase64` (`{"imagebase64": "data:image/jpeg;base64,..."}`).
- Success `200`, car detected:

```json
{
  "title": "Success",
  "status": 200,
  "description": "",
  "result": { "imageUrl": "https://storage.googleapis.com/<GCS_BUCKET>/1726000000000000000_ab12cd34ef56gh78.jpeg", "status": true }
}
```

- Success `200`, no car (still HTTP 200):

```json
{ "title": "Success", "status": 200, "description": "", "result": { "imageUrl": "", "status": false } }
```

- Errors:

| Status | Body (text/plain) | Cause |
|---|---|---|
| 400 | `bad request` | Bind failure |
| 400 | validator message | Validate (never triggers in practice) |
| panic | none | Invalid base64 or no `,` in the input |
| **process exit** | none | `vision.NewImageFromReader` or `DetectLabels` error → `log.Fatalf` stops the whole service. ⚠️ |

- DB: none.
- Outbound: Google Cloud Vision `DetectLabels` (max 10 labels), then GCS object write if a car is detected.

---

### POST `/api/v1/file/uploadbase64/sidedetect`

- Purpose: like `cardetect`, but accepts the image only when the labels show a car side.
  - Condition (`detectcar.go:86`): `(Tire || "Automotive Tire") && Car` **or** `(Wheel || "Automotive Wheel System" || "Alloy wheel") && Car`.
- Request, responses and errors: same as `cardetect` (`result.status` = `true` with `imageUrl` set, or `false` with `imageUrl: ""`).
- DB: none. Outbound: Google Cloud Vision `DetectLabels`, then GCS object write on success.

## DB Usage

| Table / function | Read / write | Endpoints |
|---|---|---|
| none | none | This service has no DB connection. The `DB_*` values in the helm files are not used by the code. |

External storage (not a DB):

| Resource | Read / write | Endpoints |
|---|---|---|
| GCS bucket `<GCS_BUCKET>` objects | write | upload, uploadbase64, cardetect (when a car is found), sidedetect (when a side is found) |
| GCS bucket default object ACL (`AllUsers` → `READER`) | write (at startup) | none (runs in `webserver.FileHandler()`) |
| Google Cloud Vision `DetectLabels` | call | cardetect, sidedetect |

## Notes / ⚠️ unverified items

1. ⚠️ **No authentication.** Anyone who can reach the service can write to the GCS bucket, and the bucket is set so that all uploaded objects are publicly readable.
2. ⚠️ **Crash risks.** `panic(err)` on bad base64, index-out-of-range on malformed data URIs, and `log.Fatalf` on Vision errors. There is no `middleware.Recover()`. A Vision error ends the whole process.
3. ⚠️ `UploadBase64` ignores GCS write errors (it only prints them) and still returns 200 with a URL.
4. ⚠️ `UploadFile` runs `defer src.Close()` inside a loop, so file handles stay open until the handler returns (minor).
5. ⚠️ `constants/constant.go` has hard-coded credentials and endpoints for SMS (ThaiBulkSMS) and OneSignal: `SmsApiKey`, `OnesignalAppID`, `OnesignalToken`, and `Salt` (JWT signing key). No route uses them. Only the names are listed here; the values should be rotated and moved to secrets. `key.json` (a GCP service-account key) is committed in the service root.
6. ⚠️ `utils/hash.go` (JWT) and `utils/utils.go` (OTP/bcrypt) are dead code. No route uses them.
7. ⚠️ Swagger metadata is still placeholder text (petstore host, `/v2` base path).
8. ⚠️ Label matching is case-sensitive (`"vehicle"` lowercase vs `"Car"`). Vision usually returns title-case labels such as `"Vehicle"`, so the `vehicle` branch may never match. This was not checked against live Vision output.
