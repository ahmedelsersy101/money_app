import 'package:flutter/material.dart';
import 'routes.dart';
import '../../features/splash/splash_view.dart';
import '../../features/onboarding/onboarding_view.dart';
import '../../features/language_theme_selection/language_theme_selection_view.dart';
import '../../features/home/views/home_view.dart';

/// Application Router
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return _buildRoute(const SplashView(), settings);
      case Routes.onboarding:
        return _buildRoute(const OnboardingView(), settings);
      case Routes.languageThemeSelection:
        return _buildRoute(const LanguageThemeSelectionView(), settings);
      case Routes.home:
        return _buildRoute(const HomeView(), settings);
      default:
        return _buildRoute(
          Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))),
          settings,
        );
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndReplace(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndRemoveUntil(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false, arguments: arguments);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
