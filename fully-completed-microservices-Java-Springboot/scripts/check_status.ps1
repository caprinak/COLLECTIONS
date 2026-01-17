<#
.SYNOPSIS
    Checks the health status of all microservices by hitting their Actuator endpoints.
    Can be run from anywhere.
#>

$ProjectRoot = Split-Path -Parent $PSScriptRoot

$services = @{
    "Config Server" = "8888"
    "Discovery"     = "8761"
    "Gateway"       = "8222"
    "Customer"      = "8090"
    "Product"       = "8050"
    "Order"         = "8070"
    "Payment"       = "8060"
    "Notification"  = "8040"
}

Write-Host "🔍 Checking Microservices Health Status..." -ForegroundColor Cyan
Write-Host "------------------------------------------------"

foreach ($name in $services.Keys | Sort-Object) {
    $port = $services[$name]
    $url = "http://localhost:$port/actuator/health"
    
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 2 -ErrorAction Stop
        $status = $response.status
        
        if ($status -eq "UP") {
            Write-Host "[UP]   " -ForegroundColor Green -NoNewline
        }
        else {
            Write-Host "[$status] " -ForegroundColor Yellow -NoNewline
        }
        Write-Host "$name`t(Port $port)"
    }
    catch {
        Write-Host "[DOWN] " -ForegroundColor Red -NoNewline
        Write-Host "$name`t(Port $port) - Unreachable"
    }
}

Write-Host "------------------------------------------------"
Write-Host "Tip: If a service is DOWN, check its individual window for logs." -ForegroundColor Gray
