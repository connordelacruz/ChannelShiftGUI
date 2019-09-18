// =============================================================================
// Classes to manage the internal state of the sketch
// =============================================================================

// TODO: should these just manage state and calculations? Or should they do the work too?

// Images ======================================================================

public class ImgManager {
  // Source, modified, and preview images
  public PImage sourceImg, targetImg, previewImg;
  // Width/height vars for easy access
  public int imgWidth, imgHeight;

  public ImgManager() {
    // TODO: initialize images?
    imgWidth = imgHeight = 0;
  }

  // Getter/Setter

  public void loadImageFile(String path) {
    // Initialize images
    sourceImg = loadImage(path);
    targetImg = sourceImg.copy();
    previewImg = sourceImg.copy();
    // Update width/height vars
    imgWidth = sourceImg.width;
    imgHeight = sourceImg.height;
  }

  // Image Utility Methods
  // TODO: doc, better names?

  public void savePreviewImg(String path) {
    previewImg.save(path);
  }

  public void copyTargetToPreview() {
    previewImg = targetImg.copy();
  }

  public void copyPreviewToTarget() {
    targetImg = previewImg.copy();
  }

  public void updatePreview() {
    previewImg.updatePixels();
  }

  // For recursive iterations
  public void copyTargetPixelsToSource() {
    sourceImg.pixels = targetImg.pixels;
  }

}

// Source/Target Channels ======================================================

/**
 * Manage the state of selected color channels
 */
public class ChannelManager {
  // Source and target channels
  public int sourceChannel, targetChannel;
  // TODO: boolean swapChannels?

  public ChannelManager() {
    sourceChannel = targetChannel = 0;
  }

  // Getter/Setter Methods

  public void setSourceChannel(int channel) {
    sourceChannel = channel;
  }

  public void setTargetChannel(int channel) {
    targetChannel = channel;
  }

  public void setChannel(boolean source, int channel) {
    if (source)
      sourceChannel = channel;
    else
      targetChannel = channel;
  }

  public int getChannel(boolean source) {
    return source ? sourceChannel : targetChannel;
  }

  public void setChannels(int source, int target) {
    sourceChannel = source;
    targetChannel = target;
  }

  public int[] getChannels() { 
    return new int[]{ sourceChannel, targetChannel }; 
  }

  // Set target to match source (i.e. don't swap)
  public void linkTargetToSource() { targetChannel = sourceChannel; }

  // Return true if channels match
  public boolean channelsMatch() { return sourceChannel == targetChannel; }

  // Reset channels to default
  public void resetChannels() { sourceChannel = targetChannel = 0; }

  // Randomize channels
  public void randomize(boolean source, boolean target) {
    if (source) {
      sourceChannel = int(random(3));
      // Set target to match source if we're not randomizing it
      if (!target) {
        targetChannel = sourceChannel;
      }
    }
    if (target) {
      targetChannel = int(random(3));
    }
  }

}


// Shift Type ==================================================================

// Shift Type States -----------------------------------------------------------

// TODO doc and implement; move to a .java file so it can include static attributes?
public interface ShiftTypeState {
  // Calculate offset for this shift type
  public int calculateShiftOffset(int pos, int shift, boolean horizontal);
}

// Implementations

public class DefaultShiftType implements ShiftTypeState {
  public int calculateShiftOffset(int pos, int shift, boolean horizontal) {
    return pos + shift;
  }
}

public class MultiplyShiftType implements ShiftTypeState {
  // Multiplier values specific to this shift type
  public int xMultiplier, yMultiplier;

  public MultiplyShiftType(int xMult, int yMult) {
    xMultiplier = xMult;
    yMultiplier = yMult;
  }

  public MultiplyShiftType() {
    // Arbitrarily using 2 in the event that this doesn't get set
    this(2, 2);
  }

  public int calculateShiftOffset(int pos, int shift, boolean horizontal) {
    int multiplier = horizontal ? xMultiplier : yMultiplier;
    return (pos * multiplier) + shift; 
  }

  // Set multipliers
  public void setXMultiplier(int val) { xMultiplier = val; }
  public void setYMultiplier(int val) { yMultiplier = val; }
  public void setMultiplier(int val, boolean horizontal) {
    if (horizontal)
      xMultiplier = val;
    else
      yMultiplier = val;
  }
  public void setMultipliers(int xMult, int yMult) {
    xMultiplier = xMult;
    yMultiplier = yMult;
  }

  // Get multipliers
  public int getMultiplier(boolean horizontal) {
    return horizontal ? xMultiplier : yMultiplier;
  }
}

// Manager ---------------------------------------------------------------------

public class ShiftTypeManager {
  // Array of state objects
  ShiftTypeState[] shiftTypes;
  // Current state index
  public int state;
  // Indexes
  int TYPE_DEFAULT = 0;
  int TYPE_MULTIPLY = 1;
  // TODO: figure out a better way to do this
  int TOTAL_SHIFT_TYPES = 2;

  public ShiftTypeManager() {
    shiftTypes = new ShiftTypeState[TOTAL_SHIFT_TYPES];
    // Initialize state objects
    shiftTypes[TYPE_DEFAULT] = new DefaultShiftType();
    shiftTypes[TYPE_MULTIPLY] = new MultiplyShiftType();
    // Start w/ default
    state = TYPE_DEFAULT;
  }

  public int calculateShiftOffset(int pos, int shift, boolean horizontal) {
    return shiftTypes[state].calculateShiftOffset(pos, shift, horizontal);
  }

  public void setShiftType(int shiftType) {
    // Handle out of bounds index
    state = shiftType < shiftTypes.length ? shiftType : 0;
  }

  // Config Setters

  // Multiply
  public void multiply_setMultiplier(int val, boolean horizontal) {
    ((MultiplyShiftType)shiftTypes[TYPE_MULTIPLY]).setMultiplier(val, horizontal);
  }
  public int multiply_getMultiplier(boolean horizontal) {
    return ((MultiplyShiftType)shiftTypes[TYPE_MULTIPLY]).getMultiplier(horizontal);
  }

}


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

// Preview Window ==============================================================

/**
 * Manages the preview window dimensions
 */
public class WindowManager {
  // Window dimensions
  public int width, height;
  // Preview window size (does not affect output image size)
  public int maxWindowSize;

  public WindowManager() {
    width = height = 0;
    maxWindowSize = 600;
  }

  // Getter/Setter Methods

  public void updateWindowDimensions(PImage img) {
    int[] dimensions = calculateWindowDimensions(img);
    width = dimensions[0];
    height = dimensions[1];
  }

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


