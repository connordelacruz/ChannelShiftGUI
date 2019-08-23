import g4p_controls.*;

// Configs =====================================================================

// Input File ------------------------------------------------------------------
// Default image to load on start
String defaultImgName = "test";
String defaultImgPath = "source/" + defaultImgName + ".jpg";

// Interface -------------------------------------------------------------------
// Preview window size (does not affect output image size)
int maxWindowSize = 600;


// Globals =====================================================================

// TODO: clearly define what each of these are, make consistent
// Original image and working image
PImage sourceImg, targetImg, previewImg;
// Window dimensions
int windowWidth, windowHeight;

// Maps index 0-2 to corresponding color channel. Used as a shorthand when
// making operations more human readable
String[] CHANNELS = new String[]{"R","G","B"};
// String to use for indent in output msgs
String INDENT = "   ";

// Base image file name, used for default save name in conjunction with
// sketchSteps
String imgFile;
// Store shift values and which channels were shifted/swapped. Will be appended
// to default save filename 
String sketchSteps;

// TODO: make these 2D arrays? Could simplify conditional assignment for reused code
// Currently selected source and target channels
int sourceChannel, targetChannel;
// Current horizontal and vertical shift amounts
// TODO: store pixels AND percentage
int horizontalShift, verticalShift;

// If true, randomize button will affect the corresponding settings
boolean randomizeSrc = true; 
boolean randomizeTarg = true; 
boolean randomizeXShift = true; 
boolean randomizeYShift = true; 
// Use resulting image as the source for next iteration
boolean recursiveIteration = false;

// Set to true if the preview image has been modified since the last time it
// was rendered, telling the draw() method that it needs to be re-drawn
boolean previewImgUpdated = true;
// Set to true if a silder was changed. Window mouse event listener checks this
// when the mouse is released and updates the preview image. This is to avoid
// re-drawing the preview every time the slider value changes
boolean sliderChanged = false;
// Whether the sliders are using percentages of dimensions or exact pixel
// values. Default is percentages. [0] is x slider and [1] is y slider
boolean[] sliderPercentValue = new boolean[]{true, true};


// Helper Methods ==============================================================

// Window ----------------------------------------------------------------------

/**
 * Calculate window dimensions based on image size and maxWindowSize config
 * @param img The PImage object that will be displayed in the window
 * @return A 2D array where [0] = width and [1] = height 
 */
