-- 08-incident-scenarios.sql
-- SAP HANA Cloud: Troubleshooting incident scenarios
-- Author: Teboho Leshoro
-- Date: 2026-09-17

-- =========================================================
-- INCIDENT 001: LOCKED USER
-- =========================================================

-- Confirm password policy
SELECT * FROM M_PASSWORD_POLICY
WHERE PROPERTY LIKE '%invalid%' OR PROPERTY LIKE '%lock%';

-- Create test user
CREATE USER TEST_LOCKED
    PASSWORD "Welcome1Test!"
    NO FORCE_FIRST_PASSWORD_CHANGE
    SET USERGROUP DEFAULT;

-- (Make 6+ failed login attempts via Database Explorer)

-- Diagnose: check user state
SELECT USER_NAME, USER_DEACTIVATED, INVALID_CONNECT_ATTEMPTS,
       LAST_INVALID_CONNECT_ATTEMPT
FROM USERS WHERE USER_NAME = 'TEST_LOCKED';

-- Diagnose: authentication error log
SELECT CORRELATION_ID, USER_NAME, REASON, TIMESTAMP
FROM SYS.AUTHENTICATION_ERROR_DETAILS
WHERE USER_NAME = 'TEST_LOCKED'
ORDER BY TIMESTAMP DESC LIMIT 10;

-- Fix
ALTER USER TEST_LOCKED RESET CONNECT ATTEMPTS;

-- Verify
SELECT USER_NAME, INVALID_CONNECT_ATTEMPTS
FROM USERS WHERE USER_NAME = 'TEST_LOCKED';

-- =========================================================
-- INCIDENT 002: MISSING PRIVILEGE
-- =========================================================

-- Create user without privileges
CREATE USER TEST_NO_ACCESS
    PASSWORD "Fresh1Access!Xy9"
    NO FORCE_FIRST_PASSWORD_CHANGE
    SET USERGROUP DEFAULT;

-- (Connect as TEST_NO_ACCESS, run SELECT on TENDER_MONITOR.SECTOR_TRENDS)
-- Error returns a GUID — use it in the procedure below

-- Diagnose (replace GUID with actual value from error)
CALL SYS.GET_INSUFFICIENT_PRIVILEGE_ERROR_DETAILS('paste-guid-here', ?);

-- Fix
GRANT SELECT ON SCHEMA TENDER_MONITOR TO TEST_NO_ACCESS;

-- Verify (from TEST_NO_ACCESS session)
-- SELECT COUNT(*) FROM TENDER_MONITOR.SECTOR_TRENDS;  -- expect 10

-- =========================================================
-- INCIDENT 003: BLOCKED USER GROUP
-- =========================================================

-- Create group and user
CREATE USERGROUP TEST_BLOCKED_GROUP;

CREATE USER TEST_GROUP_USER
    PASSWORD "Group9User!Xy"
    NO FORCE_FIRST_PASSWORD_CHANGE
    SET USERGROUP TEST_BLOCKED_GROUP;

-- Block the group
ALTER USERGROUP TEST_BLOCKED_GROUP DISABLE CLIENT CONNECT;

-- Diagnose
SELECT * FROM USERGROUP_CONNECT_RESTRICTIONS
WHERE USERGROUP_NAME = 'TEST_BLOCKED_GROUP';

SELECT CORRELATION_ID, USER_NAME, REASON, TIMESTAMP
FROM SYS.AUTHENTICATION_ERROR_DETAILS
WHERE USER_NAME = 'TEST_GROUP_USER'
ORDER BY TIMESTAMP DESC LIMIT 5;

-- Fix
ALTER USERGROUP TEST_BLOCKED_GROUP ENABLE CLIENT CONNECT;

-- =========================================================
-- INCIDENT 004: BLOCKED TRANSACTION (lock contention)
-- =========================================================

-- NOTE: Requires auto-commit OFF in both sessions.
-- Database Explorer defaults to auto-commit ON which prevents reproduction.

-- Session A: hold exclusive lock (do not commit)
UPDATE TENDER_MONITOR.SECTOR_TRENDS
SET TENDER_COUNT = TENDER_COUNT
WHERE SECTOR = 'construction';

-- Diagnose from Session C
SELECT BLOCKED_CONNECTION_ID, LOCK_OWNER_CONNECTION_ID,
       LOCK_TYPE, LOCK_MODE, WAITING_SCHEMA_NAME,
       WAITING_OBJECT_NAME, BLOCKED_TIME
FROM M_BLOCKED_TRANSACTIONS;

SELECT CONNECTION_ID, STATEMENT_STRING, COMPILED_TIME
FROM M_ACTIVE_STATEMENTS
WHERE CONNECTION_ID IN (
    SELECT BLOCKED_CONNECTION_ID FROM M_BLOCKED_TRANSACTIONS
    UNION
    SELECT LOCK_OWNER_CONNECTION_ID FROM M_BLOCKED_TRANSACTIONS
);

-- Fix (Session A)
COMMIT;

-- Production last resort
-- ALTER SYSTEM CANCEL WORK IN SESSION '<connection_id>';

-- =========================================================
-- CLEANUP (optional)
-- =========================================================
-- DROP USER TEST_LOCKED CASCADE;
-- DROP USER TEST_NO_ACCESS CASCADE;
-- DROP USER TEST_GROUP_USER CASCADE;
-- DROP USERGROUP TEST_BLOCKED_GROUP;