# LUC Student Registration System

A web-based student registration system for the fictional Lakeside University College (LUC),
integrated with Microsoft Dynamics 365 Business Central.

## Repository layout

| Folder | Purpose |
|---|---|
| `AL/` | Business Central extension (AL): tables, pages, API page, codeunit |
| `DOTNET/LUC.StudentPortal/` | ASP.NET Core MVC student portal |
| `docs/` | Architecture, decisions, and the project log |

The AL and .NET projects are separate applications. The portal talks to Business Central
only through its API, never through the Business Central SQL database.

## Development environment

- Business Central 26.0 (on-premises), server instance `BC260`
- Web client: http://localhost:8080/BC260
- .NET SDK 10.0.404
- AL object ID range: 50100-50149

## Status

See `docs/PROJECT_LOG.md` for milestones, decisions, and open issues.
