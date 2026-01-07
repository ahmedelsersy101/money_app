import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/currency_model.dart';

class SetupState {
  final CurrencyModel? selectedCurrency;
  final double? initialBalance;

  SetupState({this.selectedCurrency, this.initialBalance});

  SetupState copyWith({CurrencyModel? selectedCurrency, double? initialBalance}) {
    return SetupState(
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      initialBalance: initialBalance ?? this.initialBalance,
    );
  }
}

class SetupCubit extends Cubit<SetupState> {
  final SharedPreferences sharedPreferences;

  SetupCubit({required this.sharedPreferences})
    : super(
        SetupState(
          selectedCurrency: CurrencyModel.popularCurrencies.first, // Default to EGP
        ),
      );

  void setCurrency(CurrencyModel currency) {
    emit(state.copyWith(selectedCurrency: currency));
  }

  void setBalance(String balance) {
    if (balance.isEmpty) {
      emit(state.copyWith(initialBalance: 0));
      return;
    }
    final parsedBalance = double.tryParse(balance);
    if (parsedBalance != null) {
      emit(state.copyWith(initialBalance: parsedBalance));
    }
  }

  Future<void> completeSetup() async {
    if (state.selectedCurrency != null) {
      await sharedPreferences.setString('currency_code', state.selectedCurrency!.code);
    }
    if (state.initialBalance != null) {
      await sharedPreferences.setDouble('initial_balance', state.initialBalance!);
    }
  }
}
