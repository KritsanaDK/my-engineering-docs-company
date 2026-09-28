# c-oic-realtime — API Spec

> Source: `/Users/kritsanawathaniyanon/Code/Go/c-oic-realtime` (solution `cmi_custom.sln`). Read-only analysis, 2026-09-23.
> Despite the `c-` prefix this is **C# / .NET**, not C.

## Overview

| Item | Value |
|---|---|
| Purpose | Signing proxy for the **OIC (คปภ.) CMI Realtime Phase III** (พ.ร.บ. realtime submission). Receives policy / endorsement data as JSON, signs it with the OIC-supplied `PKISigning.dll` using the insurer's X.509 certificate, and forwards `{DigitalSignature, Token, SendDate}` to OIC's `PKISendPolicyREST` / `PKISendEndorseREST`, returning OIC's result. |
| Projects | **`cmi/`** — ASP.NET Web API 2 / MVC 5 on .NET Framework 4.x (`System.Web.Http`, WebApi 5.2.7, HelpPage area). Docker image `mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019` (IIS). **This is the working service.**<br>**`cmi_core/`** — .NET 6 port (`net6.0`), controller `YourController` with same two routes, but `Program.cs` only calls `MapRazorPages()` (no `AddControllers`/`MapControllers`) → the API routes are **not exposed** in cmi_core. |
| Port | `cmi`: IIS (container port 80 ⚠️ unverified; dev IIS Express `http://localhost:62775`). `cmi_core` dev: `https://localhost:7105`, `http://localhost:5166`. |
| Base path | `/cmi/...` (attribute routes) + default Web API template `api/{controller}/{id}` |
| Config / env NAMES | No env vars or appSettings for business config. `Web.config` `appSettings` only has MVC defaults (`webpages:Version`, `webpages:Enabled`, `ClientValidationEnabled`, `UnobtrusiveJavaScriptEnabled`). OIC base URL and certificate serial number are **hard-coded** in the controller. |
| Certificate | Loaded from Windows cert store `CurrentUser\My`, matched by hard-coded serial number and validity window (`GetCert()`, `cmi/Controllers/CMIController.cs:141`). |
| External calls | OIC CMI Realtime REST (see below) |
| Background jobs / queues | None |
| DB | None |

### OIC target URLs (hard-coded)
| Project | Policy | Endorse |
|---|---|---|
| `cmi` (UAT) | `https://extwebsvccmiinsuranceuat.oic.or.th/DMSCMIS_P3/api/PKISendPolicyREST` | `.../DMSCMIS_P3/api/PKISendEndorseREST` |
| `cmi_core` (Prod) | `https://oicws.oic.or.th/DMSCMIS/api/PKISendPolicyREST` | `https://oicws.oic.or.th/DMSCMIS/api/PKISendEndorseREST` |

## Auth & Middleware
- **No authentication/authorization** on the CMI endpoints (no `[Authorize]`, no filters besides MVC defaults in `FilterConfig`).
- `cmi_core`: `UseHttpsRedirection`, `UseHsts` (non-dev), `UseExceptionHandler("/Error")`, `UseAuthorization` (no policies).
- Response wrapper `JsonReturn` (always HTTP 200 at transport level; logical status in body):
```json
{ "Datetime": "2026-09-23T10:00:00+07:00", "Title": "Bad Request Params", "Status": 200, "Description": null, "Result": { } }
```

## Endpoint Summary

| Method | Path | Auth | Handler (file:line) | Description |
|---|---|---|---|---|
| POST | `/cmi/PKISendPolicyREST` | None | `CMIController.PolicyService` — `cmi/Controllers/CMIController.cs:22` | Sign & submit new CMI policy to OIC |
| POST | `/cmi/PKISendEndorseREST` | None | `CMIController.EndorseService` — `cmi/Controllers/CMIController.cs:76` | Sign & submit CMI endorsement to OIC |
| GET | `/` (`Home/Index`) | None | `HomeController.Index` — `cmi/Controllers/HomeController.cs:11` | MVC default home page (HTML) |
| GET | `/Help`, `/Help/Api/{apiId}` … | None | `Areas/HelpPage/Controllers/HelpController.cs` | Auto-generated Web API help pages (template) |

Total: **2 business endpoints** (+ template home/help pages). `cmi_core` equivalents (`[HttpPost("cmi/PKISendPolicyREST")]`, `[HttpPost("cmi/PKISendEndorseREST")]` in `cmi_core/Controller/CMIController.cs`) are ⚠️ **not mapped** at runtime.

## Endpoints

