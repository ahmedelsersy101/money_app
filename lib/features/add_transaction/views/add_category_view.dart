import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/category_cubit.dart';

class AddCategoryView extends StatefulWidget {
  const AddCategoryView({super.key});

  @override
  State<AddCategoryView> createState() => _AddCategoryViewState();
}

class _AddCategoryViewState extends State<AddCategoryView> {
  int _selectedTypeIndex =
      0; // 0 for Expenses (left in logic, but UI depends on order), 1 for Income
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('add_new_section'.tr()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Type Label
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'section_type'.tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10.h),

                // Segmented Control (Income / Expenses)
                Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTypeIndex = 1; // Income
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedTypeIndex == 1
                                  ? const Color(0xFFD6E4FF)
                                  : Colors.transparent, // Light blue selection
                              borderRadius: BorderRadius.horizontal(
                                left: context.locale.languageCode == 'ar'
                                    ? Radius.zero
                                    : Radius.circular(24.r),
                                right: context.locale.languageCode == 'ar'
                                    ? Radius.circular(24.r)
                                    : Radius.zero,
                              ),
                              border: _selectedTypeIndex == 1
                                  ? Border.all(color: Colors.blue.shade200)
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'income'.tr(),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors
                                    .black, // Always black for better contrast on light blue or white
                                fontWeight: _selectedTypeIndex == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(width: 1, color: Colors.grey.shade400),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTypeIndex = 0; // Expenses
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedTypeIndex == 0
                                  ? Colors.white
                                  : Colors.transparent, // White selection
                              borderRadius: BorderRadius.horizontal(
                                left: context.locale.languageCode == 'ar'
                                    ? Radius.circular(24.r)
                                    : Radius.zero,
                                right: context.locale.languageCode == 'ar'
                                    ? Radius.zero
                                    : Radius.circular(24.r),
                              ),
                              border: _selectedTypeIndex == 0
                                  ? Border.all(
                                      color: Colors.grey.shade400,
                                    ) // Slightly different to show selection
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'expenses'.tr(),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.black,
                                fontWeight: _selectedTypeIndex == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 30.h),

                // Section Name Input
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'section_name'.tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, // Light grey background like image
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      hintText: '', // Placeholder can be empty
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),

                SizedBox(height: 100.h), // Adjusted spacer
                // Add Button
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a category name')),
                        );
                        return;
                      }
                      context.read<CategoryCubit>().addCategory(
                        _nameController.text.trim(),
                        _selectedTypeIndex == 1,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor, // Blue
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      elevation: 0,
                    ),
                    child: Text(
                      'add'.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
