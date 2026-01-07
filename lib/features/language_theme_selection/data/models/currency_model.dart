class CurrencyModel {
  final String code;
  final String name;
  final String flag;

  const CurrencyModel({required this.code, required this.name, required this.flag});

  static List<CurrencyModel> get popularCurrencies => [
    const CurrencyModel(code: 'EGP', name: 'Egyptian Pound', flag: '🇪🇬'),
    const CurrencyModel(code: 'USD', name: 'US Dollar', flag: '🇺🇸'),
    const CurrencyModel(code: 'EUR', name: 'Euro', flag: '🇪🇺'),
    const CurrencyModel(code: 'SAR', name: 'Saudi Riyal', flag: '🇸🇦'),
    const CurrencyModel(code: 'AED', name: 'UAE Dirham', flag: '🇦🇪'),
    const CurrencyModel(code: 'KWD', name: 'Kuwaiti Dinar', flag: '🇰🇼'),
    const CurrencyModel(code: 'GBP', name: 'British Pound', flag: '🇬🇧'),
  ];
}
