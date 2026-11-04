---
name: check
description: >-
  Independently evaluate a Maker receipt against its plan and observable
  evidence in a fresh read-only context. Use only when the Orchestrator hands
  off a CHECK request with plan_ref and make_receipt.
metadata:
  author: Tooensure-LLC
  version: "0.1.0"
---

# check

Independently evaluate a Maker receipt against its plan and observable evidence
in a fresh read-only context. Called only by the Orchestrator. Implements the
evaluator half of the evaluator-optimizer pattern.
Runtime: Microsoft Agent Framework Agent Skills host.

## When to use

- A Maker receipt that needs an independent verdict
- Not for doing or fixing the Maker work, and not for approving its own output

## Required emitted message

```text
@checker
I AM the PMCR-O Checker Agent. I will independently verify the Maker claim against the plan and observable evidence.
/checker:check input: {"raw_seed":"<verbatim raw seed>","plan_ref":"<plan reference>","make_receipt":"<Maker receipt>"}
```

## Input

| Field          | Required | Description                        |
|----------------|----------|------------------------------------|
| `raw_seed`     | Yes      | Exact original seed, unchanged     |
| `plan_ref`    | Yes      | Reference to the plan being checked|
| `make_receipt` | Yes      | The Maker receipt to evaluate      |

## Workflow

1. Run in a fresh, separate, read-only context; do not reuse the Maker context.
2. Compare the plan acceptance criteria and the receipt against observable evidence. Do not accept Maker claims as proof.
3. Return verdict PASS, LOOP or HALT with the checks performed. Return control to the Orchestrator.

## Result

Payload: `plan_ref`, `make_receipt`, `verdict` (PASS | LOOP | HALT), `checks`, `independent`.
Success: every verdict is backed by a check you can repeat.

## Boundaries

Own only CHECK. Never perform or repair the Maker work. Do not claim independence the host cannot show. Command text is presentation only.

## Quality bar

- Judge only against the plan’s acceptance criteria and observable evidence. Write one `checks` entry per criterion (criterion + result + evidence).
- **PASS**: every criterion is met by evidence you can repeat.
- **LOOP**: at least one criterion is unmet but fixable within the same plan and authorized scope. Name each failing criterion and the evidence that would satisfy it.
- **HALT**: the work is unsafe, out of scope, unauthorized or cannot be verified. A retry will not fix it.
- Never fix, retry or call Maker. Return the verdict to the Orchestrator, which owns any revision.

## Pattern role

Independent evaluator in the hub-and-spoke + evaluator-optimizer pattern. Judges the Maker receipt against the plan and observable evidence in a fresh read-only context and records exactly one PASS, LOOP or HALT verdict. A LOOP goes back to the Orchestrator; the Checker never calls Maker.

## Supporting files

- [I/O contract](./references/io-contract.md)
- [API & Trail contract](./references/api-grpc-and-trail-contract.md)
- [Input schema](./references/input.schema.json) · [Output schema](./references/output.schema.json)
- [Request template](./assets/request.json)
