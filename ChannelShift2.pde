
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

// String to use for indent in output msgs
String INDENT = "   ";


// Helper Methods ==============================================================

// Window ----------------------------------------------------------------------

// Calculate window dimensions based on image size and maxWindowSize config
// Returns a 2D array where [0] = width and [1] = height
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

void printCompleteMsg() {
  println("SKETCH COMPLETE.");
  println(INDENT + "SPACEBAR: Save and run again");
  println(INDENT + "X: Discard and run again");
  println(INDENT + "CLICK: Save and quit");
  println(INDENT + "ESC: Discard and quit");
  println("");
  // Update state
  completeMsgShown = true;
}

// Saving ----------------------------------------------------------------------

String outputFilename() {
  // Append suffix with unique id
  String suffix = hex((int)random(0xffff),4);
  // Add details if verboseName
  // TODO: store details on iterations
  if (verboseName) {
    suffix = "_" + shiftIterations + "it";
    if (swapChannels)
      suffix += "-swap";
    if (recursiveIterations)
      suffix += "-recursive";
    if (shiftHorizontal)
      suffix += "-hori"; 
    if (shiftVertical)
      suffix += "-vert"; 
  }
  return outputPath + imgFile + suffix + ".png";
}

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

// Channel Shift ---------------------------------------------------------------

// TODO: doc
int shiftAmount(boolean horizontal, PImage img) {
  // Get corresponding config and dimension based on shift type
  boolean doShift = horizontal ? shiftHorizontal : shiftVertical;
  if (!doShift)
    return 0;
  int imgDimension = horizontal ? img.width : img.height;
  return int(random(imgDimension * shiftMultiplier));
}

int horizontalShiftAmount(PImage img) {
  return shiftAmount(true, img);
}

int verticalShiftAmount(PImage img) {
  return shiftAmount(false, img);
}

// TODO: doc, take img instead of pixels so we have dimensions
void shiftChannel(PImage sourceImg, PImage targetImg, int xShift, int yShift, int sourceChannel, int targetChannel) {
  // Get pixels
  color[] sourcePixels = sourceImg.pixels;
  color[] targetPixels = targetImg.pixels;
  // Loop thru rows
  for (int y = 0; y < targetImg.height; y++) {
    // TODO: test mod
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

// TODO: doc
void processImg() {
  sourceImg.loadPixels();
  targetImg.loadPixels();

  // TODO: keep track of channels, shift values, etc for each iteration for verbose filenames
  for (int i = 0; i < shiftIterations; i++) {
    // Pick random color channel from source
    int sourceChannel = int(random(3));
    // Pick random target channel to swap with if swapChannels = true
    int targetChannel = swapChannels ? int(random(3)) : sourceChannel;
    // Calculate shift amounts
    int horizontalShift = horizontalShiftAmount(targetImg);
    int verticalShift = verticalShiftAmount(targetImg);

    shiftChannel(sourceImg, targetImg, horizontalShift, verticalShift, sourceChannel, targetChannel);

    // Use target as source for next iteration if recursive
    if (recursiveIterations)
      sourceImg.pixels = targetImg.pixels;
  }
  // Update target pixels and set complete to true
  targetImg.updatePixels();
  sketchComplete = true;
}


// Processing ==================================================================

void setup() {
  // Load image
  sourceImg = loadImage(imgPath + imgFile+"."+imgExt);
  targetImg = sourceImg.copy();
  // Set initial state
  sketchComplete = imgSaved = completeMsgShown = false;
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
// TODO: Move up?

void keyPressed() {
  // TODO: check if sketch complete first?
  // TODO: see re-factored version and use that setup
  // TODO: extract all actions to methods
  switch (key) {
    // Space - Save and re-run
    case ' ':
      if (!imgSaved)
        saveResult();
    // X - Discard and re-run
    case 'x':
    case 'X':
      println("Running sketch...");
      setup();
      draw();
      break;
    // ESC - Discard and exit
    case ESC:
      System.exit(0);
      break;
    default:
      break;
  }
}

void mouseClicked() {
  // TODO: see re-factored version and update?
  if (sketchComplete) {
    // Save result
    if (!imgSaved)
      saveResult();
    System.exit(0);
  }
}

