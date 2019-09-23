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

// TODO move to previewWindow.pde?
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

