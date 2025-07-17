param(
    [Parameter(Mandatory = $true)]
    [string]$consumerKey,
    [Parameter(Mandatory = $true)]
    [string]$consumerSecret,
    [Parameter(Mandatory = $true)]
    [string]$urlRoot
)

$oauthTokenUrl = "$urlRoot/services/oauth2/token"

# First step, get the code. The code is used to generate a later token. This will open a browser window for the user to log in and authorize the app. 
Write-Host "Opening the URL. You will need to log in and authorize the app if this hasn't been done. "
Write-Host "This has been tested with the OAuth scopes Manage user data via (api) and Perform requests at any time (refresh_token, offline_access)."
Write-Host "These permissions are required to access the Salesforce API."

$url = "$urlRoot/services/oauth2/authorize?response_type=code&client_id=$consumerKey&redirect_uri=$urlRoot&prompt=consent"
# Note - the URL here used to have a specific schema listed, removing that allows for everything in scope to be included in the approval 
Write-Host "Opening URL: $url"
Start-Process $url

# Now wait for the user to log in and authorize the app, then copy the URL from the browser
Write-Host "Please log in to Salesforce and authorize the app. Once done and back to the login page, paste the entire URL from the browser here: "
$redirectUrl = Read-Host "Paste the URL here"

# Now extract the code from the URL
if ($redirectUrl -match 'code=([^&]+)') {
    $code = $matches[1]
    # And URL decode the code since it may contain special characters
    $code = [System.Web.HttpUtility]::UrlDecode($code) 
    Write-Host "Code extracted: $code"
}
else {
    Write-Host "No code found in the URL. Please try again."
    exit
}

# Now that we have the code, we can get the access token
$body = @{
    grant_type    = "authorization_code"
    client_id     = $consumerKey
    client_secret = $consumerSecret
    redirect_uri  = $urlRoot
    code          = $code
}


try {
    $response = Invoke-RestMethod -Method Post -Uri $oauthTokenUrl -Body $body -ContentType "application/x-www-form-urlencoded"
}
catch {
    Write-Host "Failed to retrieve the access token from Salesforce."
    Write-Host "Error details: $($_.Exception.Message)"
    Write-Host "This may be due to incorrect credentials, an invalid authorization code, or network issues."
    Write-Host "Please verify your consumer key, consumer secret, and that the authorization code has not expired or been used already."
    exit 1
}

if (-not $response.refresh_token) {
    Write-Host "ERROR: The response did not contain a refresh_token. Please check that the API permissions include 'Perform requests at any time (refresh_token, offline_access)' and that the connected app is configured to allow refresh tokens."
    exit 1
}

Write-Host ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
Write-Host "These are the values that need to be added into IdentityNow to connect to Salesforce using this script output."
Write-Host "OAuth 2.0 Token URL: $oauthTokenUrl"
Write-Host "Grant Type: Refresh Token"
Write-Host "Client ID: $consumerKey"
Write-Host "Client Secret: $consumerSecret"
Write-Host "Refresh Token: $($response.refresh_token)"
Write-Host ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
