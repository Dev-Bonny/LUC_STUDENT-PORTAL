# Project Log

## Milestones

| # | Milestone | Status |
|---|---|---|
| 1 | Project structure and environment verification |  Complete |
| 2 | Requirements and system design |  Completed |
| 3 | Business Central development | Not started |
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
