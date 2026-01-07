import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/di/injection_container.dart' as di;
import '../../core/routes/routes.dart';
import '../../core/theme/colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToNext();
  }

  void _setupAnimations() {
    _controller = AnimationController(duration: const Duration(milliseconds: 1600), vsync: this);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  void _navigateToNext() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final prefs = di.sl<SharedPreferences>();
        final isFirstTime = prefs.getBool('is_first_time') ?? true;

        if (isFirstTime) {
          Navigator.pushReplacementNamed(context, Routes.languageThemeSelection);
        } else {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 30,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    'assets/images/splashLogo.svg',
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
