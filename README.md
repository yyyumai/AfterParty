# AfterParty

AfterParty is an iOS SwiftUI prototype for retrospective health visualization around alcohol-related events.

The MVP uses mock session data, mock baseline data, mock HealthKit-style metrics, and a mock AI analysis service. It intentionally avoids HealthKit authorization, OpenAI API keys, medical diagnosis, tolerance estimates, safe limits, or recommendations about consuming alcohol.

## Architecture

- `Models`: sessions, drink entries, context tags, health metrics, baseline, AI analysis output
- `Services`: protocol abstractions plus mock implementations
- `ViewModels`: session store, creation state, home summary, analysis loading
- `Views`: home, creation, drink entry, history, details, comparison, timeline, AI insight
- `Components`: reusable metric cards, drink rows, context chips, comparison rows, chart

Future OpenAI integration should use a backend:

```text
iOS App -> Backend API -> OpenAI API
```

Do not place an OpenAI API key in the iOS client.
