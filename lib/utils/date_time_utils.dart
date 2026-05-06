/// Utility functions for date and time formatting
class DateTimeUtils {
  /// Convert UTC DateTime to IST (Indian Standard Time, GMT+5:30)
  static DateTime toIST(DateTime utcDateTime) {
    return utcDateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
  }

  /// Convert IST DateTime to UTC
  static DateTime toUTC(DateTime istDateTime) {
    return istDateTime.subtract(const Duration(hours: 5, minutes: 30)).toUtc();
  }

  /// Get current time in IST
  static DateTime nowIST() {
    return toIST(DateTime.now().toUtc());
  }
}
