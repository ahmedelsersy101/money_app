// ignore_for_file: unused_local_variable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/category_utils.dart';
import '../../home/cubit/home_cubit.dart';
import '../../home/data/models/transaction_model.dart';
import '../widgets/account_selection_sheet.dart';
import '../widgets/category_selection_sheet.dart';

class AddTransactionView extends StatefulWidget {
  final TransactionModel? transactionToEdit;

  const AddTransactionView({super.key, this.transactionToEdit});

  @override
  State<AddTransactionView> createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedCategoryKey = 'travel';
  String? _selectedCategorySvg;
  IconData _selectedCategoryIcon = Icons.flight;
  String _selectedAccountKey = 'cash';
  IconData _selectedAccountIcon = Icons.money;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isIncome = false;

  @override
  void initState() {
    super.initState();
    if (widget.transactionToEdit != null) {
      final t = widget.transactionToEdit!;
      _amountController.text = t.amount.toString();
      _notesController.text = t.notes ?? '';
      _selectedCategoryKey = t.categoryKey;
      _selectedAccountKey = t.accountKey;
      _selectedDate = t.date;
      _selectedTime = TimeOfDay.fromDateTime(t.date);
      _isIncome = t.isIncome;

      final cat = CategoryUtils.getCategory(_selectedCategoryKey);
      _selectedCategorySvg = cat.imagePath;
      _selectedCategoryIcon = cat.icon ?? Icons.category;
    } else {
      final cat = CategoryUtils.getCategory(_selectedCategoryKey);
      _isIncome = cat.isIncome;
      _selectedCategorySvg = cat.imagePath;
      _selectedCategoryIcon = cat.icon ?? Icons.category;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showCategorySelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategorySelectionSheet(
        onCategorySelected: (String key, String? imagePath, IconData? icon, bool isIncome) {
          setState(() {
            _selectedCategoryKey = key;
            _selectedCategorySvg = imagePath;
            _selectedCategoryIcon = icon ?? Icons.category;
            _isIncome = isIncome;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAccountSelection() {
    final currencyCode = context.read<HomeCubit>().state.currencyCode;
    final cashBalance = context.read<HomeCubit>().state.cashBalance;
    final bankBalance = context.read<HomeCubit>().state.bankBalance;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AccountSelectionSheet(
        selectedAccount: _selectedAccountKey,
        currencyCode: currencyCode,
        cashBalance: cashBalance,
        bankBalance: bankBalance,
        onAccountSelected: (accountName, icon, key) {
          setState(() {
            _selectedAccountKey = key;
            _selectedAccountIcon = icon;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('yyyy/MM/dd', context.locale.toString()).format(_selectedDate);
    final timeString = _selectedTime.format(context);
    final isEditing = widget.transactionToEdit != null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? 'update'.tr() : 'add_record'.tr()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Income/Expense Toggle
              _buildIncomeExpenseToggle(),
              SizedBox(height: 16.h),

              // Amount Input
              _buildAmountInput(),
              SizedBox(height: 16.h),

              // Category Selection
              _buildSelectionTile(
                label: 'category'.tr(),
                value: _selectedCategoryKey.tr(),
                icon: _selectedCategorySvg != null
                    ? SvgPicture.asset(_selectedCategorySvg!, width: 28.w, height: 28.w)
                    : Icon(_selectedCategoryIcon, size: 28.sp),
                onTap: _showCategorySelection,
              ),
              SizedBox(height: 16.h),

              // Account Selection
              _buildSelectionTile(
                label: 'account'.tr(),
                value: _selectedAccountKey.tr(),
                icon: Icon(_selectedAccountIcon, size: 28.sp, color: Colors.green),
                onTap: _showAccountSelection,
              ),
              SizedBox(height: 16.h),

              // Date Selection
              _buildSelectionTile(
                label: 'date'.tr(),
                value: dateString,
                icon: Icon(
                  Icons.calendar_today,
                  size: 24.sp,
                  color: Theme.of(context).primaryColor,
                ),
                onTap: _selectDate,
              ),
              SizedBox(height: 16.h),

              // Time Selection
              _buildSelectionTile(
                label: 'time'.tr(),
                value: timeString,
                icon: Icon(Icons.access_time, size: 24.sp, color: Theme.of(context).primaryColor),
                onTap: _selectTime,
              ),
              SizedBox(height: 30.h),

              // Notes Input
              // _buildNotesInput(),
              SizedBox(height: 40.h),

              // Save Button
              _buildSaveButton(isEditing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseToggle() {
    return Container(
      height: 40.h,
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
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isIncome = false),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: !_isIncome ? Colors.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: !_isIncome ? Colors.white : Colors.grey,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'expenses'.tr(),
                      style: TextStyle(
                        color: !_isIncome ? Colors.white : Colors.grey,
                        fontWeight: !_isIncome ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isIncome = true),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: _isIncome ? Colors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: _isIncome ? Colors.white : Colors.grey,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'income'.tr(),
                      style: TextStyle(
                        color: _isIncome ? Colors.white : Colors.grey,
                        fontWeight: _isIncome ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'amount'.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 50.h,
          child: TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _isIncome ? Colors.green : Colors.red,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '0.00',
              hintStyle: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionTile({
    required String label,
    required String value,
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 60.h,
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
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: icon,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Widget _buildNotesInput() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'notes'.tr(),
  //         style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
  //       ),
  //       SizedBox(height: 12.h),
  //       Container(
  //         decoration: BoxDecoration(
  //           color: Theme.of(context).cardColor,
  //           borderRadius: BorderRadius.circular(16.r),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.05),
  //               blurRadius: 10,
  //               offset: const Offset(0, 5),
  //             ),
  //           ],
  //         ),
  //         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
  //         child: TextField(
  //           controller: _notesController,
  //           maxLines: 3,
  //           decoration: InputDecoration(
  //             border: InputBorder.none,
  //             hintText: 'enter_amount'.tr(),
  //             hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSaveButton(bool isEditing) {
    return SizedBox(
      width: double.infinity,
      height: 45.h,
      child: ElevatedButton(
        onPressed: () {
          final amount = double.tryParse(_amountController.text);
          if (amount == null || amount <= 0) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Please enter a valid amount')));
            return;
          }

          final transaction = TransactionModel(
            id: isEditing ? widget.transactionToEdit!.id : const Uuid().v4(),
            title: _selectedCategoryKey,
            amount: amount,
            date: DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              _selectedTime.hour,
              _selectedTime.minute,
            ),
            isIncome: _isIncome,
            categoryKey: _selectedCategoryKey,
            accountKey: _selectedAccountKey,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
          );

          if (isEditing) {
            context.read<HomeCubit>().updateTransaction(transaction);
          } else {
            context.read<HomeCubit>().addTransaction(transaction);
          }
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 5,
          shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
        ),
        child: Text(
          isEditing ? 'update'.tr() : 'add'.tr(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
