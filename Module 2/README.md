# SAP HANA Administration & Monitoring Portfolio

Hands-on project demonstrating practical SAP HANA Cloud administration skills — provisioning, user management, security, monitoring, and troubleshooting.

## 🏁 The 5-Day SAP HANA Challenge

A self-imposed 5-day challenge running alongside the Launch Lab programme at Umuzi.

**Rules:**
- 5 weekdays, 4–5 focused hours per day
- 1 complete module per day
- Every module produces SQL scripts + documentation + evidence
- Daily LinkedIn post — including failures
- Full portfolio published on GitHub

**Cycle applied to every module:** Learn → Build → Break → Troubleshoot → Document → Present

**Focus areas (deliberately narrow):**
- SAP HANA Database Administration
- SAP Integration Development

**Modules:**

| Day | Module | Status |
|---|---|---|
| 1 | Provisioning & User Administration | ✅ Complete |
| 2 | Least-Privilege Roles & Custom Privileges | ✅ Complete |
| 3 | System Monitoring | 📅 Planned |
| 4 | Performance Investigation | 📅 Planned |
| 5 | Simulated Troubleshooting Incidents | 📅 Planned |

## 🛠️ Environment

| Component | Value |
|---|---|
| Platform | SAP Business Technology Platform (BTP), Trial |
| Global Account | 068be917trial |
| Subaccount | trial (Multi-Environment) |
| Cloud Provider | AWS |
| Region | US East (VA) |
| Database | SAP HANA Cloud (Free Tier) |
| Instance Name | HANA-ADMIN-LAB |
| Version | 2026.14.18 (QRC 2/2026) |

## 🔧 Tools Used

- SAP HANA Cloud Central — provisioning and management
- SAP HANA Database Explorer — SQL console and object browser
- BTP Cockpit — subscription, entitlement, role management
- Python (hdbcli, requests) — API integration
- SQL — administration, monitoring, security

## 📁 Project Structure

Each module is self-contained:

    sap-hana-admin-portfolio/
    ├── Module 1/    Provisioning and user administration
    ├── Module 2/    Least-privilege roles and real-time data ingestion
    ├── Module 3/    System monitoring (planned)
    ├── Module 4/    Performance investigation (planned)
    └── Module 5/    Simulated troubleshooting incidents (planned)

Each module contains:
- `docs/` — Markdown documentation
- `evidence/screenshots/` — visual proof of milestones
- `sql-scripts/` — SQL and Python scripts used

## 📊 Module Summaries

### Module 1 — Provisioning & User Administration
- Provisioned SAP HANA Cloud instance via HANA Cloud Central
- Solved BTP role collection authorization for HANA Cloud Central access
- Created dedicated admin user (HANA_ADMIN) using HANA Cloud's user group model
- Diagnosed authentication failure using SYS.AUTHENTICATION_ERROR_DETAILS

### Module 2 — Least-Privilege Roles & Custom Privileges
- Built a real-time data pipeline: Tenders-SA public API → Python → HANA Cloud
- Loaded 110 rows of live SA government tender data
- Created custom role TENDER_ANALYST (SELECT-only on TENDER_MONITOR schema)
- Created least-privilege user TENDER_VIEWER
- Verified enforcement: user can SELECT but cannot INSERT, UPDATE, DELETE, or DROP

## 👤 Author

**Teboho Leshoro**
Aspiring SAP HANA Technical Professional

- Focus: SAP HANA Database Administration, SAP Integration Development
- Building hands-on experience through self-designed projects