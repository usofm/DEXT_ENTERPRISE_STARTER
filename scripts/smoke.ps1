param(
  [string]$BaseUrl = 'http://localhost:8080',
  [string]$Username = $env:DEXT_DEV_ADMIN_USERNAME,
  [string]$Password = $env:DEXT_DEV_ADMIN_PASSWORD
)

$ErrorActionPreference = 'Stop'

Write-Host 'Checking health...'
Invoke-RestMethod "$BaseUrl/health" | Out-Host

Write-Host 'Logging in...'
$login = Invoke-RestMethod -Method Post -Uri "$BaseUrl/api/auth/login" -ContentType 'application/json' -Body (@{
  username = $Username
  password = $Password
} | ConvertTo-Json)

if (-not $login.accessToken) { throw 'Login did not return accessToken' }
$headers = @{ Authorization = "Bearer $($login.accessToken)" }

Write-Host 'Checking authenticated identity...'
Invoke-RestMethod -Uri "$BaseUrl/api/auth/me" -Headers $headers | Out-Host

Write-Host 'Listing accounts...'
Invoke-RestMethod -Uri "$BaseUrl/api/accounts" -Headers $headers | Out-Host

$code = 'SMOKE-' + [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()

Write-Host "Creating account $code..."
$created = Invoke-RestMethod -Method Post -Uri "$BaseUrl/api/accounts" -Headers $headers -ContentType 'application/json' -Body (@{
  code = $code
  name = 'Smoke Test Account'
  openingBalance = 123.4567890123
} | ConvertTo-Json)

if (-not $created.id) { throw 'Create account did not return an id' }
$id = $created.id

Write-Host "Reading account $id..."
Invoke-RestMethod -Uri "$BaseUrl/api/accounts/$id" -Headers $headers | Out-Host

Write-Host "Updating account $id..."
$updated = Invoke-RestMethod -Method Put -Uri "$BaseUrl/api/accounts/$id" -Headers $headers -ContentType 'application/json' -Body (@{
  name = 'Smoke Test Account Updated'
  balance = 987.6543210987
} | ConvertTo-Json)
$updated | Out-Host

Write-Host "Deleting account $id..."
Invoke-RestMethod -Method Delete -Uri "$BaseUrl/api/accounts/$id" -Headers $headers | Out-Host

Write-Host 'Smoke test completed.'
