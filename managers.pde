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

  // Return true if channels match
  public boolean channelsMatch() { return this.sourceChannel == this.targetChannel; }

  // Reset channels to default
  public void resetChannels() { this.sourceChannel = this.targetChannel = 0; }

  // Randomize channels
  public void randomize(boolean source, boolean target) {
    if (source) {
      this.sourceChannel = int(random(3));
      // Set target to match source if we're not randomizing it
      // TODO: document this behavior somewhere or only do this if !this.swapChannels?
      if (!target) {
        this.targetChannel = this.sourceChannel;
      }
    }
    if (target) {
      this.targetChannel = int(random(3));
    }
  }

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

  // TODO: upper limit based on param
  // Randomize shift value
  public void randomize() {
    this.setShiftAmount(int(random(this.imgDimension)));
  }

  // Return true if shift is 0
  public boolean shiftIsZero() { return this.shiftAmount == 0; }

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

// Randomize Config ============================================================

public class RandomizeManager {
  // If true, randomize the corresponding settings
  boolean src, targ, xShift, yShift; 

  public RandomizeManager() {
    this.src = this.targ = this.xShift = this.yShift = true; 
  }

  // Getter/Setter Methods

  // Source channel
  public void toggleSource(boolean val) { this.src = val; }
  public boolean randomizeSource() { return this.src; }

  // Target channel
  public void toggleTarget(boolean val) { this.targ = val; }
  public boolean randomizeTarget() { return this.targ; }

  // Either channel (let ChannelManager determine which one(s))
  public boolean randomizeChannel() { return this.src || this.targ; }

  // Horizontal shift
  public void toggleXShift(boolean val) { this.xShift = val; }
  public boolean randomizeXShift() { return this.xShift; }

  // Vertical shift
  public void toggleYShift(boolean val) { this.yShift = val; }
  public boolean randomizeYShift() { return this.yShift; }

}

