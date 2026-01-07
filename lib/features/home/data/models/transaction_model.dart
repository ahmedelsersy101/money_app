class TransactionModel {
  final String id;
  final String title; // can serve as categoryKey for now, or display name
  final double amount;
  final DateTime date;
  final bool isIncome;
  final String categoryKey;
  final String accountKey;
  final String? notes;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.categoryKey,
    required this.accountKey,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'isIncome': isIncome,
      'categoryKey': categoryKey,
      'accountKey': accountKey,
      'notes': notes,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      isIncome: json['isIncome'] as bool,
      categoryKey: json['categoryKey'] as String,
      accountKey: json['accountKey'] as String,
      notes: json['notes'] as String?,
    );
  }
}
