// =============================================================================
// Globals and logic related to the image preview window
// =============================================================================

// Manager =====================================================================

/**
 * Manages the preview window dimensions
 */
public class WindowManager {
  // Window dimensions
  public int width, height;
  // Preview window size (does not affect output image size)
  public int maxWindowSize;
  // Set to true if the preview image has been modified since the last time it
  // was rendered, telling the draw() method that it needs to be re-drawn
  public boolean previewImgUpdated;

  public WindowManager() {
    width = height = 0;
    maxWindowSize = 800;
    previewImgUpdated = true;
  }

  // Getter/Setter Methods

  public void updateWindowDimensions(PImage img) {
    int[] dimensions = calculateWindowDimensions(img);
    width = dimensions[0];
    height = dimensions[1];
    surface.setSize(width, height);
  }

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
    image(previewImg, 0, 0, width, height);
    previewImgDrawn();
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
    if (ratio < 1.0) {
      dimensions = new int[]{(int)(maxWindowSize * ratio), maxWindowSize};
    } else {
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


