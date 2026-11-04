# API, gRPC, and Trail boundary

The local role command text is a display projection. Before acting, emit the plugin mention, the `I AM the PMCR-O Checker Agent` identity/intent line, and `/checker:check input: <schema-valid JSON>` in that order.

The ProjectName gRPC `PhaseRequest` contains exactly `trail_id`, `actor_id`, `capability_id`, `phase`, and `payload`; `payload` is JSON-serialized text for this role's typed input. `PhaseReply` contains exactly `verdict`, `reason`, and `evidence_reference`.

The role-owned output uses `checker.verdict` in the PMCR-O message protocol. It is separate from `PhaseReply`. For the current Trail store, persist the immutable role message as an evidence artifact and put its reference in `evidenceReference`. The current `TrailFrame` type does not have a `frameType` field. Do not imply this candidate repo adds runtime fields or successful execution; the current development worker denies admission with `NO_WORKER_ADMISSION`.
