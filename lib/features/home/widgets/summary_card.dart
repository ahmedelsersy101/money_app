import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryCard extends StatelessWidget {
  final num balance;
  final num income;
  final num expenses;
  final String currencyCode;

  const SummaryCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expenses,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(
            context,
            icon: Icons.arrow_downward,
            label: 'expenses'.tr(),
            amount: expenses,
            color: Colors.red, // Keep as red for expense, maybe AppColors.error
            isIncome: false,
          ),
          _buildVerticalDivider(context),
          _buildItem(
            context,
            icon: Icons.account_balance_wallet,
            label: 'balance'.tr(),
            amount: balance,
            color: Theme.of(context).primaryColor, // Use primary color
            isIncome: true, // Just for styling logic if needed
          ),
          _buildVerticalDivider(context),
          _buildItem(
            context,
            icon: Icons.arrow_upward,
            label: 'income'.tr(),
            amount: income,
            color: Colors.green, // Keep as green, maybe AppColors.success
            isIncome: true,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Container(height: 40.h, width: 1, color: Theme.of(context).dividerColor);
  }

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required num amount,
    required Color color,
    required bool isIncome,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).iconTheme.color?.withOpacity(0.6) ?? Colors.grey,
          size: 24.sp,
        ),
        SizedBox(height: 10.h),
        Text(
          '$amount',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 5.h),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
