# MyNetDiary

## Known spec deviations

### Metric system default switch

| Spec | Status | Notes |
|------|--------|-------|
| Switch default ON for en-US, OFF otherwise | ❌ Inverted | `UserSession.swift:30` does `useMetricSystem = Locale.current.region?.identifier != "US"` → US=OFF, others=ON. Comment explicitly calls it intentional, but it contradicts the spec. |
