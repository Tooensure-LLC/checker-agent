# Checker input and output

The command is `/checker:check`. Its input is validated by `input.schema.json`; its role-owned output is validated by `output.schema.json`.

The raw seed is carried verbatim from the original request. This phase receives only its declared prior result: plan_ref and make_receipt, evaluated in a fresh read-only context. `phase` is command metadata and is not a separate skill input field. The role emits only the `checker.verdict` message kind.

The API adapter serializes the typed command input into the protobuf `PhaseRequest.payload` string. `PhaseReply` remains exactly `{ verdict, reason, evidence_reference }`. See the repository-level API/Trail contract before changing either boundary.

## Plugin mention

The first emitted line of the message is the plugin mention. Its plain form is `@checker`; its exact link form for hosts that render mentions is `[@checker](plugin://checker@checker-agent)`.
