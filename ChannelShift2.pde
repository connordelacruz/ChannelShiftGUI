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

// TODO: save/step manager
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

// Use resulting image as the source for next iteration
boolean recursiveIteration = true;

// Constants ===================================================================
// String to use for indent in output msgs
String INDENT = "   ";

// Helper Methods ==============================================================

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
  // TODO: delegate stringify parts to manager classes
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
  String filename = imgFile + sketchSteps;
  // Append current step (unless nothing's changed)
  if (!noChangesInCurrentStep())
    filename += "_" + stringifyCurrentStep();
  // Max filename of 255 characters
  filename = truncateString(filename, 255 - outputImgExt.length());
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

public void confirmBtn_click(GButton source, GEvent event) { 
  // Display preview
  showPreview();
  // Update sketch steps
  updateSteps();
  // Update targetImg to match preview
  imgManager.copyPreviewToTarget();
  // TODO: make sure this works? getting some inconsistent results; maybe need to updatePixels??
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
  /* surface.setResizable(true); */
  updateWindowSize();
  // Display controls window
  createGUI();
}


void draw() {
  // TODO: move to windowManager.updatePreview() and just call that?
  if (previewImgUpdated) {
    updatePreview();
  } 
}

