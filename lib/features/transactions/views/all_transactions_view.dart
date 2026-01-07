import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../home/cubit/home_cubit.dart';
import '../../home/data/models/transaction_model.dart';
import '../../add_transaction/views/add_transaction_view.dart';

class AllTransactionsView extends StatefulWidget {
  final DateTime? selectedDate;

  const AllTransactionsView({super.key, this.selectedDate});

  @override
  State<AllTransactionsView> createState() => _AllTransactionsViewState();
}

class _AllTransactionsViewState extends State<AllTransactionsView> {
  String _currentSort = 'newest_first';

  List<TransactionModel> _sortTransactions(List<TransactionModel> transactions) {
    List<TransactionModel> sorted = List.from(transactions);
    switch (_currentSort) {
      case 'newest_first':
        sorted.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'oldest_first':
        sorted.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'highest_price':
        sorted.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case 'lowest_price':
        sorted.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }
    return sorted;
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('delete'.tr()),
        content: Text('delete_confirm'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('cancel'.tr())),
          TextButton(
            onPressed: () {
              context.read<HomeCubit>().deleteTransaction(id);
              Navigator.pop(ctx);
            },
            child: Text('delete'.tr(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(BuildContext context, TransactionModel transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTransactionView(transactionToEdit: transaction)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'transactions'.tr(),
        ), // Needs key 'transactions' or reuse existing title like 'More Details'
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: Theme.of(context).iconTheme.color),
            onSelected: (value) {
              setState(() {
                _currentSort = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'newest_first', child: Text('newest_first'.tr())),
              PopupMenuItem(value: 'oldest_first', child: Text('oldest_first'.tr())),
              PopupMenuItem(value: 'highest_price', child: Text('highest_price'.tr())),
              PopupMenuItem(value: 'lowest_price', child: Text('lowest_price'.tr())),
            ],
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          // Filter to show transactions for the selected date (or today if not specified)
          final targetDate = widget.selectedDate ?? DateTime.now();
          final dateTransactions = state.allTransactions.where((transaction) {
            return transaction.date.year == targetDate.year &&
                transaction.date.month == targetDate.month &&
                transaction.date.day == targetDate.day;
          }).toList();

          if (dateTransactions.isEmpty) {
            return Center(child: Text('no_transactions'.tr()));
          }

          final sortedTransactions = _sortTransactions(dateTransactions);

          return ListView.separated(
            padding: EdgeInsets.all(20.w),
            itemCount: sortedTransactions.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final transaction = sortedTransactions[index];
              return Container(
                padding: EdgeInsets.all(16.r),
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
                    Row(
                      children: [
                        // Icon
                        Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color: transaction.isIncome
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            transaction.isIncome
                                ? Icons.arrow_downward
                                : Icons.arrow_upward, // Or category icon if stored/mapped
                            color: transaction.isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction.title.tr(),
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              if (transaction.notes != null && transaction.notes!.isNotEmpty)
                                Text(
                                  transaction.notes!,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        Text(
                          '${transaction.isIncome ? '+' : '-'}${transaction.amount}',
                          style: TextStyle(
                            color: transaction.isIncome ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Divider(color: Colors.grey.withOpacity(0.2)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yyyy/MM/dd').format(transaction.date),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _navigateToEdit(context, transaction),
                              icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                              splashRadius: 20,
                            ),
                            IconButton(
                              onPressed: () => _confirmDelete(context, transaction.id),
                              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                              splashRadius: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
