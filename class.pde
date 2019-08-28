
// TODO: doc and organize

// TODO: doc methods 
public class ShiftManager {
  // Shift amounts (pixels and percentage)
  int shiftAmount;
  int shiftPercent;
  // Corresponding image dimension (used for percent and max calculations)
  int imgDimension;

  public ShiftManager(int imgDimension) {
    this.shiftAmount = 0;
    this.shiftPercent = 0;
    this.imgDimension = imgDimension;
  }

  // Percent/Pixel Conversion

  private int shiftPercentToPixels(int shiftPercent) {
    return (int)(this.imgDimension * shiftPercent / 100);
  }

  private int shiftPixelsToPercent(int shiftAmount) {
    return (int)(100 * shiftAmount / this.imgDimension);
  }

  // Getter/Setter Methods

  public void setShiftAmount(int shiftAmount) {
    this.shiftAmount = shiftAmount;
    this.shiftPercent = this.shiftPixelsToPercent(shiftAmount);
  }

  public int getShiftAmount() { return this.shiftAmount; }

  public void setShiftPercent(int shiftPercent) {
    this.shiftPercent = shiftPercent;
    this.shiftAmount = this.shiftPercentToPixels(shiftPercent);
  }

  public int getShiftPercent() { return this.shiftPercent; }

  // TODO: just reset shift values?
  public void setImgDimension(int imgDimension) {
    // Skip if dimension is unchanged
    if (imgDimension == this.imgDimension)
      return;
    this.imgDimension = imgDimension;
    // Recalculate shift amount based on new dimension
    this.shiftAmount = this.shiftPercentToPixels(this.shiftPercent);
  }

  public int getImgDimension() { return this.imgDimension; }
}

