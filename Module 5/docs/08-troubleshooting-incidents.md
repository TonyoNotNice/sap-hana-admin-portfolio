# 08 - Troubleshooting Incidents

Real-world failure scenarios reproduced in the lab, diagnosed with SAP HANA's
own diagnostic views, and resolved with documented fixes.

---

## Incident 001: Locked User After Failed Login Attempts

**Date:** 2026-09-17
**Severity:** Medium
**Status:** Reproduced, diagnosed, fixed, verified

### Symptom
User TEST_LOCKED unable to log in. Errors progressed from "authentication
failed" to "lock time for user TEST_LOCKED is 1440 minutes".

### Reproduction
- Made 7 failed login attempts with the wrong password
- Threshold confirmed: `maximum_invalid_connect_attempts = 6`
- Lock window confirmed: `password_lock_time = 1440` minutes (24 hours)

### Investigation

**Step 1 — Confirmed the password policy:**
```sql
SELECT * FROM M_PASSWORD_POLICY
WHERE PROPERTY LIKE '%invalid%' OR PROPERTY LIKE '%lock%';