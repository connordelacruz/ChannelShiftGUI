// =============================================================================
// Globals related to working PImage objects
// =============================================================================

// Manager =====================================================================

// TODO store previous image objects to allow for undo?
/** 
 * Manage the source, target, and preview PImage objects
 */
public class ImgManager {
  // Source, modified, and preview images
  public PImage sourceImg, targetImg, previewImg;
  // Width/height vars for easy access
  public int imgWidth, imgHeight;

  public ImgManager() {
    imgWidth = imgHeight = 0;
  }

  // Getter/Setter

  public void loadImageFile(String path) {
    // Initialize images
    sourceImg = loadImage(path);
    targetImg = sourceImg.copy();
    previewImg = sourceImg.copy();
    // This seems to fix a bug where the recursive option doesn't do anything
    sourceImg.loadPixels();
    targetImg.loadPixels();
    previewImg.loadPixels();
    // Update width/height vars
    imgWidth = sourceImg.width;
    imgHeight = sourceImg.height;
  }

  // Image Utility Methods
  // TODO: doc, better names?

  public void savePreviewImg(String path) {
    previewImg.save(path);
  }

  public void copyTargetToPreview() {
    previewImg = targetImg.copy();
    previewImg.loadPixels();
  }

  public void copyPreviewToTarget() {
    targetImg = previewImg.copy();
    targetImg.loadPixels();
  }

  public void updatePreview() {
    previewImg.updatePixels();
  }

  // For recursive iterations
  public void copyTargetPixelsToSource() {
    sourceImg.pixels = targetImg.pixels;
    sourceImg.updatePixels();
  }

}
