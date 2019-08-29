// =============================================================================
// Classes to manage the internal state of the sketch
// =============================================================================

// Source/Target Channels ======================================================

/**
 * Manage the state of selected color channels
 */
public class ChannelManager {
  // Source and target channels
  int sourceChannel, targetChannel;
  // TODO: boolean swapChannels?

  public ChannelManager() {
    this.sourceChannel = this.targetChannel = 0;
  }

  // Getter/Setter Methods

  public void setSourceChannel(int channel) {
    this.sourceChannel = channel;
  }

  public int getSourceChannel() { return this.sourceChannel; }

  public void setTargetChannel(int channel) {
    this.targetChannel = channel;
  }

  public int getTargetChannel() { return this.targetChannel; }

  // TODO: setChannel(boolean source, int channel)

  public int getChannel(boolean source) {
    return source ? this.sourceChannel : this.targetChannel;
  }

  public void setChannels(int source, int target) {
    this.sourceChannel = source;
    this.targetChannel = target;
  }

  public int[] getChannels() { 
    return new int[]{ this.sourceChannel, this.targetChannel }; 
  }

  // Set target to match source (i.e. don't swap)
  public void linkTargetToSource() { this.targetChannel = this.sourceChannel; }

  // Reset channels to default
  public void resetChannels() { this.sourceChannel = this.targetChannel = 0; }

}


// Channel Shift ===============================================================

/**
 * Manage the state of channel shift values
 */
public class ShiftManager {
  // Shift amounts (pixels and percentage)
  int shiftAmount, shiftPercent;
  // Corresponding image dimension (used for percent and max calculations)
  int imgDimension;

  public ShiftManager() {
    this.shiftAmount = this.shiftPercent = this.imgDimension = 0;
  }

  public ShiftManager(int imgDimension) {
    this();
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

  public void resetShift() { this.shiftAmount = this.shiftPercent = 0; }

  // TODO: just reset shift values? Then use this instead of creating new ShiftManagers each time
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


