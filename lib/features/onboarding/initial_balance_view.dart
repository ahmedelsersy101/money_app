import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_app/core/di/injection_container.dart' as di;
import 'package:money_app/core/routes/routes.dart';
import 'package:money_app/features/home/cubit/home_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitialBalanceView extends StatefulWidget {
  const InitialBalanceView({super.key});

  @override
  State<InitialBalanceView> createState() => _InitialBalanceViewState();
}

class _InitialBalanceViewState extends State<InitialBalanceView> {
  final TextEditingController _balanceController = TextEditingController();
  String _selectedCurrency = 'egp';

  final List<String> _currencies = ['egp', 'usd', 'eur', 'sar', 'aed', 'kwd', 'qar'];

  Future<void> _startApp() async {
    final balanceText = _balanceController.text.trim();
    if (balanceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_enter_balance'.tr()), backgroundColor: Colors.red),
      );
      return;
    }

    final balance = double.tryParse(balanceText) ?? 0.0;
    if (balance < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Balance cannot be negative'), backgroundColor: Colors.red),
      );
      return;
    }

    final prefs = di.sl<SharedPreferences>();
    await prefs.setDouble('cash_balance', balance);
    await prefs.setString('currency_code', _selectedCurrency.toUpperCase());
    await prefs.setBool('is_first_time', false);

    if (mounted) {
      context.read<HomeCubit>().loadHomeData();
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              Text(
                'enter_balance'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.h),

              // Balance Input
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: TextField(
                  controller: _balanceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0.00',
                    hintStyle: Theme.of(
                      context,
                    ).textTheme.displaySmall?.copyWith(color: Colors.grey.shade300),
                  ),
                ),
              ),

              SizedBox(height: 40.h),
              Text(
                'select_currency'.tr(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),

              // Currency Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 2.5,
                ),
                itemCount: _currencies.length,
                itemBuilder: (context, index) {
                  final currency = _currencies[index];
                  final isSelected = _selectedCurrency == currency;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedCurrency = currency),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        currency.tr(),
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 60.h),

              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: _startApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    elevation: 5,
                    shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
                  ),
                  child: Text(
                    'start'.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
