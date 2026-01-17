<#
.SYNOPSIS
    Builds all microservices in the project.
    Can be run from anywhere.

.DESCRIPTION
    Iterates through each microservice and runs 'mvn clean package -DskipTests'.
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

Write-Host "🔨 Starting Full Project Build..." -ForegroundColor Cyan

foreach ($service in $services) {
    Write-Host "   building $service..." -ForegroundColor Yellow
    
    Push-Location $service
    try {
        $process = Start-Process -FilePath "cmd" -ArgumentList "/c mvn clean package -DskipTests" -PassThru -NoNewWindow -Wait
        
        if ($process.ExitCode -ne 0) {
            Write-Host "❌ Build failed for $service" -ForegroundColor Red
            Pop-Location
            exit 1
        }
    }
    finally {
        Pop-Location
    }
}

Write-Host "✅ All services built successfully!" -ForegroundColor Green
