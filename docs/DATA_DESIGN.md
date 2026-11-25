# Data Design

## Ownership principle

- **Business Central owns the student**: identity, programme, status. Staff edit it there.
- **The portal owns the process**: accounts, passwords, what was submitted and when, sync state.
- The portal keeps a copy of each submission as a record of the *event*. It is never edited to match BC.
- Never ask the user for something the system already knows (department, faculty, year of study,
  academic year, admission date, status).

## Fields

| Field | Required | Lives in | Notes |
|---|---|---|---|
| Student Number | generated | BC | Number series; portal stores a display copy |
| First / Last Name | Yes | BC + submission copy | Letters, spaces, hyphens, apostrophes; max 50 |
| Middle Name | No | BC + copy | |
| Date of Birth | Yes | BC + copy | Past date, plausible age range (about 15 to 80) |
| Gender | No | BC + copy | Optional; only if LUC needs it (possible sensitive data under the DPA 2019) |
| Nationality | Yes | BC + copy | Lookup (countries), default Kenya |
| National ID / Passport No. | Yes | BC + copy | Unique in BC. Kenyan ID: 7-8 digits. Highest-risk field |
| Email | Yes | Identity, BC, copy | Taken from the portal account |
| Phone | Yes | BC + copy | Normalised to +254 format |
| Postal Address | No | BC + copy | Free text |
| Academic Programme | Yes | BC + copy | Lookup from BC (LUC Programme table) |
| Department, Faculty | derived | BC | From the programme, never typed by the student |
| Admission Intake | Yes | BC + copy | Enum: January, May, September |
| Admission Academic Year | derived | Portal sets | e.g. 2026/2027 |
| Study Mode | Yes | BC + copy | Enum: Full-time, Part-time, Evening, Distance |
| Year of Study | derived | BC | Always 1 for new registrations |
| Admission Date | derived | BC | Set by staff on verification |
| Student Status | derived | BC | Pending Verification, Active, Rejected |
| Admission Reference | No | BC + copy | Stored, not enforced |
| Submission ID (GUID) | generated | Portal, sent to BC | Idempotency key, unique in BC |
| Sync status, attempts, last error | generated | Portal only | Operational data |

## Privacy and access

- National ID / passport: registry roles only in BC, masked in lists, never logged, never in URLs.
- Do not collect ethnicity, religion, health, or next-of-kin at this stage.

## Portal database (SQL Server, EF Core)

| Table | Purpose |
|---|---|
| Identity tables (AspNetUsers, AspNetRoles, ...) | Accounts, hashed passwords, roles. Managed by ASP.NET Core Identity |
| RegistrationSubmissions | One row per submission: Id (GUID, PK), UserId, submitted fields, Status, BcSystemId, StudentNumber, AttemptCount, NextRetryAtUtc, LastError, CreatedAtUtc, UpdatedAtUtc |
| IntegrationAttempts | One row per call to BC: SubmissionId, AttemptedAtUtc, Outcome, HttpStatus, ErrorSummary, DurationMs |

- Rule: one *active* (non-rejected) submission per user, enforced by a filtered unique index on UserId.
- Programme, intake, and study-mode lists are not stored in the portal DB. Programmes are read from BC.

## Submission statuses

Submitted -> Syncing -> Synced
Syncing -> RetryPending (temporary failure) -> Syncing
Syncing -> Failed (permanent failure or retries exhausted, needs attention)
