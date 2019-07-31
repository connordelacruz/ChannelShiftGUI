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

// TODO: Globals for common dimensions/positioning?

public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  // Controls window -----------------------------------------------------------
  controlsWindow = GWindow.getWindow(this, "Channel Shift", 0, 0, 400, 400, JAVA2D);
  controlsWindow.noLoop();
  controlsWindow.setActionOnClose(G4P.KEEP_OPEN);
  controlsWindow.addDrawHandler(this, "controlsWindow_draw");
  // Source channel toggle -----------------------------------------------------
  srcChannelToggle = new GToggleGroup();
  srcR = new GOption(controlsWindow, 10, 40, 120, 20);
  srcR.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  srcR.setText("R");
  srcR.setLocalColorScheme(GCScheme.RED_SCHEME);
  srcR.setOpaque(true);
  srcR.addEventHandler(this, "srcR_clicked");
  srcG = new GOption(controlsWindow, 10, 60, 120, 20);
  srcG.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  srcG.setText("G");
  srcG.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  srcG.setOpaque(true);
  srcG.addEventHandler(this, "srcG_clicked");
  srcB = new GOption(controlsWindow, 10, 80, 120, 20);
  srcB.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  srcB.setText("B");
  srcB.setOpaque(true);
  srcB.addEventHandler(this, "srcB_clicked");
  srcChannelToggle.addControl(srcR);
  srcR.setSelected(true);
  srcChannelToggle.addControl(srcG);
  srcChannelToggle.addControl(srcB);
  srcChannelLabel = new GLabel(controlsWindow, 10, 20, 120, 20);
  srcChannelLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  srcChannelLabel.setText("Source Channel");
  srcChannelLabel.setTextBold();
  srcChannelLabel.setOpaque(false);
  // Target channel toggle -----------------------------------------------------
  targChannelToggle = new GToggleGroup();
  targR = new GOption(controlsWindow, 150, 40, 120, 20);
  targR.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  targR.setText("R");
  targR.setLocalColorScheme(GCScheme.RED_SCHEME);
  targR.setOpaque(true);
  targR.addEventHandler(this, "targR_clicked");
  targG = new GOption(controlsWindow, 150, 60, 120, 20);
  targG.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  targG.setText("G");
  targG.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  targG.setOpaque(true);
  targG.addEventHandler(this, "targG_clicked");
  targB = new GOption(controlsWindow, 150, 80, 120, 20);
  targB.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  targB.setText("B");
  targB.setOpaque(true);
  targB.addEventHandler(this, "targB_clicked");
  targChannelToggle.addControl(targR);
  targR.setSelected(true);
  targChannelToggle.addControl(targG);
  targChannelToggle.addControl(targB);
  targChannelLabel = new GLabel(controlsWindow, 150, 20, 120, 20);
  targChannelLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  targChannelLabel.setText("Target Channel");
  targChannelLabel.setTextBold();
  targChannelLabel.setOpaque(false);
  // Horizontal shift slider ---------------------------------------------------
  xSlider = new GSlider(controlsWindow, 10, 140, 380, 50, 10.0);
  xSlider.setShowValue(true);
  xSlider.setShowLimits(true);
  // TODO: use total pixels instead of percent for more accurate sliders
  xSlider.setLimits(0, 0, 100);
  xSlider.setShowTicks(true);
  xSlider.setNumberFormat(G4P.INTEGER, 0);
  xSlider.setLocalColorScheme(GCScheme.RED_SCHEME);
  xSlider.setOpaque(true);
  xSlider.addEventHandler(this, "xSlider_change");
  xSliderLabel = new GLabel(controlsWindow, 10, 120, 120, 20);
  xSliderLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  xSliderLabel.setText("Horizontal Shift");
  xSliderLabel.setTextBold();
  xSliderLabel.setLocalColorScheme(GCScheme.RED_SCHEME);
  xSliderLabel.setOpaque(true);
  // Vertical shift slider -----------------------------------------------------
  ySlider = new GSlider(controlsWindow, 10, 230, 380, 50, 10.0);
  ySlider.setShowValue(true);
  ySlider.setShowLimits(true);
  // TODO: use total pixels instead of percent for more accurate sliders
  ySlider.setLimits(0, 0, 100);
  ySlider.setShowTicks(true);
  ySlider.setNumberFormat(G4P.INTEGER, 0);
  ySlider.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  ySlider.setOpaque(true);
  ySlider.addEventHandler(this, "ySlider_change");
  ySliderLabel = new GLabel(controlsWindow, 10, 210, 120, 20);
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
  previewBtn = new GButton(controlsWindow, 10, 310, 180, 30);
  previewBtn.setText("Preview");
  previewBtn.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  previewBtn.addEventHandler(this, "previewBtn_click");
  // Confirm button ------------------------------------------------------------
  confirmBtn = new GButton(controlsWindow, 210, 310, 180, 30);
  confirmBtn.setText("Confirm Step");
  confirmBtn.addEventHandler(this, "confirmBtn_click");
  // Load button ---------------------------------------------------------------
  loadBtn = new GButton(controlsWindow, 10, 350, 180, 30);
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
GSlider ySlider; 
GLabel ySliderLabel; 
GButton randomizeBtn; 
GButton resetBtn; 
GButton previewBtn; 
GButton confirmBtn; 
GButton loadBtn; 
GButton saveBtn; 

