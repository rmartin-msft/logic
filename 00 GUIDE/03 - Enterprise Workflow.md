

Purpose
Demonstrate that Logic Apps can handle real integration complexity, not just happy paths.
Scenario (extends Lab 1)
"For each incoming order, call multiple downstream systems in parallel and handle partial failure safely."
What attendees extend
The same Logic App from Lab 1:

Add a fan‑out pattern (For each / parallel actions)
Introduce at least one intentional failure
Implement controlled retries and failure paths
Key steps (high‑level)

Split incoming payload into multiple items
Process items in parallel
Configure retry policies explicitly
Use Scope + run‑after to manage failure
Capture and surface failure details
Concepts intentionally taught

Fan‑out / fan‑in patterns
Default vs explicit retry behaviour
Scope, run‑after, and failure handling
Transient vs terminal failures
Why “green ticks” don’t always mean success




Final evolution of the same scenario:
Add one of:

Service Bus (async decoupling)
Function call
External SaaS system
Introduce:

Correlation IDs
Logging to Log Analytics
Basic alerting
