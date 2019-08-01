import g4p_controls.*;
// Configs =====================================================================

// Input File ------------------------------------------------------------------
// File path relative to current directory
String imgPath = "source/";
// File name
String imgFile = "test";
// File extension
String imgExt = "jpg";

// Output File -----------------------------------------------------------------
// File path relative to current directory
String outputPath = imgPath + imgFile + "/";
// Use a verbose filename w/ details on the sketch config
// TODO: checkbox for this
boolean verboseName = true; 

// Sketch Settings -------------------------------------------------------------
// Number of times to repeat the process
/* int shiftIterations = 3; */
int shiftIterations = 0; // TODO: disabling for testing
// Randomly swap channels
boolean swapChannels = true;
// Use resulting image as the source for subsequent iterations
boolean recursiveIterations = true;
// Shift channels horizontally
boolean shiftHorizontal = true;
// Shift channels vertically
boolean shiftVertical = shiftHorizontal; // TODO: setting both to true so GUI works
// Multiplier for the shift amount. Lower numbers = less drastic shifts
float shiftMultiplier = 1.0;
// TODO: future options: uniformShift (per-dimension?), perlinNoise, manualMode

// Interface -------------------------------------------------------------------
// Preview window size (does not affect output image size)
int maxWindowSize = 600;


// Globals =====================================================================

// Original image and working image
PImage sourceImg, targetImg, previewImg;
// Window dimensions
int windowWidth, windowHeight;
// Used to check sketch progress
// TODO: are these necessary anymore?
boolean sketchComplete, imgSaved, completeMsgShown;

// Maps index 0-2 to corresponding color channel. Used as a shorthand when
// making operations more human readable
String[] CHANNELS = new String[]{"R","G","B"};

// Store shift values and which channels were shifted/swapped. Will be appended
// to filename if verboseName is true
String sketchSteps;

// String to use for indent in output msgs
String INDENT = "   ";

// TODO: doc and organize
int sourceChannel, targetChannel;
int horizontalShift, verticalShift;

// Set when controls window is drawn so it doesn't get duplicated on subsequent
// calls to setup()
boolean controlsWindowCreated = false;


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

// Output ----------------------------------------------------------------------

// TODO: add output panel to GUI

/**
 * Prints "SKETCH COMPLETE" message with list of input actions. Sets
 * completeMsgShown to true after message is printed
 */
void printCompleteMsg() {
  println("SKETCH COMPLETE.");
  println(INDENT + "SPACEBAR: Save and run again");
  println(INDENT + "X: Discard and run again");
  println(INDENT + "ENTER: Save and quit");
  println(INDENT + "ESC: Discard and quit");
  println("");
  // Update state
  completeMsgShown = true;
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
 * If shiftHorizontal or shiftVertical are set to false, the "-x{int}" or
 * "-y{int}" will be omitted, respectively.
 */
String stringifyStep(int horizontalShift, int verticalShift, int sourceChannel, int targetChannel) {
  String step = "";
  // Only show what channel was shifted if not swapped
  if (sourceChannel == targetChannel)
    step += CHANNELS[sourceChannel];
  else
    step += "s" + CHANNELS[sourceChannel] + "t" + CHANNELS[targetChannel];
  if (shiftHorizontal)
    step += "-x" + horizontalShift;
  if (shiftVertical)
    step += "-y" + verticalShift;
  return step;
}

/**
 * Update sketchSteps using globals
 */
void updateSteps() {
  sketchSteps += "_" + stringifyStep(horizontalShift, verticalShift, sourceChannel, targetChannel);
}

/**
 * Returns an output file path based on sketch configurations.
 * @return A unique output filepath based on sketch configs. If verboseName is
 * true, a suffix will be appended to the filename detailing the sketch configs
 * and shifts/swaps that occurred at each iteration
 */
String outputFilename() {
  // Append suffix with unique id
  // TODO: remove unless not verbose
  String suffix = hex((int)random(0xffff),4);
  // Add details if verboseName
  if (verboseName) {
    suffix += "-" + shiftIterations + "it";
    if (swapChannels)
      suffix += "-swap";
    if (recursiveIterations)
      suffix += "-recursive";
    if (shiftHorizontal)
      suffix += "-hori"; 
    if (shiftVertical)
      suffix += "-vert"; 
    // Append steps
    suffix += sketchSteps;
  }
  // TODO: update docstring w/ sketchPath stuff
  return sketchPath(outputPath + imgFile + suffix + ".png");
}

// TODO: update docstring, rename saveResultAs() for clarity?
/**
 * Save the resulting image. Path is based on output configs and generated
 * using outputFilename(). Sets imgSaved to true once file is written
 */
void saveResult() {
  String outputFile = outputFilename(); // TODO: make sure this all works w/ save dialog
  // TODO: create outputPath if !exist?
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
    // Update state and print output
    imgSaved = true;
    println("Result saved:");
    println(INDENT + outputFile);
    println("");
  }
}

// Loading ---------------------------------------------------------------------

