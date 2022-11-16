// =============================================================================
// Globals and logic related to the image preview window
// =============================================================================

// Manager =====================================================================

/**
 * Manages the preview window dimensions
 */
public class WindowManager {
  // Window dimensions and position
  public int windowWidth, windowHeight;
  public int windowX, windowY;
  // Set to true if the preview image has been modified since the last time it
  // was rendered, telling the draw() method that it needs to be re-drawn
  public boolean previewImgUpdated;

  // Window title text
  public static final String WINDOW_TITLE_TEXT = "Image Preview";

  public WindowManager() {
    this.windowWidth = this.windowHeight = 0;
    this.previewImgUpdated = true;
    surface.setTitle(this.WINDOW_TITLE_TEXT);
  }

  /**
   * Set window size and position based on image dimensions
   */
  public void updateWindowDimensions(PImage img) {
    int[] dimensions = calculateWindowDimensions(img);
    this.windowWidth = dimensions[0];
    this.windowHeight = dimensions[1];
    surface.setSize(this.windowWidth, this.windowHeight);
    // Right side of the screen w/ 50 pixels for padding
    this.windowX = displayWidth - this.windowWidth - 50;
    // Vertically center
    this.windowY = (displayHeight - this.windowHeight) / 2;
    surface.setLocation(this.windowX, this.windowY);
  }

  /**
   * Tell window whether preview image was updated
   */
  public void previewImgUpdated(boolean wasUpdated) {
    previewImgUpdated = wasUpdated;
  }

  public void previewImgUpdated() { previewImgUpdated(true); }

  public void previewImgDrawn() { previewImgUpdated(false); }

  // Display preview image

  // Redraw if previewImgUpdated
  public void updatePreview(PImage previewImg) {
    if (previewImgUpdated)
      drawPreview(previewImg);
  }
  public void drawPreview(PImage previewImg) {
    image(previewImg, 0, 0, this.windowWidth, this.windowHeight);
    previewImgDrawn();
  }

  // Update window title if image was modified
  public void updateWindowTitle(boolean wasPreviewImageModified) {
    String windowTitleSuffix = wasPreviewImageModified ? "*" : "";
    surface.setTitle(this.WINDOW_TITLE_TEXT + windowTitleSuffix);
  }

  // Helpers

  /**
   * Calculate window dimensions based on image size and maxWindowSize config
   * @param img The PImage object that will be displayed in the window
   * @return A 2D array where [0] = width and [1] = height 
   */
  int[] calculateWindowDimensions(PImage img) {
    int[] dimensions;
    float ratio = (float) img.width/img.height;
    // Set longer side to maxWindowSize, then multiply ratio by the shorter side to
    // maintain aspect ratio
    int maxWindowSize = 0;
    // Portrait
    if (ratio < 1.0) {
      maxWindowSize = 2 * displayHeight / 3;
      dimensions = new int[]{(int)(maxWindowSize * ratio), maxWindowSize};
    // Landscape
    } else {
      maxWindowSize = displayWidth / 2;
      dimensions = new int[]{maxWindowSize, (int)(maxWindowSize / ratio)};
    }
    return dimensions;
  }
}

// Helper Methods ==============================================================

// Displaying Preview ----------------------------------------------------------

/**
 * Sets previewImg to a copy of targetImg and calls shiftChannel(). Sets
 * previewImgUpdated to true and calls previewImg.updatePixels() after shifting
 */
void showPreview() {
  // Make sure preview image matches target
  imgManager.copyTargetToPreview();
  shiftChannel(imgManager.sourceImg, imgManager.previewImg, xShiftManager.shiftAmount, yShiftManager.shiftAmount, channelManager.sourceChannel, channelManager.targetChannel);
  // Update preview image pixels and redraw
  imgManager.updatePreview();
  windowManager.previewImgUpdated();
}


