# Salesforce Source Setup in SailPoint

This document provides a summary for configuring a Salesforce source in SailPoint using a refresh token for authentication.

# Navagating the Salesforce Lightning UI
Setup -> App -> External Client Apps -> External Client App Manager
Create an external client app, for example "Sailpoint Instance" 

## Policies -> App Authorization
- Expire fresh token if not used for specific time 
- Token Validity period at least 30 days 

### OAuth Settings
- **Enable OAuth Settings**: Check the box to enable OAuth settings for the app.
- **Callback URL**: Enter the redirect URI that SailPoint will use (e.g., `https://test.salesforce.com` or `https://login.salesforce.com`).
- **Selected OAuth Scopes**: Add the following scopes as required:
    - `Perform requests on your behalf at any time (refresh_token, offline_access)`
    - `Access and manage your data (api)`
    - `Full access (full)` should be unneeded
- **Save** the configuration and note the **Consumer Key** and **Consumer Secret** for use in script below.

# Creating the Refresh Token via Script
The refresh token used is created using the code returned by the OAuth interface when `response_type=code`. 
This is something like the following. 

```
https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=YOUR_CONSUMER_KEY&redirect_uri=https://login.salesforce.com&prompt=consent
```

Once the sign in and authorization is completed in the browser, a command needs to be run to transform the code returned into a refresh token. 
The official documentation covers doing this in Postman, however I have wrapped this into a short script that outputs exactly what needs to be added to SailPoint, and takes care of any URL encoding issues.

```
.\salesforce.ps1 -consumerKey xxxx -consumerSecret yyyyy -urlRoot "https://test.salesforce.com"
```

This will build the exact URL that needs to be opened, open it in the default browser, then wait for the URL (with the embedded code) to be pasted in to complete processsing. 

On completion, the second request modeled after the Postman call will be made to retrieve the refresh token. 

This will output something like the following: 
```
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
These are the values that need to be added into IdentityNow to connect to Salesforce using this script output.
OAuth 2.0 Token URL: $oauthTokenUrl
Grant Type: Refresh Token
Client ID: $consumerKey
Client Secret: $consumerSecret
Refresh Token: $($response.refresh_token)
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
```

# Navigating the SailPoint UI
Admin -> Connections -> Sources -> Create New -> Connection Settings 

# Settings to Enter
Connection Timeout - Default of 1 is fine 
Connection Type - Oauth 2.0 

OAuth 2.0 Token Url - from script output
Grant Type - from script output
Client ID - from script output 
Client Secret - from script output 
Refresh Token - from script output


