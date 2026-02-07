import 'package:flutter/material.dart';

class CategoryDetails {
  final String key;
  final String? imagePath;
  final IconData? icon;
  final bool isIncome;
  final String? group; // For grouping categories

  CategoryDetails({
    required this.key,
    this.imagePath,
    this.icon,
    this.isIncome = false,
    this.group,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'imagePath': imagePath,
      'icon': icon?.codePoint,
      'isIncome': isIncome,
      'group': group,
    };
  }

  factory CategoryDetails.fromJson(Map<String, dynamic> json) {
    return CategoryDetails(
      key: json['key'],
      imagePath: json['imagePath'],
      icon: json['icon'] != null ? IconData(json['icon'], fontFamily: 'MaterialIcons') : null,
      isIncome: json['isIncome'] ?? false,
      group: json['group'],
    );
  }
}

class CategoryUtils {
  static const String _basePath = 'assets/images';

  static final List<CategoryDetails> categories = [
    // ========== EXPENSES ==========
    // Bills & Utilities
    CategoryDetails(key: 'electricity', imagePath: '$_basePath/كهرباء.svg', group: 'bills'),
    CategoryDetails(key: 'water', imagePath: '$_basePath/مياه.svg', group: 'bills'),
    CategoryDetails(key: 'gas', imagePath: '$_basePath/غاز.svg', group: 'bills'),
    CategoryDetails(key: 'internet', imagePath: '$_basePath/انترنت.svg', group: 'bills'),
    CategoryDetails(key: 'phone', imagePath: '$_basePath/اتصالات.svg', group: 'bills'),
    CategoryDetails(key: 'bills', imagePath: '$_basePath/فواتير.svg', group: 'bills'),

    // Food & Dining
    CategoryDetails(key: 'food', imagePath: '$_basePath/طعام.svg', group: 'food'),
    CategoryDetails(key: 'groceries', icon: Icons.shopping_cart, group: 'food'),
    CategoryDetails(key: 'restaurant', icon: Icons.restaurant, group: 'food'),
    CategoryDetails(key: 'coffee', icon: Icons.local_cafe, group: 'food'),

    // Shopping
    CategoryDetails(key: 'shopping', imagePath: '$_basePath/تسوق.svg', group: 'shopping'),
    CategoryDetails(key: 'clothing', icon: Icons.checkroom, group: 'shopping'),
    CategoryDetails(key: 'electronics', icon: Icons.devices, group: 'shopping'),

    // Transportation
    CategoryDetails(key: 'transport', icon: Icons.directions_bus, group: 'transport'),
    CategoryDetails(key: 'fuel', icon: Icons.local_gas_station, group: 'transport'),
    CategoryDetails(key: 'parking', icon: Icons.local_parking, group: 'transport'),
    CategoryDetails(key: 'taxi', icon: Icons.local_taxi, group: 'transport'),
    CategoryDetails(key: 'travel', icon: Icons.flight, group: 'transport'),

    // Health & Medical
    CategoryDetails(key: 'health', imagePath: '$_basePath/صحة.svg', group: 'health'),
    CategoryDetails(key: 'doctors', imagePath: '$_basePath/اطباء.svg', group: 'health'),
    CategoryDetails(key: 'medicines', imagePath: '$_basePath/ادوية.svg', group: 'health'),
    CategoryDetails(key: 'pharmacy', icon: Icons.local_pharmacy, group: 'health'),
    CategoryDetails(key: 'gym', icon: Icons.fitness_center, group: 'health'),

    // Education
    CategoryDetails(key: 'education', imagePath: '$_basePath/تعليم.svg', group: 'education'),
    CategoryDetails(key: 'courses', imagePath: '$_basePath/دورات.svg', group: 'education'),
    CategoryDetails(key: 'books', imagePath: '$_basePath/كتب.svg', group: 'education'),
    CategoryDetails(key: 'tuition', icon: Icons.school, group: 'education'),

    // Housing
    CategoryDetails(key: 'rent', imagePath: '$_basePath/ايجار.svg', group: 'housing'),
    CategoryDetails(key: 'maintenance', icon: Icons.home_repair_service, group: 'housing'),
    CategoryDetails(key: 'cleaning', imagePath: '$_basePath/نظافة.svg', group: 'housing'),

    // Entertainment & Hobbies
    CategoryDetails(
      key: 'entertainment',
      imagePath: '$_basePath/ترفيه.svg',
      group: 'entertainment',
    ),
    CategoryDetails(key: 'movies', icon: Icons.movie, group: 'entertainment'),
    CategoryDetails(key: 'games', imagePath: '$_basePath/لعبة.svg', group: 'entertainment'),
    CategoryDetails(key: 'sports', imagePath: '$_basePath/رياضي.svg', group: 'entertainment'),
    CategoryDetails(key: 'music', icon: Icons.music_note, group: 'entertainment'),

    // Personal Care
    CategoryDetails(key: 'beauty', icon: Icons.face, group: 'personal'),
    CategoryDetails(key: 'haircut', icon: Icons.content_cut, group: 'personal'),

    // Family & Kids
    CategoryDetails(key: 'family', imagePath: '$_basePath/العائله.svg', group: 'family'),
    CategoryDetails(key: 'children', imagePath: '$_basePath/اطفال.svg', group: 'family'),
    CategoryDetails(key: 'pets', imagePath: '$_basePath/حيوانات.svg', group: 'family'),
    CategoryDetails(key: 'baby', icon: Icons.child_care, group: 'family'),

    // Subscriptions & Services
    CategoryDetails(
      key: 'subscriptions',
      imagePath: '$_basePath/الأشتراكات.svg',
      group: 'subscriptions',
    ),
    CategoryDetails(key: 'services', imagePath: '$_basePath/خدمات.svg', group: 'subscriptions'),
    CategoryDetails(key: 'streaming', icon: Icons.video_library, group: 'subscriptions'),

    // Financial
    CategoryDetails(key: 'insurance', imagePath: '$_basePath/تأمينات.svg', group: 'financial'),
    CategoryDetails(key: 'bank_fees', icon: Icons.account_balance, group: 'financial'),
    CategoryDetails(key: 'taxes', icon: Icons.receipt_long, group: 'financial'),

    // Gifts & Donations
    CategoryDetails(key: 'gifts', icon: Icons.card_giftcard, group: 'other'),
    CategoryDetails(key: 'donations', imagePath: '$_basePath/تبرعات.svg', group: 'other'),
    CategoryDetails(key: 'charity', icon: Icons.favorite, group: 'other'),

    // Other
    CategoryDetails(key: 'other', imagePath: '$_basePath/اخرى.svg', group: 'other'),

    // ========== INCOME ==========
    // Salary & Work
    CategoryDetails(key: 'salary', icon: Icons.attach_money, isIncome: true, group: 'salary'),
    CategoryDetails(key: 'freelance', icon: Icons.work, isIncome: true, group: 'salary'),
    CategoryDetails(key: 'bonus', icon: Icons.card_giftcard, isIncome: true, group: 'salary'),

    // Business & Sales
    CategoryDetails(
      key: 'sales',
      imagePath: '$_basePath/مبيعات.svg',
      isIncome: true,
      group: 'business',
    ),
    CategoryDetails(key: 'business', icon: Icons.business, isIncome: true, group: 'business'),
    CategoryDetails(key: 'rental_income', icon: Icons.home, isIncome: true, group: 'business'),

    // Investments
    CategoryDetails(
      key: 'investment',
      imagePath: '$_basePath/استثمار.svg',
      isIncome: true,
      group: 'investment',
    ),
    CategoryDetails(key: 'dividends', icon: Icons.trending_up, isIncome: true, group: 'investment'),
    CategoryDetails(key: 'interest', icon: Icons.savings, isIncome: true, group: 'investment'),

    // Transfers
    CategoryDetails(
      key: 'transfer_money',
      imagePath: '$_basePath/تحويل.svg',
      isIncome: true,
      group: 'transfer',
    ),
    CategoryDetails(
      key: 'withdraw_money',
      imagePath: '$_basePath/سحب.svg',
      isIncome: true,
      group: 'transfer',
    ),
    CategoryDetails(key: 'refund', icon: Icons.refresh, isIncome: true, group: 'transfer'),

    // Other Income
    CategoryDetails(key: 'gift_income', icon: Icons.card_giftcard, isIncome: true, group: 'other'),
    CategoryDetails(key: 'other_income', icon: Icons.add_circle, isIncome: true, group: 'other'),
  ];

  // Category groups for organization
  static const Map<String, String> expenseGroups = {
    'bills': 'bills_group',
    'food': 'food_group',
    'shopping': 'shopping_group',
    'transport': 'transport_group',
    'health': 'health_group',
    'education': 'education_group',
    'housing': 'housing_group',
    'entertainment': 'entertainment_group',
    'personal': 'personal_group',
    'family': 'family_group',
    'subscriptions': 'subscriptions_group',
    'financial': 'financial_group',
    'other': 'other_group',
  };

  static const Map<String, String> incomeGroups = {
    'salary': 'salary_group',
    'business': 'business_group',
    'investment': 'investment_group',
    'transfer': 'transfer_group',
    'other': 'other_income_group',
  };

  static List<CategoryDetails> get expenseCategories =>
      categories.where((c) => !c.isIncome).toList();

  static List<CategoryDetails> get incomeCategories => categories.where((c) => c.isIncome).toList();

  static CategoryDetails getCategory(String key) {
    try {
      return categories.firstWhere((element) => element.key == key);
    } catch (e) {
      return CategoryDetails(key: key, icon: Icons.category);
    }
  }
}
