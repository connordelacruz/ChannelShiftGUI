// =============================================================================
// Globals, logic, and event handlers related to channel shift values
// =============================================================================

// TODO rename file? Or rename shiftTypes for consistency?

// Globals =====================================================================

// Set to true if a slider was changed. Window mouse event listener checks this
// when the mouse is released and updates the preview image. This is to avoid
// re-drawing the preview every time the slider value changes
boolean sliderChanged = false;
// Whether the sliders are using percentages of dimensions or exact pixel
// values. Default is percentages. [0] is x slider and [1] is y slider
boolean[] sliderPercentValue = new boolean[]{true, true};


// Manager =====================================================================

/**
 * Manage the state of channel shift values
 */
public class ShiftManager {
  // Shift amounts (pixels and percentage)
  public int shiftAmount, shiftPercent;
  // Corresponding image dimension (used for percent and max calculations)
  public int imgDimension;
  // True if shifting on x axis, false if on y axis (for stringifying step)
  public boolean horizontal;

  public ShiftManager(boolean horizontal) {
    shiftAmount = shiftPercent = imgDimension = 0;
    this.horizontal = horizontal;
  }

  public ShiftManager(boolean horizontal, int imgDimension) {
    this(horizontal); 
    this.imgDimension = imgDimension;
  }

  public String stringifyStep() {
    String step = "";
    // Only show shift if not 0
    if (shiftAmount > 0)
      step += "-" + (horizontal ? "x" : "y") + shiftAmount;
    return step;
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


// Event Handlers ==============================================================
// TODO organize

// Horizontal/Vertical Shift ---------------------------------------------------

/**
 * Shorthand function for checking whether a slider is set to use percent value
 */
boolean sliderPercentValue(boolean horizontal) {
  return sliderPercentValue[horizontal ? 0 : 1];
}

/**
 * Set whether a shift slider is using a percentage or exact pixel values.
 * Converts the existing value of the slider accordingly
 * @param horizontal If true, set horizontal slider, else set vertical slider
 * @param setPercentValue If true, use a percentage for the slider, else use
 * exact pixel values
 */
void setSliderValueType(boolean horizontal, boolean setPercentValue) {
  int configIndex = horizontal ? 0 : 1;
  // Don't update if nothing changed
  if (sliderPercentValue(horizontal) == setPercentValue)
    return;
  ShiftManager manager = horizontal ? xShiftManager : yShiftManager;
  GSlider target = horizontal ? xSlider : ySlider;
  int updatedValue, upperBound;
  if (setPercentValue) {
    updatedValue = manager.shiftPercent;
    upperBound = 100;
  } else {
    updatedValue = manager.shiftAmount;
    upperBound = manager.getImgDimension();
  }
  // Set bounds and current value
  target.setLimits(updatedValue, 0, upperBound);
  // Update text input
  updateShiftSliderInput(horizontal);
  // Update globals
  sliderPercentValue[configIndex] = setPercentValue;
}

/**
 * Set horizontal or vertical shift
 * @param horizontal If true, set horizontal shift, else set vertical shift
 * @param shiftAmount Number of pixels to shift by. If the specified slider is
 * set to use percent values, it will be converted
 */
void setShift(boolean horizontal, int shiftAmount) {
  ShiftManager manager = horizontal ? xShiftManager : yShiftManager;
  if (sliderPercentValue(horizontal))
    manager.setShiftPercent(shiftAmount);
  else
    manager.setShiftAmount(shiftAmount);
}

/**
 * Update the shift slider value to match the corresponding global variable
 * @param horizontal If true, set horizontal shift, else set vertical shift
 */
void updateShiftSlider(boolean horizontal) {
  GSlider slider = horizontal ? xSlider : ySlider;
  GTextField sliderInput = horizontal ? xSliderInput : ySliderInput;
  ShiftManager manager = horizontal ? xShiftManager : yShiftManager;
  boolean percentValue = sliderPercentValue(horizontal);
  int val = percentValue ? manager.shiftPercent : manager.shiftAmount;
  // TODO: extract upperBound calc to method and update usages?
  int upperBound = percentValue ? 100 : manager.getImgDimension();
  slider.setLimits(val, 0, upperBound);
  // Update text input
  updateShiftSliderInput(horizontal);
}

/**
 * Update the x/y shift slider values to match global variables. Wrapper that
 * calls updateShiftSlider() for both horizontal and vertical 
 */
void updateShiftSliders() {
  updateShiftSlider(true);
  updateShiftSlider(false);
}

public void xSlider_change(GSlider source, GEvent event) { 
  setShift(true, source.getValueI());
  xSliderInput.setText("" + source.getValueI());
  sliderChanged = true;
} 

public void ySlider_change(GSlider source, GEvent event) { 
  setShift(false, source.getValueI());
  ySliderInput.setText("" + source.getValueI());
  sliderChanged = true;
} 

// Listens for mouse events and updates preview if a slider was changed
public void controlsWindow_mouse(PApplet appc, GWinData data, MouseEvent event) {
  switch(event.getAction()) {
    case MouseEvent.RELEASE:
      // Update preview if a slider value was changed
      if (sliderChanged) {
        sliderChanged = false;
        showPreview();
      }
      break;
    default:
      break;
  }
}

// Slider Text Inputs ----------------------------------------------------------

// TODO: walk thru what's getting updated and pulling values and reduce any redundancy

/**
 * Event handler for slider inputs
 * @param source The GTextField object
 * @param event The GEvent fired
 * @param horizontal true if horizontal shift input, false if vertical shift
 * input
 */
void sliderInputEventHandler(GTextField source, GEvent event, boolean horizontal) {
  switch(event) {
    case ENTERED:
      // Unfocus on enter, then do same actions as LOST_FOCUS case
      source.setFocus(false);
    case LOST_FOCUS:
      // Sanitize and update slider
      // NOTE: setShift() wraps manager methods that will handle val > upper
      // bound of slider. updateShiftSlider() will call
      // updateShiftSliderInput() after setting the slider to match the
      // ShiftManager, so we don't have to worry about going over the bounds at
      // this time
      int val = sanitizeIntegerInputValue(source);
      if (val > -1) {
        setShift(horizontal, val);
        updateShiftSlider(horizontal);
        showPreview();
      } else {
        // Set to match slider if empty
        updateShiftSliderInput(horizontal);
      }
      break;
    default:
      break;
  }
}

/**
 * Update slider input text to match slider value
 * @param horizontal true if horizontal shift input, false if vertical shift
 * input
 */
void updateShiftSliderInput(boolean horizontal) {
  GTextField input = horizontal ? xSliderInput : ySliderInput;
  GSlider slider = horizontal ? xSlider : ySlider;
  input.setText("" + slider.getValueI());
}

public void xSliderInput_change(GTextField source, GEvent event) {
  sliderInputEventHandler(source, event, true);
}

public void ySliderInput_change(GTextField source, GEvent event) {
  sliderInputEventHandler(source, event, false);
}

// Slider Toggles --------------------------------------------------------------

// TODO: rename related items to indicate that this sets the units of the sliders?

public void xSliderPercent_clicked(GOption source, GEvent event) {
  setSliderValueType(true, true);
}

public void xSliderPixels_clicked(GOption source, GEvent event) {
  setSliderValueType(true, false);
}

public void ySliderPercent_clicked(GOption source, GEvent event) {
  setSliderValueType(false, true);
}

public void ySliderPixels_clicked(GOption source, GEvent event) {
  setSliderValueType(false, false);
}

