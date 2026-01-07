import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onNextMonth;
  final VoidCallback onPreviousMonth;
  final DateTime selectedDate;

  const HomeHeader({
    super.key,
    required this.onNextMonth,
    required this.onPreviousMonth,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentMonth =
        selectedDate.year == DateTime.now().year && selectedDate.month == DateTime.now().month;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPreviousMonth,
            icon: Icon(Icons.chevron_left, size: 30.sp, color: Theme.of(context).iconTheme.color),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(width: 40.w),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18.sp, color: Theme.of(context).iconTheme.color),
              SizedBox(width: 8.w),
              Text(
                DateFormat('MMMM yyyy', context.locale.toString()).format(selectedDate),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(width: 40.w),
          IconButton(
            onPressed: isCurrentMonth ? null : onNextMonth,
            icon: Icon(
              Icons.chevron_right,
              size: 30.sp,
              color: isCurrentMonth
                  ? Colors.grey.withOpacity(0.3)
                  : Theme.of(context).iconTheme.color,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
