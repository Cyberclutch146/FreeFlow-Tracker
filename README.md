# 💸 FreelanceFlow

**FreelanceFlow** is a premium, offline-first personal finance and income tracking application built specifically for freelancers, tutors, and independent contractors. It combines beautiful, fluid "liquid glass" aesthetics with powerful on-device automation and artificial intelligence to act as your personal Chief Financial Officer.

---

## ✨ Key Features

### 🎨 Stunning "Liquid Glass" Interface
Built from the ground up with a completely custom design system.
*   **Dynamic Glassmorphism**: Frosted glass panels (`GlassPanel`) that beautifully blur the animated liquid backgrounds behind them.
*   **Fluid Animations**: Fully integrated with `flutter_animate` for staggered load-ins, smooth micro-interactions, and satisfying transitions.
*   **Custom Theming**: Choose between multiple curated color palettes (e.g., Midnight Purple, Ocean Teal, Sunset Orange) that persist instantly via Isar.

### 🧠 Triple-Threat Intelligence Engine
FreelanceFlow doesn't just track your money—it understands it.

1.  **Automated SMS Parsing**: Connects directly to Android's telephony API to read incoming bank SMS messages. It uses an advanced RegEx engine tuned for Indian banking formats to automatically categorize and log "Unconfirmed Transactions" while you sleep.
2.  **Rule-Based Savings Advisor**: A local, deterministic engine that analyzes your cash flow against your active savings goals. It proactively warns you if you are behind schedule, identifies conflicting goals, and celebrates milestones.
3.  **Gemini AI Integration**: Connect your own Google Gemini API key to unlock a powerful Chat Assistant and Monthly Report generator. It securely reads your local transaction history to answer natural language questions (e.g., *"How much did I spend on food this month compared to last?"*).

### 💼 Income Source Tracking
Unlike standard budget apps, FreelanceFlow tracks *where* your money comes from.
*   **Freelance Projects**: Track clients, hourly rates, overall project value, and status (Ongoing, Completed, Unpaid).
*   **Tutoring Students**: Manage students, grade levels, subjects, and hourly rates in dedicated hub screens.

### 🎯 Goals & Budgets
*   **Smart Budgets**: Set category-specific monthly limits. The app tracks your pacing dynamically.
*   **Savings Goals**: Define target amounts and deadlines. The app calculates the exact monthly allocation required to hit your goal on time.

### 💾 100% Offline & Private
Your financial data is yours. 
*   Powered by the **Isar Database**, offering lightning-fast, synchronous local storage.
*   Zero cloud dependencies (except for optional Gemini AI calls).
*   **Data Export**: Instantly export your transactions to CSV, or backup your entire database to JSON and share it via the native iOS/Android share sheet.

---

## 🛠 Tech Stack

*   **Framework**: [Flutter](https://flutter.dev/) (Dart)
*   **State Management & DI**: [Riverpod](https://riverpod.dev/) (`flutter_riverpod`, `riverpod_annotation`)
*   **Local Database**: [Isar](https://isar.dev/) (NoSQL, ultra-fast)
*   **Routing**: [GoRouter](https://pub.dev/packages/go_router) (Type-safe, shell routing)
*   **Animations**: [Flutter Animate](https://pub.dev/packages/flutter_animate)
*   **AI SDK**: [Google Generative AI](https://pub.dev/packages/google_generative_ai)
*   **Platform Integrations**: `telephony` (SMS reading), `share_plus` (Data sharing), `path_provider`

---

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK (v3.22+)
*   Android Studio / Xcode (for emulation)
*   *(Optional)* A free Google Gemini API Key from [Google AI Studio](https://aistudio.google.com/).

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/freelanceflow.git
    cd freelanceflow
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Generate Isar schemas and Riverpod code**
    If you make changes to the data models, you must re-run the build runner:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app**
    ```bash
    flutter run
    ```

---

## 📱 App Structure Overview

*   **`lib/core/`**: Centralized configurations including dependency injection (`providers.dart`), routing, and the `AppColors`/`AppTextStyles` design system.
*   **`lib/database/`**: Isar database initialization and migrations.
*   **`lib/models/`**: Isar collections (`Transaction`, `SavingsGoal`, `Budget`, `Project`, etc.).
*   **`lib/repositories/`**: Abstraction layer over Isar collections for CRUD operations.
*   **`lib/screens/`**: UI views grouped by feature (Home, Transactions, Income, Goals, Settings, AI).
*   **`lib/services/`**: Core business logic.
    *   `ai/gemini_service.dart`: Handles AI API calls and rate limiting.
    *   `export/csv_export_service.dart`: Data backup generation.
    *   `sms/`: SMS listening, parsing, and categorization logic.
    *   `insights_engine.dart` & `savings_advisor.dart`: Rule-based deterministic analysis.
*   **`lib/widgets/`**: Reusable UI components like `GlassPanel` and `LiquidBackground`.

---

## 🤝 Contributing

Contributions are welcome! If you're adding new database models, remember to annotate them with `@collection` and run the build runner. For UI contributions, please ensure you utilize the `context.colors` and `context.textStyles` extensions to maintain the Glassmorphism theme.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
