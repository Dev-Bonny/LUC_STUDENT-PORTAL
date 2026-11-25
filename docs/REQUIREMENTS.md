# Requirements

## Scope decisions

- **Open sign-up.** Anyone can create a portal account and submit a registration.
  An optional admission reference is stored but not enforced (admissions is a future module).
- **Business Central assigns the student number** (number series), as part of creating the record.
- **Idempotency:** every submission has a portal-generated GUID, sent to BC and enforced as a
  unique key there. A retry returns the existing record instead of creating a second one.
- **Initial BC status is `Pending Verification`.** Registry staff move it to Active or Rejected.

## Actors

Student/applicant, registry staff, system administrator, Business Central, integration service.

## Workflow

1. Student creates a portal account.
2. Student logs in and submits the registration form.
3. Portal validates on the server and saves a submission (status: Submitted).
4. Integration service sends it to Business Central via the API.
5. BC creates the student record, assigns the student number, returns its identifier.
6. Portal stores the identifier, marks the submission Synced, shows the student their status.
7. Registry staff verify the record in BC.

## Functional requirements

| ID | Requirement |
|---|---|
| FR-01 | A visitor can create a portal account with an email address and password |
| FR-02 | A user can log in, log out, and change their password |
| FR-03 | A logged-in student can submit one registration with personal and academic details |
| FR-04 | The system validates all fields on the server and shows clear error messages |
| FR-05 | Each submission is saved with a unique submission ID and a status |
| FR-06 | The system sends submissions to Business Central through its API |
| FR-07 | The system stores the BC record identifier and student number returned |
| FR-08 | The system prevents duplicate student records, including on retry |
| FR-09 | The student can see their submission status and registration history |
| FR-10 | Failed submissions are logged and retried without creating duplicates |
| FR-11 | Registry staff can list, open, and update student records in Business Central |
| FR-12 | An administrator can see submissions that failed to sync |

## Non-functional requirements

| ID | Category | Requirement |
|---|---|---|
| NFR-01 | Security | Passwords are hashed, never stored as plain text |
| NFR-02 | Security | BC credentials and tokens never reach the browser or source control |
| NFR-03 | Security | Role-based access: students see only their own records |
| NFR-04 | Privacy | Collect only what registration needs (Kenya Data Protection Act, 2019) |
| NFR-05 | Reliability | A BC outage never loses a submission |
| NFR-06 | Maintainability | BC communication lives in a dedicated service, not in controllers |
| NFR-07 | Observability | Integration errors are logged with enough detail to diagnose them |
| NFR-08 | Configuration | Connection strings and secrets come from configuration providers |
| NFR-09 | Data integrity | Schema changes go through EF Core migrations |
| NFR-10 | Testability | Core logic is covered by automated tests |
