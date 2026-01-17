<#
.SYNOPSIS
    Starts all microservices in separate PowerShell windows.
    Run this script from the project root: .\scripts\start_all.ps1

.DESCRIPTION
    This script launches each microservice (Config, Discovery, Gateway, etc.) in a new window.
    It adds a small delay between core infrastructure and business services to ensure stability.
#>

Write-Host "🚀 Starting Microservices Ecosystem..." -ForegroundColor Cyan

# 1. Start Config Server (The Backbone)
Write-Host "   [1/8] Starting Config Server..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& {HOST_TITLE='Config Server'; $host.ui.RawUI.WindowTitle = 'Config Server'; cd services/config-server; mvn spring-boot:run}"

# Wait for Config Server to be ready (approx)
Start-Sleep -Seconds 15

# 2. Start Discovery Service (The Registry)
Write-Host "   [2/8] Starting Discovery Service..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& {HOST_TITLE='Discovery Service'; $host.ui.RawUI.WindowTitle = 'Discovery Service'; cd services/discovery; mvn spring-boot:run}"

# Wait for Eureka to be ready
Start-Sleep -Seconds 10

# 3. Start Infrastructure & Core Services (Parallel)
Write-Host "   [3/8] Starting Gateway Service..." -ForegroundColor Before
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& {HOST_TITLE='Gateway Service'; $host.ui.RawUI.WindowTitle = 'Gateway Service'; cd services/gateway; mvn spring-boot:run}"

Write-Host "   [4/8] Starting Customer Service..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& {HOST_TITLE='Customer Service'; $host.ui.RawUI.WindowTitle = 'Customer Service'; cd services/customer; mvn spring-boot:run}"

Write-Host "   [5/8] Starting Product Service..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& {HOST_TITLE='Product Service'; $host.ui.RawUI.WindowTitle = 'Product Service'; cd services/product; mvn spring-boot:run}"

Write-Host "   [6/8] Starting Order Service..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& {HOST_TITLE='Order Service'; $host.ui.RawUI.WindowTitle = 'Order Service'; cd services/order; mvn spring-boot:run}"

Write-Host "   [7/8] Starting Payment Service..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& {HOST_TITLE='Payment Service'; $host.ui.RawUI.WindowTitle = 'Payment Service'; cd services/payment; mvn spring-boot:run}"

Write-Host "   [8/8] Starting Notification Service..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& {HOST_TITLE='Notification Service'; $host.ui.RawUI.WindowTitle = 'Notification Service'; cd services/notification; mvn spring-boot:run}"

Write-Host "`n✅ All services have been triggered! Check the individual windows for logs." -ForegroundColor Cyan
Write-Host "⏳ Please allow 1-2 minutes for all services to register with Eureka." -ForegroundColor Gray
