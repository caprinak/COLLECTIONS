# Microservices E2E Test Script (PowerShell)
# This script automates the Customer -> Product -> Order flow via the API Gateway.

$GatewayUrl = "http://localhost:8222/api/v1"

# 1. Create Customer
$CustomerPayload = @{
    firstname = "Automation"
    lastname = "Tester"
    email = "auto.test@example.com"
    address = @{
        street = "Scripting Lane"
        houseNumber = "101"
        zipCode = "99999"
    }
} | ConvertTo-Json

Write-Host "--- Step 1: Creating Customer ---" -ForegroundColor Cyan
$CustomerResponse = Invoke-RestMethod -Uri "$GatewayUrl/customers" -Method Post -Body $CustomerPayload -ContentType "application/json"
$CustomerId = $CustomerResponse
Write-Host "Success! Customer ID: $CustomerId" -ForegroundColor Green

# 2. Create Product
$ProductPayload = @{
    name = "Automated Gadget"
    description = "A product created by the test script"
    availableQuantity = 50
    price = 99.99
    categoryId = 1
} | ConvertTo-Json

Write-Host "`n--- Step 2: Creating Product ---" -ForegroundColor Cyan
$ProductId = Invoke-RestMethod -Uri "$GatewayUrl/products" -Method Post -Body $ProductPayload -ContentType "application/json"
Write-Host "Success! Product ID: $ProductId" -ForegroundColor Green

# 3. Place Order
$Reference = "AUTO_ORD_$(Get-Date -Format 'HHmm')"
$OrderPayload = @{
    reference = $Reference
    amount = 99.99
    paymentMethod = "PAYPAL"
    customerId = $CustomerId
    products = @(
        @{
            productId = $ProductId
            quantity = 1
        }
      )
} | ConvertTo-Json

Write-Host "`n--- Step 3: Placing Order ---" -ForegroundColor Cyan
$OrderId = Invoke-RestMethod -Uri "$GatewayUrl/orders" -Method Post -Body $OrderPayload -ContentType "application/json"
Write-Host "Success! Order ID: $OrderId" -ForegroundColor Green
Write-Host "Order Reference: $Reference" -ForegroundColor Green

Write-Host "`n==========================================" -ForegroundColor Yellow
Write-Host "E2E Integration Test Completed Successfully!" -ForegroundColor Yellow
Write-Host "Check Zipkin: http://localhost:9411"
Write-Host "Check MailDev: http://localhost:1080"
Write-Host "==========================================" -ForegroundColor Yellow
