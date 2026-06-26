# 💸 FreelanceFlow

**FreelanceFlow** is a premium, offline-first personal finance and income tracking application built specifically for freelancers, tutors, and independent contractors. It combines stunning glassmorphism aesthetics with powerful on-device AI and automation to act as your personal financial assistant — with zero cloud dependencies.

> **100% Private. Zero Cloud. Everything stays on your device.**

---

## ✨ Key Features

### 🎨 Glassmorphism UI System

Built with a fully custom design system — no Material Widget defaults, no generic colors.

- **`GlassPanel`**: A reusable frosted-glass container using `BackdropFilter` + translucent backgrounds
- **Dynamic Theming**: Three curated themes — **Dark**, **OLED Black** (true `#000000`, battery-saver), and **Light**
- **Fluid Animations**: `flutter_animate` powers staggered load-ins, slide transitions, and micro-interactions
- **Glassmorphism palette**: Custom `AppColors` + `AppTextStyles` extensions on `BuildContext`
- **Floating Navigation**: Custom glass-panel bottom nav bar with animated selection indicators

### 🧠 Triple-Layer Intelligence Engine

FreelanceFlow doesn't just track money — it understands patterns and advises you.

1. **Bank Statement Parser** (`lib/services/statement_parser.dart`)
   - **CSV Support**: Parses standard bank CSV exports with automatic column detection
   - **PDF Support**: Extracts tabular transaction data from bank-generated PDF statements using `syncfusion_flutter_pdf`
   - **LLM-Assisted Parsing**: Optional Google Generative AI integration for complex/non-standard PDF formats (`lib/services/ai/llm_parser_service.dart`)
   - **Non-AI Fallback**: Rule-based regex parsing for known bank PDF formats (e.g., PNB) — works fully offline
   - **Auto-Categorization**: Parsed transactions are automatically categorized using the unified `CategoryClassifier`
   - **Duplicate Detection**: Prevents re-importing already-existing transactions

2. **Unified Categorization Engine** (`lib/services/ai/category_classifier.dart`)
   - Single source of truth for all categorization — statement parser, SMS pipeline, AND AI engine use the same classifier
   - ~250 keywords across 8 categories covering Indian merchants, brands, and services
   - **Longest-match algorithm**: prevents false positives from short generic words
   - **User learning**: records manual re-categorizations and applies them to future parsing
   - **Direction-aware fallback**: uncategorized credit transactions default to `Category.income`

3. **Offline AI Assistant** (`lib/services/ai/offline_ai_service.dart`)
   - Zero API key, zero internet, zero latency
   - Accessible via a prominent banner on the Home dashboard — opens as a full-screen chat interface
   - 15+ intent categories with natural language matching
   - **Conversation memory**: follow-up questions ("and last month?" / "break that down") are detected and answered with deeper context
   - **Transaction search**: natural language queries like "find transactions over 500" or "show payments to Amazon"
   - **Spending habit tracking**: detects patterns in your spending behavior and provides actionable insights
   - **Statement summaries**: generates comprehensive summaries after uploading bank statements
   - Covers: monthly summary, budget status, top expenses, savings advice, income target, goal progress, spending trends, category breakdown, recurring charges, daily averages, end-of-month projections

4. **Rule-Based Savings Advisor** (`lib/services/savings_advisor.dart`)
   - Detects goals ahead of / behind schedule
   - Identifies conflicting goal allocations vs. current savings
   - Celebrates milestones (25%, 50%, 75%, 100%)

5. **Insights Engine** (`lib/services/insights_engine.dart`)
   - 8 deterministic rules: spending spike, category spike, budget exceeded, budget warning, overdue project, recurring charge detection, income target progress, top merchant

### 📊 Reports & Analytics

- **Monthly Reports**: Visual charts powered by `fl_chart` showing income vs expenses, category breakdowns, and spending trends
- **Category Pie Charts**: See exactly where your money goes each month
- **Trend Lines**: Track your financial trajectory over time

### 💼 Income Source Tracking

- **Freelance Projects**: Track client name, project value, status (Ongoing/Completed/Unpaid), deadline, notes
- **Tutoring Students**: Manage name, subject, fee per session, schedule, active/inactive status
- **PDF Invoice Generation**: One-tap invoice PDF from any project, shareable via native share sheet

### 🎯 Goals & Budgets

- **Savings Goals**: Name, emoji, target amount, deadline, monthly allocation. AI calculates ETA.
- **Goal Contributions**: Track individual deposits toward each goal
- **Budgets**: Category-level monthly limits with real-time pacing and 80% warning threshold
- **Subscription Scanner**: Auto-detects recurring charges from transaction history

### 📤 Bank Statement Upload

- **CSV Import**: Upload CSV bank statements directly from your file manager
- **PDF Import**: Extract transactions from bank-generated PDF statements
- **Prominent Upload UI**: Clearly accessible from the Transactions screen header
- **Post-Upload Summary**: AI generates a spending summary after every successful import

### 🎓 Interactive Onboarding & Tutorial

