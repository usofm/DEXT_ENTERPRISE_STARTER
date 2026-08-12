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

Write-Host 'Smoke test completed.'
