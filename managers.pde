// =============================================================================
// Classes to manage the internal state of the sketch
// =============================================================================

// Images ======================================================================

public class ImgManager {
  // Source, modified, and preview images
  public PImage sourceImg, targetImg, previewImg;
  // Width/height vars for easy access
  public int imgWidth, imgHeight;

  public ImgManager() {
    imgWidth = imgHeight = 0;
  }

  // Getter/Setter

  public void loadImageFile(String path) {
    // Initialize images
    sourceImg = loadImage(path);
    targetImg = sourceImg.copy();
    previewImg = sourceImg.copy();
    // This seems to fix a bug where the recursive option doesn't do anything
    sourceImg.loadPixels();
    targetImg.loadPixels();
    previewImg.loadPixels();
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
    previewImg.loadPixels();
  }

  public void copyPreviewToTarget() {
    targetImg = previewImg.copy();
    targetImg.loadPixels();
  }

  public void updatePreview() {
    previewImg.updatePixels();
  }

  // For recursive iterations
  public void copyTargetPixelsToSource() {
    sourceImg.pixels = targetImg.pixels;
    sourceImg.updatePixels();
  }

}

// Source/Target Channels ======================================================

/**
 * Manage the state of selected color channels
 */
public class ChannelManager {
  // Source and target channels
  public int sourceChannel, targetChannel;

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

// Shift Type Interface --------------------------------------------------------

public interface ShiftTypeState {
  // TODO stringifyStep() method
  // Calculate offset for this shift type
  public int calculateShiftOffset(int x, int y, int shift, boolean horizontal);
}

// Default ---------------------------------------------------------------------

public class DefaultShiftType implements ShiftTypeState {
  public int calculateShiftOffset(int x, int y, int shift, boolean horizontal) {
    return (horizontal ? x : y) + shift;
  }
}

// Multiply --------------------------------------------------------------------

public class MultiplyShiftType implements ShiftTypeState {
  // Multiplier values specific to this shift type
  public float xMultiplier, yMultiplier;

  public MultiplyShiftType(float xMult, float yMult) {
    xMultiplier = xMult;
    yMultiplier = yMult;
  }

  public MultiplyShiftType() {
    // Arbitrarily using 2 in the event that this doesn't get set
    this(2.0, 2.0);
  }

  public int calculateShiftOffset(int x, int y, int shift, boolean horizontal) {
    return (int)(horizontal ? x * xMultiplier : y * yMultiplier) + shift; 
  }

  // Set multipliers
  public void setXMultiplier(float val) { xMultiplier = val; }
  public void setYMultiplier(float val) { yMultiplier = val; }
  public void setMultiplier(float val, boolean horizontal) {
    if (horizontal)
      xMultiplier = val;
    else
      yMultiplier = val;
  }
  public void setMultipliers(float xMult, float yMult) {
    xMultiplier = xMult;
    yMultiplier = yMult;
  }

  // Get multipliers
  public float getMultiplier(boolean horizontal) {
    return horizontal ? xMultiplier : yMultiplier;
  }
}

// Linear ----------------------------------------------------------------------

public class LinearShiftType implements ShiftTypeState {
  // Coefficient for equation
  public float m;
  // TODO negative coefficient (boolean/checkbox)
  // y=mx+b if true, x=my+b if false
  public boolean yEquals;

  public LinearShiftType(float m, boolean yEquals) {
    this.m = m;
    this.yEquals = yEquals;
  }

  public LinearShiftType() {
    // Arbitrarily using y=x+shift as the default
    this(1.0, true);
  }

  public int calculateShiftOffset(int x, int y, int shift, boolean horizontal) {
    int offset;
    // y= equation
    if (yEquals) 
      offset = horizontal ? x + (int)((y - shift) / m) : y + (int)(m * x + shift);
    // x= equation
    else 
      offset = horizontal ? x + (int)(y * m + shift) : y + (int)((x - shift) / m);
    return offset; 
  }

