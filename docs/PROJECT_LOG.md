# Project Log

## Milestones

| # | Milestone | Status |
|---|---|---|
| 1 | Project structure and environment verification |  Complete |
| 2 | Requirements and system design |  Completed |
| 3 | Business Central development | Completed |
| 4 | .NET foundation | Not started |
| 5 | Student registration interface | Not started |
| 6 | Business Central integration | Not started |
| 7 | Testing and refinement | Not started |
| 8 | Documentation and future expansion | Not started |

## Milestone 1 Complete

- [x] Existing AL project confirmed in `AL/`
- [x] .NET SDK 10.0.404 verified
- [x] `docs/` and `DOTNET/` folders created
- [x] `.gitignore` created, Git repository initialised
- [ x ] First commit
- [ x ] AL project compiles and publishes to BC260
- [ x ] .NET project created in `DOTNET/LUC.StudentPortal`

## Decisions

- One parent repository, with separate AL and .NET projects.
- The portal integrates with Business Central through its API only.
- Target framework: .NET 10.

## Open issues / assumptions to verify

- Authentication method for on-premises API calls (Windows auth in use locally).
- Actual API port and whether OData services are enabled.
- Leftover `Default Publisher_...app` build file in `AL/` (ignored by Git).

## Milestone 2 decisions

- Open sign-up; optional admission reference stored, not enforced.
- BC assigns the student number (number series). New BC records start as Pending Verification.
- Idempotency: portal-generated Submission ID (GUID), checked before create, unique key in BC.
- BC owns the programme list (LUC Programme table + read-only API); intake and study mode are enums.
- Single .NET project with folder boundaries (Controllers / Services / Integration / Data).
- Save the submission first, then call BC; background worker retries with backoff.
- BC API: publisher luc, group registration, version v1.0, entity set students.
- Authentication method for BC calls to be decided in Milestone 6 after testing the real server.

## Open issues

- Confirm the BC API port and whether OData services are enabled (Milestone 3).
- Choose the BC authentication method (Milestone 6).
- Confirm Data Protection Act treatment of the Gender field if the project goes beyond learning.
- Country/Region list in the Lakeside company is not empty: Kenya exists with code KEN (three-letter ISO codes). Use three-letter codes for any countries added later. Add more countries before Milestone 5.

## Milestone 3 design refinements

- Correction to Milestone 2: duplicate prevention in BC is enforced in AL code (OnValidate/OnInsert),
  not with unique keys, because unique keys cannot ignore empty values (staff-created students have
  no portal Submission ID and card pages insert before fields are filled).
- Added enums 50112 "LUC Gender" and 50113 "LUC ID Document Type"; ID document type + number identify a person.
- Date of birth range in BC is 16 to 80 years.
- Working company for the project: "Lakeside University College" (id 511c5f36-00e7-f111-8af0-e86a64f8f1c5). CRONUS is untouched.
## Milestone 3 progress (Step 4)

- Added table 50105 "LUC Programme", page 50114 "LUC Programme List" (new ID: the plan lacked a maintenance page).
- Added table 50110 "LUC Student Setup" (singleton) and page 50111 "LUC Student Setup" holding the number series.
- Number series LUCSTUD (LUC-000001 to LUC-999999) configured in the Lakeside company.
- "Open for Registration" defaults to false: new programmes are hidden from the portal until staff open them.
- Department and Faculty are plain text on LUC Programme for now (proper tables belong to the academic-programmes module).

## Milestone 3 progress (Step 5)

- LUC Student table completed: academic fields (20-29), status and system fields (30-32).
- Department, Faculty and Programme Name are FlowFields from LUC Programme (derived, never typed).
- BC system fields used instead of custom ones: SystemId (the API "id", the portal's BC reference), SystemCreatedAt, SystemModifiedAt.
- Student number assigned in OnInsert from the LUCSTUD series.
- Setting Status to Active requires the essential fields and stamps Admission Date if empty.
- Active students cannot be deleted.
- Programme "open for registration" is enforced by the portal dropdown. BC does not block staff from assigning a closed programme.

## Milestone 3: object ID clash with libManagement

- Publishing failed: pages 50101 and 50102 were also defined by the libManagement extension (D:\LIBRARY_MANAGEMENT\library\libManagement), which declares the same ID range 50100-50149.
- Fix: renumbered LUC Student List to 50115 and LUC Student Card to 50116. Tables were untouched (they hold data). Range in app.json unchanged.
- The two projects still share a range. Before adding any new object, run the ID clash check (compare object type + ID across both projects).
- Object plan update: pages 50101/50102 belong to libManagement. LUC pages: 50111, 50114, 50115, 50116.


Milestone 3 progress (Step 7)

- Added API pages 50103 "LUC Student API" and 50106 "LUC Programme API" (publisher luc, group registration, version v1.0). Both served on port 7048.
- Student API: create and read only (no modify, no delete). studentNumber, status, admissionDate, yearOfStudy and derived fields are read-only.
- Idempotency check for the portal: GET students?$filter=portalSubmissionId eq <guid>.
- Programme API is fully read-only. Portal dropdown query: programmes?$filter=openForRegistration eq true.
- Verified from PowerShell: programme list, create, lookup by submission ID, duplicate submission rejected, duplicate identity rejected, invalid academic year rejected, status cannot be forced to Active.
- Codeunit 50104 not needed yet (logic lives in table triggers). ID stays reserved.


- BC license date filter only allows months 11, 12, 01, 02. Test dates (birth dates, admission dates) must fall in those months. After February, Today() will be rejected too, so activation (which stamps the admission date) will fail until the license or environment is changed.