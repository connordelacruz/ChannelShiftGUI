import g4p_controls.*;

// Configs =====================================================================

// Input File ------------------------------------------------------------------
// Default image to load on start
String defaultImgName = "test";
String defaultImgPath = "source/" + defaultImgName + ".jpg";

// Output File -----------------------------------------------------------------
// File extension of the output image
String outputImgExt = ".png";

// Globals =====================================================================

// TODO: step/save name manager?
// Base image file name, used for default save name in conjunction with
// sketchSteps
String imgFile;
// Store shift values and which channels were shifted/swapped. Will be appended
// to default save filename 
String sketchSteps;

// Image managers
ImgManager imgManager;
// Sketch state managers
ChannelManager channelManager;
ShiftManager xShiftManager, yShiftManager;
RandomizeManager randomizeManager;
// Advanced option managers
ShiftTypeManager shiftTypeManager;
// Interface managers
WindowManager windowManager;

// TODO: doc, sketch steps
String[] SHIFT_TYPES = new String[]{"Default", "Multiply", "Linear"};

// Use resulting image as the source for next iteration
boolean recursiveIteration = true;

// TODO: img/preview manager?
// Set to true if the preview image has been modified since the last time it
// was rendered, telling the draw() method that it needs to be re-drawn
boolean previewImgUpdated = true;
// TODO: shift sliders manager
// Set to true if a silder was changed. Window mouse event listener checks this
// when the mouse is released and updates the preview image. This is to avoid
// re-drawing the preview every time the slider value changes
boolean sliderChanged = false;
// Whether the sliders are using percentages of dimensions or exact pixel
// values. Default is percentages. [0] is x slider and [1] is y slider
boolean[] sliderPercentValue = new boolean[]{true, true};

// Constants ===================================================================

// Maps index 0-2 to corresponding color channel. Used as a shorthand when
// making operations more human readable
String[] CHANNELS = new String[]{"R","G","B"};
// String to use for indent in output msgs
String INDENT = "   ";

// Helper Methods ==============================================================

// Window ----------------------------------------------------------------------

// TODO: move to manager?
/**
 * Update windowManager based on sourceImg dimensions and resize surface
 */
void updateWindowSize() {
  windowManager.updateWindowDimensions(imgManager.sourceImg);
  surface.setSize(windowManager.width, windowManager.height);
}

/**
 * Re-draws previewImg and sets previewImgUpdated to false
 */
void updatePreview() {
  image(imgManager.previewImg, 0, 0, windowManager.width, windowManager.height);
  previewImgUpdated = false;
}

// Loading ---------------------------------------------------------------------

/**
 * Returns the name of a file with the extension removed
 */
String getBaseFileName(File f) {
  String name = f.getName();
  // Return name stripping last . followed by 1 or more chars
  return name.replaceFirst("[.][^.]+$", "");
}

/**
 * Show file select dialog and attempt to load image on callback
 */
void selectFile() {
  selectInput("Load image:", "imageFileSelected");
}

/**
 * Callback function for selectInput() when loading a file
 */
void imageFileSelected(File selection) {
  if (selection != null) {
    println("Loading...");
    loadImageFile(selection.getAbsolutePath(), getBaseFileName(selection));
    println("Image loaded.");
    println("");
    // Reset UI and configs
    resetShift();
  }
}

/**
 * Load an image file. Sets global variables and updates window size
 * accordingly. 
 * @param path Full path to the image file
 * @param name Name of file without extension. Used for default filename when
 * saving
 */
void loadImageFile(String path, String name) {
  // Load image objects
  imgManager.loadImageFile(path);
  // Update window size
  updateWindowSize();
  // Update imgFile (for default output name)
  imgFile = name;
  // Reset steps string
  sketchSteps = "";
  // Update managers
  xShiftManager.setImgDimension(imgManager.imgWidth);
  yShiftManager.setImgDimension(imgManager.imgHeight);
  // Redraw preview
  previewImgUpdated = true;
}

// Saving ----------------------------------------------------------------------

/**
 * Returns a string representation of a channel shift step.
 * @param horizontalShift Amount channel was shifted horizontally
 * @param verticalShift Amount channel was shifted vertically
 * @param sourceChannel Channel from the source image (Index into CHANNELS)
 * @param targetChannel Channel from the target image (Index into CHANNELS)
 * @param recursiveIteration Whether this was a recursive iteration or not
 * @return String representation of the sketch step. The general format is:
 * "s{RGB}-t{RGB}-x{int}-y{int}{-rec}"
 * If source and target channels are the same, a single RGB channel will be
 * listed instead of "s{RGB}-t{RGB}".
 */
