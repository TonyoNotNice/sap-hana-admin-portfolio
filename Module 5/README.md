# Module 5 — Simulated Troubleshooting Incidents

Real-world failure scenarios reproduced in the lab, diagnosed with SAP HANA's own diagnostic views, and documented as portfolio-ready incident reports.

## Objectives

- Practice the troubleshooting method: reproduce → diagnose → fix → verify → document
- Use SAP HANA's native diagnostic views and procedures
- Document real incidents with before/after evidence
- Build a troubleshooting mindset, not just SQL skills

## The Four Incidents

| # | Incident | Skill Demonstrated | Status |
|---|---|---|---|
| 001 | Locked user after failed logins | Password policy + user state diagnosis | ✅ Fully reproduced |
| 002 | Missing privilege on table | GUID-based privilege diagnosis | ✅ Fully reproduced |
| 003 | Blocked user group | Group-level restriction diagnosis | Documented |
| 004 | Blocked transaction (lock contention) | Lock diagnostic views | Documented |

## Diagnostic Tools Used

| Tool | Purpose |
|---|---|
| M_PASSWORD_POLICY | Password policy thresholds |
| SYS.AUTHENTICATION_ERROR_DETAILS | Why logins failed |
| SYS.GET_INSUFFICIENT_PRIVILEGE_ERROR_DETAILS | Which privilege is missing |
| USERGROUP_CONNECT_RESTRICTIONS | Group-level connect controls |
| M_BLOCKED_TRANSACTIONS | Lock contention — who blocks whom |
| M_ACTIVE_STATEMENTS | What each session is running |

## The Troubleshooting Method

Applied to every incident:

1. **Reproduce** — make the failure happen reliably
2. **Capture identifiers** — correlation IDs, GUIDs, error codes
3. **Query diagnostic views** — the database records everything
4. **Read the REASON** — not what you assume, what the database says
5. **Fix** — apply the specific resolution
6. **Verify** — confirm the user works again
7. **Document** — write the incident report

## Key Learnings

### Every error has a diagnostic trail
- Authentication failures → `AUTHENTICATION_ERROR_DETAILS`
- Privilege errors → GUID + `GET_INSUFFICIENT_PRIVILEGE_ERROR_DETAILS`
- Lock contention → `M_BLOCKED_TRANSACTIONS`

### Correct fixes vs. workarounds
- `ALTER USER ... RESET CONNECT ATTEMPTS` — proper unlock (not password reset)
- `GRANT SELECT ON SCHEMA` — proper privilege fix (not user recreation)
- `ALTER USERGROUP ... ENABLE CLIENT CONNECT` — proper unblock
- `ALTER SYSTEM CANCEL WORK IN SESSION` — last resort, not first choice

### Verify from the user's perspective
The admin being able to query doesn't prove the user can. Always test with the affected user's credentials.

## Files in This Module

    Module 5/
    ├── README.md
    ├── docs/
    │   └── 08-troubleshooting-incidents.md
    ├── evidence/
    │   └── screenshots/
    └── sql-scripts/
        └── 08-incident-scenarios.sql

## Module Status

Complete — 2026-09-17

## See Also

- Module 1 — Provisioning & User Administration
- Module 2 — Least-Privilege Roles & Real-Time Data
- Module 3 — System Monitoring
- Module 4 — Performance Investigation
- Project Root — Full project README