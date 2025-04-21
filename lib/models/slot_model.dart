/// Model representing a turf slot to be created.
class SlotModel {
  final String slotId;
  final String date; // ISO 8601 format (e.g., "2025-04-13")
  final String startTime; // ISO 8601 format (e.g., "2025-04-13T09:00:00")
  final int available5sTurfCount;
  final int available7sTurfCount;
  final double turf5sPrice;
  final double turf7sPrice;

  SlotModel({
    required this.slotId,
    required this.date,
    required this.startTime,
    required this.available5sTurfCount,
    required this.available7sTurfCount,
    required this.turf5sPrice,
    required this.turf7sPrice,
  });

  /// Converts this model to a map for storing in Firestore or JSON.
  Map<String, dynamic> toMap() {
    return {
      'slotId': slotId,
      'date': date,
      'startTime': startTime,
      'available5sTurfCount': available5sTurfCount,
      'available7sTurfCount': available7sTurfCount,
      'turf5sPrice': turf5sPrice,
      'turf7sPrice': turf7sPrice,
    };
  }

  /// Creates a model from a map (e.g., Firestore or JSON).
  factory SlotModel.fromMap(
      Map<String, dynamic> map, Map<String, dynamic> data) {
    return SlotModel(
      slotId: map['slotId'] ?? '',
      date: map['date'] ?? '',
      startTime: map['startTime'] ?? '',
      available5sTurfCount: map['available5sTurfCount'] ?? 0,
      available7sTurfCount: map['available7sTurfCount'] ?? 0,
      turf5sPrice: (map['turf5sPrice'] ?? 0).toDouble(),
      turf7sPrice: (map['turf7sPrice'] ?? 0).toDouble(),
    );
  }
}