- **3-Step Onboarding**: Currency selection, theme preference, and income goal setup
- **Feature Tour**: Full-screen interactive slideshow with mini UI mockups explaining every feature
- **Automatic Flow**: Router-level redirect ensures new users always see onboarding → tutorial → dashboard

### 🔒 Privacy & Security

- **Biometric Lock**: Fingerprint/face/PIN via `local_auth`. App locks on background, unlocks on resume.
- **100% Local**: All data lives in Isar on-device. Zero cloud sync required.
- **Data Export**: CSV export for transactions, full JSON backup/restore for everything

---

## 🛠 Tech Stack

| Layer            | Technology                                                                   |
| ---------------- | ---------------------------------------------------------------------------- |
| Framework        | [Flutter](https://flutter.dev/) (Dart 3.x)                                  |
| State Management | [Riverpod](https://riverpod.dev/) (`flutter_riverpod` v2)                    |
| Local Database   | [Isar](https://isar.dev/) v3 — NoSQL, in-process, ultra-fast                |
| Routing          | [GoRouter](https://pub.dev/packages/go_router) v17 — type-safe shell routing|
| Animations       | [flutter_animate](https://pub.dev/packages/flutter_animate)                  |
| Charts           | [fl_chart](https://pub.dev/packages/fl_chart)                                |
| PDF Generation   | `pdf` + `printing`                                                           |
| PDF Parsing      | `syncfusion_flutter_pdf`                                                     |
| AI (Optional)    | `google_generative_ai` — only for complex PDF parsing fallback               |
| Auth             | `local_auth` v3                                                              |
| File Picking     | `file_picker`                                                                |
| Export/Share     | `share_plus`, `path_provider`, `csv`                                         |
| Fonts            | `google_fonts`                                                               |
| Markdown         | `flutter_markdown`                                                           |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK **3.11+** (tested on 3.41.x)
- Android Studio with an Android SDK (API 21+)
- A physical Android device or emulator

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/freelanceflow.git
cd freelanceflow

# 2. Install dependencies
flutter pub get

# 3. Accept Android licenses (first-time setup)
flutter doctor --android-licenses

# 4. Run on connected device/emulator
flutter run
```

### Building a Release APK

```bash
flutter build apk
# Output: build/app/outputs/flutter-apk/app-release.apk (~70MB)
```

### Code Generation

If you modify any Isar `@collection` model or add a new Riverpod `@riverpod` provider:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📁 Project Structure

```
lib/
├── main.dart               # Entry point — DB init, orientation lock, app bootstrap
├── app.dart                # Root widget — biometric lock, theme, lifecycle listener
├── core/
│   ├── constants/
│   │   └── app_constants.dart      # All enums (Category, PaymentMethod, etc.) + constants
│   ├── di/
│   │   └── providers.dart          # All Riverpod providers (except routerProvider)
│   ├── router/
│   │   └── app_router.dart         # GoRouter config — shell + top-level routes
│   ├── theme/
│   │   ├── app_colors.dart         # AppColors ThemeExtension + context.colors
│   │   ├── app_text_styles.dart    # AppTextStyles + context.textStyles
│   │   ├── app_theme.dart          # MaterialTheme builder from ThemeConfig
│   │   └── theme_config.dart       # ThemeConfig: darkMode, oledMode, lightMode
│   └── utils/
│       ├── currency_formatter.dart # ₹ formatting helper
│       ├── date_helpers.dart       # Month name, date range utilities
│       └── extensions.dart         # String.fastHash (Isar ID), String.capitalize
├── database/
│   ├── database_service.dart       # Isar init, clearAll, exportAllJson, importFromJson
│   └── migrations/
│       └── migration_v1.dart       # Creates default AppSettings on first launch
├── models/                         # Isar @collection entities + toJson/fromJson
│   ├── advisor_card.dart
│   ├── app_settings.dart           # Includes onboardingComplete & tutorialComplete flags
│   ├── budget.dart
│   ├── goal_contribution.dart
│   ├── insight_card.dart
│   ├── project.dart
│   ├── savings_goal.dart
│   ├── session.dart
│   ├── sms_raw_log.dart
│   ├── student.dart
│   └── transaction.dart
├── repositories/                   # Isar CRUD + Stream abstraction layer
│   ├── budget_repository.dart
│   ├── goal_repository.dart
│   ├── project_repository.dart
│   ├── settings_repository.dart
│   ├── student_repository.dart
│   └── transaction_repository.dart
├── screens/
│   ├── ai/
│   │   ├── ai_chat_screen.dart     # Full-screen AI chat (pushed from dashboard banner)
│   │   └── ai_report_screen.dart   # AI-generated financial report
│   ├── goals/                      # Goals + Budgets tabs + add sheets
│   ├── home/
│   │   └── home_screen.dart        # Dashboard with AI banner + financial snapshot
│   ├── income/                     # Projects + Students tabs + detail screens
│   ├── reports/
│   │   └── reports_screen.dart     # Charts and monthly report view (bottom nav tab)
│   ├── settings/
│   │   ├── onboarding_screen.dart  # 3-step first-launch setup (currency, theme, goal)
│   │   ├── settings_screen.dart    # App preferences, export, backup
│   │   ├── subscriptions_screen.dart # Detected recurring subscriptions
│   │   └── tutorial_screen.dart    # Full-screen interactive feature tour
│   ├── splash/                     # Splash screen with routing redirect
│   └── transactions/
│       ├── add_transaction_sheet.dart      # Manual transaction entry
│       ├── split_transaction_sheet.dart    # Split a transaction across categories
│       ├── transactions_screen.dart        # Transaction list with upload banner
│       └── upload_statement_screen.dart    # CSV/PDF bank statement import
├── services/
│   ├── ai/
│   │   ├── category_classifier.dart   # ✅ UNIFIED categorizer (single source of truth)
│   │   ├── llm_parser_service.dart    # Google AI PDF parsing fallback
│   │   └── offline_ai_service.dart    # Conversational AI engine (15+ intents)
│   ├── export/
│   │   └── csv_export_service.dart
│   ├── notification/                  # Local notification scheduling
│   ├── pdf/
│   │   └── invoice_service.dart       # PDF invoice generation for projects
│   ├── auth_service.dart              # Biometric authentication
│   ├── insights_engine.dart           # 8-rule deterministic insights
│   ├── savings_advisor.dart           # Goal pace prediction + advice
│   ├── statement_parser.dart          # CSV + PDF bank statement parser
│   └── subscription_scanner_service.dart # Recurring charge detection
└── widgets/
    ├── budgets/                    # Budget card widgets
    ├── common/                     # GlassPanel, AppButton, EmptyState, LiquidBackground
    ├── navigation/
    │   └── main_scaffold.dart      # Floating glass bottom nav (5 tabs)
    └── transactions/               # Transaction list item widgets
```

---

## 🗺 Navigation Architecture

FreelanceFlow uses a two-tier GoRouter routing architecture with automatic onboarding/tutorial redirects:

### Routing Flow (New User)

```
/splash → /onboarding → /tutorial → /home
```

### Shell Routes (Bottom Navigation Visible)

| Route           | Screen              | Tab Label |
| --------------- | ------------------- | --------- |
| `/home`         | HomeScreen          | Home      |
| `/transactions` | TransactionsScreen  | Txns      |
| `/income`       | IncomeScreen        | Income    |
| `/goals`        | GoalsScreen         | Goals     |
| `/reports`      | ReportsScreen       | Reports   |

### Top-Level Routes (Full-Screen, No Bottom Nav)

| Route                  | Screen                 | Purpose                          |
| ---------------------- | ---------------------- | -------------------------------- |
| `/settings`            | SettingsScreen         | App preferences and data export  |
| `/ai-chat`             | AiChatScreen           | Full-screen AI assistant         |
| `/ai-report`           | AiReportScreen         | AI-generated financial report    |
| `/project-detail/:id`  | ProjectDetailScreen    | Freelance project detail view    |
| `/student-detail/:id`  | StudentDetailScreen    | Tutoring student detail view     |
| `/subscriptions`       | SubscriptionsScreen    | Detected recurring subscriptions |
| `/onboarding`          | OnboardingScreen       | First-launch setup               |
| `/tutorial`            | TutorialScreen         | Interactive feature tour         |
| `/splash`              | SplashScreen           | Loading + initial routing        |

---

## 📱 Android Permissions

| Permission                          | Why                                           |
| ----------------------------------- | --------------------------------------------- |
| `READ_EXTERNAL_STORAGE`             | Pick CSV/PDF bank statement files for import   |
| `USE_BIOMETRIC` / `USE_FINGERPRINT` | Biometric lock screen                          |

---

## 🤝 Contributing

### Adding a new category keyword

Edit `lib/services/ai/category_classifier.dart` — add your keyword to the appropriate `Category` list. Use lowercase. The longest-match algorithm will handle specificity automatically.

### Adding a new AI intent

Edit `lib/services/ai/offline_ai_service.dart`:
1. Add the intent name to the `_classifyIntent()` keyword map
2. Create a handler method `_handleYourIntent()`
3. Wire it into `_dispatch()`

### Adding a new Isar model

1. Create the model in `lib/models/` with `@collection` annotation
2. Add it to `DatabaseService.initialize()` in `lib/database/database_service.dart`
3. Run `flutter pub run build_runner build --delete-conflicting-outputs`
4. Create a repository in `lib/repositories/`
5. Expose it as a Riverpod provider in `lib/core/di/providers.dart`

### Adding a new bank statement format

Edit `lib/services/statement_parser.dart`:
1. Add a new format detection method (e.g., `_detectBankXFormat()`)
2. Implement the parsing logic for that bank's CSV/PDF layout
3. Wire it into `parseCSV()` or `parsePDF()`

### Theme contributions

All UI must use `context.colors` (AppColors) and `context.textStyles` (AppTextStyles) — never hardcode colors or font sizes.

---

## 📄 License

This project is private and not licensed for redistribution.
