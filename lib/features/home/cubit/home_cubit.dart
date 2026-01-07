import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/transaction_model.dart';
import 'home_state.dart';

export 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SharedPreferences sharedPreferences;

  HomeCubit({required this.sharedPreferences}) : super(HomeState(selectedDate: DateTime.now())) {
    loadHomeData();
  }

  void loadHomeData() {
    emit(state.copyWith(isLoading: true));

    final currencyCode = sharedPreferences.getString('currency_code') ?? '';

    // Load persisted transactions
    final transactionsJson = sharedPreferences.getStringList('transactions') ?? [];
    final allTransactions = transactionsJson
        .map((e) => TransactionModel.fromJson(jsonDecode(e)))
        .toList();

    // Sort transactions by date descending
    allTransactions.sort((a, b) => b.date.compareTo(a.date));

    // Load wallet balances
    final cashBalance = sharedPreferences.getDouble('cash_balance') ?? 0.0;
    final bankBalance = sharedPreferences.getDouble('bank_balance') ?? 0.0;

    // Calculate total balance from wallets
    final num currentBalance = cashBalance + bankBalance;

    // Apply Monthly Filter
    _applyFilter(
      allTransactions: allTransactions,
      balance: currentBalance,
      currencyCode: currencyCode,
      cashBalance: cashBalance,
      bankBalance: bankBalance,
    );
  }

  void changeMonth(int offset) {
    final newDate = DateTime(state.selectedDate.year, state.selectedDate.month + offset);

    // Prevent future months if desired (though sometimes useful for budgeting)
    // Plan said: "Prevent navigating to future months"
    if (newDate.isAfter(DateTime.now())) {
      // Allow current month, but not strictly future months (e.g. next month empty)
      // Let's check simply if newDate month > current month
      final now = DateTime.now();
      if (newDate.year > now.year || (newDate.year == now.year && newDate.month > now.month)) {
        return;
      }
    }

    emit(state.copyWith(selectedDate: newDate));
    _applyFilter(
      allTransactions: state.allTransactions,
      balance: state.balance,
      currencyCode: state.currencyCode,
      cashBalance: state.cashBalance,
      bankBalance: state.bankBalance,
    );
  }

  void _applyFilter({
    required List<TransactionModel> allTransactions,
    num? balance,
    String? currencyCode,
    num? cashBalance,
    num? bankBalance,
  }) {
    final selectedMonth = state.selectedDate;

    final filtered = allTransactions.where((t) {
      return t.date.year == selectedMonth.year && t.date.month == selectedMonth.month;
    }).toList();

    num monthlyIncome = 0;
    num monthlyExpenses = 0;

    for (var t in filtered) {
      if (t.isIncome) {
        monthlyIncome += t.amount;
      } else {
        monthlyExpenses += t.amount;
      }
    }

    emit(
      state.copyWith(
        allTransactions: allTransactions,
        filteredTransactions: filtered,
        balance: balance ?? state.balance,
        monthlyIncome: monthlyIncome,
        monthlyExpenses: monthlyExpenses,
        currencyCode: currencyCode ?? state.currencyCode,
        cashBalance: cashBalance ?? state.cashBalance,
        bankBalance: bankBalance ?? state.bankBalance,
        isLoading: false,
      ),
    );
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final currentTransactions = List<TransactionModel>.from(state.allTransactions);
    currentTransactions.add(transaction);

    // Update wallet balance
    await _updateWalletBalance(transaction.accountKey, transaction.amount, transaction.isIncome);

    await _saveAndReload(currentTransactions);
  }

  Future<void> deleteTransaction(String id) async {
    final currentTransactions = List<TransactionModel>.from(state.allTransactions);
    final transaction = currentTransactions.firstWhere((t) => t.id == id);

    // Reverse wallet balance change
    await _updateWalletBalance(transaction.accountKey, transaction.amount, !transaction.isIncome);

    currentTransactions.removeWhere((t) => t.id == id);
    await _saveAndReload(currentTransactions);
  }

  Future<void> updateTransaction(TransactionModel updatedTransaction) async {
    final currentTransactions = List<TransactionModel>.from(state.allTransactions);
    final index = currentTransactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      final oldTransaction = currentTransactions[index];

      // Reverse old transaction's effect
      await _updateWalletBalance(
        oldTransaction.accountKey,
        oldTransaction.amount,
        !oldTransaction.isIncome,
      );

      // Apply new transaction's effect
      await _updateWalletBalance(
        updatedTransaction.accountKey,
        updatedTransaction.amount,
        updatedTransaction.isIncome,
      );

      currentTransactions[index] = updatedTransaction;
      await _saveAndReload(currentTransactions);
    }
  }

  Future<void> _saveAndReload(List<TransactionModel> transactions) async {
    final transactionsListJson = transactions.map((e) => jsonEncode(e.toJson())).toList();
    await sharedPreferences.setStringList('transactions', transactionsListJson);
    loadHomeData();
  }

  Future<void> addMoneyToWallet(String walletKey, double amount) async {
    if (amount <= 0) return;

    if (walletKey == 'cash') {
      final newBalance = state.cashBalance + amount;
      await sharedPreferences.setDouble('cash_balance', newBalance.toDouble());
      emit(state.copyWith(cashBalance: newBalance));
    } else if (walletKey == 'bank_account') {
      final newBalance = state.bankBalance + amount;
      await sharedPreferences.setDouble('bank_balance', newBalance.toDouble());
      emit(state.copyWith(bankBalance: newBalance));
    }
  }

  Future<void> _updateWalletBalance(String walletKey, double amount, bool isIncome) async {
    final change = isIncome ? amount : -amount;

    if (walletKey == 'cash') {
      final newBalance = state.cashBalance + change;
      await sharedPreferences.setDouble('cash_balance', newBalance.toDouble());
    } else if (walletKey == 'bank_account') {
      final newBalance = state.bankBalance + change;
      await sharedPreferences.setDouble('bank_balance', newBalance.toDouble());
    }
  }
}
