import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String bookingId;
  final DateTime bookedTime;

  final List<String> slotIds;
  final String slotDate;
  final List<String>
      slotStartTimes; // Assuming these are string representations of time
  final String bookedType;

  final String customerName;
  final String customerPhoneNumber;
  final String customerEmail;

  final String? paymentId;
  final double paymentAmount;
  final String paymentStatus;
  final String paymentMode;

  BookingModel({
    required this.slotDate,
    required this.bookingId,
    required this.bookedTime,
    required this.slotIds,
    required this.slotStartTimes,
    required this.bookedType,
    required this.customerName,
    required this.customerPhoneNumber,
    required this.customerEmail,
    this.paymentId,
    required this.paymentAmount,
    required this.paymentStatus,
    required this.paymentMode,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      bookingId: map['bookingId'],
      bookedTime: (map['bookedTime'] as Timestamp).toDate(),
      slotIds: List<String>.from(map['slotIds'] ?? []),
      slotDate: map['slotDate'],
      slotStartTimes: List<String>.from(map['slotStartTimes'] ?? []),
      bookedType: map['bookedType'],
      customerName: map['customerName'],
      customerPhoneNumber: map['customerPhoneNumber'],
      customerEmail: map['customerEmail'],
      paymentId: map['paymentId'],
      paymentAmount: (map['paymentAmount'] as num).toDouble(),
      paymentStatus: map['paymentStatus'] ?? '',
      paymentMode: map['paymentMode'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'bookedTime': Timestamp.fromDate(bookedTime),
      'slotIds': slotIds,
      'slotDate': slotDate,
      'slotStartTimes': slotStartTimes,
      'bookedType': bookedType,
      'customerName': customerName,
      'customerPhoneNumber': customerPhoneNumber,
      'customerEmail': customerEmail,
      'paymentId': paymentId,
      'paymentAmount': paymentAmount,
      'paymentStatus': paymentStatus,
      'paymentMode': paymentMode,
    };
  }
}
