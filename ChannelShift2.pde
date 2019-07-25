
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
boolean verboseName = true;

// Sketch Settings -------------------------------------------------------------
// Number of times to repeat the process
int shiftIterations = 3;
// Randomly swap channels
boolean swapChannels = true;
// Use resulting image as the source for subsequent iterations
boolean recursiveIterations = true;
// Shift channels horizontally
boolean shiftHorizontal = true;
// Shift channels vertically
boolean shiftVertical = !shiftHorizontal;
// Multiplier for the shift amount. Lower numbers = less drastic shifts
float shiftMultiplier = 1.0;
// TODO: future options: uniformShift (per-dimension?), perlinNoise, manualMode

// Interface -------------------------------------------------------------------
// Preview window size (does not affect output image size)
int maxWindowSize = 600;


// Globals =====================================================================

// Original image and working image
PImage sourceImg, targetImg;
// Window dimensions
int windowWidth, windowHeight;
// Used to check sketch progress
boolean sketchComplete, imgSaved, completeMsgShown;

// Maps index 0-2 to corresponding color channel. Used as a shorthand when
// making operations more human readable
String[] CHANNELS = new String[]{"R","G","B"};

// Store shift values and which channels were shifted/swapped. Will be appended
// to filename if verboseName is true
String sketchSteps;

// String to use for indent in output msgs
String INDENT = "   ";


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

// Output ----------------------------------------------------------------------

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
 * Returns an output file path based on sketch configurations.
 * @return A unique output filepath based on sketch configs. If verboseName is
 * true, a suffix will be appended to the filename detailing the sketch configs
 * and shifts/swaps that occurred at each iteration
 */
String outputFilename() {
  // Append suffix with unique id
  // TODO: remove unless not verbose? If an image has the exact same name then it's probably the same image
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
  return outputPath + imgFile + suffix + ".png";
}

/**
 * Save the resulting image. Path is based on output configs and generated
 * using outputFilename(). Sets imgSaved to true once file is written
 */
void saveResult() {
  println("Saving...");
  String outputFile = outputFilename();
  targetImg.save(outputFile);
  // Update state
  imgSaved = true;
  println("Result saved:");
  println(INDENT + outputFile);
  println("");
}

// Input Handlers --------------------------------------------------------------

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

/**
 * Runs the sketch. Sets sketchComplete to true after running through all
 * iterations and updating targetImg pixels
 */
void processImg() {
  sourceImg.loadPixels();
  targetImg.loadPixels();

  for (int i = 0; i < shiftIterations; i++) {
    // Pick random color channel from source
    int sourceChannel = int(random(3));
    // Pick random target channel to swap with if swapChannels = true
    int targetChannel = swapChannels ? int(random(3)) : sourceChannel;
    // Calculate shift amounts
    int horizontalShift = horizontalShiftAmount(targetImg);
    int verticalShift = verticalShiftAmount(targetImg);

    shiftChannel(sourceImg, targetImg, horizontalShift, verticalShift, sourceChannel, targetChannel);

    // Update steps
    sketchSteps += "_" + stringifyStep(horizontalShift, verticalShift, sourceChannel, targetChannel);

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


// Processing ==================================================================

void setup() {
  // Load image
  sourceImg = loadImage(imgPath + imgFile+"."+imgExt);
  targetImg = sourceImg.copy();
  // Set initial state
  sketchComplete = imgSaved = completeMsgShown = false;
  // Reset steps string
  sketchSteps = "";
  // Window
  size(1,1);
  surface.setResizable(true);
  int[] dimensions = getWindowDimensions(sourceImg);
  // Set globals for later use
  windowWidth = dimensions[0];
  windowHeight = dimensions[1];
  surface.setSize(windowWidth, windowHeight);
  // Load image
  image(sourceImg, 0, 0, windowWidth, windowHeight);
}


void draw() {
  if (!sketchComplete) {
    processImg();
    image(targetImg, 0, 0, windowWidth, windowHeight);
  } else if (!completeMsgShown) {
    printCompleteMsg();
  }
}

// Input Listeners =============================================================

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

