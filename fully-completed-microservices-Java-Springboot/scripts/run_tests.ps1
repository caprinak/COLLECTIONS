<#
.SYNOPSIS
    Wraps the existing E2E test script with a more convenient interface.
    Can be run from anywhere.
#>

$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

Write-Host "🧪 Running End-to-End Integration Tests..." -ForegroundColor Cyan

if (Test-Path "tests/run_test.ps1") {
    .\tests\run_test.ps1
}
else {
    Write-Host "❌ Error: Could not find tests/run_test.ps1" -ForegroundColor Red
}
