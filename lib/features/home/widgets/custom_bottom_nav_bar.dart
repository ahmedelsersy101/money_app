import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'home'.tr(), // Using 'start' as 'Home' for now or add 'home' key
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_balance_wallet),
          label: 'wallets'.tr(),
        ),
        BottomNavigationBarItem(icon: const Icon(Icons.pie_chart), label: 'reports'.tr()),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: 'settings'.tr(),
        ),
      ],
    );
  }
}
