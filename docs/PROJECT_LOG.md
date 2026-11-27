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

Miilestone 4:
- Email confirmation is off (RequireConfirmedAccount = false) because there is no email sender yet. Enable it with the Notifications module.
## Milestone 4 progress (Steps 1-5)

- SQL Server instance localhost\BCDEMO verified: Windows login has dbcreator and sysadmin. The portal gets its own database, LUC_StudentPortal, separate from Business Central's database.
- Packages: dotnet add package picked 11.0.0 (targets net11.0) and failed with NU1202 on net10.0. Fix: pinned Microsoft.EntityFrameworkCore.SqlServer, Microsoft.AspNetCore.Identity.EntityFrameworkCore and Microsoft.EntityFrameworkCore.Design to the latest stable 10.0.x, and installed dotnet-ef at 10.0.x to match. Lesson: pin versions to the target framework.
- Added Data/ApplicationUser.cs (IdentityUser plus CreatedAtUtc) and Data/ApplicationDbContext.cs (IdentityDbContext of ApplicationUser). Personal registration data stays out of the account and will live in submissions (Milestone 5).
- Connection string DefaultConnection in appsettings.json uses Trusted_Connection (no password in the file).
- Program.cs: registered the DbContext and Identity with ApplicationUser and IdentityRole. Password: minimum 10 characters with a digit, upper-case and lower-case letter. Unique email. Lockout after 5 failed attempts for 15 minutes. Cookie paths /Account/Login and /Account/AccessDenied. app.UseAuthentication() runs before app.UseAuthorization().
- First migration InitialIdentity (20261127091533) created in Data/Migrations and applied. The database has 8 tables: the 7 Identity tables plus __EFMigrationsHistory. AspNetUsers includes CreatedAtUtc.
- dotnet run needs --project "DOTNET\LUC.StudentPortal" when run from the repository root.
- The app starts at http://localhost:5221.

## Open issues (additions)

- Email confirmation is off (RequireConfirmedAccount = false) because there is no email sender yet. Enable it with the Notifications module.
- HTTPS redirect warning at startup: the launch profile has no HTTPS port. Handle when preparing deployment.

- On Step 5,  i have done the following:
- Added view models RegisterViewModel and LoginViewModel with data annotations. Password strength rules stay in the Identity options in Program.cs (one source of truth).
- Added AccountController (Register, Login, Logout, AccessDenied) using UserManager and SignInManager through dependency injection.
- Security decisions: forms carry anti-forgery tokens; Logout is POST only; returnUrl is followed only if it is a local URL (open redirect protection); one generic message for failed logins; lockout enabled (5 failed attempts, 15 minutes); logs record the user ID, not the email address.
- Views: Account/Register, Account/Login, Account/AccessDenied. Added Shared/_LoginPartial to the navbar in _Layout.
- Manual test checklist: weak password rejected with Identity messages; mismatched passwords rejected; valid registration creates an AspNetUsers row with a hashed password (the plain password is stored nowhere); wrong password shows the generic message; five wrong attempts lock the account. Edit this list if any check behaved differently.
## Milestone 4 progress (Step 6)

- Roles: Student and Admin (constants in Data/AppRoles.cs). A Registry role was dropped: registry staff work in Business Central, so the portal has no use for it yet.
- Data/IdentitySeeder.cs creates the roles and, if configured, the first administrator. It is idempotent and runs at startup from Program.cs inside a manual service scope.
- The administrator email and password come from user secrets (SeedAdmin:Email, SeedAdmin:Password), stored outside the repository. For production, create the first administrator through a controlled one-off process.
- New registrations are added to the Student role before sign-in, so the login cookie carries the role. Role changes take effect at the next login.
- AdminController is protected with [Authorize(Roles = AppRoles.Admin)]. The Admin menu link is shown only to admins, but the attribute is the real protection.
- Accounts created before Step 6 have no role (the Step 5 test account).
- Manual tests: anonymous user is sent to login with a returnUrl; no-role and Student accounts get Access Denied on /Admin; the admin account opens it and returns there after login. Edit this line if any check behaved differently.
