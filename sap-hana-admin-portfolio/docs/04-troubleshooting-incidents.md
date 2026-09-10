# Troubleshooting Incidents

## Incident 001: Authentication Failed for New Admin User

**Date:** 2026-09-10
**Severity:** Medium — blocked user onboarding workflow

### Symptom
Attempted to add a new database connection in SAP HANA Database Explorer using the
newly created admin user. Connection rejected with:
- Error code: DATABASE_CONNECTION_ERROR
- Message: "authentication failed"
- Correlation ID: 74F2490F30EAFB4E98BB3075054DD42A

### Investigation
Queried the HANA authentication error log using the correlation ID:

    SELECT * FROM SYS.AUTHENTICATION_ERROR_DETAILS
    WHERE CORRELATION_ID = '74F2490F30EAFB4E98BB3075054DD42A';

### Root Cause
The diagnostic log showed:
- USER_NAME: HANA-ADMIN-LAB
- REASON: "User HANA-ADMIN-LAB does not exist"

The connection attempt used the DATABASE instance name (HANA-ADMIN-LAB, with hyphens)
as the username, instead of the actual HANA USER name (HANA_ADMIN, with underscore).

### Resolution
Corrected the User field to HANA_ADMIN (underscore) and retried the connection.
Authentication succeeded.

### Lessons Learned
1. HANA distinguishes between instance names and user names.
2. The SYS.AUTHENTICATION_ERROR_DETAILS system view, keyed by correlation ID,
   is a powerful diagnostic tool for authentication failures.
3. Always read the REASON column carefully — it points directly at the fix.

### Evidence
- Diagnostic query result: evidence/authentication-error-details.csv