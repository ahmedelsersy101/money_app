import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/theme/colors.dart';
import '../../core/widgets/custom_button.dart';
import 'initial_balance_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      titleKey: 'onboarding_title_1',
      descriptionKey: 'onboarding_desc_1',
      accent: AppColors.primary,
    ),
    OnboardingData(
      titleKey: 'onboarding_title_2',
      descriptionKey: 'onboarding_desc_2',
      accent: AppColors.secondary,
    ),
    OnboardingData(
      titleKey: 'onboarding_title_3',
      descriptionKey: 'onboarding_desc_3',
      accent: AppColors.accent,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToHome();
    }
  }

  Future<void> _navigateToHome() async {
    // Navigate to Initial Balance screen instead of persisting 'is_first_time' immediately
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InitialBalanceView()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 350),
                child: TextButton(
                  onPressed: _navigateToHome,
                  child: Text(
                    'skip'.tr(),
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14),
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: CustomButton(
                  text: _currentPage == _pages.length - 1 ? 'get_started'.tr() : 'next'.tr(),
                  onPressed: _nextPage,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Colors.white),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
              child: Center(
                child: SvgPicture.asset(
                  _pages.indexOf(data) == 0
                      ? 'assets/images/onboarding1.svg'
                      : _pages.indexOf(data) == 1
                      ? 'assets/images/onboarding2.svg'
                      : 'assets/images/onboarding3.svg',
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            data.titleKey.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            data.descriptionKey.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.6, color: Colors.white.withOpacity(0.82)),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildHighlights(Color accent) {
    final highlights = [
      'onboarding_feature_1'.tr(),
      'onboarding_feature_2'.tr(),
      'onboarding_feature_3'.tr(),
    ];

    return Column(
      children: highlights
          .map(
            (text) => Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class OnboardingData {
  final String titleKey;
  final String descriptionKey;
  final Color accent;

  OnboardingData({required this.titleKey, required this.descriptionKey, required this.accent});
}