int[] getWindowDimensions(PImage img) {
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

/**
 * Set windowWidth and windowHeight and resize surface
 */
void updateWindowSize() {
  int[] dimensions = getWindowDimensions(sourceImg);
  // Set globals for later use
  windowWidth = dimensions[0];
  windowHeight = dimensions[1];
  surface.setSize(windowWidth, windowHeight);
}

/**
 * Re-draws previewImg and sets previewImgUpdated to false
 */
void updatePreview() {
  image(previewImg, 0, 0, windowWidth, windowHeight);
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
  // Set globals
  sourceImg = loadImage(path);
  targetImg = sourceImg.copy();
  previewImg = sourceImg.copy();
  // Update window size
  updateWindowSize();
  // Update imgFile (for default output name)
  imgFile = name;
  // Reset steps string
  sketchSteps = "";
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
 * Update sketchSteps using globals
 */
void updateSteps() {
  sketchSteps += "_" + stringifyStep(horizontalShift, verticalShift, sourceChannel, targetChannel, recursiveIteration);
}

/**
 * Returns an output file path based on source image name and sketch steps.
 * @return File name with the image file and sketch steps. Parent directory is
 * not specified, so selectOutput() should default to last opened directory
 * (depending on OS)
 */
String defaultOutputFilename() {
  // TODO: if we're saving previewImg, stringify current sketch step
  // TODO: max filename of 255 characters
  return imgFile + sketchSteps + ".png";
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
    // TODO: Save previewImg instead
    targetImg.save(outputFile);
    // Print output
    println("Result saved:");
    println(INDENT + outputFile);
    println("");
  }
}

// Channel Shift ---------------------------------------------------------------

/**
 * Returns a random shift amount in pixels based on image dimensions.
 * @param horizontal If true, calculate horizontal shift, else calculate
 * vertical shift
 * @param img PImage object that will be channel shifted. Used to determine
 * shift amount based on dimensions
 * @return Shift amount in pixels
 */
int randomShiftAmount(boolean horizontal, PImage img) {
  int imgDimension = horizontal ? img.width : img.height;
  return int(random(imgDimension));
}

/**
 * Returns a random shift percentage
 * @return Shift amount percentage (int between 0 and 99)
 */
int randomShiftPercent() {
  // Leaving 100 as upper bound since a 100% shift is identical
  return int(random(100));
}

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
  sourceImg.loadPixels();
  targetImg.loadPixels();
  // Get pixels
  color[] sourcePixels = sourceImg.pixels;
  color[] targetPixels = targetImg.pixels;
  // Loop thru rows
  for (int y = 0; y < targetImg.height; y++) {
    int yOffset = (y + yShift) % targetImg.height;

    // Loop thru pixels in current row
    for (int x = 0; x < targetImg.width; x++) {
      int xOffset = (x + xShift) % targetImg.width;

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

// Source/Target Channel -------------------------------------------------------

/**
 * Set the current source/target channel
 * @param source If true, set sourceChannel, else set targetChannel
 * @param channel Channel to set (Index into CHANNELS)
 */
void selectChannel(boolean source, int channel) {
  if (source)
    sourceChannel = channel;
  else
    targetChannel = channel;
}

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
  int channel = source ? sourceChannel : targetChannel;
  setChannelToggle(source, channel);
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

// TODO: just 2 listeners, find a way to bind data for RGB index?

public void srcR_clicked(GOption source, GEvent event) { 
  selectChannel(true, 0);
  showPreview();
} 

public void srcG_clicked(GOption source, GEvent event) { 
  selectChannel(true, 1);
  showPreview();
} 

public void srcB_clicked(GOption source, GEvent event) { 
  selectChannel(true, 2);
  showPreview();
} 

public void targR_clicked(GOption source, GEvent event) { 
  selectChannel(false, 0);
  showPreview();
} 

public void targG_clicked(GOption source, GEvent event) { 
  selectChannel(false, 1);
  showPreview();
} 

public void targB_clicked(GOption source, GEvent event) { 
  selectChannel(false, 2);
  showPreview();
} 

// Horizontal/Vertical Shift ---------------------------------------------------

/**
 * Convert shift percent to number of pixels
 * @param horizontal If true, calculate horizontal shift, else vertical shift
 * @param shiftPercent Percent of image dimension to convert to pixels
 */
int shiftPercentToPixels(boolean horizontal, int shiftPercent) {
  int imgDimension = horizontal ? targetImg.width : targetImg.height;
  return (int)(imgDimension * shiftPercent / 100);
}

/**
 * Convert shift pixel amount to a percent of the image size
 * @param horizontal If true, calculate horizontal shift, else vertical shift
 * @param shiftAmount Amount of pixels to convert to a percentage
 */
int shiftPixelsToPercent(boolean horizontal, int shiftAmount) {
  int imgDimension = horizontal ? targetImg.width : targetImg.height;
  return (int)(100 * shiftAmount / imgDimension);
}

/**
 * Set whether a shift slider is using a percentage or exact pixel values.
 * Converts the existing value of the slider accordingly
 * @param horizontal If true, set horizontal slider, else set vertical slider
 * @param setPercentValue If true, use a percentage for the slider, else use
 * exact pixel values
 */
void setSliderValueType(boolean horizontal, boolean setPercentValue) {
  // Determine which slider to update
  int configIndex = horizontal ? 0 : 1;
  GSlider target = horizontal ? xSlider : ySlider;
  int imgDimension = horizontal ? targetImg.width : targetImg.height;
  int upperBound = setPercentValue ? 100 : imgDimension;
  // Convert existing value to new value type
  int currentValue = target.getValueI();
  int updatedValue = currentValue;
  if (setPercentValue && !sliderPercentValue[configIndex])
    updatedValue = shiftPixelsToPercent(horizontal, currentValue);
  else if (!setPercentValue && sliderPercentValue[configIndex])
    updatedValue = shiftPercentToPixels(horizontal, currentValue);
  // Set bounds and current value
  target.setLimits(updatedValue, 0, upperBound);
  // Update globals
  sliderPercentValue[configIndex] = setPercentValue;
  setShift(horizontal, updatedValue);
  // Update preview since percentage and pixels might not convert to exact values
  // TODO: only update preview if exact pixel amount is not the same?
  showPreview();
}

/**
 * Set horizontal or vertical shift
 * @param horizontal If true, set horizontal shift, else set vertical shift
 * @param shiftAmount Number of pixels to shift by. If the specified slider is
 * set to use percent values, it will be converted
 */
void setShift(boolean horizontal, int shiftAmount) {
  // Calculate amount of pixels to shift
  // TODO: should this function be aware of the GUI implementation? or should percentage calc happen before call?
  boolean percentValue = sliderPercentValue[horizontal ? 0 : 1];
  // If slider is using a percent value, convert it, otherwise it's already an
  // exact pixel value
  if (percentValue)
    shiftAmount = shiftPercentToPixels(horizontal, shiftAmount);
  if (horizontal)
    horizontalShift = shiftAmount;
  else
    verticalShift = shiftAmount;
}

// TODO: doc and implement all below

void setShiftSliderValue(boolean horizontal, int shiftAmount) {
  GSlider slider = horizontal ? xSlider : ySlider;
  // TODO: There's too much back and forth conversion, figure out how to reduce percentage conversions
  if (sliderPercentValue[horizontal ? 0 : 1])
    shiftAmount = shiftPixelsToPercent(horizontal, shiftAmount);
  slider.setValue(shiftAmount);
}

void updateShiftSlider(boolean horizontal) {
  int shiftAmount = horizontal ? horizontalShift : verticalShift;
  setShiftSliderValue(horizontal, shiftAmount);
}

void updateShiftSliders() {
  updateShiftSlider(true);
  updateShiftSlider(false);
}

public void xSlider_change(GSlider source, GEvent event) { 
  setShift(true, source.getValueI());
  sliderChanged = true;
} 

public void ySlider_change(GSlider source, GEvent event) { 
  setShift(false, source.getValueI());
  sliderChanged = true;
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

// TODO: doc, clean up reusable?
void randomizeValues(boolean source, boolean target, boolean horizontal, boolean vertical) {
  // Channels
  // TODO: random(3) seems to favor 0 when converted to an int, maybe use a higher value and divide or something when casting?
  if (source) {
    sourceChannel = int(random(3));
    updateChannelToggle(true);
    // Set target to match source if unchecked
    // TODO: Explain this behavior somewhere; add a toggle to lock target to match channel (i.e. enable/disable swap)
    if (!target) {
      targetChannel = sourceChannel;
      updateChannelToggle(false);
    }
  }
  if (target) {
    targetChannel = int(random(3));
    updateChannelToggle(false);
  }
  // Shift
  // TODO: inputs for max percent random shift for each dimension
  // TODO: REDUCE REDUNDANT PERCENT CONVERSIONS
  if (horizontal) {
    int xShift = sliderPercentValue[0] ? randomShiftPercent() : randomShiftAmount(true, targetImg);
    setShift(true, xShift);
    updateShiftSlider(true);
  }
  if (vertical) {
    int yShift = sliderPercentValue[1] ? randomShiftPercent() : randomShiftAmount(false, targetImg);
    setShift(false, yShift);
    updateShiftSlider(false);
  }
}

public void randSrcCheckbox_click(GCheckbox source, GEvent event) {
  randomizeSrc = source.isSelected();
}

public void randTargCheckbox_click(GCheckbox source, GEvent event) {
  randomizeTarg = source.isSelected();
}

public void randXShiftCheckbox_click(GCheckbox source, GEvent event) {
  randomizeXShift = source.isSelected();
}

public void randYShiftCheckbox_click(GCheckbox source, GEvent event) {
  randomizeYShift = source.isSelected();
}

public void randomizeBtn_click(GButton source, GEvent event) {
  randomizeValues(randomizeSrc, randomizeTarg, randomizeXShift, randomizeYShift);
  showPreview();
} 

// Reset Button ----------------------------------------------------------------

/**
 * Reset selected source/target channels and horizontal/vertical shift values
 */
void resetShift() {
  sourceChannel = targetChannel = 0;
  updateChannelToggles();
  setShift(true, 0);
  setShift(false, 0);
  updateShiftSliders();
}

public void resetBtn_click(GButton source, GEvent event) { 
  resetShift();
  showPreview();
} 

// Preview Button --------------------------------------------------------------

// TODO: Remove preview btn after ensuring all inputs update the preview on change
// TODO: Replace preview button with reset above confirm step, stretch randomize to fill

/**
 * Sets previewImg to a copy of targetImg and calls shiftChannel(). Sets
 * previewImgUpdated to true and calls previewImg.updatePixels() after shifting
 */
void showPreview() {
  previewImg = targetImg.copy();
  shiftChannel(sourceImg, previewImg, horizontalShift, verticalShift, sourceChannel, targetChannel);
  previewImgUpdated = true;
  previewImg.updatePixels();
}

public void previewBtn_click(GButton source, GEvent event) { 
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
  targetImg = previewImg.copy();
  // If recursive, sourceImg.pixels = targetImg.pixels
  if (recursiveIteration)
    sourceImg.pixels = targetImg.pixels;
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

// TODO: it seems preview is reverted to previous step on save click?
public void saveBtn_click(GButton source, GEvent event) {
  // TODO: set targetImg to previewImg before saving so you get what you see
  saveResultAs();
} 


// Processing ==================================================================

void setup() {
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

