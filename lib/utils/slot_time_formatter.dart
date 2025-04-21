String slotTimeFormatter(String date) {
  try {
    DateTime dateTime = DateTime.parse(date);
    int hour = dateTime.hour;
    String period = hour < 12 ? 'AM' : 'PM';
    int displayHour = hour % 12;
    if (displayHour == 0) {
      displayHour = 12;
    }
    return '$displayHour $period';
  } catch (e) {
    // Handle potential parsing errors
    print('Error parsing date: $e');
    return date;
  }
}
