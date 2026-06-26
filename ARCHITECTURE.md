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
│  Business logic: AI engine, statement   │
│  parser, insights rules, savings advisor│
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
`DatabaseService.initialize()` opens Isar and immediately runs `MigrationV1`, which creates the default `AppSettings` singleton if none exists. The `AppSettings` model includes both `onboardingComplete` and `tutorialComplete` flags to control the first-launch flow.

### Isar ID Strategy
All models use a `String id` (UUID) as the business key, with a computed `isarId` using FNV-1a hash for the Isar internal `Id`:
```dart
Id get isarId => id.fastHash; // See extensions.dart
```

---

## 4. Intelligence Engine Architecture

### 4.1 Bank Statement Parser (`lib/services/statement_parser.dart`)

The primary data ingestion pipeline. Supports two formats:

**CSV Parsing:**
- Auto-detects column layout by scanning headers for keywords (date, amount, debit, credit, description, etc.)
- Handles multiple CSV dialects from Indian banks (PNB, SBI, HDFC, ICICI, etc.)
- Splits combined debit/credit columns vs. separate columns automatically
- Cleans amount strings (removes commas, currency symbols, handles parenthesized negatives)

**PDF Parsing (Dual Strategy):**
1. **Rule-Based Fallback** — Regex patterns tuned for known bank PDF formats (e.g., PNB). Extracts date, description, amount, and balance from each line. Works 100% offline.
2. **LLM-Assisted** (`lib/services/ai/llm_parser_service.dart`) — For complex/unknown PDF layouts, sends extracted text to Google Generative AI with a structured prompt requesting JSON output. Falls back to rule-based if no API key is configured.

**Post-Processing Pipeline:**
```
Raw File (CSV/PDF)
    │
    ▼
StatementParser.parseCSV() / parsePDF()
    │
    ▼
List<Transaction> (with amounts, dates, descriptions)
    │
    ▼
CategoryClassifier.classifyWithDirection()   → auto-categorize each transaction
    │
    ▼
Duplicate detection (checks existing DB)     → filter out already-imported rows
    │
    ▼
TransactionRepository.saveAll()              → persist to Isar
    │
    ▼
OfflineAIService.generateStatementSummary()  → AI summary dialog shown to user
```

### 4.2 Unified Categorization (`lib/services/ai/category_classifier.dart`)

**Single source of truth** for categorizing transactions by merchant/description.

Previously the codebase had three competing categorizers. They are now unified into one `CategoryClassifier` with:
- ~250 keyword entries across 8 `Category` enum values
- **Longest-match algorithm**: the most specific keyword wins (e.g., `"amazon prime"` beats `"amazon"`)
- **User correction learning**: `learnFromCorrection(merchant, category)` stores overrides, applied first before keyword matching
- **Direction-aware fallback**: uncategorized credit transactions default to `Category.income`

Used by:
- `StatementParser` — CSV/PDF bank statement import pipeline
- `OfflineAIService.batchCategorize()` — AI engine batch classification

### 4.3 Offline AI Engine (`lib/services/ai/offline_ai_service.dart`)

A deterministic, intent-based conversational assistant. No API calls, no ML model — pure Dart logic.

**Architecture:**
```
userMessage
    │
    ▼
_classifyIntent()    → 15+ intent patterns, longest-keyword match
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
                    (income, expense, budgets, goals, category breakdown,
                     allTransactions, thisMonth)
```

**Session persistence:** The provider uses `ref.keepAlive()` so `_history`, `_lastIntent`, and `_turnCount` persist across navigation events within an app session.

**Supported intents:** `greeting`, `monthly_summary`, `top_expenses`, `budget_check`, `savings_advice`, `income_status`, `goal_progress`, `spending_trend`, `category_breakdown`, `recurring_check`, `daily_average`, `prediction`, `transaction_search`, `statement_summary`, `habit_tracking`

**Advanced capabilities:**
- **Transaction Search**: Parses natural language queries like "find transactions over 500" or "show payments to Amazon". Extracts amount thresholds, merchant names, and date ranges from the query.
- **Statement Summaries**: After a bank statement upload, generates a comprehensive spending breakdown with category totals, top merchants, and actionable tips.
- **Habit Tracking**: Analyzes spending patterns over time to identify behavioral trends (e.g., weekend splurges, end-of-month overspending).

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

### Router-Level Redirects

The router implements a three-stage redirect chain for first-launch flows:

```dart
// 1. Not onboarded → force onboarding
if (!onboardingComplete) → redirect to '/onboarding'

// 2. Onboarded but no tutorial → force tutorial
if (onboardingComplete && !tutorialComplete) → redirect to '/tutorial'

// 3. Both complete but trying to revisit → send to home
if (both complete && on /onboarding or /tutorial) → redirect to '/home'
```

### Shell Routes (Bottom Nav Visible)
- `/home` → HomeScreen (dashboard + AI banner + financial snapshot)
- `/transactions` → TransactionsScreen (transaction list + upload banner)
- `/income` → IncomeScreen (projects + students tabs)
- `/goals` → GoalsScreen (savings goals + budgets)
- `/reports` → ReportsScreen (charts + analytics)

### Top-Level Routes (Full-Screen, No Bottom Nav)
- `/settings` → App preferences, data export, backup/restore
- `/ai-chat` → Full-screen AI chat assistant (pushed from dashboard banner)
- `/ai-report` → AI-generated financial report
- `/project-detail/:id`, `/student-detail/:id` → Detail views
- `/subscriptions` → Detected recurring charges
- `/onboarding` → First-launch setup (3 steps)
- `/tutorial` → Interactive feature tour (4 pages)
- `/splash` → Initial loading screen

---

## 7. Onboarding & Tutorial Flow

FreelanceFlow implements a two-phase first-launch experience:

### Phase 1: Onboarding (`lib/screens/settings/onboarding_screen.dart`)
A 3-step PageView flow:
1. **Welcome** — App introduction with privacy focus
2. **Preferences** — Currency selection + theme picker (Dark/OLED/Light)
3. **Income Goal** — Monthly income target slider

On completion, writes `onboardingComplete: true` to `AppSettings` in Isar.

### Phase 2: Tutorial (`lib/screens/settings/tutorial_screen.dart`)
A 4-page interactive slideshow with miniature UI component mockups:
1. **Financial Snapshot** — Mini GlassPanel balance card
2. **AI Assistant** — Mini AI banner replica
3. **Upload Statements** — Styled upload button mockup
4. **Goals & Budgets** — Progress bar mockup with sample data

On completion, writes `tutorialComplete: true` to `AppSettings` in Isar.

Both phases are enforced by the GoRouter redirect logic — users cannot skip them.

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

---

## 10. Bank Statement Import Architecture

The statement import feature is a critical user-facing pipeline:

```
User taps "Upload Statement" banner (TransactionsScreen)
    │
    ▼
GoRouter.push('/transactions/upload')  → UploadStatementScreen
    │
    ▼
file_picker → user selects CSV or PDF
    │
    ├── CSV → StatementParser.parseCSV()
    │         └── Auto-detect columns, clean amounts, extract dates
    │
    └── PDF → StatementParser.parsePDF()
              ├── Try rule-based regex parser first
              └── Fall back to LLM parser if regex fails
    │
    ▼
Parsed transactions displayed in review list
    │
    ▼
User confirms → save to Isar + show AI summary dialog
```

The `UploadStatementScreen` provides:
- File type detection (CSV vs PDF by extension)
- A preview list of parsed transactions before saving
- Error handling with user-friendly messages
- Post-import AI summary dialog via `OfflineAIService.generateStatementSummary()`
