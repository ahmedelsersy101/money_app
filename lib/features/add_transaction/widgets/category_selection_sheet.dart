import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/utils/category_utils.dart';
import '../../../core/theme/colors.dart';
import '../views/add_category_view.dart';
import '../cubit/category_cubit.dart';

class CategorySelectionSheet extends StatefulWidget {
  final Function(String key, String? imagePath, IconData? icon, bool isIncome) onCategorySelected;

  const CategorySelectionSheet({super.key, required this.onCategorySelected});

  @override
  State<CategorySelectionSheet> createState() => _CategorySelectionSheetState();
}

class _CategorySelectionSheetState extends State<CategorySelectionSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<CategoryDetails> _filterCategories(List<CategoryDetails> categories) {
    if (_searchQuery.isEmpty) return categories;
    return categories.where((cat) {
      return cat.key.toLowerCase().contains(_searchQuery) ||
          cat.key.tr().toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Map<String, List<CategoryDetails>> _groupCategories(List<CategoryDetails> categories) {
    final filtered = _filterCategories(categories);
    final grouped = <String, List<CategoryDetails>>{};

    for (var cat in filtered) {
      final group = cat.group ?? 'other';
      if (!grouped.containsKey(group)) {
        grouped[group] = [];
      }
      grouped[group]!.add(cat);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final expenseCategories = state.expenseCategories;
        final incomeCategories = state.incomeCategories;

        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Row(
                  children: [
                    Text(
                      'category'.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: FadeInDown(
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border, width: 1.5),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'search'.tr(),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      ),
                    ),
                  ),
                ),
              ),

              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: 'expenses'.tr()),
                  Tab(text: 'income'.tr()),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGroupedCategories(expenseCategories, CategoryUtils.expenseGroups),
                    _buildGroupedCategories(incomeCategories, CategoryUtils.incomeGroups),
                  ],
                ),
              ),

              // "Add New Section" button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddCategoryView()),
                      );
                    },
                    icon: Icon(Icons.add_rounded, size: 20.sp),
                    label: Text('add_new_section'.tr()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGroupedCategories(List<CategoryDetails> categories, Map<String, String> groups) {
    final grouped = _groupCategories(categories);

    if (grouped.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64.sp, color: AppColors.textSecondary),
            SizedBox(height: 16.h),
            Text(
              'no_results'.tr(),
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final groupEntry = grouped.entries.toList()[index];
        final groupKey = groupEntry.key;
        final groupCategories = groupEntry.value;

        return FadeInUp(
          duration: Duration(milliseconds: 100 + (index * 50)),
          child: Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group Header
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
                  child: Text(
                    groups[groupKey]?.tr() ?? groupKey.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.surface,
                    ),
                  ),
                ),

                // Categories Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: groupCategories.length,
                  itemBuilder: (context, catIndex) {
                    final cat = groupCategories[catIndex];
                    return _buildCategoryItem(cat);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(CategoryDetails cat) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => widget.onCategorySelected(cat.key, cat.imagePath, cat.icon, cat.isIncome),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.info.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 217, 240, 237),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: cat.imagePath != null
                  ? SvgPicture.asset(cat.imagePath!, width: 28.w, height: 28.w)
                  : Icon(cat.icon ?? Icons.category_rounded, color: AppColors.primary, size: 24.sp),
            ),
            SizedBox(height: 8.h),
            Flexible(
              child: Text(
                cat.key.tr(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.surface : AppColors.surfaceDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
