// =============================================================================
// Globals, logic, and event handlers related to loading/saving image files
// =============================================================================

// Globals =====================================================================

// Base image file name, used for default save name 
String imgFile;

// Constants ===================================================================

// File extension of the output image
String outputImgExt = ".png";

// Helper Methods ==============================================================

// Loading ---------------------------------------------------------------------

/**
 * Returns the name of a file with the extension removed
 */
String getBaseFileName(File f) {
  String name = f.getName();
  // Return name stripping last . followed by 1 or more chars
  return name.replaceFirst("[.][^.]+$", "");
}

/**
 * Callback function for selectInput() when loading a file
 */
void imageFileSelected(File selection) {
  if (selection != null) {
    println("Loading...");
    loadImageFile(selection.getAbsolutePath(), getBaseFileName(selection));
    println("Image loaded.");
    println("");
    // Reset UI and configs
    resetShift();
  }
}

/**
 * Load an image file. Sets global variables and updates window size
 * accordingly. 
 * @param path Full path to the image file
 * @param name Name of file without extension. Used for default filename when
 * saving
 */
void loadImageFile(String path, String name) {
  // Load image objects
  imgManager.loadImageFile(path);
  // Update window size
  updateWindowSize();
  // Update imgFile (for default output name)
  imgFile = name;
  // Reset steps string
  sketchSteps = "";
  // Update managers
  xShiftManager.setImgDimension(imgManager.imgWidth);
  yShiftManager.setImgDimension(imgManager.imgHeight);
  // Redraw preview
  previewImgUpdated = true;
}

// Saving ----------------------------------------------------------------------

/**
 * Returns an output file path based on source image name and sketch steps.
 * @return File name with the image file and sketch steps. Parent directory is
 * not specified, so selectOutput() should default to last opened directory
 * (depending on OS)
 */
String defaultOutputFilename() {
  String filename = imgFile + sketchSteps;
  // Append current step (unless nothing's changed)
  if (!noChangesInCurrentStep())
    filename += "_" + stringifyCurrentStep();
  // Max filename of 255 characters
  filename = truncateString(filename, 255 - outputImgExt.length());
  return filename + outputImgExt;
}

/**
 * Callback function for selectOutput() when saving result
 */
void outFileSelected(File selection) {
  if (selection != null) {
    println("Saving...");
    String outputFile = selection.getAbsolutePath();
    // Save previewImg so preview matches output file
    imgManager.savePreviewImg(outputFile);
    // Print output
    println("Result saved:");
    println(INDENT + outputFile);
    println("");
  }
}

// Event Handlers ==============================================================

// Load Button -----------------------------------------------------------------

public void loadBtn_click(GButton source, GEvent event) {
  selectInput("Load image:", "imageFileSelected");
}

// Save Button -----------------------------------------------------------------

public void saveBtn_click(GButton source, GEvent event) {
  selectOutput("Save as:", "outFileSelected", new File(defaultOutputFilename()));
} 

