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
      child: EasyDateTimeLinePicker(
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 30)),
        onDateChange: onDateSelected,
        currentDate: DateTime.now(),
        focusedDate: initialDate,
        timelineOptions: const TimelineOptions(
          height: 90,
        ),
        headerOptions: const HeaderOptions(
          headerType: HeaderType.viewOnly,
        ),
      ),
    );
  }
}
