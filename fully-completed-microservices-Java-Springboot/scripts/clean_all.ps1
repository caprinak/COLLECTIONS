<#
.SYNOPSIS
    Cleans all microservices (removes target directories).
    Can be run from anywhere.
#>

$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

$services = @(
    "services/config-server",
    "services/discovery",
    "services/gateway",
    "services/customer",
    "services/product",
    "services/order",
    "services/payment",
    "services/notification"
)

Write-Host "🧹 Cleaning Project Artifacts..." -ForegroundColor Cyan

foreach ($service in $services) {
    Write-Host "   cleaning $service..." -ForegroundColor Gray
    
    if (Test-Path $service) {
        Push-Location $service
        try {
            Start-Process -FilePath "cmd" -ArgumentList "/c mvn clean" -NoNewWindow -Wait
        }
        finally {
            Pop-Location
        }
    }
    else {
        Write-Host "⚠️ Path not found: $service" -ForegroundColor Yellow
    }
}

Write-Host "✨ Project cleaned successfully!" -ForegroundColor Green
