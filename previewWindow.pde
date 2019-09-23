// =============================================================================
// Globals and  logic related to the image preview window
// =============================================================================

// Globals =====================================================================

// Set to true if the preview image has been modified since the last time it
// was rendered, telling the draw() method that it needs to be re-drawn
// TODO move to manager
boolean previewImgUpdated = true;


// Manager =====================================================================

/**
 * Manages the preview window dimensions
 */
public class WindowManager {
  // Window dimensions
  public int width, height;
  // Preview window size (does not affect output image size)
  public int maxWindowSize;

  public WindowManager() {
    width = height = 0;
    maxWindowSize = 600;
  }

  // Getter/Setter Methods

  public void updateWindowDimensions(PImage img) {
    int[] dimensions = calculateWindowDimensions(img);
    width = dimensions[0];
    height = dimensions[1];
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

