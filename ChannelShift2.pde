import g4p_controls.*;

// Configs =====================================================================

// Input File ------------------------------------------------------------------
// TODO: only need imgFile, get rid of path and ext and just make a variable for default image path
// File path relative to current directory
String imgPath = "source/";
// File name
String imgFile = "test";
// File extension
String imgExt = "jpg";

// Interface -------------------------------------------------------------------
// Preview window size (does not affect output image size)
int maxWindowSize = 600;


// Globals =====================================================================

// Original image and working image
PImage sourceImg, targetImg, previewImg;
// Window dimensions
int windowWidth, windowHeight;

// Maps index 0-2 to corresponding color channel. Used as a shorthand when
// making operations more human readable
String[] CHANNELS = new String[]{"R","G","B"};

// Store shift values and which channels were shifted/swapped. Will be appended
// to default filename 
String sketchSteps;

// String to use for indent in output msgs
String INDENT = "   ";

// TODO: make these 2D arrays? Could simplify conditional assignment for reused code
// Currently selected source and target channels
int sourceChannel, targetChannel;
// Current horizontal and vertical shift amounts
int horizontalShift, verticalShift;

// If true, randomize button will affect the corresponding settings
boolean randomizeSrc = true; 
boolean randomizeTarg = true; 
boolean randomizeXShift = true; 
boolean randomizeYShift = true; 
// Use resulting image as the source for next iteration
boolean recursiveIteration = false;

// Set when controls window is drawn so it doesn't get duplicated on subsequent
// calls to setup()
boolean controlsWindowCreated = false;
// Set to true if the preview image has been modified since the last time it
// was rendered, telling the draw() method that it needs to be re-drawn
boolean previewImgUpdated = true;
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
 * Show file select dialog and attempt to load image on callback
 */
void selectFile() {
  // NOTE: doing this so that the file select dialog starts in the sketch
  // directory. selectInput() is kinda limited, so passing it the sketch file
  // as a starting point as a hack-y workaround
  // TODO: Should this just start in the last selected directory?
  File defaultInFile = new File(sketchPath(getClass().getName() + ".pde"));
  selectInput("Load image:", "imageFileSelected", defaultInFile);
}

/**
 * Callback function for selectInput() when loading a file
 */
void imageFileSelected(File selection) {
  if (selection != null) {
    println("Loading...");
    loadImageFile(selection.getAbsolutePath());
    println("Image loaded.");
    println("");
  }
}

/**
 * Load an image file. Sets global variables and updates window size
 * accordingly. 
 * @param filename Path to the image file
 */
void loadImageFile(String filename) {
  // Set globals
  sourceImg = loadImage(filename);
  targetImg = sourceImg.copy();
  previewImg = sourceImg.copy();
  // Update window size
  updateWindowSize();
  // TODO: update imgFile (for default output name)
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
 * @return String representation of the sketch step. The general format is:
 * "s{RGB}-t{RGB}-x{int}-y{int}"
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
    step += "-recurs";
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
 * @return A full file name and path with the image file and sketch steps.
 * Relative path is passed to sketchPath(), so default output will be within
 * the current directory
 */
String defaultOutputFilename() {
  // TODO: don't use sketchPath() and let OS handle output dir?
  return sketchPath(imgFile + sketchSteps + ".png");
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
    targetImg.save(outputFile);
    // Print output
    println("Result saved:");
    println(INDENT + outputFile);
    println("");
  }
}

// Channel Shift ---------------------------------------------------------------

// TODO: clean up and re-organize for new setup, update docs to remove old info

/**
 * Calculates shift amount based on sketch configs.
 * @param horizontal If true, calculate horizontal shift, else calculate
 * vertical shift
 * @param img PImage object that will be channel shifted. Used to determine
 * shift amount based on dimensions
 * @return Shift amount based on configs. If the type of shift is disabled,
 * will always return 0
 */
int randomShiftAmount(boolean horizontal, PImage img) {
  int imgDimension = horizontal ? img.width : img.height;
  return int(random(imgDimension));
}

// TODO: doc 
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

// Sets controlsWindowCreated to true
synchronized public void controlsWindow_draw(PApplet appc, GWinData data) { 
  appc.background(230);
  controlsWindowCreated = true;
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

// TODO: doc 
// TODO: just have this automatically update to match globals?
void setChannelToggle(boolean source, int channel) {
  GOption[] toggles;
  if (source)
    toggles = new GOption[]{ srcR, srcG, srcB };
  else
    toggles = new GOption[]{ targR, targG, targB };
  toggles[channel].setSelected(true);
}

public void srcR_clicked(GOption source, GEvent event) { 
  selectChannel(true, 0);
} 

public void srcG_clicked(GOption source, GEvent event) { 
  selectChannel(true, 1);
} 

public void srcB_clicked(GOption source, GEvent event) { 
  selectChannel(true, 2);
} 

public void targR_clicked(GOption source, GEvent event) { 
  selectChannel(false, 0);
} 

public void targG_clicked(GOption source, GEvent event) { 
  selectChannel(false, 1);
} 

public void targB_clicked(GOption source, GEvent event) { 
  selectChannel(false, 2);
} 

// Horizontal/Vertical Shift ---------------------------------------------------

// TODO: update preview once mouse is released
//        https://forum.processing.org/two/discussion/11491/g4p-how-to-receive-slider-changes-only-on-mouse-release

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
}

/**
 * Set horizontal or vertical shift
 * @param horizontal If true, set horizontal shift, else set vertical shift
 * @param shiftAmount Percent/number of pixels to shift by. If the specified
 * slider is set to use percent values, it will be converted
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

public void xSlider_change(GSlider source, GEvent event) { 
  setShift(true, source.getValueI());
} 

public void ySlider_change(GSlider source, GEvent event) { 
  setShift(false, source.getValueI());
} 

// Slider Toggles --------------------------------------------------------------

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
  if (source) {
    sourceChannel = int(random(3));
    setChannelToggle(true, sourceChannel);
  }
  // TODO: if source && !target, set target to match?
  if (target) {
    targetChannel = int(random(3));
    setChannelToggle(false, targetChannel);
  }
  // Shift
  if (horizontal) {
    int xShift = sliderPercentValue[0] ? randomShiftPercent() : randomShiftAmount(true, targetImg);
    xSlider.setValue(xShift);
    setShift(true, xShift);
  }
  if (vertical) {
    int yShift = sliderPercentValue[1] ? randomShiftPercent() : randomShiftAmount(false, targetImg);
    setShift(false, yShift);
    ySlider.setValue(yShift);
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
  // TODO: method that updates toggles based on globals, use in randomize
  srcR.setSelected(true);
  targR.setSelected(true);
  sourceChannel = targetChannel = 0;
  xSlider.setValue(0.0);
  ySlider.setValue(0.0);
  setShift(true, 0);
  setShift(false, 0);
}

public void resetBtn_click(GButton source, GEvent event) { 
  resetShift();
  showPreview();
} 

// Preview Button --------------------------------------------------------------

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

public void saveBtn_click(GButton source, GEvent event) {
  // TODO: set targetImg to previewImg before saving so you get what you see
  saveResultAs();
} 


// Processing ==================================================================

void setup() {
  // Load image (initializes global PImage objects)
  loadImageFile(imgPath + imgFile + "." + imgExt);
  // Reset steps string
  sketchSteps = "";
  // Window
  size(1,1);
  surface.setResizable(true);
  updateWindowSize();
  // Display controls window
  if (!controlsWindowCreated)
    createGUI();
}


void draw() {
  if (previewImgUpdated) {
    updatePreview();
  } 
}

