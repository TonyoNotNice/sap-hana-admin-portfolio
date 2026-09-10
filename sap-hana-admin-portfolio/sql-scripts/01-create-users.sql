-- 01-create-users.sql
-- SAP HANA Cloud: User Group and Admin User Setup
-- Purpose: Create a dedicated admin user (HANA_ADMIN) in a user group,
--          following HANA Cloud's user group model instead of on-prem role-based model.
-- Author: Teboho Leshoro
-- Date: 2026-09-10

-- 1. Create the user group that will contain admin users
CREATE USERGROUP ADMINS;

-- 2. Create the user inside the group with fixed password (lab scenario)
CREATE USER HANA_ADMIN
    PASSWORD "Welcome1Hana!"
    NO FORCE_FIRST_PASSWORD_CHANGE
    SET USERGROUP ADMINS;

-- 3. Grant OPERATOR privilege on the group — makes user a group administrator
GRANT OPERATOR ON USERGROUP ADMINS TO HANA_ADMIN;

-- 4. Verify user and group membership
SELECT USER_NAME, USERGROUP_NAME, USER_DEACTIVATED
FROM USERS
WHERE USER_NAME = 'HANA_ADMIN';

-- 5. Verify the OPERATOR privilege
SELECT USER_NAME, PRINCIPAL_NAME, PRINCIPAL_TYPE, PRIVILEGE
FROM EFFECTIVE_PRIVILEGES
WHERE USER_NAME = 'HANA_ADMIN'
AND PRIVILEGE = 'OPERATOR';