import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/category_utils.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        final expenseCategories = state.expenseCategories;
        final incomeCategories = state.incomeCategories;

        return Container(
          height: 600.h,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: 'search'.tr(),
                          prefixIcon: const Icon(Icons.search),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: [
                  Tab(text: 'expenses'.tr()),
                  Tab(text: 'income'.tr()),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCategoryGrid(expenseCategories),
                    _buildCategoryGrid(incomeCategories),
                  ],
                ),
              ),

              // "Add New Section" button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddCategoryView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                  ),
                  child: Text(
                    'add_new_section'.tr(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
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

  Widget _buildCategoryGrid(List<CategoryDetails> categories) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return InkWell(
          onTap: () => widget.onCategorySelected(cat.key, cat.imagePath, cat.icon, cat.isIncome),
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: cat.imagePath != null
                      ? SvgPicture.asset(
                          cat.imagePath!,
                          width: 32.w,
                          height: 32.w,
                          // placeholderBuilder: (context) => Icon(cat.icon ?? Icons.category, color: Theme.of(context).primaryColor),
                        )
                      : Icon(
                          cat.icon ?? Icons.category,
                          color: Theme.of(context).primaryColor,
                          size: 28.sp,
                        ),
                ),
                SizedBox(height: 12.h),
                Text(
                  cat.key.tr(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
