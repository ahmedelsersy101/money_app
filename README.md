# MoneyApp - Personal Finance Tracker 💰

A professional, modern personal finance management application built with Flutter. MoneyApp helps users track their daily transactions, manage multiple wallets (Cash & Bank), and gain deep insights into their spending habits through beautiful charts and statistics.

---

## ✨ Features

- **Multi-Wallet Management**: Maintain separate balances for Cash and Bank Accounts with a unified total balance display.
- **Transaction Tracking**: Easily record income and expenses with categories, notes, and specific accounts.
- **Professional Reports**:
  - Interactive Pie Charts for Income vs. Expense analysis.
  - Category-wise spending breakdown with visual progress bars.
  - Top 3 spending categories highlight.
- **Modern UI/UX**:
  - Gradient-based wallet cards for a premium feel.
  - Custom typography (Changa) for a sleek look.
  - Dark and Light mode support.
  - Responsive design powered by `flutter_screenutil`.
- **Localization**: Fully localized in **Arabic** and **English**, including RTL support.
- **Onboarding Flow**: Guided initial balance setup and currency selection.

---

## 🚀 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Bloc/Cubit](https://pub.dev/packages/flutter_bloc)
- **Dependency Injection**: [GetIt](https://pub.dev/packages/get_it)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Persistence**: [SharedPreferences](https://pub.dev/packages/shared_preferences)
- **Charts**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Internationalization**: [easy_localization](https://pub.dev/packages/easy_localization)
- **Architecture**: Clean Architecture approach with a feature-based folder structure.

---

## 🌟 App Screenshots | صور التطبيق

<div align="center">
  <img src="assets/expenses_banner.jpg" alt="App Banner" width="100%" style="border-radius: 12px;" />
</div>
---

## 🛠️ Getting Started

### Prerequisites

- Flutter SDK (latest version recommended)
- Android Studio / VS Code
- Dart SDK

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/money_app.git
   ```

2. **Navigate to the project directory:**

   ```bash
   cd money_app
   ```

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

```text
lib/
├── core/               # App-wide themes, constants, and routing
├── features/           # Feature-based folders
│   ├── home/           # Home, Wallets, and Reports
│   ├── add_transaction/# Transaction entry logic
│   ├── onboarding/     # Initial setup screens
│   └── ...
├── data/               # Models and repositories
└── main.dart           # App entry point
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙌 Implementation

Made with ❤️ by [Ahmed Elsersy](https://github.com/ahmedelsersy) (and Antigravity AI)

# money_app
