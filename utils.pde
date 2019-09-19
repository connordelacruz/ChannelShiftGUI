// =============================================================================
// Misc. common utility methods
// =============================================================================
import java.util.regex.*;

// TODO: organize, move other stuff here


// Input Helpers ===============================================================

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