### POST `/cmi/PKISendPolicyREST`
- **Purpose:** submit a พ.ร.บ. (CMI) policy to OIC realtime.
- **Flow:** bind `OIC.PKISigning.PolicyInformation` → reject if `CompanyCode == ""` or `PolicyNumber == ""` → `GetCert()` → `OIC.PKISigning.DigitalSignature(_temp, cert)` → if `ErrorCode != ""` return 400-wrapper with sign result → POST JSON `{DigitalSignature, Token, SendDate:"dd-MM-yyyy"}` to OIC → deserialize into `PKISendPolicyREST`.
- **Request body** — type defined in closed-source `PKISigning.dll` ("OIC CMIRT PKISigning Phase III"). Property names found in the DLL metadata (⚠️ exact membership per class `PolicyInformation` vs `EndorseInformation`, types and required flags unverified):
```json
{
  "CompanyCode": "XXXX",
  "ProxyCompanyCode": "XXXX",
  "PolicyNumber": "CMI-2026-000001",
  "AgentBrokerLicenseNumber": "",
  "ContractDt": "23/09/2026",
  "EffectiveDt": "23/09/2026",
  "EndDt": "23/09/2027",
  "InsuredUniqueID": "1111111111119",
  "InsuredName": "กฤษณะ",
  "InsuredSurname": "วัฒนายนนต์",
  "PlateNumber": "1กข1234",
  "RegisteredProvinceCode": "10",
  "ChassisVINNumber": "MR0XXXXXXXXXXXXXX",
  "VehicleTypeCode": "1.10",
  "VehicleBrand": "TOYOTA",
  "VehicleModel": "YARIS",
  "VehicleColor": "WHITE"
}
```
| Field | Type | Required | Validation |
|---|---|---|---|
| `CompanyCode` | string | yes | non-empty (controller check) |
| `PolicyNumber` | string | yes | non-empty (controller check) |
| other fields above | string ⚠️ | ⚠️ unverified | validated inside `PKISigning.DigitalSignature` (returns `ErrorCode`/`ErrorMessage`) |

- **Success (HTTP 200, `Status: 200`):**
```json
{
  "Datetime": "2026-09-23T10:00:00+07:00",
  "Title": "Bad Request Params",
  "Status": 200,
  "Result": {
    "ProxyCompanyCode": "XXXX", "CompanyCode": "XXXX", "PolicyNumber": "CMI-2026-000001",
    "ReferenceNumber": "...", "ReceiveNumber": "...",
    "EndorseRefNumber": null, "EndorseReceiveNumber": null,
    "Result": "...", "Errors": [ { "ErrorCode": "...", "ErrorMessage": "..." } ]
  }
}
```
(`Title` is always "Bad Request Params" even on success — copy/paste in code.)
- **Errors (HTTP 200 with body `Status: 400`):** missing CompanyCode/PolicyNumber → `Result: null`; signing failure → `Result: SignResult{ErrorCode, ErrorMessage, DigitalSignature, Token}`. OIC business errors come back in `Result.Errors[]` with `Status: 200`. Unhandled exceptions (e.g. cert not found → null cert) → HTTP 500.
- **DB:** none. **Outbound:** `POST {BaseUrl}/DMSCMIS_P3/api/PKISendPolicyREST` (JSON).

### POST `/cmi/PKISendEndorseREST`
- Same as above with `OIC.PKISigning.EndorseInformation` (adds endorsement fields found in DLL: `EndorseRefNumber`, `EndorseEffectiveDt`, `EndorseFlag`, `IssuedCounter` ⚠️ unverified), same validations and wrapper; forwards to `.../DMSCMIS_P3/api/PKISendEndorseREST`; response deserialized into the same `PKISendPolicyREST` shape (`EndorseRefNumber`, `EndorseReceiveNumber` populated).

## DB Usage

| Table / function | Read/Write | Endpoints |
|---|---|---|
| — | — | None. No connection strings or data access code. |

## Notes / ⚠️ unverified items
- Environment is chosen by **which project is deployed** (cmi = UAT URL, cmi_core = Prod URL), not by config — risky; and cmi_core does not expose the controllers at all (`Program.cs` lacks `AddControllers()` / `MapControllers()`).
- Certificate serial number is hard-coded; if the cert is missing/expired `GetCert()` returns null and signing throws.
- `PKISigning.dll` HintPath points to a developer desktop path (`..\Users\TT\Desktop\CMI\PKISigning.dll`); a copy exists in `cmi/bin/`. Request DTO fields are inferred from DLL metadata strings only.
- `new HttpClient()` per request (socket exhaustion risk); response HTTP status from OIC is not checked; `sendPostJson` builds `content` but posts via `PostAsJsonAsync` (unused variable).
- No authentication — must be network-isolated. ⚠️ unverified which Go service calls this proxy.
- `bin/`, `obj/`, `.vs/` build artifacts are present in the folder.