// TODO: document all, move before saving section

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
 * Load an image file. Sets global variables and updates window size accordingly
 * @param filename Path to the image file
 */
void loadImageFile(String filename) {
  // Set globals
  sourceImg = loadImage(filename);
  targetImg = sourceImg.copy();
  previewImg = sourceImg.copy();
  // Update window size
  updateWindowSize();
  // TODO: update output dir name to match?
}

// Input Handlers --------------------------------------------------------------
// TODO: Remove?

/**
 * Handle key presses
 * @param k Character for the key that was pressed
 */
void keyHandler(char k) {
  switch (k) {
    // Space - Save and re-run
    case ' ':
      if (!imgSaved)
        saveResult();
    // X - Discard and re-run
    case 'x':
    case 'X':
      restartSketch();
      break;
    // ENTER - Save and exit
    case ENTER:
      if (!imgSaved)
        saveResult();
    // ESC - Discard and exit
    case ESC:
      System.exit(0);
      break;
    default:
      break;
  }
}

// Channel Shift ---------------------------------------------------------------

/**
 * Calculates shift amount based on sketch configs.
 * @param horizontal If true, calculate horizontal shift, else calculate
 * vertical shift
 * @param img PImage object that will be channel shifted. Used to determine
 * shift amount based on dimensions
 * @return Shift amount based on configs. If the type of shift is disabled,
 * will always return 0
 */
int shiftAmount(boolean horizontal, PImage img) {
  // TODO: remove this after GUI implemented
  // Get corresponding config and dimension based on shift type
  boolean doShift = horizontal ? shiftHorizontal : shiftVertical;
  if (!doShift)
    return 0;
  int imgDimension = horizontal ? img.width : img.height;
  return int(random(imgDimension * shiftMultiplier));
}

/**
 * Calculates horizontal shift amount based on sketch configs. Wrapper around
 * shiftAmount()
 * @param img PImage object that will be channel shifted. Used to determine
 * shift amount based on dimensions
 * @return Shift amount based on configs. If the type of shift is disabled,
 * will always return 0
 */
int horizontalShiftAmount(PImage img) {
  return shiftAmount(true, img);
}

/**
 * Calculates vertical shift amount based on sketch configs. Wrapper around
 * shiftAmount()
 * @param img PImage object that will be channel shifted. Used to determine
 * shift amount based on dimensions
 * @return Shift amount based on configs. If the type of shift is disabled,
 * will always return 0
 */
