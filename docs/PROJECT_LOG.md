# Project Log

## Milestones

| # | Milestone | Status |
|---|---|---|
| 1 | Project structure and environment verification | In progress |
| 2 | Requirements and system design | Not started |
| 3 | Business Central development | Not started |
| 4 | .NET foundation | Not started |
| 5 | Student registration interface | Not started |
| 6 | Business Central integration | Not started |
| 7 | Testing and refinement | Not started |
| 8 | Documentation and future expansion | Not started |

## Milestone 1 progress

- [x] Existing AL project confirmed in `AL/`
- [x] .NET SDK 10.0.404 verified
- [x] `docs/` and `DOTNET/` folders created
- [x] `.gitignore` created, Git repository initialised
- [ ] First commit
- [ ] AL project compiles and publishes to BC260
- [ ] .NET project created in `DOTNET/LUC.StudentPortal`

## Decisions

- One parent repository, with separate AL and .NET projects.
- The portal integrates with Business Central through its API only.
- Target framework: .NET 10.

## Open issues / assumptions to verify

- Authentication method for on-premises API calls (Windows auth in use locally).
- Actual API port and whether OData services are enabled.
- Leftover `Default Publisher_...app` build file in `AL/` (ignored by Git).
