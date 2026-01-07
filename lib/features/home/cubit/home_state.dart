import '../data/models/transaction_model.dart';

class HomeState {
  final num balance; // Global Balance
  final num totalIncome; // Global or Monthly? Plan says Monthly for cards
  final num totalExpenses; // Plan says Monthly for cards
  final String currencyCode;

  // All transactions (source of truth)
  final List<TransactionModel> allTransactions;

  // Monthly specific
  final DateTime selectedDate;
  final List<TransactionModel> filteredTransactions;
  final num monthlyIncome;
  final num monthlyExpenses;

  // Wallet balances
  final num cashBalance;
  final num bankBalance;

  final bool isLoading;

  const HomeState({
    this.balance = 0,
    this.totalIncome = 0,
    this.totalExpenses = 0,
    this.currencyCode = '',
    this.allTransactions = const [],
    required this.selectedDate,
    this.filteredTransactions = const [],
    this.monthlyIncome = 0,
    this.monthlyExpenses = 0,
    this.cashBalance = 0,
    this.bankBalance = 0,
    this.isLoading = false,
  });

  HomeState copyWith({
    num? balance,
    num? totalIncome,
    num? totalExpenses,
    String? currencyCode,
    List<TransactionModel>? allTransactions,
    DateTime? selectedDate,
    List<TransactionModel>? filteredTransactions,
    num? monthlyIncome,
    num? monthlyExpenses,
    num? cashBalance,
    num? bankBalance,
    bool? isLoading,
  }) {
    return HomeState(
      balance: balance ?? this.balance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      currencyCode: currencyCode ?? this.currencyCode,
      allTransactions: allTransactions ?? this.allTransactions,
      selectedDate: selectedDate ?? this.selectedDate,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      cashBalance: cashBalance ?? this.cashBalance,
      bankBalance: bankBalance ?? this.bankBalance,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
