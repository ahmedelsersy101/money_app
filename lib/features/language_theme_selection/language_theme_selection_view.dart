// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_app/core/routes/routes.dart';
import '../../core/di/injection_container.dart' as di;
import '../../core/theme/cubit/theme_cubit.dart';
import 'cubit/setup_cubit.dart';

class LanguageThemeSelectionView extends StatefulWidget {
  final bool isSettingsPage;

  const LanguageThemeSelectionView({super.key, this.isSettingsPage = false});

  @override
  State<LanguageThemeSelectionView> createState() => _LanguageThemeSelectionViewState();
}

class _LanguageThemeSelectionViewState extends State<LanguageThemeSelectionView> {
  final TextEditingController _balanceController = TextEditingController();

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SetupCubit>(),
      child: Scaffold(
        appBar: widget.isSettingsPage ? null : AppBar(title: Text('settings_title'.tr())),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: BlocBuilder<SetupCubit, SetupState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('select_language'.tr(), style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 10.h),
                    _buildLanguageSelector(context),
                    SizedBox(height: 30.h),
                    Text('select_theme'.tr(), style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 10.h),
                    _buildThemeSelector(context),
                    SizedBox(height: 40.h),

                    ?widget.isSettingsPage ? null : _buildSaveButton(context),
                    SizedBox(height: 30.h),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, Routes.onboarding);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        child: Text('next'.tr()),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SelectionCard(
            title: 'English',
            isSelected: context.locale.languageCode == 'en',
            onTap: () {
              context.setLocale(const Locale('en'));
            },
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: _SelectionCard(
            title: 'العربية',
            isSelected: context.locale.languageCode == 'ar',
            onTap: () {
              context.setLocale(const Locale('ar'));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, currentTheme) {
        return Row(
          children: [
            Expanded(
              child: _SelectionCard(
                title: 'theme_system'.tr(),
                isSelected: currentTheme == ThemeMode.system,
                onTap: () => context.read<ThemeCubit>().changeTheme(ThemeMode.system),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _SelectionCard(
                title: 'theme_light'.tr(),
                isSelected: currentTheme == ThemeMode.light,
                onTap: () => context.read<ThemeCubit>().changeTheme(ThemeMode.light),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _SelectionCard(
                title: 'theme_dark'.tr(),
                isSelected: currentTheme == ThemeMode.dark,
                onTap: () => context.read<ThemeCubit>().changeTheme(ThemeMode.dark),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCard({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 5.w),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.3)),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
