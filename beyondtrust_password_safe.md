# BeyondTrust Password Safe Configuration
1. Sign into BeyondTrust Password Safe SaaS instance.
2. Navigate to **Configuration** > **General** > **Connectors**.
3. Create a new connector of SCIM type.  
    *Note: As of August 2025, only one of these adapter types can be created. Use caution if connecting sandbox and prod.*
4. Save the Client ID and Secret somewhere safe.

# SailPoint Configuration
1. Sign into your SailPoint SaaS instance.
2. Navigate to **Admin** > **Connections**.
3. Select **Create New**.
4. Choose the connector type: **BeyondTrust Password Safe - SaaS**.
5. Complete the required base configuration fields.
6. In the **Connector Settings** section, provide:
    1. **Host Url:** `https://<yourinstance>.ps.beyondtrustcloud.com/scim/v2/`
    2. **Auth Type:** OAUTH 2.0
    3. **Grant Type:** Client Credentials
    4. **OAUTH 2.0 Token Url:** `https://<yourinstance>.ps.beyondtrustcloud.com/scim/oauth/token`
    5. **Client ID:** `<from BeyondTrust Password Safe>`
    6. **Client Secret:** `<from BeyondTrust Password Safe>`
