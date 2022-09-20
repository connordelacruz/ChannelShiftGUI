import java.util.Arrays;
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
  // Use resulting image as the source for next iteration upon confirming step
  public boolean recursiveIteration;

  public ImgManager() {
    this.imgWidth = this.imgHeight = 0;
    this.recursiveIteration = true;
  }

  // Getter/Setter

  public void loadImageFile(String path) {
    // Initialize images
    this.sourceImg = loadImage(path);
    this.targetImg = sourceImg.copy();
    this.previewImg = sourceImg.copy();
    // This seems to fix a bug where the recursive option doesn't do anything
    this.sourceImg.loadPixels();
    this.targetImg.loadPixels();
    this.previewImg.loadPixels();
    // Update width/height vars
    this.imgWidth = this.sourceImg.width;
    this.imgHeight = this.sourceImg.height;
  }

  public void toggleRecursiveIteration(boolean recursive) { this.recursiveIteration = recursive; }

  // Confirm Current Step
  public void confirmStep() {
    // Update targetImg to match preview
    this.copyPreviewToTarget();
    // If recursive, sourceImg.pixels = targetImg.pixels
    if (this.recursiveIteration)
      this.copyTargetPixelsToSource();
  }

  // Image Utility Methods
  // TODO: doc, better names?

  public void savePreviewImg(String path) {
    this.previewImg.save(path);
  }

  public void copyTargetToPreview() {
    this.previewImg = this.targetImg.copy();
    this.previewImg.loadPixels();
  }

  public void copyPreviewToTarget() {
    this.targetImg = this.previewImg.copy();
    this.targetImg.loadPixels();
  }

  public void updatePreview() {
    this.previewImg.updatePixels();
  }

  // For recursive iterations
  public void copyTargetPixelsToSource() {
    this.sourceImg.pixels = this.targetImg.pixels;
    this.sourceImg.updatePixels();
  }

  public boolean hasPreviewImageBeenModified() {
    return !Arrays.equals(this.previewImg.pixels, this.targetImg.pixels);
  }

}

// Event Handlers ==============================================================

// Recursive Checkbox ----------------------------------------------------------

public void recursiveCheckbox_click(GCheckbox source, GEvent event) {
  imgManager.toggleRecursiveIteration(source.isSelected());
}

