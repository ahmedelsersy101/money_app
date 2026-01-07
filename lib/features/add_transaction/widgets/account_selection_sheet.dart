import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountSelectionSheet extends StatelessWidget {
  final String selectedAccount;
  final String currencyCode;
  final num cashBalance;
  final num bankBalance;
  final Function(String, IconData, String) onAccountSelected;

  const AccountSelectionSheet({
    super.key,
    required this.selectedAccount,
    required this.currencyCode,
    required this.cashBalance,
    required this.bankBalance,
    required this.onAccountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAccountItem(
            context,
            key: 'cash',
            icon: Icons.money,
            balance: cashBalance.toDouble(),
            isSelected: selectedAccount == 'cash',
          ),
          Divider(color: Colors.grey.withOpacity(0.2)),
          _buildAccountItem(
            context,
            key: 'bank_account',
            icon: Icons.account_balance,
            balance: bankBalance.toDouble(),
            isSelected: selectedAccount == 'bank_account',
          ),
        ],
      ),
    );
  }

  Widget _buildAccountItem(
    BuildContext context, {
    required String key,
    required IconData icon,
    required double balance,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => onAccountSelected(key.tr(), icon, key),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Text('$balance $currencyCode', style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Text(
              key.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 15.w),
            Icon(icon, color: Colors.green, size: 30),
          ],
        ),
      ),
    );
  }
}
