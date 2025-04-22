import 'dart:math';

String generateBookingId() {
  // Use a combination of letters and numbers for better readability
  // Format: XXXX-XXXX where X can be a letter or number
  const chars =
      'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Removed confusing characters like I, O, 0, 1
  final random = Random();
  String id = '';

  // Generate first 4 characters
  for (int i = 0; i < 4; i++) {
    id += chars[random.nextInt(chars.length)];
  }

  // Add separator
  id += '-';

  // Generate last 4 characters
  for (int i = 0; i < 4; i++) {
    id += chars[random.nextInt(chars.length)];
  }

  return id;
}
