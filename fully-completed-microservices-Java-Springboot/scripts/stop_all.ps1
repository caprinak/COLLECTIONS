<#
.SYNOPSIS
    Stops all running Java microservices started by the project.
    Run this script from the project root: .\scripts\stop_all.ps1

.DESCRIPTION
    This script force-kills all Java processes that match the project's service names or generalized Java processes if running in dev mode.
    WARNING: This stops ALL Java processes. Use with caution if you have other Java apps running.
#>

Write-Host "🛑 Stopping Microservices..." -ForegroundColor Red

# Aggressive stop: Kills all Java processes. 
# In a production script, we would use PID tracking, but for dev, this is the cleanest 'Execute Order 66'.
Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force

Write-Host "✅ All Java microservices have been stopped." -ForegroundColor Cyan
