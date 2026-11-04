# API, gRPC, and Trail boundary

- Human command text is a presentation: plugin mention, `I AM` identity/intent, then slash command and typed JSON input.
- The phase request is `trail_id`, `actor_id`, `capability_id`, `phase`, and JSON text in `payload`.
- The phase reply is exactly `verdict`, `reason`, and `evidence_reference`.
- This skill's role-owned frame kind is `checker.verdict` and is evidence payload, not the gRPC reply.
- The current ProjectName Trail frame stores `evidenceReference` and has no `frameType` property. Store the immutable role frame as evidence and reference it; do not claim a Trail frame-type field exists today.
- The current development worker is deny-all (`NO_WORKER_ADMISSION`); schemas and text examples do not claim successful execution.
