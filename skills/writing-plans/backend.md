# Backend Logging

Language- and framework-agnostic additions to [architecture.md](architecture.md).
Use the framework's logger and request-logging middleware to carry them.

1. Every request, command, and background job carries one identifier — a
   request ID plus the business key, such as an order number or a device serial
   — in every line it logs. An error response returns the identifier, so a
   user's report can be traced.
2. An error turned into a generic failure response is logged where it is turned,
   with the original error. A response that hides the cause and logs nothing is
   a defect. Expected rejections — invalid input, no permission, a state
   conflict — are not logged as errors.
3. Log an error once, where it is handled; never log and rethrow at every layer.
4. A call to another system or a background job that fails logs the target, the
   outcome, and the duration. A state change support must be able to explain — a
   command queued, sent, acknowledged, failed — is logged or kept as an audit
   record.
5. Log key-value fields. Never log secrets — tokens, keys, signatures,
   passwords — in any form; mask phone, ID, and card numbers.
6. Every request leaves an access line: method, path, status, duration,
   identifier.

## Review signals

| Signal | Rule |
|---|---|
| A catch-all mapping errors to a generic failure without logging the original error | 2 |
| A request path that produces no line carrying its identifier | 1, 6 |
| The same error logged at several layers | 3 |
