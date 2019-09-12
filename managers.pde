// =============================================================================
// Classes to manage the internal state of the sketch
// =============================================================================

// TODO: consistent syntax/naming/usage of this
// TODO: make attributes public so getters aren't necessary?

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
    // Upper bound
    if (shiftAmount > this.imgDimension)
      shiftAmount = this.imgDimension;
    this.shiftAmount = shiftAmount;
    this.shiftPercent = this.shiftPixelsToPercent(shiftAmount);
  }

  public int getShiftAmount() { return this.shiftAmount; }

  public void setShiftPercent(int shiftPercent) {
    // Upper bound
    if (shiftPercent > 100)
      shiftPercent = 100;
    this.shiftPercent = shiftPercent;
    this.shiftAmount = this.shiftPercentToPixels(shiftPercent);
  }

  public int getShiftPercent() { return this.shiftPercent; }

  public void resetShift() { this.shiftAmount = this.shiftPercent = 0; }

  // Randomize shift value
  public void randomize(int maxPercent) {
    this.setShiftAmount(int(random(this.imgDimension * maxPercent / 100)));
  }
  public void randomize() { this.randomize(100); }

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
  // Maximum percent channels can be shifted
  int xShiftMax, yShiftMax;

  public RandomizeManager() {
    this.src = this.targ = this.xShift = this.yShift = true; 
    this.xShiftMax = this.yShiftMax = 100;
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
  // Horizontal shift max percent
  public void setXShiftMaxPercent(int percent) {
    this.xShiftMax = this.getPercentWithinBounds(percent);
  }
  public int xShiftMaxPercent() { return this.xShiftMax; }

  // Vertical shift
  public void toggleYShift(boolean val) { this.yShift = val; }
  public boolean randomizeYShift() { return this.yShift; }
  // Vertical shift max percent
  public void setYShiftMaxPercent(int percent) {
    this.yShiftMax = this.getPercentWithinBounds(percent);
  }
  public int yShiftMaxPercent() { return this.yShiftMax; }

  // Conditional max shift getter/setters
  public void setShiftMaxPercent(int percent, boolean horizontal) {
    if (horizontal)
      this.setXShiftMaxPercent(percent);
    else
      this.setYShiftMaxPercent(percent);
  }
  public int shiftMaxPercent(boolean horizontal) {
    return horizontal ? this.xShiftMax : this.yShiftMax;
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

// Preview Window ==============================================================

/**
 * Manages the preview window dimensions
 */
public class WindowManager {
  // Window dimensions
  int windowWidth, windowHeight;
  // Preview window size (does not affect output image size)
  int maxWindowSize;

  public WindowManager() {
    windowWidth = windowHeight = 0;
    maxWindowSize = 600;
  }

  // Getter/Setter Methods

  public void updateWindowDimensions(PImage img) {
    int[] dimensions = this.calculateWindowDimensions(img);
    windowWidth = dimensions[0];
    windowHeight = dimensions[1];
  }

  public int getWidth() { return windowWidth; }
  public int getHeight() { return windowHeight; }

  // TODO: get/set maxWindowSize?

  // Helpers

  /**
   * Calculate window dimensions based on image size and maxWindowSize config
   * @param img The PImage object that will be displayed in the window
   * @return A 2D array where [0] = width and [1] = height 
   */
  int[] calculateWindowDimensions(PImage img) {
    int[] dimensions;
    float ratio = (float) img.width/img.height;
    // Set longer side to maxWindowSize, then multiply ratio by the shorter side to
    // maintain aspect ratio
    if (ratio < 1.0) {
      dimensions = new int[]{(int)(maxWindowSize * ratio), maxWindowSize};
    } else {
      dimensions = new int[]{maxWindowSize, (int)(maxWindowSize / ratio)};
    }
    return dimensions;
  }
}


