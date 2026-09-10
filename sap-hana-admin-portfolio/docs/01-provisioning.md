# 01 - Instance Provisioning

**Date:** 2026-09-10
**Environment:** SAP BTP Trial, Global Account 068be917trial, Subaccount trial, AWS US East (VA)

## Objective
Provision a SAP HANA Cloud database instance for hands-on administration,
monitoring, and troubleshooting practice.

## Actions Taken
1. Opened SAP HANA Cloud Central via BTP Cockpit → Subscriptions → SAP HANA Cloud → Go to Application
2. Started Create Instance wizard, selected SAP HANA Database
3. Configured:
   - Instance Name: HANA-ADMIN-LAB
   - Runtime: Other Environments
   - Free Tier preset (16 GB memory, 80 GB storage, 1 vCPU)
   - Connections: Allow all IP addresses (learning configuration)
   - Cloud Connector: Disabled
   - Data Lake: Disabled (out of scope)
   - Version: 2026.14 (QRC 2/2026)

## Design Decisions
- **Free Tier:** trial environment constraints; sufficient for administration learning
- **Other Environments:** required for Multi-Environment subaccount
- **Allow all IP addresses:** enables connections from local SQL clients needed for later troubleshooting
- **Data Lake disabled:** focus is HANA Database administration and integration, not data lake analytics

## Outcome
Instance provisioned successfully. State: Running.