// =============================================================================
// Classes to manage the internal state of the sketch
// =============================================================================

// Channel Shift ===============================================================

/**
 * Manage the state of channel shift values
 */
public class ShiftManager {
  // Shift amounts (pixels and percentage)
  public int shiftAmount, shiftPercent;
  // Corresponding image dimension (used for percent and max calculations)
  public int imgDimension;

  public ShiftManager() {
    shiftAmount = shiftPercent = imgDimension = 0;
  }

  public ShiftManager(int imgDimension) {
    this(); 
    this.imgDimension = imgDimension;
  }

  // Percent/Pixel Conversion

  private int shiftPercentToPixels(int percent) {
    return (int)(imgDimension * percent / 100);
  }

  private int shiftPixelsToPercent(int amount) {
    return (int)(100 * amount / imgDimension);
  }

  // Getter/Setter Methods

  public void setShiftAmount(int amount) {
    // Upper bound
    if (amount > imgDimension)
      amount = imgDimension;
    shiftAmount = amount;
    shiftPercent = shiftPixelsToPercent(amount);
  }

  public void setShiftPercent(int percent) {
    // Upper bound
    if (percent > 100)
      percent = 100;
    shiftPercent = percent;
    shiftAmount = shiftPercentToPixels(percent);
  }

  public void resetShift() { shiftAmount = shiftPercent = 0; }

  // Randomize shift value
  public void randomize(int maxPercent) {
    setShiftAmount(int(random(imgDimension * maxPercent / 100)));
  }
  public void randomize() { randomize(100); }

  // Return true if shift is 0
  public boolean shiftIsZero() { return shiftAmount == 0; }

  public void setImgDimension(int dimension) {
    // Skip if dimension is unchanged
    if (dimension == imgDimension)
      return;
    imgDimension = dimension;
    // Recalculate shift amount based on new dimension
    shiftAmount = shiftPercentToPixels(shiftPercent);
  }

  public int getImgDimension() { return imgDimension; }
}

