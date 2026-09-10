# SAP HANA Administration & Monitoring Portfolio

Hands-on project demonstrating practical SAP HANA Cloud administration skills — provisioning, user management, security, monitoring, and troubleshooting.

## 🎯 Project Goal

Move beyond theory by building, breaking, troubleshooting, and documenting a real SAP HANA Cloud environment, focused on:

1. **SAP HANA Database Administration**
2. **SAP Integration Development**

## 🛠️ Environment

| Component | Value |
|---|---|
| Platform | SAP Business Technology Platform (BTP), Trial |
| Global Account | `068be917trial` |
| Subaccount | `trial` (Multi-Environment) |
| Cloud Provider | AWS |
| Region | US East (VA) |
| Database Service | SAP HANA Cloud (Free Tier) |
| Instance Name | `HANA-ADMIN-LAB` |
| Version | 2026.14.18 (QRC 2/2026) |

## 🔧 Tools Used

- **SAP HANA Cloud Central** — instance provisioning and management
- **SAP HANA Database Explorer** — SQL console and object browser
- **BTP Cockpit** — subscription, entitlement, and role management
- **SQL** — user administration, monitoring, and troubleshooting
- **Git / GitHub** — version control and documentation

## 📁 Project Structure
sap-hana-admin-portfolio/
├── README.md
├── .gitignore
├── configs/ # Instance configuration exports
│ └── hana-instance-config.json
├── docs/ # Markdown documentation
│ ├── 01-provisioning.md
│ └── 04-troubleshooting-incidents.md
├── sql-scripts/ # SQL used throughout the project
│ └── 01-create-users.sql
└── evidence/
└── screenshots/ # Visual proof of each milestone


## 📊 Progress Log

### ✅ Module 1: Provisioning & User Administration (Complete)

- Provisioned a HANA Cloud instance via HANA Cloud Central (`HANA-ADMIN-LAB`, Free Tier)
- Documented all provisioning decisions in `docs/01-provisioning.md`
- Solved "Not authorized" error by assigning correct BTP role collections
- Created HANA Cloud user group `ADMINS` following HANA Cloud's security model
- Created dedicated admin user `HANA_ADMIN` (separate from DBADMIN)
- Granted `OPERATOR` privilege on the user group
- Verified user by connecting via Database Explorer as HANA_ADMIN
- Diagnosed and resolved an authentication failure using `SYS.AUTHENTICATION_ERROR_DETAILS`
  (see Incident 001 in `docs/04-troubleshooting-incidents.md`)

### ⏳ Module 2: Least-Privilege Roles (In Progress)

- Custom role design for non-admin users
- Granular privilege assignment
- Verification of least-privilege enforcement

### 📅 Planned Modules

- **Module 3:** System Monitoring (M_ system views, alerts, performance)
- **Module 4:** Performance Investigation (expensive statements, plan analysis)
- **Module 5:** Simulated Troubleshooting Incidents (locking, resource exhaustion, connectivity)

## 🧠 Key Learnings

### HANA Cloud vs. On-Prem HANA Security Model

HANA Cloud replaces the on-prem `DBADMIN` **role** with a **user group** model. Admin users are created inside a user group and granted `OPERATOR` on the group. This was discovered during troubleshooting (`GRANT DBADMIN` fails in HANA Cloud).

### BTP Role Collections

Access to HANA Cloud Central requires specific BTP role collections (`SAP HANA Cloud Administrator`, `SAP HANA Cloud Security Administrator`) — being a Subaccount Administrator alone is not sufficient.

### Diagnostic Tooling

The `SYS.AUTHENTICATION_ERROR_DETAILS` view, keyed by correlation ID, gives the exact reason any authentication attempt failed. This is the first place to look when login fails.

## 👤 Author

**Teboho Leshoro**
Aspiring SAP HANA Technical Professional

- Learning focus: SAP HANA Database Administration, SAP Integration Development
- This portfolio is a record of hands-on learning, troubleshooting, and documentation

## 📄 License

This is a personal learning project. Documentation and scripts are shared for educational reference.
