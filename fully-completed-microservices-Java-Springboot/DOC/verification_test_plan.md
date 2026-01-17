# Microservices Verification & Test Plan

This verification plan outlines the steps to invoke endpoints, trigger service-to-service communication, and verify the results using infrastructure observability tools (Zipkin, Logs).

## 1. Endpoints & Payloads

All requests should be sent to the **API Gateway** on port **8222**.

### A. Create Customer
*   **Service**: Customer Service
*   **Endpoint**: `POST /api/v1/customers`
*   **Payload**:
    ```json
    {
      "firstname": "John",
      "lastname": "Doe",
      "email": "john.doe@example.com",
      "address": {
        "street": "123 Tech Avenue",
        "houseNumber": "456",
        "zipCode": "10001"
      }
    }
    ```
*   **Expected Response**: Customer ID (String).

### B. Create Product
*   **Service**: Product Service
*   **Endpoint**: `POST /api/v1/products`
*   **Payload**:
    ```json
    {
      "name": "Mechanical Keyboard",
      "description": "High-performance mechanical keyboard with RGB.",
      "availableQuantity": 100,
      "price": 150.00,
      "categoryId": 1
    }
    ```
*   **Expected Response**: Product ID (Integer).

### C. Place Order
*   **Service**: Order Service
*   **Endpoint**: `POST /api/v1/orders`
*   **Description**: This request triggers the entire chain:
    1.  Order Service -> Customer Service (Verify customer).
    2.  Order Service -> Product Service (Purchase product/reduce stock).
    3.  Order Service -> Payment Service (Process payment).
    4.  Order Service -> Kafka Topic (`order-topic`).
    5.  Notification Service <- Kafka Topic (Send Email).
*   **Payload**:
    ```json
    {
      "reference": "ORD_TEST_001",
      "amount": 150.00,
      "paymentMethod": "PAYPAL",
      "customerId": "CUSTOMER_ID_FROM_STEP_A",
      "products": [
        {
          "productId": PRODUCT_ID_FROM_STEP_B,
          "quantity": 1
        }
      ]
    }
    ```
*   **Expected Response**: Order ID (Integer).

## 2. Infrastructure Verification Checks

### A. Zipkin Tracing
*   **URL**: [http://localhost:9411](http://localhost:9411)
*   **Action**: Search for traces.
*   **Verification**:
    *   Find a trace for `POST /api/v1/orders`.
    *   Verify the span hierarchy: `gateway` -> `order-service` -> `customer-service`, `product-service`, `payment-service`.
    *   Check for asynchronous spans linking `order-service` to `notification-service` via Kafka.

### B. Config Server Verification
*   **URL**: [http://localhost:8888/order-service/default](http://localhost:8888/order-service/default)
*   **Verification**: Ensure the response contains configuration properties, confirming the service is fetching its config.

### C. Notification / MailDev
*   **URL**: [http://localhost:1080](http://localhost:1080)
*   **Verification**: Check for a new email confirming the order and payment. This proves the **Notification Service** successfully consumed the Kafka message.

## 3. Automated E2E Testing

We provide automated scripts to run the full flow (Create Customer -> Create Product -> Place Order).

### Running the Test
From the project root directory, run one of the following commands:

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy Bypass -File .\tests\run_test.ps1
```

**Linux/Mac (Bash):**
```bash
chmod +x ./tests/run_test.sh
./tests/run_test.sh
```

### Understanding the Output
When the test completes, you will see two different identifiers for the order:
- **Order ID**: The internal database primary key (e.g., `4`).
- **Order Reference**: The business-facing reference (e.g., `AUTO_ORD_1211`), which includes the timestamp of the request. 

> [!NOTE]
> The emails in **MailDev** will use the **Order Reference** for communication, while internal logs and the database will primarily use the **Order ID**.

## 4. Observability & Verification
This script can be integrated into a CI/CD pipeline (e.g., GitHub Actions) to run after deployment, asserting that the HTTP response code is 200 and the Order ID is returned.
