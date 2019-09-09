// =============================================================================
// Misc. common utility methods
// =============================================================================

// TODO: organize, move other stuff here


// Input Helpers ===============================================================

/**
 * Clear non-numeric values from text input and return the int representation
 * @param input The GTextField object
 * @return int representation of sanitized text (or -1 if empty string after
 * sanitizing)
 */
int sanitizeNumericInputValue(GTextField input) {
  String sanitized = input.getText().trim().replaceAll("\\D", "");
  // Return -1 if empty string
  if (sanitized.equals(""))
    return -1;
  int parsed = Integer.parseInt(sanitized);
  return parsed;
}

