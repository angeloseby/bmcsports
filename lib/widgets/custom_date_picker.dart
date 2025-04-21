import 'package:bmcsports/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: EasyDateTimeLine(
        initialDate: initialDate,
        onDateChange: onDateSelected,
        activeColor: AppColors.secondaryColor, // Yellow accent
        timeLineProps: const EasyTimeLineProps(
            decoration: BoxDecoration(
          shape: BoxShape.circle,
        )),
        headerProps: const EasyHeaderProps(
          showSelectedDate: true,
          dateFormatter: DateFormatter.fullDateMonthAsStrDY(),
        ),
        dayProps: const EasyDayProps(
          dayStructure: DayStructure.dayStrDayNumMonth,
          activeDayStyle: DayStyle(
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            dayStrStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            monthStrStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            dayNumStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          inactiveDayStyle: DayStyle(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              dayStrStyle:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
              dayNumStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              monthStrStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
