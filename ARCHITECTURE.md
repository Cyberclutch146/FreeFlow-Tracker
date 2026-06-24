# Architecture & Design Decisions

This document details the architectural patterns, state management strategies, and key design decisions behind **FreelanceFlow**.

---

## 1. Core Architecture: Feature-First Layered

FreelanceFlow follows a **Feature-First Layered Architecture** adapted for Flutter:

```
┌─────────────────────────────────────────┐
│  Presentation Layer                     │
│  lib/screens/ + lib/widgets/            │
│  Watches Riverpod providers, rebuilds   │
│  reactively on data changes             │
├─────────────────────────────────────────┤
│  Service Layer                          │
│  lib/services/                          │
│  Business logic: AI engine, SMS parser, │
│  insights rules, savings advisor        │
├─────────────────────────────────────────┤
│  Repository Layer                       │
│  lib/repositories/                      │
│  CRUD abstraction over Isar collections │
│  Exposes Future + Stream methods        │
├─────────────────────────────────────────┤
│  Data Layer                             │
│  lib/models/ + lib/database/            │
│  Isar @collection entities, migrations  │
└─────────────────────────────────────────┘
```

---

## 2. State Management: Riverpod

[Riverpod](https://riverpod.dev/) v2 is used exclusively for DI and state management. All providers are defined in `lib/core/di/providers.dart` and `lib/core/router/app_router.dart`.

### Provider Patterns

**Repository singletons** — `Provider<T>`:
```dart
final transactionRepositoryProvider = Provider(
  (ref) => TransactionRepository(ref.read(databaseServiceProvider))
);
```

**Reactive DB streams** — `StreamProvider<List<T>>`:
```dart
final recentTransactionsProvider = StreamProvider<List<Transaction>>(
  (ref) => ref.watch(transactionRepositoryProvider).watchAll()
);
```
When Isar writes happen, the stream emits the new list and any watching widget rebuilds automatically — no manual `setState` or `notifyListeners`.

**Computed async providers** — `FutureProvider<List<T>>`:
```dart
final insightsProvider = FutureProvider<List<InsightCard>>((ref) async {
  final txns = await ref.watch(transactionRepositoryProvider).getAll();
  // ... compute insights
});
```

**Singleton service with keepAlive** — Ensures stateful services like `OfflineAIService` maintain their conversation history across navigation:
```dart
final geminiServiceProvider = Provider<OfflineAIService>((ref) {
  ref.keepAlive(); // Prevents disposal when no widget is watching
  return OfflineAIService();
});
```

---

## 3. Local Storage: Isar Database

[Isar](https://isar.dev/) v3 was chosen for:
- **Zero isolation overhead**: Runs in-process (no separate database process)
- **Synchronous + async APIs**: Fast synchronous reads for most lookups
- **Reactivity**: `isar.collection.watch()` emits a new list on every write — the backbone of the reactive UI
- **Type-safe queries**: Fully Dart-typed query builder, no raw SQL

### DB Initialization & Migration
`DatabaseService.initialize()` opens Isar and immediately runs `MigrationV1`, which creates the default `AppSettings` singleton if none exists.

### Isar ID Strategy
All models use a `String id` (UUID) as the business key, with a computed `isarId` using FNV-1a hash for the Isar internal `Id`:
```dart
Id get isarId => id.fastHash; // See extensions.dart
```

---

## 4. Intelligence Engine Architecture

### 4.1 Unified Categorization (`lib/services/ai/category_classifier.dart`)

**Single source of truth** for categorizing transactions by merchant/description.

Previously the codebase had three competing categorizers. They are now unified into one `CategoryClassifier` with:
- ~250 keyword entries across 8 `Category` enum values
- **Longest-match algorithm**: the most specific keyword wins (e.g., `"amazon prime"` beats `"amazon"`)
- **User correction learning**: `learnFromCorrection(merchant, category)` stores overrides, applied first before keyword matching
- **Direction-aware fallback**: uncategorized credit transactions default to `Category.income`

Used by:
- `SmsToTransaction.convert()` — SMS auto-parsing pipeline
- `OfflineAIService.batchCategorize()` — AI engine batch classification

### 4.2 SMS Parser (`lib/services/sms/sms_parser.dart`)

Parses raw bank SMS text into `ParsedSms` using regex tuned for Indian banking formats.

**Supported patterns:**
- Debit: `debited`, `paid`, `withdrawn`, `purchase`, `used at`, `charged`
- Credit: `credited`, `received`, `refund`, `cashback`, `IMPS received`
- Amounts: `Rs. 1,000.50`, `Rs 1000`, `INR 50,000`, `₹500`
- Merchants: `to <name>`, `at <name>`, UPI VPA (`name@bank`)
- UPI refs: 9-15 digit transaction IDs
- 25+ Indian banks identified by sender ID

**Confidence scoring:**
- `high`: amount + merchant both extracted
- `medium`: amount only
- `low`: fallback (currently unused — low-confidence SMS are discarded)

### 4.3 Offline AI Engine (`lib/services/ai/offline_ai_service.dart`)

A deterministic, intent-based conversational assistant. No API calls, no ML model — pure Dart logic.

**Architecture:**
```
userMessage
    │
    ▼
_classifyIntent()    → 12 intent patterns, longest-keyword match
    │
    ▼
_isFollowUp()        → checks history, detects follow-up phrases
    │
    ├── is follow-up → _handleFollowUp() → deeper response on same topic
    │
    └── new intent   → _dispatch() → specific intent handler
                            │
                            ▼
                    _FinancialContext.build()
                    (income, expense, budgets, goals, category breakdown)
```

**Session persistence:** The provider uses `ref.keepAlive()` so `_history`, `_lastIntent`, and `_turnCount` persist across navigation events within an app session.

**Supported intents:** `greeting`, `monthly_summary`, `top_expenses`, `budget_check`, `savings_advice`, `income_status`, `goal_progress`, `spending_trend`, `category_breakdown`, `recurring_check`, `daily_average`, `prediction`

### 4.4 Insights Engine (`lib/services/insights_engine.dart`)

8 deterministic rule-based cards generated fresh each time the provider is evaluated:

| Rule | Trigger |
|------|---------|
| `spending_spike` | Current month expenses > 125% of last month |
| `category_spike` | Category > 140% of 3-month average |
| `budget_exceeded` | Category spending > monthly limit |
| `budget_warning` | >80% of budget used with >7 days left |
| `unpaid_project` | Project overdue with no linked income transaction |
| `recurring_detected` | Same merchant+amount appears 3+ times in 3 months |
| `income_target` | Progress towards monthly income goal |
| `savings_rate` | Current month income vs expense ratio |

### 4.5 Savings Advisor (`lib/services/savings_advisor.dart`)

Evaluates active savings goals against current cash flow:

| Capability | Logic |
|-----------|-------|
| Pace prediction | `predicted = now + (remaining / monthlyAllocation) * 30 days` |
| Behind schedule | `predicted > deadline` → calculate required increased allocation |
| Competing goals | `totalAllocationNeeded > currentSavings` |
| Pause suggestion | Recommend pausing lowest-priority goal to fund highest |
| Milestones | Triggered at exactly 25%, 50%, 75%, 100% |

---

## 5. Theming System

### ThemeConfig & AppColors
Colors are not passed via MaterialTheme's `ColorScheme` — instead we use a custom `ThemeExtension<AppColors>` providing tokens like `accentPurple`, `backgroundPrimary`, `textMuted`, etc. This gives complete control independent of Material's palette assumptions.

### Three Themes
| Theme | Background | Use Case |
|-------|-----------|----------|
| `darkMode` | `#121212` | Standard dark mode |
| `oledMode` | `#000000` | True black for AMOLED — black pixels are literally off, saving battery |
| `lightMode` | `#F8F9FA` | Light mode |

### Live Switching
`AppSettings.theme` (stored in Isar) → `settingsProvider` (StreamProvider) → `themeConfigProvider` (computed Provider) → `AppTheme.fromConfig()` in `MaterialApp.router`. Changing the theme in Settings writes to Isar, which streams through all providers and repaints instantly.

### Context Extensions
```dart
// Any widget can access the theme without a BuildContext dance:
final colors = context.colors;    // AppColors
final styles = context.textStyles; // AppTextStyles
```

---

## 6. Routing: GoRouter

Two-tier routing via `lib/core/router/app_router.dart`:

**Shell routes** (bottom nav stays visible):
- `/home` → HomeScreen
- `/transactions` → TransactionsScreen
- `/income` → IncomeScreen
- `/goals` → GoalsScreen
- `/reports` → ReportsScreen

**Top-level routes** (full-screen push, no bottom nav):
- `/settings`, `/ai-chat`, `/ai-report`
- `/project-detail/:id`, `/student-detail/:id`
- `/subscriptions`

---

## 7. SMS Auto-Sync

The `autoSmsSyncProvider` (a `Provider<void>`) runs a background sync loop:

1. On creation: immediately calls `_runSync()`
2. Every 2 minutes: periodic `Timer` calls `_runSync()`
3. `_runSync()` fetches inbox → parses each SMS **once** → converts to Transaction → duplicate-checks before saving
4. Shows a SnackBar if new transactions were found

The `SmsService.watchIncomingSms()` stream also listens for real-time incoming SMS while the app is in the foreground (background listening is disabled to avoid battery drain).

---

## 8. Data Export & Backup

| Export Type | Implementation |
|------------|----------------|
| CSV (transactions) | `CsvExportService.exportTransactions()` → temp file → `Share.shareXFiles()` |
| Full JSON backup | `DatabaseService.exportAllJson()` → `CsvExportService.exportJson()` → share |
| JSON restore | `DatabaseService.importFromJson()` → Isar `putAll()` (merges, doesn't overwrite) |
| PDF Invoice | `InvoiceService.generateAndShareInvoice()` → `Printing.sharePdf()` |

---

## 9. Biometric Lock

Flow:
1. App starts → `_authenticate()` called
2. If no biometrics available → unlock immediately
3. If biometrics available → show lock overlay until auth succeeds
4. On `AppLifecycleState.paused` → re-lock (`_isLocked = true`)
5. On `AppLifecycleState.resumed` → `_authenticate()` called again

Lock overlay is rendered in the `MaterialApp.router` builder using a `Stack`, ensuring it covers all routes including dialogs.
