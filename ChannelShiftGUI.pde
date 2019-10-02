import g4p_controls.*;

// Configs =====================================================================

// Input File ------------------------------------------------------------------
// Default image to load on start
String defaultImgName = "test";
String defaultImgPath = "source/" + defaultImgName + ".jpg";

// Globals =====================================================================

// Image managers
ImgManager imgManager;
// Sketch state managers
ChannelManager channelManager;
ShiftManager xShiftManager, yShiftManager;
RandomizeManager randomizeManager;
// Advanced option managers
ShiftTypeManager shiftTypeManager;
// Sketch step manager
StepManager stepManager;
// Interface managers
WindowManager windowManager;

// Constants ===================================================================
// String to use for indent in output msgs
String INDENT = "   ";

// Helper Methods ==============================================================

// Channel Shift ---------------------------------------------------------------

// TODO move this to its own file? Or to shift.pde? Even tho it relies on shift type?
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
      int yOffset = mod(shiftTypeManager.calculateShiftOffset(x, y, targetImg.width, targetImg.height, yShift, false), targetImg.height);
      int xOffset = mod(shiftTypeManager.calculateShiftOffset(x, y, targetImg.width, targetImg.height, xShift, true), targetImg.width);

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

// Processing ==================================================================

void setup() {
  // Window
  size(1,1);
  // Initialize managers
  imgManager = new ImgManager();
  channelManager = new ChannelManager();
  xShiftManager = new ShiftManager(true);
  yShiftManager = new ShiftManager(false);
  shiftTypeManager = new ShiftTypeManager();
  randomizeManager = new RandomizeManager();
  stepManager = new StepManager(xShiftManager, yShiftManager, channelManager, shiftTypeManager, imgManager);
  windowManager = new WindowManager();
  // Load image (initializes global PImage objects)
  loadImageFile(defaultImgPath, defaultImgName);
  // Display controls window
  createGUI();
}


void draw() {
  windowManager.updatePreview(imgManager.previewImg);
}

