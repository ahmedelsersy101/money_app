import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/home_cubit.dart';
import '../widgets/home_header.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_list.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'wallets_view.dart';
import 'reports_view.dart';
import '../../language_theme_selection/language_theme_selection_view.dart';

import '../../add_transaction/views/add_transaction_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeViewBody();
  }
}

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeDashboard(),
    const WalletsView(),
    const ReportsView(),
    const LanguageThemeSelectionView(isSettingsPage: true),
  ];

  final List<String> _titles = ['app_name', 'wallets', 'reports', 'settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.background, // Removed to let Theme handle it
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex].tr(),
          // Use style from Theme
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: _currentIndex == 0
            ? [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none, color: Theme.of(context).iconTheme.color),
                ),
              ]
            : [],
      ),
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTransactionView()),
                );
              },
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Center(
                child: HomeHeader(
                  selectedDate: state.selectedDate,
                  onNextMonth: () => context.read<HomeCubit>().changeMonth(1),
                  onPreviousMonth: () => context.read<HomeCubit>().changeMonth(-1),
                ),
              ),
              SizedBox(height: 20.h),
              SummaryCard(
                balance: state.balance,
                income: state.monthlyIncome,
                expenses: state.monthlyExpenses,
                currencyCode: state.currencyCode,
              ),
              SizedBox(height: 20.h),
              TransactionList(
                transactions: state.filteredTransactions,
                currencyCode: state.currencyCode,
              ),
            ],
          );
        },
      ),
    );
  }
}
