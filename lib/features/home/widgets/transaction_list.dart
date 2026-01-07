import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/category_utils.dart';
import '../data/models/transaction_model.dart';
import '../../transactions/views/all_transactions_view.dart';
import '../../add_transaction/views/add_transaction_view.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final String currencyCode;

  const TransactionList({super.key, required this.transactions, required this.currencyCode});

  Map<String, List<TransactionModel>> _groupTransactions(BuildContext context) {
    final grouped = <String, List<TransactionModel>>{};

    for (var transaction in transactions) {
      final date = transaction.date;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      final transactionDate = DateTime(date.year, date.month, date.day);

      String key;
      if (transactionDate == today) {
        key = 'today'.tr();
      } else if (transactionDate == yesterday) {
        key = 'yesterday'.tr();
      } else {
        key = DateFormat('dd MMMM yyyy', context.locale.toString()).format(date);
      }

      if (grouped.containsKey(key)) {
        grouped[key]!.add(transaction);
      } else {
        grouped[key] = [transaction];
      }
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return _buildEmptyState(context);
    }

    final groupedTransactions = _groupTransactions(context);

    return Column(
      children: [
        ...groupedTransactions.entries.map((entry) {
          return Container(
            margin: EdgeInsets.only(bottom: 20.h),
            padding: EdgeInsets.all(20.w),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat(
                        'yyyy/MM/dd',
                        context.locale.toString(),
                      ).format(entry.value.first.date),
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Divider(color: Theme.of(context).dividerTheme.color),
                SizedBox(height: 4.h),
                // Transactions for this day
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entry.value.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Theme.of(context).dividerTheme.color),
                  itemBuilder: (context, index) {
                    final transaction = entry.value[index];
                    final category = CategoryUtils.getCategory(transaction.categoryKey);
                    final timeString = DateFormat(
                      'hh:mm a',
                      context.locale.toString(),
                    ).format(transaction.date);

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddTransactionView(transactionToEdit: transaction),
                          ),
                        );
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: EdgeInsets.all(8.r),
                        width: 45.w,
                        height: 45.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: category.imagePath != null
                            ? Padding(
                                padding: EdgeInsets.all(4.r),
                                child: SvgPicture.asset(category.imagePath!),
                              )
                            : Icon(
                                category.icon ?? Icons.category,
                                color: Theme.of(context).primaryColor,
                                size: 24.sp,
                              ),
                      ),
                      title: Text(
                        category.key.tr(), // Use category name for translation
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${transaction.accountKey.tr()} • $timeString',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      trailing: Text(
                        '${transaction.isIncome ? '+' : '-'}${transaction.amount} $currencyCode',
                        style: TextStyle(
                          color: transaction.isIncome ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    );
                  },
                ),
                Divider(color: Theme.of(context).dividerTheme.color),
                SizedBox(height: 8.h),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AllTransactionsView(selectedDate: entry.value.first.date),
                        ),
                      );
                    },
                    child: Text(
                      'more_details'.tr(),
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        }), // No toList needed if we use spread operator on map result, but map returns Iterable.
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      width: double.infinity,
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
      child: Column(
        children: [
          Text(
            'today'.tr(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          Text(
            'no_transactions'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
          ),
          SizedBox(height: 20.h),
          Divider(color: Theme.of(context).dividerTheme.color),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
