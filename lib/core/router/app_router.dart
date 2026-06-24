import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/navigation/main_scaffold.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/transactions/transactions_screen.dart';
import '../../screens/income/income_screen.dart';
import '../../screens/goals/goals_screen.dart';
import '../../screens/reports/reports_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/settings/subscriptions_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/ai/ai_chat_screen.dart';
import '../../screens/ai/ai_report_screen.dart';
import '../../screens/income/project_detail_screen.dart';
import '../../screens/income/student_detail_screen.dart';
import '../../screens/settings/onboarding_screen.dart';
import '../di/providers.dart';

/// The application router, defined as a Riverpod [Provider] so it can be
/// watched by the root [MaterialApp.router].
///
/// Route layout:
/// - Shell routes (bottom nav preserved): /home, /transactions, /income, /goals, /reports
/// - Top-level (full-screen, no bottom nav): /settings, /ai-chat, /ai-report,
///   /project-detail/:id, /student-detail/:id, /subscriptions
final routerProvider = Provider<GoRouter>((ref) {
  final settingsAsync = ref.watch(settingsProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      if (settingsAsync is AsyncLoading) return null;
      if (state.matchedLocation == '/splash') return null;
      
      final settings = settingsAsync.valueOrNull;
      final isComplete = settings?.onboardingComplete ?? false;
      
      if (!isComplete && state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }
      
      if (isComplete && state.matchedLocation == '/onboarding') {
        return '/home';
      }
      
      return null;
    },
    routes: [
      // ── Bottom-tab shell ────────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/transactions', builder: (context, state) => const TransactionsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/income', builder: (context, state) => const IncomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/goals', builder: (context, state) => const GoalsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/reports', builder: (context, state) => const ReportsScreen())],
          ),
        ],
      ),

      // ── Full-screen routes (push on top, no bottom nav) ─────────────────
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(path: '/ai-chat', builder: (context, state) => const AiChatScreen()),
      GoRoute(path: '/ai-report', builder: (context, state) => const AiReportScreen()),
      GoRoute(
        path: '/project-detail/:id',
        builder: (context, state) =>
            ProjectDetailScreen(projectId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/student-detail/:id',
        builder: (context, state) =>
            StudentDetailScreen(studentId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/subscriptions', builder: (context, state) => const SubscriptionsScreen()),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
});
