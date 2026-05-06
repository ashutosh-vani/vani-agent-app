/// Utility class for formatting numbers in Indian number system
class NumberFormatter {
  /// Format number in Indian number system (lakhs, crores)
  /// Examples:
  /// - 1000 -> 1,000
  /// - 10000 -> 10,000
  /// - 100000 -> 1,00,000 (1 lakh)
  /// - 10000000 -> 1,00,00,000 (1 crore)
  /// - 233.62 -> 233.62
  /// - 153263.51 -> 1,53,263.51
  static String formatIndian(dynamic value) {
    if (value == null) return '0';
    
    // Convert to string and remove any existing formatting
    String numStr = value.toString().replaceAll(',', '').trim();
    
    // Handle empty string
    if (numStr.isEmpty) return '0';
    
    // Try to parse as number
    double? number;
    try {
      number = double.parse(numStr);
    } catch (e) {
      // If parsing fails, return original value
      return value.toString();
    }
    
    // Handle negative numbers
    bool isNegative = number < 0;
    if (isNegative) {
      number = number.abs();
    }
    
    // Convert to string to split properly
    String numString = number.toString();
    
    // Handle scientific notation (e.g., 1.5e+7)
    if (numString.contains('e') || numString.contains('E')) {
      number = double.parse(numString);
      numString = number.toStringAsFixed(2);
      // Remove trailing zeros after decimal
      if (numString.contains('.')) {
        numString = numString.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      }
    }
    
    // Split into integer and decimal parts
    List<String> parts = numString.split('.');
    String intPart = parts[0];
    String decimalPart = '';
    
    // Only keep decimal part if it exists and is not just zeros
    if (parts.length > 1 && parts[1] != '0') {
      decimalPart = parts[1];
    }
    
    // Parse integer part
    int intValue;
    try {
      intValue = int.parse(intPart);
    } catch (e) {
      return value.toString();
    }
    
    // If less than 1000, no formatting needed
    if (intValue < 1000) {
      String result = intPart;
      if (decimalPart.isNotEmpty) {
        result += '.$decimalPart';
      }
      return isNegative ? '-$result' : result;
    }
    
    // Indian number system formatting for integer part
    String result = '';
    int length = intPart.length;
    
    // Last 3 digits
    result = intPart.substring(length - 3);
    int remaining = length - 3;
    
    // Add remaining digits in groups of 2
    while (remaining > 0) {
      int start = remaining - 2;
      if (start < 0) start = 0;
      result = '${intPart.substring(start, remaining)},$result';
      remaining = start;
    }
    
    // Add decimal part if exists
    if (decimalPart.isNotEmpty) {
      result += '.$decimalPart';
    }
    
    return isNegative ? '-$result' : result;
  }
  
  /// Format currency with rupee symbol
  /// Meta API returns amounts in smallest currency unit (cents/paise),
  /// so we divide by 100 to get the actual currency value.
  static String formatCurrency(dynamic value, {String currency = '₹', bool divideBy100 = true}) {
    if (value == null) return '$currency 0';
    
    String numStr = value.toString().replaceAll(',', '').trim();
    if (numStr.isEmpty) return '$currency 0';
    
    double? number;
    try {
      number = double.parse(numStr);
    } catch (e) {
      return '$currency $value';
    }
    
    if (divideBy100) {
      number = number / 100;
    }
    
    // Format with 2 decimal places for currency
    String formatted = number.toStringAsFixed(2);
    
    // Split into integer and decimal parts
    List<String> parts = formatted.split('.');
    String intPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '00';
    
    // Handle negative
    bool isNegative = intPart.startsWith('-');
    if (isNegative) {
      intPart = intPart.substring(1);
    }
    
    // Apply Indian number formatting to integer part
    int intValue;
    try {
      intValue = int.parse(intPart);
    } catch (e) {
      return '$currency $value';
    }
    
    String formattedInt;
    if (intValue < 1000) {
      formattedInt = intPart;
    } else {
      // Indian number system formatting
      String result = '';
      int length = intPart.length;
      result = intPart.substring(length - 3);
      int remaining = length - 3;
      while (remaining > 0) {
        int start = remaining - 2;
        if (start < 0) start = 0;
        result = '${intPart.substring(start, remaining)},$result';
        remaining = start;
      }
      formattedInt = result;
    }
    
    String finalResult = '$formattedInt.$decimalPart';
    if (isNegative) {
      finalResult = '-$finalResult';
    }
    
    return '$currency $finalResult';
  }
  
  /// Format large numbers with K, L, Cr suffixes
  /// Examples:
  /// - 1000 -> 1K
  /// - 100000 -> 1L
  /// - 10000000 -> 1Cr
  static String formatCompact(dynamic value) {
    if (value == null) return '0';
    
    double number;
    try {
      number = double.parse(value.toString().replaceAll(',', ''));
    } catch (e) {
      return value.toString();
    }
    
    if (number >= 10000000) {
      // Crores
      return '${(number / 10000000).toStringAsFixed(2)}Cr';
    } else if (number >= 100000) {
      // Lakhs
      return '${(number / 100000).toStringAsFixed(2)}L';
    } else if (number >= 1000) {
      // Thousands
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    
    return number.toStringAsFixed(0);
  }
}
