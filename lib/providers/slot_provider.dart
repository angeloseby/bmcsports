import 'package:bmcsports/services/slot_services.dart';
import 'package:flutter/material.dart';
import '../models/slot_model.dart';

/// A provider class to manage the creation and real-time streaming of turf slots.
class SlotProvider extends ChangeNotifier {
  final SlotService _slotService = SlotService();

  Stream<List<SlotModel>>? _slotsStream;
  Stream<List<SlotModel>>? get slotsStream => _slotsStream;

  String? _currentDate;
  String? get cuurentDate => _currentDate;

  /// Set the stream for the selected date
  void setSlotStream(String date) {
    _currentDate = date;
    _slotsStream = _slotService.getSlotsByDate(date);
    notifyListeners();
  }
}
