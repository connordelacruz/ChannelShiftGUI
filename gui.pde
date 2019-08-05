/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

// Globals =====================================================================

// Positioning -----------------------------------------------------------------
// Use 10 as the left-most position to add padding to the window
int X_START = 10;
// Margins ---------------------------------------------------------------------
// Subtract from widths to get margins on either side
int X_MARGINS = 2 * X_START;
// Window ----------------------------------------------------------------------
int WINDOW_WIDTH  = 600;
int WINDOW_HEIGHT = 400;
// Toggles ---------------------------------------------------------------------
int TOGGLE_WIDTH = 120;
int TOGGLE_HEIGHT = 20;
// Sliders ---------------------------------------------------------------------
int SLIDER_WIDTH = WINDOW_WIDTH - 2*TOGGLE_WIDTH - X_MARGINS;
int SLIDER_HEIGHT = 50;
int X_SLIDER_Y = 140;
int Y_SLIDER_Y = 230;
// Slider Toggles --------------------------------------------------------------
int SLIDER_TOGGLE_X_START = X_START + SLIDER_WIDTH;


public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  // Controls window -----------------------------------------------------------
  controlsWindow = GWindow.getWindow(this, "Channel Shift", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, JAVA2D);
  controlsWindow.noLoop();
  controlsWindow.setActionOnClose(G4P.KEEP_OPEN);
  controlsWindow.addDrawHandler(this, "controlsWindow_draw");
  // Source channel toggle -----------------------------------------------------
  srcChannelToggle = new GToggleGroup();
  srcR = new GOption(controlsWindow, X_START, 2*TOGGLE_HEIGHT, TOGGLE_WIDTH, TOGGLE_HEIGHT);
  srcR.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  srcR.setText("R");
  srcR.setLocalColorScheme(GCScheme.RED_SCHEME);
  srcR.setOpaque(true);
  srcR.addEventHandler(this, "srcR_clicked");
  srcG = new GOption(controlsWindow, X_START, 3*TOGGLE_HEIGHT, TOGGLE_WIDTH, TOGGLE_HEIGHT);
  srcG.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  srcG.setText("G");
  srcG.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  srcG.setOpaque(true);
  srcG.addEventHandler(this, "srcG_clicked");
  srcB = new GOption(controlsWindow, X_START, 4*TOGGLE_HEIGHT, TOGGLE_WIDTH, TOGGLE_HEIGHT);
  srcB.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  srcB.setText("B");
  srcB.setOpaque(true);
  srcB.addEventHandler(this, "srcB_clicked");
  srcChannelToggle.addControl(srcR);
  srcR.setSelected(true);
  srcChannelToggle.addControl(srcG);
  srcChannelToggle.addControl(srcB);
  srcChannelLabel = new GLabel(controlsWindow, X_START, TOGGLE_HEIGHT, TOGGLE_WIDTH, TOGGLE_HEIGHT);
  srcChannelLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  srcChannelLabel.setText("Source Channel");
  srcChannelLabel.setTextBold();
  srcChannelLabel.setOpaque(false);
  // Target channel toggle -----------------------------------------------------
  targChannelToggle = new GToggleGroup();
  targR = new GOption(controlsWindow, 150, 2*TOGGLE_HEIGHT, TOGGLE_WIDTH, TOGGLE_HEIGHT);
  targR.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  targR.setText("R");
  targR.setLocalColorScheme(GCScheme.RED_SCHEME);
  targR.setOpaque(true);
  targR.addEventHandler(this, "targR_clicked");
  targG = new GOption(controlsWindow, 150, 3*TOGGLE_HEIGHT, TOGGLE_WIDTH, TOGGLE_HEIGHT);
  targG.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  targG.setText("G");
  targG.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  targG.setOpaque(true);
  targG.addEventHandler(this, "targG_clicked");
  targB = new GOption(controlsWindow, 150, 4*TOGGLE_HEIGHT, TOGGLE_WIDTH, TOGGLE_HEIGHT);
  targB.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  targB.setText("B");
  targB.setOpaque(true);
  targB.addEventHandler(this, "targB_clicked");
  targChannelToggle.addControl(targR);
  targR.setSelected(true);
  targChannelToggle.addControl(targG);
  targChannelToggle.addControl(targB);
  targChannelLabel = new GLabel(controlsWindow, 150, TOGGLE_HEIGHT, TOGGLE_WIDTH, TOGGLE_HEIGHT);
  targChannelLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  targChannelLabel.setText("Target Channel");
  targChannelLabel.setTextBold();
  targChannelLabel.setOpaque(false);
  // Horizontal shift slider ---------------------------------------------------
  xSlider = new GSlider(controlsWindow, X_START, X_SLIDER_Y, SLIDER_WIDTH, SLIDER_HEIGHT, 10.0);
  xSlider.setShowValue(true);
  xSlider.setShowLimits(true);
  // TODO: use total pixels instead of percent for more accurate sliders? But also show/toggle percent?
  xSlider.setLimits(0, 0, 100);
  xSlider.setShowTicks(true);
  xSlider.setNumberFormat(G4P.INTEGER, 0);
  xSlider.setLocalColorScheme(GCScheme.RED_SCHEME);
  xSlider.setOpaque(true);
  xSlider.addEventHandler(this, "xSlider_change");
  xSliderLabel = new GLabel(controlsWindow, X_START, 120, 120, 20);
  xSliderLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  xSliderLabel.setText("Horizontal Shift");
  xSliderLabel.setTextBold();
  xSliderLabel.setLocalColorScheme(GCScheme.RED_SCHEME);
  xSliderLabel.setOpaque(true);
  // Horizontal shift toggles --------------------------------------------------
  xSliderToggle = new GToggleGroup();
  xSliderPercent = new GOption(controlsWindow, SLIDER_TOGGLE_X_START, X_SLIDER_Y, TOGGLE_WIDTH, TOGGLE_HEIGHT);
  xSliderPercent.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  xSliderPercent.setText("Percent");
  xSliderPercent.setLocalColorScheme(GCScheme.RED_SCHEME);
  xSliderPercent.setOpaque(true);
  xSliderPercent.addEventHandler(this, "xSliderPercent_clicked");
  xSliderPixels = new GOption(controlsWindow, SLIDER_TOGGLE_X_START + TOGGLE_WIDTH, X_SLIDER_Y, TOGGLE_WIDTH, TOGGLE_HEIGHT);
  xSliderPixels.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  xSliderPixels.setText("Pixels");
  xSliderPixels.setLocalColorScheme(GCScheme.RED_SCHEME);
  xSliderPixels.setOpaque(true);
  xSliderPixels.addEventHandler(this, "xSliderPixels_clicked");
  xSliderToggle.addControl(xSliderPercent);
  xSliderPercent.setSelected(true);
  xSliderToggle.addControl(xSliderPixels);
  // Vertical shift slider -----------------------------------------------------
  ySlider = new GSlider(controlsWindow, X_START, Y_SLIDER_Y, SLIDER_WIDTH, SLIDER_HEIGHT, 10.0);
  ySlider.setShowValue(true);
  ySlider.setShowLimits(true);
  // TODO: use total pixels instead of percent for more accurate sliders? But also show/toggle percent?
  ySlider.setLimits(0, 0, 100);
  ySlider.setShowTicks(true);
  ySlider.setNumberFormat(G4P.INTEGER, 0);
  ySlider.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  ySlider.setOpaque(true);
  ySlider.addEventHandler(this, "ySlider_change");
  ySliderLabel = new GLabel(controlsWindow, X_START, 210, 120, 20);
  ySliderLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  ySliderLabel.setText("Vertical Shift");
  ySliderLabel.setTextBold();
  ySliderLabel.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  ySliderLabel.setOpaque(true);
  // Randomize button ----------------------------------------------------------
  randomizeBtn = new GButton(controlsWindow, 280, 20, 100, 30);
  randomizeBtn.setText("Randomize");
  randomizeBtn.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  randomizeBtn.addEventHandler(this, "randomizeBtn_click");
  // Reset button --------------------------------------------------------------
  resetBtn = new GButton(controlsWindow, 280, 70, 100, 30);
  resetBtn.setText("Reset");
  resetBtn.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  resetBtn.addEventHandler(this, "resetBtn_click");
  // Preview button ------------------------------------------------------------
  previewBtn = new GButton(controlsWindow, X_START, 310, 180, 30);
  previewBtn.setText("Preview");
  previewBtn.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  previewBtn.addEventHandler(this, "previewBtn_click");
  // Confirm button ------------------------------------------------------------
  confirmBtn = new GButton(controlsWindow, 210, 310, 180, 30);
  confirmBtn.setText("Confirm Step");
  confirmBtn.addEventHandler(this, "confirmBtn_click");
  // Load button ---------------------------------------------------------------
  loadBtn = new GButton(controlsWindow, X_START, 350, 180, 30);
  loadBtn.setText("Load Image");
  loadBtn.setTextBold();
  loadBtn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  loadBtn.addEventHandler(this, "loadBtn_click");
  // Save button ---------------------------------------------------------------
  saveBtn = new GButton(controlsWindow, 210, 350, 180, 30);
  saveBtn.setText("Save Result");
  saveBtn.setTextBold();
  saveBtn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  saveBtn.addEventHandler(this, "saveBtn_click");

  controlsWindow.loop();
}

// Variable declarations 
// autogenerated do not edit
GWindow controlsWindow;
GToggleGroup srcChannelToggle; 
GOption srcR; 
GOption srcG; 
GOption srcB; 
GLabel srcChannelLabel; 
GToggleGroup targChannelToggle; 
GOption targR; 
GOption targG; 
GOption targB; 
GLabel targChannelLabel; 
GSlider xSlider; 
GLabel xSliderLabel; 
GToggleGroup xSliderToggle; 
GOption xSliderPercent; 
GOption xSliderPixels; 
GSlider ySlider; 
GLabel ySliderLabel; 
GToggleGroup ySliderToggle; 
GOption ySliderPercent; 
GOption ySliderPixels; 
GButton randomizeBtn; 
GButton resetBtn; 
GButton previewBtn; 
GButton confirmBtn; 
GButton loadBtn; 
GButton saveBtn; 