String stringifyStep(int horizontalShift, int verticalShift, int sourceChannel, int targetChannel, boolean recursiveIteration) {
  String step = "";
  // Only show what channel was shifted if not swapped
  if (sourceChannel == targetChannel)
    step += CHANNELS[sourceChannel];
  else
    step += "s" + CHANNELS[sourceChannel] + "t" + CHANNELS[targetChannel];
  step += "-x" + horizontalShift;
  step += "-y" + verticalShift;
  if (recursiveIteration)
    step += "-rec";
  return step;
}

/**
 * Returns a string representation of the current sketch step
 */
String stringifyCurrentStep() {
  return stringifyStep(xShiftManager.shiftAmount, yShiftManager.shiftAmount, channelManager.sourceChannel, channelManager.targetChannel, recursiveIteration);
}

/**
 * Update sketchSteps using globals
 */
void updateSteps() {
  sketchSteps += "_" + stringifyCurrentStep();
}

/**
 * Returns an output file path based on source image name and sketch steps.
 * @return File name with the image file and sketch steps. Parent directory is
 * not specified, so selectOutput() should default to last opened directory
 * (depending on OS)
 */
String defaultOutputFilename() {
  // TODO: max filename of 255 characters
  String filename = imgFile + sketchSteps;
  // Append current step (unless nothing's changed)
  if (!noChangesInCurrentStep())
    filename += "_" + stringifyCurrentStep();
  return filename + outputImgExt;
}

/**
 * Pull up save dialog for current result. Default path is generated using
 * defaultOutputFilename()
 */
void saveResultAs() {
  String outputFile = defaultOutputFilename();
  File defaultOutFile = new File(outputFile);
  selectOutput("Save as:", "outFileSelected", defaultOutFile);
}

/**
 * Callback function for selectOutput() when saving result
 */
void outFileSelected(File selection) {
  if (selection != null) {
    println("Saving...");
    String outputFile = selection.getAbsolutePath();
    // Save previewImg so preview matches output file
    imgManager.savePreviewImg(outputFile);
    // Print output
    println("Result saved:");
    println(INDENT + outputFile);
    println("");
  }
}

// Channel Shift ---------------------------------------------------------------

/**
 * Shift and swap color channels
 * @param sourceImg The base PImage object to be channel shifted
 * @param targetImg The PImage object to apply channel swaps/shifts to
 * @param xShift Amount to shift channel horizontally
 * @param yShift Amount to shift channel vertically
 * @param sourceChannel Color channel to grab from sourceImg (Index into
 * CHANNELS)
 * @param targetChannel Color channel to insert shifted sourceChannel as in
 * targetImg (Index into CHANNELS). Set to the same value as sourceChannel if
 * you don't want to swap color channels
 */
void shiftChannel(PImage sourceImg, PImage targetImg, int xShift, int yShift, int sourceChannel, int targetChannel) {
  // Get pixels
  color[] sourcePixels = sourceImg.pixels;
  color[] targetPixels = targetImg.pixels;
  // Loop thru rows
  for (int y = 0; y < targetImg.height; y++) {

    // Loop thru pixels in current row
    for (int x = 0; x < targetImg.width; x++) {
      int yOffset = mod(shiftTypeManager.calculateShiftOffset(x, y, yShift, false), targetImg.height);
      int xOffset = mod(shiftTypeManager.calculateShiftOffset(x, y, xShift, true), targetImg.width);

      // Get source pixel and its RGB vals
      int sourceIndex = yOffset * sourceImg.width + xOffset;
      color sourcePixel = sourcePixels[sourceIndex];
      float[] sourceRGB = new float[]{ red(sourcePixel), green(sourcePixel), blue(sourcePixel) };

      // Get target pixel and its RGB vals
      int targetIndex = y * targetImg.width + x;
      color targetPixel = targetPixels[targetIndex];
      float[] targetRGB = new float[]{ red(targetPixel), green(targetPixel), blue(targetPixel) };

      // Swap source channel w/ target channel
      targetRGB[targetChannel] = sourceRGB[sourceChannel];
      targetPixels[targetIndex] = color(targetRGB[0], targetRGB[1], targetRGB[2]);
    }
  }
}

// Sketch State ----------------------------------------------------------------

// TODO: use each time a GUI change is made to enable/disable confirm

/**
 * Returns true if source and target channels match and x/y shift are both 0
 */
boolean noChangesInCurrentStep() {
  return channelManager.channelsMatch() && xShiftManager.shiftIsZero() && yShiftManager.shiftIsZero();
}

// GUI =========================================================================

// Controls Window -------------------------------------------------------------

