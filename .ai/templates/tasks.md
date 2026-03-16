# TASKS: [Phase N]

## Context
**Linked Phase Design**: [Link to {N}-PHASE-DESIGN.md]

## Execution Waves
Plans are grouped into waves. Tasks in the same wave can be executed in parallel. Waves must be executed sequentially.

### Wave 1: [Description, e.g., Foundation]

```xml
<task id="1.1" type="auto">
  <name>Create Data Models</name>
  <files>src/models/user.ts, src/types/index.ts</files>
  <action>
    Create the User interface and associated type guards. 
    Make sure to include fields for role and status.
  </action>
  <verify>npm run typecheck passes</verify>
  <done>User interface exported and typecheck succeeds</done>
</task>
```

```xml
<task id="1.2" type="auto">
  <name>Setup API Route</name>
  <files>src/api/users.ts</files>
  <action>
    Create the express router for users. Implement GET / endpoint.
    Return mock data for now.
  </action>
  <verify>curl localhost:3000/api/users returns 200 array</verify>
  <done>Endpoint returns HTTP 200 and JSON array</done>
</task>
```

### Wave 2: [Description, e.g., Integration]

```xml
<task id="2.1" type="auto">
  <name>Connect Route to Model</name>
  <files>src/api/users.ts</files>
  <action>
    Update GET / to use the database instead of mock data.
    Type the response using the User interface.
  </action>
  <verify>npm run test:api passes</verify>
  <done>Endpoint returns real data and tests pass</done>
</task>
```
