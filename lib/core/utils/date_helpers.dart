class DateHelpers {
  static DateTime getStartOfMonth(int month, int year) {
    return DateTime(year, month, 1);
  }

  static DateTime getEndOfMonth(int month, int year) {
    return DateTime(year, month + 1, 0, 23, 59, 59, 999);
  }

  static String formatMonthYear(int month, int year) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[month - 1]} $year';
  }
}