synchronized public void controlsWindow_draw(PApplet appc, GWinData data) { 
  appc.background(230);
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

// Preview Window --------------------------------------------------------------

/**
 * Sets previewImg to a copy of targetImg and calls shiftChannel(). Sets
 * previewImgUpdated to true and calls previewImg.updatePixels() after shifting
 */
void showPreview() {
  // Make sure preview image matches target
  imgManager.copyTargetToPreview();
  shiftChannel(imgManager.sourceImg, imgManager.previewImg, xShiftManager.shiftAmount, yShiftManager.shiftAmount, channelManager.sourceChannel, channelManager.targetChannel);
  // Update preview image pixels and redraw
  previewImgUpdated = true;
  imgManager.updatePreview();
}

// Source/Target Channel -------------------------------------------------------

/**
 * Select a source/target channel toggle
 * @param source If true, set sourceChannel, else set targetChannel
 * @param channel Channel to set (Index into CHANNELS)
 */
void setChannelToggle(boolean source, int channel) {
  GOption[] toggles;
  // TODO: move arrays to global so they don't need to be allocated each time
  if (source)
    toggles = new GOption[]{ srcR, srcG, srcB };
  else
    toggles = new GOption[]{ targR, targG, targB };
  toggles[channel].setSelected(true);
}

/**
 * Update the selected source/target channel toggle to match the corresponding
 * global variable
 * @param source If true, set sourceChannel, else set targetChannel
 */
void updateChannelToggle(boolean source) {
  setChannelToggle(source, channelManager.getChannel(source));
}

/**
 * Update the selected source and target channel toggles to match global
 * variables. Wrapper that calls updateChannelToggle() for both source and
 * target
 */
void updateChannelToggles() {
  updateChannelToggle(true);
  updateChannelToggle(false);
}

public void channelOption_clicked(ChannelOption source, GEvent event) {
  channelManager.setChannel(source.isSource(), source.getChannel());
  showPreview();
}

// Shift Type ------------------------------------------------------------------

public void shiftTypeSelect_change(GDropList source, GEvent event) {
  // Hide previously selected panel
  togglePanelVisibility(shiftTypeConfigPanels[shiftTypeManager.state], false);
  shiftTypeManager.setShiftType(source.getSelectedIndex());
  // Show newly selected panel
  togglePanelVisibility(shiftTypeConfigPanels[shiftTypeManager.state], true);
  showPreview();
}

// Multiply Configs ------------------------------------------------------------

void multiplierInputEventHandler(GTextField source, GEvent event, boolean horizontal) {
  switch(event) {
    // TODO: select all on focus (will need to extend class)
    case ENTERED:
      // Unfocus on enter, then do same actions as LOST_FOCUS case
      source.setFocus(false);
    case LOST_FOCUS:
      // Sanitize and update manager
      float val = sanitizeFloatInputValue(source);
      if (val > -1.0) {
        shiftTypeManager.multiply_setMultiplier(val, horizontal);
        showPreview();
      } 
      // Update input text to match sanitized input 
      // Also reverts input text in the event that it was not a valid numeric
      // value after parsing
      source.setText("" + shiftTypeManager.multiply_getMultiplier(horizontal));
      break;
    default:
      break;
  }
}

public void xMultiplierInput_change(GTextField source, GEvent event) {
  multiplierInputEventHandler(source, event, true);
}

public void yMultiplierInput_change(GTextField source, GEvent event) {
  multiplierInputEventHandler(source, event, false);
}

// Linear Configs --------------------------------------------------------------

// TODO: rename all _clicked to _click for consistency
public void linearYEquals_clicked(GOption source, GEvent event) {
  shiftTypeManager.linear_setEquationType(true);
  showPreview();
}

public void linearXEquals_clicked(GOption source, GEvent event) {
  shiftTypeManager.linear_setEquationType(false);
  showPreview();
}

public void linearCoeffInput_change(GTextField source, GEvent event) {
  switch(event) {
    // TODO: select all on focus (will need to extend class)
    case ENTERED:
      // Unfocus on enter, then do same actions as LOST_FOCUS case
      source.setFocus(false);
    case LOST_FOCUS:
      // Sanitize and update manager
      float val = sanitizeFloatInputValue(source);
      // TODO: might want to add support for negatives (or add checkbox input)
      if (val > -1.0) {
        shiftTypeManager.linear_setCoefficient(val);
        showPreview();
      } 
      // Update input text to match sanitized input 
      // Also reverts input text in the event that it was not a valid numeric
      // value after parsing
      source.setText("" + shiftTypeManager.linear_getCoefficient());
      break;
    default:
      break;
  }
}

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

// TODO: better integrate w/ managers?
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
    // TODO: select all on focus (will need to extend class)
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

// Randomize Button ------------------------------------------------------------

/** 
 * Calls the randomize() methods of managers based on the configuration of
 * randomizeManager. Updates GUI on change
 */
void randomizeValues() {
  // Channels
  if (randomizeManager.randomizeChannel()) {
    channelManager.randomize(randomizeManager.src, randomizeManager.targ);
    updateChannelToggles();
  }
  // Shift
  if (randomizeManager.xShift) {
    xShiftManager.randomize(randomizeManager.xShiftMax);
    updateShiftSlider(true);
  }
  if (randomizeManager.yShift) {
    yShiftManager.randomize(randomizeManager.yShiftMax);
    updateShiftSlider(false);
  }
}

public void randomizeBtn_click(GButton source, GEvent event) {
  randomizeValues();
  showPreview();
} 

// Randomize Checkboxes

public void randSrcCheckbox_click(GCheckbox source, GEvent event) {
  randomizeManager.toggleSource(source.isSelected());
}

public void randTargCheckbox_click(GCheckbox source, GEvent event) {
  randomizeManager.toggleTarget(source.isSelected());
}

// TODO: enable/disable corresponding input
public void randXShiftCheckbox_click(GCheckbox source, GEvent event) {
  randomizeManager.toggleXShift(source.isSelected());
}

// TODO: enable/disable corresponding input
public void randYShiftCheckbox_click(GCheckbox source, GEvent event) {
  randomizeManager.toggleYShift(source.isSelected());
}

// Max Shift Percent Inputs

// TODO: doc, merge common w/ slider inputs
void randMaxInputEventHandler(GTextField source, GEvent event, boolean horizontal) {
  switch(event) {
    // TODO: select all on focus (will need to extend class)
    case ENTERED:
      // Unfocus on enter, then do same actions as LOST_FOCUS case
      source.setFocus(false);
    case LOST_FOCUS:
      // Sanitize and update manager
      // NOTE: RandomizeManager percent setter methods ensure the value is
      // between 0 and 100
      int val = sanitizeIntegerInputValue(source);
      if (val > -1) {
        randomizeManager.setShiftMaxPercent(val, horizontal);
      } 
      // Update input text to match sanitized input (after RandomizeManager
      // ensures it's a valid percentage)
      // Also reverts input text in the event that it was not a valid numeric
      // value after parsing
      source.setText("" + randomizeManager.shiftMaxPercent(horizontal));
      break;
    default:
      break;
  }
}

public void randXMaxInput_change(GTextField source, GEvent event) {
  randMaxInputEventHandler(source, event, true);
}

public void randYMaxInput_change(GTextField source, GEvent event) {
  randMaxInputEventHandler(source, event, false);
}

// Reset Button ----------------------------------------------------------------

/**
 * Reset selected source/target channels and horizontal/vertical shift values
 */
void resetShift() {
  channelManager.resetChannels();
  updateChannelToggles();
  xShiftManager.resetShift();
  yShiftManager.resetShift();
  updateShiftSliders();
}

public void resetBtn_click(GButton source, GEvent event) { 
  resetShift();
  showPreview();
} 

// Confirm Button --------------------------------------------------------------

// TODO: Undo button (keep track of steps)
// TODO: Disable confirm button if no changes are made

public void confirmBtn_click(GButton source, GEvent event) { 
  // Display preview
  showPreview();
  // Update sketch steps
  updateSteps();
  // Update targetImg to match preview
  imgManager.copyPreviewToTarget();
  // TODO: make sure this works? getting some inconsistent results
  // If recursive, sourceImg.pixels = targetImg.pixels
  if (recursiveIteration)
    imgManager.copyTargetPixelsToSource();
  // Reset shift values and UI
  resetShift();
} 

// Recursive Checkbox ----------------------------------------------------------

public void recursiveCheckbox_click(GCheckbox source, GEvent event) {
  recursiveIteration = source.isSelected();
}

// Load Button -----------------------------------------------------------------

public void loadBtn_click(GButton source, GEvent event) {
  selectFile();
}

// Save Button -----------------------------------------------------------------

public void saveBtn_click(GButton source, GEvent event) {
  saveResultAs();
} 


// Processing ==================================================================

void setup() {
  // Initialize managers
  imgManager = new ImgManager();
  channelManager = new ChannelManager();
  xShiftManager = new ShiftManager();
  yShiftManager = new ShiftManager();
  randomizeManager = new RandomizeManager();
  shiftTypeManager = new ShiftTypeManager();
  windowManager = new WindowManager();
  // Load image (initializes global PImage objects)
  loadImageFile(defaultImgPath, defaultImgName);
  // Window
  size(1,1);
  surface.setResizable(true);
  updateWindowSize();
  // Display controls window
  createGUI();
}


void draw() {
  if (previewImgUpdated) {
    updatePreview();
  } 
}

