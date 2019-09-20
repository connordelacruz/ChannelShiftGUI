// =============================================================================
// Misc. common utility methods
// =============================================================================
import java.util.regex.*;

// Math ========================================================================

// Mod function that handles negatives
// https://dev.to/maurobringolf/a-neat-trick-to-compute-modulo-of-negative-numbers-111e

/** 
 * Mod function that handles negative numbers. Equivalent to x % n, but
 * negative numbers wrap
 * Based on:
 * https://dev.to/maurobringolf/a-neat-trick-to-compute-modulo-of-negative-numbers-111e
 */
int mod(int x, int n) {
  return (x % n + n) % n;
}


// Strings =====================================================================

/** 
 * Truncate a string if it's longer than the specified length
 * @param s String to truncate
 * @param maxLength Max length string should have before getting truncated
 * @param ellipsis If true, append "..." to the end. 3 extra characters will be
 * removed to ensure the output is the desired max length
 * @return Truncated string
 */
String truncateString(String s, int maxLength, boolean ellipsis) {
  if (s.length() > maxLength) {
    if (ellipsis)
      s = s.substring(0, maxLength - 3) + "...";
    else
      s = s.substring(0, maxLength);
  }
  return s;
}

/** 
 * Truncate a string if it's longer than the specified length. If truncated,
 * "..." will be appended to the end. 3 extra characters will be removed to
 * ensure the output is the desired max length
 * @param s String to truncate
 * @param maxLength Max length string should have before getting truncated
 * @return Truncated string
 */
String truncateString(String s, int maxLength) {
  return truncateString(s, maxLength, true);
}


// Input Helpers ===============================================================

// Numeric Inputs --------------------------------------------------------------

/**
 * Clear non-numeric values from text input and return the int representation
 * @param input The GTextField object
 * @return int representation of sanitized text (or -1 if empty string after
 * sanitizing)
 */
int sanitizeIntegerInputValue(GTextField input) {
  String sanitized = input.getText().trim().replaceAll("\\D", "");
  // Return -1 if empty string
  if (sanitized.equals(""))
    return -1;
  int parsed = Integer.parseInt(sanitized);
  return parsed;
}

/**
 * Clear non-numeric/decimal values from text input and return the float
 * representation
 * @param input The GTextField object
 * @return float representation of sanitized text (or -1.0 if empty string
 * after sanitizing)
 */
float sanitizeFloatInputValue(GTextField input) {
  // Replace all but digits and decimals
  String sanitized = input.getText().trim().replaceAll("[^\\d.]", "");
  // Strip any multiple points from string
  Pattern p = Pattern.compile("\\d*\\.?\\d*");
  Matcher m = p.matcher(sanitized);
  // If there's a match, add leading 0 to fix parsing errors with edge cases
  // (e.g. just a ".")
  sanitized = m.find() ? "0" + m.group() : "";
  // Return -1 if empty string
  if (sanitized.equals(""))
    return -1.0;
  float parsed = Float.parseFloat(sanitized);
  return parsed;
}

