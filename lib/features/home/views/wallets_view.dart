import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/home_cubit.dart';
import '../widgets/add_money_dialog.dart';

class WalletsView extends StatelessWidget {
  const WalletsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final totalBalance = state.cashBalance + state.bankBalance;

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Balance Header
              Center(
                child: Column(
                  children: [
                    Text(
                      'total_balance'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${totalBalance.toStringAsFixed(0)} ${state.currencyCode}',
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),

              // Cash Wallet Card
              _WalletCard(
                walletKey: 'cash',
                walletName: 'cash'.tr(),
                balance: state.cashBalance,
                currencyCode: state.currencyCode,
                gradient: const LinearGradient(
                  colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.money,
                onAddMoney: () => _showAddMoneyDialog(context, 'cash', 'cash'.tr()),
              ),
              SizedBox(height: 20.h),

              // Bank Account Wallet Card
              _WalletCard(
                walletKey: 'bank_account',
                walletName: 'bank_account'.tr(),
                balance: state.bankBalance,
                currencyCode: state.currencyCode,
                gradient: const LinearGradient(
                  colors: [Color(0xFF7E57C2), Color(0xFF5E35B1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.account_balance,
                onAddMoney: () => _showAddMoneyDialog(context, 'bank_account', 'bank_account'.tr()),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddMoneyDialog(BuildContext context, String walletKey, String walletName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddMoneyDialog(
        walletName: walletName,
        onAdd: (amount) {
          context.read<HomeCubit>().addMoneyToWallet(walletKey, amount);
        },
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  final String walletKey;
  final String walletName;
  final num balance;
  final String currencyCode;
  final LinearGradient gradient;
  final IconData icon;
  final VoidCallback onAddMoney;

  const _WalletCard({
    required this.walletKey,
    required this.walletName,
    required this.balance,
    required this.currencyCode,
    required this.gradient,
    required this.icon,
    required this.onAddMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                walletName,
                style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: Colors.white, size: 28.sp),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            '${balance.toStringAsFixed(0)} $currencyCode',
            style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddMoney,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text('add_money'.tr(), style: const TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
