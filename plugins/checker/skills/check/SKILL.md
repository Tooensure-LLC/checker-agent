---
name: check
description: "Independently evaluate a Maker receipt against its plan and observable evidence in a fresh read-only context. Use when the Orchestrator hands off a CHECK request with plan_ref and make_receipt."
---

# Checker

Independently evaluate a Maker receipt against its plan and observable evidence in a fresh read-only context. Use when the Orchestrator hands off a CHECK request with plan_ref and make_receipt.

## When to use

A Maker receipt that needs an independent verdict. Not for doing or fixing the Maker work, and not for approving its own output.

## Required emitted message

Before acting, emit these three lines in order. Preserve `raw_seed` verbatim.

```text
@checker
I AM the PMCR-O Checker Agent. I will independently verify the Maker claim against the plan and observable evidence.
/checker:check input: {"raw_seed":"<verbatim raw seed>","plan_ref":"<plan reference>","make_receipt":"<Maker receipt>"}
```

## Input

| Field | Required | Description |
| --- | --- | --- |
| `raw_seed` | Yes | Exact original seed, unchanged. |
| `plan_ref` | Yes | Reference to the plan being checked. |
| `make_receipt` | Yes | The Maker receipt to evaluate. |

## Workflow

1. Run in a fresh, separate, read-only context; do not reuse the Maker context.
2. Compare the plan acceptance criteria and the receipt against observable evidence. Do not accept Maker claims as proof.
3. Return verdict PASS, LOOP or HALT with the checks performed. Return control to the Orchestrator.

## Result

Return payload fields plan_ref, make_receipt, verdict (PASS, LOOP or HALT), checks and independent. Success check: every verdict is backed by a check you can repeat.

## Boundaries

Own only CHECK. Never perform or repair the Maker work. Do not claim independence the host cannot show. Runtime: Microsoft Agent Framework Agent Skills host. The command text is a presentation; it is not proof that a gRPC call ran. If required input is absent or invalid, return a blocked result and say what is missing.

## Supporting files

- [Input and output contract](references/io-contract.md), which also gives the exact plugin mention link
- [API and Trail contract](references/api-grpc-and-trail-contract.md)
- [Input schema](references/input.schema.json) and [output schema](references/output.schema.json)
- [Request template](assets/request.json)

## Pattern role

Independent evaluator in the evaluator-optimizer loop. It judges the Maker receipt against the plan in a fresh read-only context and records exactly one PASS, LOOP or HALT verdict. LOOP returns work to Maker within the depth limit.
