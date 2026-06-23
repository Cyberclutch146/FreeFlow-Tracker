# Architecture & Design Decisions

This document details the architectural patterns, state management strategies, and design decisions behind **FreelanceFlow**.

## 1. Core Architecture Pattern

FreelanceFlow follows a **Feature-First Layered Architecture** adapted for Flutter. 

*   **Data Layer (`lib/models`, `lib/database`)**: Represents the raw Isar entities and the database initialization logic. Models are strictly data containers with `toJson`/`fromJson` helpers.
*   **Repository Layer (`lib/repositories`)**: Abstracts the database operations. Repositories (e.g., `BudgetRepository`) expose simple `Future` methods for one-off reads/writes and `Stream` methods for reactive UI updates.
*   **Service Layer (`lib/services`)**: Contains the core business logic and background engines. Services like `SavingsAdvisor` and `GeminiService` observe data from repositories and compute results, separating heavy logic from the UI.
*   **Presentation Layer (`lib/screens`, `lib/widgets`)**: Contains the UI. Screens watch Riverpod providers to rebuild reactively when data changes.

## 2. State Management: Riverpod

[Riverpod](https://riverpod.dev/) is used exclusively for state management and dependency injection.
Instead of passing repositories and services through constructors, we expose them as global providers in `lib/core/di/providers.dart`.

### Key Provider Patterns:
1.  **Repository Providers**: `Provider<T>` exposing singletons of repositories.
    ```dart
    final transactionRepositoryProvider = Provider((ref) => TransactionRepository());
    ```
2.  **Reactive Streams**: `StreamProvider<List<T>>` used to watch Isar database queries. When the database changes, the stream yields a new list, and any UI watching this provider rebuilds automatically.
    ```dart
    final recentTransactionsProvider = StreamProvider((ref) {
      return ref.watch(transactionRepositoryProvider).watchRecent(10);
    });
    ```
3.  **Computed Providers**: The `SavingsAdvisor` and `InsightsEngine` are exposed as providers that themselves watch the database streams, compute insights, and yield results to the UI.

## 3. Local Storage: Isar Database

We chose [Isar](https://isar.dev/) for its exceptional performance on mobile and its synchronous, type-safe API.
*   **Offline-First**: All data is stored locally. The app requires no internet connection to function (aside from the Gemini AI features).
*   **Reactivity**: We heavily utilize Isar's `watch()` functionality. The UI never has to manually refresh after a write operation; the database pushes the change through the stream.

## 4. Theming System: Dynamic Glassmorphism

The UI relies on a highly customized, dynamic theme system rather than standard Material Design.
*   **`ThemeConfig` & `AppColors`**: We define custom color tokens (`accentPurple`, `backgroundElevated`, etc.) via `ThemeExtension`.
*   **Live Switching**: The selected theme is stored in the `AppSettings` Isar collection. Changing the theme updates the database, which streams the change to `themeConfigProvider`, instantly repainting the entire app.
*   **`LiquidBackground`**: A global animated background widget that provides the flowing gradient aesthetic.
*   **`GlassPanel`**: A highly reusable container widget that applies a `BackdropFilter` (blur), a semi-transparent background color, and a subtle white border to achieve the frosted glass effect.

## 5. Background Engines

### SMS Parser (`lib/services/sms`)
*   Uses the `telephony` package to request SMS permissions and read the inbox.
*   The `SmsParser` uses regex patterns tailored to Indian banking notifications (e.g., `Rs. 450.00 debited from A/c XX123`).
*   The `AutoCategorizer` runs the parsed SMS through a keyword dictionary (e.g., "SWIGGY" -> Food) before saving it as an Unconfirmed Transaction.

### Savings Advisor (`lib/services/savings_advisor.dart`)
A deterministic engine that evaluates a user's financial health.
*   **Capabilities**: Calculates pacing, detects conflicting goals, identifies achievable goals, and tracks milestones.
*   Outputs structured `AdvisorCard` objects that the UI renders.

### Gemini AI Engine (`lib/services/ai/gemini_service.dart`)
*   Acts as an intelligent layer on top of the deterministic engines.
*   **Context Injection**: The service pulls the last 50 transactions and active goals, formats them into a minified text string, and injects them into the Gemini System Prompt.
*   **Rate Limiting**: To respect the Gemini API free tier, a memory-based `RateLimiter` restricts calls to 14 requests per minute, preventing HTTP 429 errors.

## 6. Routing: GoRouter

We use `go_router` for declarative routing.
*   **`StatefulShellRoute`**: Used to implement the bottom navigation bar. It keeps the state of each tab (Home, Transactions, Income, Goals, Reports) alive when switching between them.
*   **Top-Level Routes**: Screens like Settings and AI Chat are pushed on top of the shell route to hide the bottom navigation bar and provide a full-screen focus.
