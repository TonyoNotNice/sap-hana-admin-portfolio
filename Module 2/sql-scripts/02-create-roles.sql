-- 02-create-roles.sql
-- SAP HANA Cloud: Custom role and least-privilege user
-- Author: Teboho Leshoro
-- Date: 2026-09-11

-- 1. Create the custom role
CREATE ROLE TENDER_ANALYST;

-- 2. Grant read-only access to the role
GRANT SELECT ON SCHEMA TENDER_MONITOR TO TENDER_ANALYST;

-- 3. Create the non-admin user
CREATE USER TENDER_VIEWER
    PASSWORD "Welcome1Viewer!"
    NO FORCE_FIRST_PASSWORD_CHANGE
    SET USERGROUP DEFAULT;

-- 4. Grant the role to the user
GRANT TENDER_ANALYST TO TENDER_VIEWER;

-- 5. Verify the role assignment
SELECT GRANTEE, ROLE_NAME, GRANTEE_TYPE
FROM GRANTED_ROLES
WHERE GRANTEE = 'TENDER_VIEWER';

-- 6. Verify the effective privileges on TENDER_MONITOR
SELECT USER_NAME, PRIVILEGE, OBJECT_NAME, PRINCIPAL_TYPE
FROM EFFECTIVE_PRIVILEGES
WHERE USER_NAME = 'TENDER_VIEWER'
AND OBJECT_NAME = 'TENDER_MONITOR';

-- 7. Least-privilege enforcement tests (run as TENDER_VIEWER):
--    SELECT * FROM TENDER_MONITOR.SECTOR_TRENDS;   -- succeeds
--    SELECT * FROM TENDER_MONITOR.RECENT_AWARDS;   -- succeeds
--    INSERT INTO TENDER_MONITOR.SECTOR_TRENDS ...; -- blocked
--    DELETE FROM TENDER_MONITOR.SECTOR_TRENDS ...; -- blocked
--    DROP TABLE TENDER_MONITOR.SECTOR_TRENDS;      -- blocked