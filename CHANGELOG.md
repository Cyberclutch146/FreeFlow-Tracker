# Changelog

All notable changes to FreelanceFlow are documented here.

---

## [Unreleased] — In Development

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

### Documentation
- `README.md` — Full rewrite: removed Gemini references, documented offline AI, proper folder tree, Android permissions table, tech stack table
- `ARCHITECTURE.md` — Full rewrite: accurate intelligence engine docs, OLED theme docs, unified categorizer docs, SMS sync architecture, proper data flow diagrams
- `CHANGELOG.md` — This file

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
