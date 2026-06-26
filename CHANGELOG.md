# Changelog

All notable changes to FreelanceFlow are documented here.

---

## [0.2.0] — 2026-06-26

### Added

#### Bank Statement Parser
- `lib/services/statement_parser.dart` — Full CSV and PDF bank statement parser
  - CSV: auto-detects column layout from headers, handles Indian bank formats (PNB, SBI, HDFC, ICICI, etc.)
  - PDF: rule-based regex extraction for known formats (PNB), with fallback to LLM-assisted parsing
  - Duplicate detection prevents re-importing existing transactions
  - Post-import auto-categorization via unified `CategoryClassifier`
- `lib/services/ai/llm_parser_service.dart` — Google Generative AI integration for complex PDF formats
- `lib/screens/transactions/upload_statement_screen.dart` — File picker UI with parsed transaction preview and AI summary dialog

#### AI Assistant Overhaul
- **Full-screen AI Chat**: `AiChatScreen` is now a top-level pushed route (`/ai-chat`), no longer embedded in a bottom nav tab. This eliminates the chatbox overlay issue where the floating nav bar covered the text input.
- **Dashboard AI Banner**: Prominent "Ask AI Assistant" banner on `HomeScreen` with gradient icon, opening the full-screen chat on tap
- **Transaction Search**: AI can now parse natural language queries like "find transactions over 500" or "show payments to Amazon" — extracts amount thresholds and merchant names
- **Statement Summaries**: `OfflineAIService.generateStatementSummary()` produces a spending breakdown after every bank statement import
- **Habit Tracking**: AI detects spending patterns over time and surfaces behavioral insights
- **Extended `_FinancialContext`**: Now carries `allTransactions` and `thisMonth` lists for deeper AI analysis

#### Interactive Tutorial
- `lib/screens/settings/tutorial_screen.dart` — Full-screen 4-page slideshow tutorial
  - Each page features a miniature UI component mockup (GlassPanel balance card, AI banner replica, upload button, savings progress bar)
  - Automatic redirect: GoRouter forces new users through onboarding → tutorial → dashboard
  - `tutorialComplete` flag added to `AppSettings` model (Isar, with `build_runner` regeneration)
- **Replaced `tutorial_coach_mark` overlay**: The previous coach mark approach had persistent alignment issues with animated widgets. The full-screen slideshow is far more reliable and polished.

#### Onboarding Improvements
- Removed SMS permission step from onboarding flow (SMS parsing is no longer a core feature — replaced by bank statement upload)
- Reduced onboarding from 4 steps to 3: Welcome → Preferences → Income Goal

#### Upload Statement Prominence
- Added a prominent "Upload Bank Statement" banner at the top of `TransactionsScreen`
- Statement upload is now the primary recommended way to get transaction data into the app

#### Navigation Updates
- Reports screen restored to the 5th bottom nav tab (was briefly replaced by AI Hub)
- AI Chat moved to a dedicated full-screen route with a proper back button
- Bottom nav labels: Home, Txns, Income, Goals, Reports

### Changed
- `lib/core/router/app_router.dart` — Added `/tutorial` and `/ai-chat` routes, three-stage redirect chain (onboarding → tutorial → home)
- `lib/widgets/navigation/main_scaffold.dart` — Simplified: removed `tutorial_coach_mark` dependency and all coach mark logic. Clean `ConsumerStatefulWidget` with just nav bar rendering
- `lib/screens/home/home_screen.dart` — Added AI banner widget, removed `TutorialKeys` references
- `lib/screens/ai/ai_chat_screen.dart` — Added `go_router` import and proper `AppBar` with `leading` back button
- `lib/models/app_settings.dart` — Added `tutorialComplete` field
- `lib/services/ai/offline_ai_service.dart` — Added `allTransactions` and `thisMonth` to `_FinancialContext`, added `transaction_search`, `statement_summary`, and `habit_tracking` intents

### Removed
- `lib/core/utils/tutorial_keys.dart` — Deleted (was used by the removed coach mark system)
- `tutorial_coach_mark` package — Removed from `pubspec.yaml`
- SMS permission step from onboarding — No longer needed since the app relies on bank statement uploads

### Documentation
- `README.md` — Full rewrite: documented bank statement parser, updated project structure tree, added navigation architecture section, updated permissions table, added contributing guides for new AI intents and bank formats
- `ARCHITECTURE.md` — Full rewrite: added bank statement import architecture with data flow diagram, documented tutorial/onboarding flow, updated routing section with redirect chain, expanded AI engine docs with new intents
- `CHANGELOG.md` — This entry

---

## [0.1.1] — 2026-06-26

