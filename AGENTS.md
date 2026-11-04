# Repository instructions

- Keep this repository bounded to the Checker role and `CHECK` phase.
- Do not add another phase command or role skill here.
- Keep typed input, role output frame, protobuf reply, and human-readable command text as separate schemas/projections.
- Preserve the existing `PhaseRequest` and `PhaseReply` field names; see `docs/api-grpc-and-trail-contract.md`.
- The Checker must stay in a separate fresh read-only context from Maker execution.
- Candidate files do not establish registration, grants, activation, execution, or Trail persistence.