  // Setters
  public void setCoefficient(float val) { m = val; }
  public void setEquationType(boolean isYEquals) { yEquals = isYEquals; }
  public void yEqualsEquation() { setEquationType(true); }
  public void xEqualsEquation() { setEquationType(false); }

  // Getters
  public float getCoefficient() { return m; }
  public boolean isYEqualsEquation() { return yEquals; }
}

// Skew ------------------------------------------------------------------------

public class SkewShiftType implements ShiftTypeState {
  // TODO doc, floats? negative?
  float xSkew, ySkew;

  public SkewShiftType(float xSkew, float ySkew) {
    this.xSkew = xSkew;
    this.ySkew = ySkew;
  }

  public SkewShiftType() {
    this(2.0, 2.0);
  }

  public int calculateShiftOffset(int x, int y, int shift, boolean horizontal) {
    return horizontal ? x + shift + (int)(xSkew * y) : y + shift + (int)(ySkew * x);
  }

  // Setters
  public void setXSkew(float val) { xSkew = val; }
  public void setYSkew(float val) { ySkew = val; }
  public void setSkew(float val, boolean horizontal) { 
    if (horizontal)
      xSkew = val;
    else
      ySkew = val;
  }

  // Getters
  public float getXSkew() { return xSkew; }
  public float getYSkew() { return ySkew; }
  public float getSkew(boolean horizontal) { return horizontal ? xSkew : ySkew; }
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
  int TYPE_LINEAR = 2;
  int TYPE_SKEW = 3;
  // TODO: figure out a dynamic way to do this
  int TOTAL_SHIFT_TYPES = 4;

  public ShiftTypeManager() {
    shiftTypes = new ShiftTypeState[TOTAL_SHIFT_TYPES];
    // Initialize state objects
    shiftTypes[TYPE_DEFAULT] = new DefaultShiftType();
    shiftTypes[TYPE_MULTIPLY] = new MultiplyShiftType();
    shiftTypes[TYPE_LINEAR] = new LinearShiftType();
    shiftTypes[TYPE_SKEW] = new SkewShiftType();
    // Start w/ default
    state = TYPE_DEFAULT;
  }

  public int calculateShiftOffset(int x, int y, int shift, boolean horizontal) {
    return shiftTypes[state].calculateShiftOffset(x, y, shift, horizontal);
  }

  public void setShiftType(int shiftType) {
    // Handle out of bounds index
    state = shiftType < shiftTypes.length ? shiftType : 0;
  }

  // Config Setters

  // Multiply
  public void multiply_setMultiplier(float val, boolean horizontal) {
    ((MultiplyShiftType)shiftTypes[TYPE_MULTIPLY]).setMultiplier(val, horizontal);
  }
  public float multiply_getMultiplier(boolean horizontal) {
    return ((MultiplyShiftType)shiftTypes[TYPE_MULTIPLY]).getMultiplier(horizontal);
  }

  // Linear
  public void linear_setCoefficient(float val) {
    ((LinearShiftType)shiftTypes[TYPE_LINEAR]).setCoefficient(val);
  }
  public float linear_getCoefficient() {
    return ((LinearShiftType)shiftTypes[TYPE_LINEAR]).getCoefficient();
  }
  public void linear_setEquationType(boolean isYEquals) {
    ((LinearShiftType)shiftTypes[TYPE_LINEAR]).setEquationType(isYEquals);
  }
  public boolean linear_isYEqualsEquation() {
    return ((LinearShiftType)shiftTypes[TYPE_LINEAR]).isYEqualsEquation();
  }

  // Skew
  public void skew_setSkew(float val, boolean horizontal) {
    ((SkewShiftType)shiftTypes[TYPE_SKEW]).setSkew(val, horizontal);
  }
  public float skew_getSkew(boolean horizontal) {
    return ((SkewShiftType)shiftTypes[TYPE_SKEW]).getSkew(horizontal);
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


