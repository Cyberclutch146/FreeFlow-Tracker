# 💸 FreelanceFlow

**FreelanceFlow** is a premium, offline-first personal finance and income tracking application built specifically for freelancers, tutors, and independent contractors. It combines stunning glassmorphism aesthetics with powerful on-device AI and automation to act as your personal financial assistant — with zero cloud dependencies.

---

## ✨ Key Features

### 🎨 Glassmorphism UI System

Built with a fully custom design system — no Material Widget defaults, no generic colors.

- **`GlassPanel`**: A reusable frosted-glass container using `BackdropFilter` + translucent backgrounds
- **Dynamic Theming**: Three curated themes — **Dark**, **OLED Black** (true `#000000`, battery-saver), and **Light**
- **Fluid Animations**: `flutter_animate` powers staggered load-ins, slide transitions, and micro-interactions
- **Glassmorphism palette**: Custom `AppColors` + `AppTextStyles` extensions on `BuildContext`

### 🧠 Triple-Layer Intelligence Engine

FreelanceFlow doesn't just track money — it understands patterns and advises you.

1. **Automated SMS Parsing** (`lib/services/sms/`)
   - Reads bank SMS directly from Android's telephony API
   - Handles 25+ Indian banks, UPI, card, NEFT, IMPS formats
   - Detects: debited, paid, withdrawn, purchase, used at, charged, received, credited, refund
   - Extracts merchant name, amount, bank, UPI ref ID, and payment method

2. **Unified Categorization Engine** (`lib/services/ai/category_classifier.dart`)
   - Single source of truth for all categorization — SMS pipeline AND AI engine use the same classifier
   - ~250 keywords across 8 categories covering Indian merchants, brands, and services
   - **Longest-match algorithm**: prevents false positives from short generic words
   - **User learning**: records manual re-categorizations and applies them to future SMS parsing

3. **Offline AI Assistant** (`lib/services/ai/offline_ai_service.dart`)
   - Zero API key, zero internet, zero latency
   - 12 intent categories with natural language matching
   - **Conversation memory**: follow-up questions ("and last month?" / "break that down") are detected and answered with deeper context
   - Covers: monthly summary, budget status, top expenses, savings advice, income target, goal progress, spending trends, category breakdown, recurring charges, daily averages, end-of-month projections

4. **Rule-Based Savings Advisor** (`lib/services/savings_advisor.dart`)
   - Detects goals ahead of / behind schedule
   - Identifies conflicting goal allocations vs. current savings
   - Celebrates milestones (25%, 50%, 75%, 100%)

5. **Insights Engine** (`lib/services/insights_engine.dart`)
   - 8 deterministic rules: spending spike, category spike, budget exceeded, budget warning, overdue project, recurring charge detection, income target progress, top merchant

### 💼 Income Source Tracking

- **Freelance Projects**: Track client name, project value, status (Ongoing/Completed/Unpaid), deadline, notes
- **Tutoring Students**: Manage name, subject, fee per session, schedule, active/inactive status
- **PDF Invoice Generation**: One-tap invoice PDF from any project, shareable via native share sheet

### 🎯 Goals & Budgets

- **Savings Goals**: Name, emoji, target amount, deadline, monthly allocation. AI calculates ETA.
- **Goal Contributions**: Track individual deposits toward each goal
- **Budgets**: Category-level monthly limits with real-time pacing and 80% warning threshold
- **Subscription Scanner**: Auto-detects recurring charges from transaction history

### 🔒 Privacy & Security

- **Biometric Lock**: Fingerprint/face/PIN via `local_auth`. App locks on background, unlocks on resume.
- **100% Local**: All data lives in Isar on-device. Zero cloud sync required.
- **Data Export**: CSV export for transactions, full JSON backup/restore for everything

---

## 🛠 Tech Stack

| Layer            | Technology                                                                   |
| ---------------- | ---------------------------------------------------------------------------- |
| Framework        | [Flutter](https://flutter.dev/) (Dart 3.x)                                   |
| State Management | [Riverpod](https://riverpod.dev/) (`flutter_riverpod` v2)                    |
| Local Database   | [Isar](https://isar.dev/) v3 — NoSQL, in-process, ultra-fast                 |
| Routing          | [GoRouter](https://pub.dev/packages/go_router) v17 — type-safe shell routing |
| Animations       | [flutter_animate](https://pub.dev/packages/flutter_animate)                  |
| Charts           | [fl_chart](https://pub.dev/packages/fl_chart)                                |
| PDF              | `pdf` + `printing`                                                           |
| SMS              | `telephony`                                                                  |
| Auth             | `local_auth` v3                                                              |
| Export/Share     | `share_plus`, `path_provider`, `csv`                                         |
| Fonts            | `google_fonts`                                                               |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK **3.11+** (tested on 3.41.x)
- Android Studio with an Android SDK (API 21+)
- A physical Android device or emulator with SMS capability for SMS features

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
│   ├── app_settings.dart
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
├── screens/                        # Feature-grouped UI screens
│   ├── ai/                         # ai_chat_screen.dart, ai_report_screen.dart
│   ├── goals/                      # Goals + Budgets tabs + add sheets
│   ├── home/                       # Dashboard + SMS review sheet
│   ├── income/                     # Projects + Students tabs + detail screens
│   ├── reports/                    # Charts and monthly report view
│   ├── settings/                   # App settings + Subscriptions screen
│   └── transactions/               # Transactions list + add sheet
├── services/                       # Business logic and integrations
│   ├── ai/
│   │   ├── category_classifier.dart  # ✅ UNIFIED categorizer (single source of truth)
│   │   └── offline_ai_service.dart   # Conversational AI engine
│   ├── export/
│   │   └── csv_export_service.dart
│   ├── pdf/
│   │   └── invoice_service.dart
│   ├── sms/
│   │   ├── sms_parser.dart          # Regex-based Indian bank SMS parser
│   │   └── sms_to_transaction.dart  # ParsedSms → Transaction converter
│   ├── auth_service.dart
│   ├── insights_engine.dart
│   ├── savings_advisor.dart
│   ├── sms_service.dart
│   └── subscription_scanner_service.dart
└── widgets/
    ├── budgets/
    ├── common/                     # GlassPanel, AppButton, EmptyState, etc.
    └── navigation/
        └── main_scaffold.dart      # Bottom nav shell
```

---

## 📱 Android Permissions

The following permissions are required and requested at runtime:

| Permission                          | Why                                                |
| ----------------------------------- | -------------------------------------------------- |
| `READ_SMS`                          | Read bank notification SMS for auto-categorization |
| `RECEIVE_SMS`                       | Listen for new incoming bank SMS in real-time      |
| `USE_BIOMETRIC` / `USE_FINGERPRINT` | Biometric lock screen                              |

---

## 🤝 Contributing

### Adding a new category keyword

Edit `lib/services/ai/category_classifier.dart` — add your keyword to the appropriate `Category` list. Use lowercase. The longest-match algorithm will handle specificity automatically.

### Adding a new Isar model

1. Create the model in `lib/models/` with `@collection` annotation
2. Add it to `DatabaseService.initialize()` in `lib/database/database_service.dart`
3. Run `flutter pub run build_runner build --delete-conflicting-outputs`
4. Create a repository in `lib/repositories/`
5. Expose it as a Riverpod provider in `lib/core/di/providers.dart`

### Theme contributions

All UI must use `context.colors` (AppColors) and `context.textStyles` (AppTextStyles) — never hardcode colors or font sizes