### Fixed
- **AI Engine — Conversation Memory**: `_history` list is now actually used to detect follow-up questions. Asking "and last month?" or "explain more" after a summary now returns a deeper breakdown instead of a random response.
- **AI Engine — Follow-up chaining**: `_lastIntent` is now read and used in `_isFollowUp()` and `_handleFollowUp()`. Context-aware follow-up responses are now functional.
- **AI Engine — January month bug**: `DateTime(year, month - 1)` when month=1 now correctly resolves to December of the prior year using explicit `year-1, month=12` logic.
- **AI Engine — `getQuickInsight` empty context**: Now accepts `goals`, `budgets`, and `settings` parameters so budget/goal queries via quick insight work correctly.
- **AI Engine — Error safety**: `chat()` is now wrapped in try/catch. Any unexpected error returns a graceful message instead of crashing the chat screen.
- **AI Engine — Duplicate tips**: `_handleSavingsAdvice` no longer picks the same tip twice. Uses shuffle+take(2) for guaranteed unique selection.
- **Categorization — Three competing systems unified**: `AutoCategorizer`, `CategoryClassifier`, and `CategoryKeywords` (3 separate implementations with contradicting results) merged into a single `CategoryClassifier` with ~250 keywords, longest-match algorithm, and user-correction learning.
- **SMS Parser — Missing debit patterns**: Added `withdrawn`, `withdrawal`, `purchase`, `used at`, `charged`, `trf to`, `imps/neft sent` as debit signals.
- **SMS Parser — Merchant regex**: Now handles hyphens, ampersands, slashes, and apostrophes in merchant names (e.g., H&M, 7-Eleven, Pizza-Hut).
- **SMS Parser — Card detection**: Added `_isCardTransaction()` to detect card payments from "Card XX used at..." patterns.
- **SMS Parser — Bank coverage**: Expanded from 7 to 25+ banks including Yes Bank, IndusInd, IDFC FIRST, Federal Bank, Bank of Baroda, Canara Bank, UCO Bank, Paytm, PhonePe, Google Pay.
- **Providers — Double parsing**: `_runSync` no longer parses each SMS twice. Single parse point at `SmsParser.parseMessage()`.
- **Providers — Sync batch duplicates**: `existingTxns` list is updated after each save within a sync batch so transactions can't be saved twice in a single run.
- **Providers — AI service singleton**: `geminiServiceProvider` now uses `ref.keepAlive()` so `OfflineAIService` state (conversation history, turn count, last intent) persists across navigation.
- **Home Screen — Balance calculation**: Dashboard now shows current-month totals by default. Added "This Month / All Time" toggle chips.
- **Home Screen — Review button wired**: "Review" button on the unconfirmed SMS banner now opens `ReviewSmsSheet`.
- **Home Screen — See All wired**: "See All" on recent transactions now navigates to `/transactions`.
- **Home Screen — Notification bell**: Now navigates to Settings (placeholder until notification center is built).
- **OLED Theme**: `AppThemeMode.oled` now returns `ThemeConfig.oledMode` with true `#000000` background instead of falling through to `#121212` dark mode.
- **Auth Service**: Removed deprecated `biometricOnly` parameter (removed in `local_auth` v3). Now uses plain `authenticate()` with typed `PlatformException` catch.

### Removed (Dead Code)
- `lib/models/enums.dart` — Empty file (enums are in `app_constants.dart`)
- `lib/core/router/app_router.dart` — Replaced with proper module
- `lib/core/database/database_provider.dart` — Empty file
- `lib/core/constants/category_keywords.dart` — Unused duplicate categorizer
- `lib/services/categorization/auto_categorizer.dart` — Replaced by unified `CategoryClassifier`
- `lib/services/categorization/` — Empty directory after removing auto_categorizer
- `lib/services/insights/` — Empty placeholder directory
- `lib/services/advisor/` — Empty placeholder directory
- `lib/services/csv/` — Empty placeholder directory
- `lib/core/widgets/` — Empty placeholder directory
- Root-level Python scaffolding scripts moved to `scripts/`

### Added
- `ThemeConfig.oledMode` — True black (`#000000`) OLED theme config
- `CategoryClassifier.learnFromCorrection()` — User correction learning API
- `CategoryClassifier.classifyWithDirection()` — Direction-aware categorization with income fallback
- `OfflineAIService.conversationSummary` — Read-only getter for current session history
- `OfflineAIService._isFollowUp()` — Follow-up intent detection
- `OfflineAIService._handleFollowUp()` — Context-aware deeper response routing
- `lib/core/router/app_router.dart` — Dedicated router module (extracted from providers.dart)
- `scripts/` — Moved all build/setup Python scripts out of project root

---

## [0.1.0] — Initial Release

- Core transaction tracking (add/delete, SMS auto-import)
- Income source tracking (Projects + Students)
- Goals & Budgets
- Offline AI chat
- Glassmorphism UI with 3 theme modes
- Data export (CSV + JSON backup)
- PDF invoice generation
- Biometric lock