int verticalShiftAmount(PImage img) {
  return shiftAmount(false, img);
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

// Sketch ----------------------------------------------------------------------

// TODO: REMOVE
/**
 * Runs the sketch. Sets sketchComplete to true after running through all
 * iterations and updating targetImg pixels
 */
void processImg() {
  for (int i = 0; i < shiftIterations; i++) {
    // Pick random color channel from source
    sourceChannel = int(random(3));
    // Pick random target channel to swap with if swapChannels = true
    targetChannel = swapChannels ? int(random(3)) : sourceChannel;
    // Calculate shift amounts
    horizontalShift = horizontalShiftAmount(targetImg);
    verticalShift = verticalShiftAmount(targetImg);

    shiftChannel(sourceImg, targetImg, horizontalShift, verticalShift, sourceChannel, targetChannel);

    // Update sketch steps
    updateSteps();

    // Use target as source for next iteration if recursive
    if (recursiveIterations)
      sourceImg.pixels = targetImg.pixels;
  }
  // Update target pixels and set complete to true
  targetImg.updatePixels();
  sketchComplete = true;
}

/**
 * Run setup() and draw()
 */
void restartSketch() {
  println("Running sketch...");
  setup();
  draw();
}

// GUI =========================================================================

// TODO: implement, re-work existing setup, cleanup generated code
// TODO: figure out how recursive will work

// Controls Window -------------------------------------------------------------

// Sets controlsWindowCreated to true
synchronized public void controlsWindow_draw(PApplet appc, GWinData data) { //_CODE_:controlsWindow:848299:
  appc.background(230);
  controlsWindowCreated = true;
} //_CODE_:controlsWindow:848299:

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

// TODO: doc and implement
// TODO: just have this automatically update to match globals?
void setChannelToggle(boolean source, int channel) {
  GOption[] toggles;
  if (source)
    toggles = new GOption[]{ srcR, srcG, srcB };
  else
    toggles = new GOption[]{ targR, targG, targB };
  toggles[channel].setSelected(true);
}

public void srcR_clicked(GOption source, GEvent event) { //_CODE_:srcR:723362:
  selectChannel(true, 0);
} //_CODE_:srcR:723362:

public void srcG_clicked(GOption source, GEvent event) { //_CODE_:srcG:663851:
  selectChannel(true, 1);
} //_CODE_:srcG:663851:

public void srcB_clicked(GOption source, GEvent event) { //_CODE_:srcB:834511:
  selectChannel(true, 2);
} //_CODE_:srcB:834511:

public void targR_clicked(GOption source, GEvent event) { //_CODE_:targR:594833:
  selectChannel(false, 0);
} //_CODE_:targR:594833:

public void targG_clicked(GOption source, GEvent event) { //_CODE_:targG:802122:
  selectChannel(false, 1);
} //_CODE_:targG:802122:

public void targB_clicked(GOption source, GEvent event) { //_CODE_:targB:979900:
  selectChannel(false, 2);
} //_CODE_:targB:979900:

// Horizontal/Vertical Shift ---------------------------------------------------

/**
 * Set horizontal or vertical shift
 * @param horizontal If true, set horizontal shift, else set vertical shift
 * @param shiftPercent Percent of image dimension to shift by
 */
void setShift(boolean horizontal, int shiftPercent) {
  // Calculate amount of pixels to shift
  int imgDimension = horizontal ? targetImg.width : targetImg.height;
  int shiftAmount = (int)(imgDimension * shiftPercent / 100);
  if (horizontal)
    horizontalShift = shiftAmount;
  else
    verticalShift = shiftAmount;
}

public void xSlider_change(GSlider source, GEvent event) { //_CODE_:xSlider:739546:
  setShift(true, source.getValueI());
} //_CODE_:xSlider:739546:

public void ySlider_change(GSlider source, GEvent event) { //_CODE_:ySlider:334762:
  setShift(false, source.getValueI());
} //_CODE_:ySlider:334762:

// Randomize Button ------------------------------------------------------------

// TODO: implement: randomly pick channels/shift amounts similar to how original sketch worked
public void randomizeBtn_click(GButton source, GEvent event) { //_CODE_:randomizeBtn:517784:
  // Channels
  sourceChannel = int(random(3));
  setChannelToggle(true, sourceChannel);
  targetChannel = int(random(3));
  setChannelToggle(false, targetChannel);
  // Shift
  // TODO: just pick 0-100
  horizontalShift = horizontalShiftAmount(targetImg);
  verticalShift = verticalShiftAmount(targetImg);
  // TODO: update GUI
} //_CODE_:randomizeBtn:517784:

// Reset Button ----------------------------------------------------------------

// TODO: doc
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

// TODO: should this also revert the image to its original state?
public void resetBtn_click(GButton source, GEvent event) { //_CODE_:resetBtn:841959:
  resetShift();
} //_CODE_:resetBtn:841959:

// Preview Button --------------------------------------------------------------

// TODO: doc
void showPreview() {
  previewImg = targetImg.copy();
  shiftChannel(sourceImg, previewImg, horizontalShift, verticalShift, sourceChannel, targetChannel);
  previewImg.updatePixels();
}

public void previewBtn_click(GButton source, GEvent event) { //_CODE_:previewBtn:835641:
  showPreview();
} //_CODE_:previewBtn:835641:

// Confirm Button --------------------------------------------------------------

public void confirmBtn_click(GButton source, GEvent event) { //_CODE_:confirmBtn:409845:
  // Display preview
  showPreview();
  // Update sketch steps
  updateSteps();
  // Update targetImg to match preview
  targetImg = previewImg.copy();
  // Reset shift values and UI
  resetShift();
  // TODO: recursive checkbox?
} //_CODE_:confirmBtn:409845:

// Load Button -----------------------------------------------------------------

// TODO: implement
public void loadBtn_click(GButton source, GEvent event) {
  selectFile();
}

// Save Button -----------------------------------------------------------------

// TODO: implement: Save currently displayed unless file exists; Allow for custom filename?
public void saveBtn_click(GButton source, GEvent event) {
  // TODO: set targetImg to previewImg before saving so you get what you see
  saveResult();
  // TODO: Have imgSaved set to false after a change is made
  // For now just ignore it
  imgSaved = false;
} 



// Processing ==================================================================

void setup() {
  // TODO: selectFile() on setup if imgFile is not set
  // Load image (initializes global PImage objects)
  loadImageFile(imgPath + imgFile + "." + imgExt);
  // Set initial state
  sketchComplete = imgSaved = completeMsgShown = false;
  // Reset steps string
  sketchSteps = "";
  // Window
  size(1,1);
  surface.setResizable(true);
  updateWindowSize();
  // Load image
  image(sourceImg, 0, 0, windowWidth, windowHeight);
  // Display controls window
  if (!controlsWindowCreated)
    createGUI();
}


void draw() {
  if (!sketchComplete) {
    // TODO: TESTING
    /* processImg(); */
    image(previewImg, 0, 0, windowWidth, windowHeight);
  } else if (!completeMsgShown) {
    printCompleteMsg();
  }
}

// Input Listeners =============================================================
// TODO: Remove? Modify?

void keyPressed() {
  // TODO: check if sketch complete first? Input seems to be buffered so might not matter
  keyHandler(key);
}

// TODO: Remove? Or click to just save?
void mouseClicked() {
  if (sketchComplete) {
    // Save result
    if (!imgSaved)
      saveResult();
    System.exit(0);
  }
}
