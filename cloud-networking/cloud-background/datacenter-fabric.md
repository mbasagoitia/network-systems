# Datacenter Fabric (VL2)

How do we maximize efficiency of large data centers that are expensive to run?

Tenets of Cloud Scale Data Centers:

- Agility: ability to assign any servers to any services. Boosts cloud utilization.
- Scaling out: Use large pools of commodities. Achieves reliability, performance, low cost.

Cloud DC challenges:

- Instrumented a large cluster used for data mining and identified distinctive traffic patterns
- Traffic patterns are highly volatile; large number of distinctive patterns even in a day
- Traffic patterns are unpredictable; correlation between patterns weak

So, optimization should be done frequently and rapidly.

## Specific Objective and Solutions

Objective: layer 2 semantics
Approach: employ flat addressing
Solution: name-location separation and resolution service

Objective: uniform high capacity between servers
Approach: guarantee bandwidth for hose-model traffic
Solution: flow-based random traffic indirection (Valiant load balancing)

Objective: performance isolation
Approach: enforce hose model using existing mechanisms only
Solution: TCP