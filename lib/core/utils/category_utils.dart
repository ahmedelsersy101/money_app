import 'package:flutter/material.dart';

class CategoryDetails {
  final String key;
  final String? imagePath;
  final IconData? icon;
  final bool isIncome;

  CategoryDetails({required this.key, this.imagePath, this.icon, this.isIncome = false});

  Map<String, dynamic> toJson() {
    return {'key': key, 'imagePath': imagePath, 'icon': icon?.codePoint, 'isIncome': isIncome};
  }

  factory CategoryDetails.fromJson(Map<String, dynamic> json) {
    return CategoryDetails(
      key: json['key'],
      imagePath: json['imagePath'],
      icon: json['icon'] != null ? IconData(json['icon'], fontFamily: 'MaterialIcons') : null,
      isIncome: json['isIncome'] ?? false,
    );
  }
}

class CategoryUtils {
  static const String _basePath = 'assets/images';

  static final List<CategoryDetails> categories = [
    // Expenses
    CategoryDetails(key: 'food', imagePath: '$_basePath/طعام.svg'),
    CategoryDetails(key: 'shopping', imagePath: '$_basePath/تسوق.svg'),
    CategoryDetails(key: 'bills', imagePath: '$_basePath/فواتير.svg'),
    CategoryDetails(key: 'internet', imagePath: '$_basePath/انترنت.svg'),
    CategoryDetails(key: 'phone', imagePath: '$_basePath/اتصالات.svg'),
    CategoryDetails(key: 'electricity', imagePath: '$_basePath/كهرباء.svg'),
    CategoryDetails(key: 'water', imagePath: '$_basePath/مياه.svg'),
    CategoryDetails(key: 'gas', imagePath: '$_basePath/غاز.svg'),
    CategoryDetails(key: 'education', imagePath: '$_basePath/تعليم.svg'),
    CategoryDetails(key: 'health', imagePath: '$_basePath/صحة.svg'),
    CategoryDetails(key: 'doctors', imagePath: '$_basePath/اطباء.svg'),
    CategoryDetails(key: 'medicines', imagePath: '$_basePath/ادوية.svg'),
    CategoryDetails(key: 'children', imagePath: '$_basePath/اطفال.svg'),
    CategoryDetails(key: 'family', imagePath: '$_basePath/العائله.svg'),
    CategoryDetails(key: 'rent', imagePath: '$_basePath/ايجار.svg'),
    CategoryDetails(key: 'subscriptions', imagePath: '$_basePath/الأشتراكات.svg'),
    CategoryDetails(key: 'insurance', imagePath: '$_basePath/تأمينات.svg'),
    CategoryDetails(key: 'donations', imagePath: '$_basePath/تبرعات.svg'),
    CategoryDetails(key: 'gifts', icon: Icons.card_giftcard), // No image found yet
    CategoryDetails(key: 'entertainment', imagePath: '$_basePath/ترفيه.svg'),
    CategoryDetails(key: 'games', imagePath: '$_basePath/لعبة.svg'),
    CategoryDetails(key: 'books', imagePath: '$_basePath/كتب.svg'),
    CategoryDetails(key: 'courses', imagePath: '$_basePath/دورات.svg'),
    CategoryDetails(key: 'sports', imagePath: '$_basePath/رياضي.svg'),
    CategoryDetails(key: 'pets', imagePath: '$_basePath/حيوانات.svg'), // mapped to pets
    CategoryDetails(key: 'services', imagePath: '$_basePath/خدمات.svg'),
    CategoryDetails(key: 'transport', icon: Icons.directions_bus), // No image found
    CategoryDetails(key: 'travel', icon: Icons.flight), // No image found
    CategoryDetails(key: 'cleaning', imagePath: '$_basePath/نظافة.svg'),
    CategoryDetails(key: 'other', imagePath: '$_basePath/اخرى.svg'),

    // Income / Transfers
    CategoryDetails(key: 'salary', icon: Icons.attach_money, isIncome: true),
    CategoryDetails(key: 'transfer_money', imagePath: '$_basePath/تحويل.svg', isIncome: true),
    CategoryDetails(key: 'withdraw_money', imagePath: '$_basePath/سحب.svg', isIncome: true),
    CategoryDetails(key: 'sales', imagePath: '$_basePath/مبيعات.svg', isIncome: true),
    CategoryDetails(
      key: 'investment',
      imagePath: '$_basePath/استثمار.svg',
      isIncome: true,
    ), // Often income
  ];

  static List<CategoryDetails> get expenseCategories =>
      categories.where((c) => !c.isIncome).toList();

  static List<CategoryDetails> get incomeCategories => categories.where((c) => c.isIncome).toList();

  static CategoryDetails getCategory(String key) {
    try {
      // Map legacy keys if needed, or just find by key
      return categories.firstWhere((element) => element.key == key);
    } catch (e) {
      // Fallback
      return CategoryDetails(key: key, icon: Icons.category);
    }
  }
}
