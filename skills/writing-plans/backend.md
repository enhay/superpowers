# Backend Rules

Language- and framework-agnostic additions to [architecture.md](architecture.md).
Where code lives — which package or layer — belongs to each repository's
conventions, not to this file.

## Code

1. A business calculation takes the current time, generated identifiers, and
   facts from other systems as inputs; it never reads a clock, generates an
   identifier, or calls another system itself.
2. Third-party SDK types and error codes stay inside the code that talks to that
   system. Name that code for the business capability — payments, not the
   vendor's client — so switching vendors changes neither its name nor its
   callers, and give it only the operations its callers use.
3. One transaction keeps one module's data consistent. When modules must succeed
   or fail together, the design states the trade-off.
4. When a database write and a message must both happen reliably, store the
   message with the data and send it afterwards. Without that need, do not
   build it.

## Logging

5. Every request, command, and background job carries one identifier — a
   request ID plus the business key, such as an order number or a device serial
   — in every line it logs. An error response returns the identifier, so a
   user's report can be traced.
6. An error turned into a generic failure response is logged where it is turned,
   with the original error. A response that hides the cause and logs nothing is
   a defect. Expected rejections — invalid input, no permission, a state
   conflict — are not logged as errors.
7. Log an error once, where it is handled; never log and rethrow at every layer.
8. A call to another system or a background job that fails logs the target, the
   outcome, and the duration. A state change support must be able to explain — a
   command queued, sent, acknowledged, failed — is logged or kept as an audit
   record.
9. Log key-value fields. Never log secrets — tokens, keys, signatures,
   passwords — in any form; mask phone, ID, and card numbers.
10. Every request leaves an access line: method, path, status, duration,
    identifier.

## Review signals

| Signal | Rule |
|---|---|
| A catch-all mapping errors to a generic failure without logging the original error | 6 |
| A request path that produces no line carrying its identifier | 5, 10 |
| A business calculation reading the clock or generating identifiers | 1 |
| SDK types or error codes in business code | 2 |
| The same error logged at several layers | 7 |
