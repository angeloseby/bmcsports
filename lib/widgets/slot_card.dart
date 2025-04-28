import 'package:bmcsports/models/slot_model.dart';
import 'package:bmcsports/styles/app_colors.dart';
import 'package:bmcsports/utils/slot_time_formatter.dart';
import 'package:flutter/material.dart';

class SlotCard extends StatelessWidget {
  final SlotModel slot;
  final String selectedTurfType;
  final bool isSelected;

  const SlotCard({
    super.key,
    required this.slot,
    required this.selectedTurfType,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.white,
      shape: RoundedRectangleBorder(
        side: isSelected
            ? const BorderSide(color: AppColors.primaryColor, width: 2)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        leading: const Icon(Icons.access_time, color: Color(0xFF003453)),
        title: Text(
          '${slotTimeFormatter(slot.startTime)} - ₹${selectedTurfType == '5s' ? slot.turf5sPrice : slot.turf7sPrice}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
