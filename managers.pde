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

// Randomize Config ============================================================

public class RandomizeManager {
  // TODO: more informative names now that these are public 
  // If true, randomize the corresponding settings
  public boolean src, targ, xShift, yShift; 
  // Maximum percent channels can be shifted
  public int xShiftMax, yShiftMax;

  public RandomizeManager() {
    src = targ = xShift = yShift = true; 
    xShiftMax = yShiftMax = 100;
  }

  // Getter/Setter Methods

  // Source channel
  public void toggleSource(boolean val) { src = val; }

  // Target channel
  public void toggleTarget(boolean val) { targ = val; }

  // Either channel (let ChannelManager determine which one(s))
  public boolean randomizeChannel() { return src || targ; }

  // Horizontal shift
  public void toggleXShift(boolean val) { xShift = val; }
  // Horizontal shift max percent
  public void setXShiftMaxPercent(int percent) {
    xShiftMax = getPercentWithinBounds(percent);
  }

  // Vertical shift
  public void toggleYShift(boolean val) { yShift = val; }
  // Vertical shift max percent
  public void setYShiftMaxPercent(int percent) {
    yShiftMax = getPercentWithinBounds(percent);
  }

  // Conditional max shift getter/setters
  public void setShiftMaxPercent(int percent, boolean horizontal) {
    if (horizontal)
      setXShiftMaxPercent(percent);
    else
      setYShiftMaxPercent(percent);
  }
  public int shiftMaxPercent(boolean horizontal) {
    return horizontal ? xShiftMax : yShiftMax;
  }

  // Helpers

  int getPercentWithinBounds(int percent) {
    if (percent > 100)
      percent = 100;
    else if (percent < 0)
      percent = 0;
    return percent;
  }

}



