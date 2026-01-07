import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/home_cubit.dart';
import '../../home/data/models/transaction_model.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  String _selectedPeriod = 'month'; // month, year, all

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final filteredTransactions = _getFilteredTransactions(state);
        final categoryData = _getCategoryBreakdown(filteredTransactions);
        final incomeExpenseData = _getIncomeExpenseData(filteredTransactions);

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period Selector
              _buildPeriodSelector(),
              SizedBox(height: 20.h),

              // Income vs Expense Pie Chart
              _buildIncomeExpensePieChart(incomeExpenseData, state.currencyCode),
              SizedBox(height: 24.h),

              // Statistics Cards
              _buildStatisticsCards(filteredTransactions, state.currencyCode),
              SizedBox(height: 24.h),

              // Category Breakdown
              _buildCategoryBreakdown(categoryData, state.currencyCode),
              SizedBox(height: 24.h),

              // Top Spending Categories
              _buildTopCategories(categoryData, state.currencyCode),
            ],
          ),
        );
      },
    );
  }

  List<TransactionModel> _getFilteredTransactions(HomeState state) {
    final now = DateTime.now();
    return state.allTransactions.where((t) {
      switch (_selectedPeriod) {
        case 'month':
          return t.date.year == now.year && t.date.month == now.month;
        case 'year':
          return t.date.year == now.year;
        case 'all':
        default:
          return true;
      }
    }).toList();
  }

  Map<String, double> _getCategoryBreakdown(List<TransactionModel> transactions) {
    final Map<String, double> breakdown = {};
    for (var t in transactions) {
      if (!t.isIncome) {
        breakdown[t.categoryKey] = (breakdown[t.categoryKey] ?? 0) + t.amount;
      }
    }
    return breakdown;
  }

  Map<String, double> _getIncomeExpenseData(List<TransactionModel> transactions) {
    double income = 0;
    double expense = 0;
    for (var t in transactions) {
      if (t.isIncome) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }
    return {'income': income, 'expense': expense};
  }

  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _buildPeriodButton('month', 'this_month'.tr()),
          _buildPeriodButton('year', 'this_year'.tr()),
          _buildPeriodButton('all', 'all_time'.tr()),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period, String label) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = period),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeExpensePieChart(Map<String, double> data, String currency) {
    final income = data['income'] ?? 0;
    final expense = data['expense'] ?? 0;
    final total = income + expense;

    if (total == 0) {
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Text(
            'no_transactions'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20.w),
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
      child: Column(
        children: [
          Text(
            'income_vs_expenses'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 200.h,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50.r,
                sections: [
                  PieChartSectionData(
                    value: income,
                    title: '${((income / total) * 100).toStringAsFixed(0)}%',
                    color: Colors.green,
                    radius: 60.r,
                    titleStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: expense,
                    title: '${((expense / total) * 100).toStringAsFixed(0)}%',
                    color: Colors.red,
                    radius: 60.r,
                    titleStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('income'.tr(), Colors.green, income, currency),
              _buildLegendItem('expenses'.tr(), Colors.red, expense, currency),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, double amount, String currency) {
    return Row(
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
            Text(
              '${amount.toStringAsFixed(0)} $currency',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsCards(List<TransactionModel> transactions, String currency) {
    final income = transactions.where((t) => t.isIncome).fold(0.0, (sum, t) => sum + t.amount);
    final expense = transactions.where((t) => !t.isIncome).fold(0.0, (sum, t) => sum + t.amount);
    final balance = income - expense;
    final avgTransaction = transactions.isEmpty ? 0.0 : (income + expense) / transactions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'statistics'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        _buildStatCard(
          'net_balance'.tr(),
          balance,
          currency,
          balance >= 0 ? Colors.green : Colors.red,
          Icons.account_balance_wallet,
        ),
        SizedBox(height: 12.w),
        _buildStatCard(
          'transactions'.tr(),
          transactions.length.toDouble(),
          '',
          Theme.of(context).primaryColor,
          Icons.receipt_long,
        ),
        SizedBox(height: 12.h),
        _buildStatCard(
          'avg_transaction'.tr(),
          avgTransaction,
          currency,
          Colors.blue,
          Icons.trending_up,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    double value,
    String currency,
    Color color,
    IconData icon, {
    bool isFullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                SizedBox(height: 4.h),
                Text(
                  currency.isEmpty
                      ? value.toStringAsFixed(0)
                      : '${value.toStringAsFixed(0)} $currency',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(Map<String, double> data, String currency) {
    if (data.isEmpty) return const SizedBox.shrink();

    final sortedEntries = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'category_breakdown'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
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
          child: Column(
            children: sortedEntries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildCategoryItem(
                  entry.key.tr(),
                  entry.value,
                  currency,
                  data.values.reduce((a, b) => a + b),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String category, double amount, String currency, double total) {
    final percentage = (amount / total * 100);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            Text(
              '${amount.toStringAsFixed(0)} $currency',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey.shade200,
                color: Theme.of(context).primaryColor,
                minHeight: 8.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopCategories(Map<String, double> data, String currency) {
    if (data.isEmpty) return const SizedBox.shrink();

    final sortedEntries = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topThree = sortedEntries.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'top_spending'.tr(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        ...topThree.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          return _buildTopCategoryCard(index + 1, data.key.tr(), data.value, currency);
        }),
      ],
    );
  }

  Widget _buildTopCategoryCard(int rank, String category, double amount, String currency) {
    final colors = [Colors.amber, Colors.grey, Colors.brown];
    final icons = [Icons.emoji_events, Icons.emoji_events, Icons.emoji_events];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: colors[rank - 1].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icons[rank - 1], color: colors[rank - 1], size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  '#$rank ${'most_spent'.tr()}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '${amount.toStringAsFixed(0)} $currency',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
