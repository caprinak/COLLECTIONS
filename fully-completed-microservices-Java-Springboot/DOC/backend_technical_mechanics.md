# Backend Technical Mechanics & Design Decisions

This document provides a deep dive into the technical implementation of our microservices, explaining the "how" and "why" behind the code. It serves as a living reference for troubleshooting and future enhancements.

---

## 1. Inter-Service Communication: Feign Clients

### The Case Study: Order Service → Payment Service

In the `order-service`, communicating with the `payment-service` is handled via **OpenFeign**.

#### 💡 Why Feign?
- **Declarative Approach**: Instead of writing boilerplate code using `RestTemplate` or `WebClient` to handle URLs, connection opening, and JSON parsing, we define a simple Java **Interface**. Spring Cloud handles the implementation.
- **Microservices Integration**: Feign is designed to work with **Eureka** (Discovery) and **Load Balancing**. It can look up services by name rather than hard-coded IPs.
- **Resiliency Integration**: It provides native support for **Resilience4j** (Circuit Breakers), which is our next phase for handling cascading failures.

#### 📂 The "Payment" Package (`order-service`)

| File | Role |
| :--- | :--- |
| **`PaymentRequest.java`** | A **DTO (Data Transfer Object)**. It is a `record` that acts as the "payload" or envelope carrying transaction details (Order ID, Reference, Amount) across the network. |
| **`PaymentClient.java`** | The **Feign Client Interface**. It uses annotations like `@FeignClient` and `@PostMapping` to define the contract with the remote Payment Service. |

#### ⚙️ The Execution Flow
1. **Persistence**: The `OrderService` first persists the order in its local PostgreSQL database.
2. **Synchronization**: It then calls the `PaymentClient`. This is a **blocking/synchronous** call. The Order service waits for a successful response from the Payment service before proceeding.
3. **Completion**: If payment succeeds, the service then emits an asynchronous event to Kafka for notifications.

#### ⚠️ Technical Risks & Next Steps
- **Tight Coupling**: Because the call is synchronous, if the Payment service is down or slow, the Order service will hang or return a 500 error.
- **Proposed Solution**: Introduce a **Circuit Breaker** (Phase 1 of our roadmap) to "fail fast" and provide a fallback response when the Payment service is unhealthy.

---

## 2. Asynchronous Patterns (To be expanded)
*Details on Kafka Producers/Consumers will be added here.*

---

## 3. Database Strategy (To be expanded)
*Details on PostgreSQL Persistence and MongoDB implementation will be added here.*

---
*Maintained by the Antigravity Engineering Team*
