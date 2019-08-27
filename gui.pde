// G4P Variable Declarations ===================================================

// Window ----------------------------------------------------------------------
GWindow controlsWindow;
// Source Toggle ---------------------------------------------------------------
GPanel srcChannelPanel;
GToggleGroup srcChannelToggle; 
GOption srcR, srcG, srcB; 
// Target Toggle ---------------------------------------------------------------
GPanel targChannelPanel;
GToggleGroup targChannelToggle; 
GOption targR, targG, targB; 
// X Slider --------------------------------------------------------------------
GPanel xShiftPanel;
GSlider xSlider; 
GToggleGroup xSliderToggle; 
GOption xSliderPercent, xSliderPixels; 
// Y Slider --------------------------------------------------------------------
GPanel yShiftPanel;
GSlider ySlider; 
GToggleGroup ySliderToggle; 
GOption ySliderPercent, ySliderPixels; 
// Randomize Button/Toggles ----------------------------------------------------
GPanel randomizePanel, randomizeCheckboxPanel;
GButton randomizeBtn; 
GCheckbox randSrcCheckbox, randTargCheckbox, 
          randXShiftCheckbox, randYShiftCheckbox;
// Reset/Confirm Buttons -------------------------------------------------------
GPanel resetConfirmPanel;
GButton resetBtn, confirmBtn; 
GCheckbox recursiveCheckbox;
// Save/Load Buttons -----------------------------------------------------------
GPanel loadSavePanel;
GButton loadBtn; 
GButton saveBtn; 


// Globals =====================================================================

// Positioning -----------------------------------------------------------------
// Use 10 as the left-most position to add padding to the window
int X_START = 10;
// Use 20 as the top-most position to add padding to the window
int Y_START = 20; 
// Margins ---------------------------------------------------------------------
// TODO: more specific about what margins are used for and make sure usage is consistent, implement Y
// Single margin
int X_MARGIN = X_START;
int Y_MARGIN = Y_START;
// Subtract from widths to get margins on either side
int X_MARGINS = 2 * X_MARGIN;
// Panels ----------------------------------------------------------------------
// Panel labels are ~20, add this so children don't overlap
int PANEL_Y_START = 20;
// Window ----------------------------------------------------------------------
int WINDOW_WIDTH  = 650;
int WINDOW_HEIGHT = 475;
// Toggles ---------------------------------------------------------------------
// General
int CHANNEL_TOGGLE_WIDTH = 150;
int CHANNEL_TOGGLE_HEIGHT = 30;
int CHANNEL_PANEL_HEIGHT = 3 * CHANNEL_TOGGLE_HEIGHT + PANEL_Y_START;
int R_CHANNEL_Y = PANEL_Y_START;
int G_CHANNEL_Y = PANEL_Y_START + CHANNEL_TOGGLE_HEIGHT;
int B_CHANNEL_Y = PANEL_Y_START + 2 * CHANNEL_TOGGLE_HEIGHT;
// Source
int SRC_CHANNEL_X = X_START;
int SRC_CHANNEL_Y = Y_START;
// Target
int TARG_CHANNEL_X = SRC_CHANNEL_X + CHANNEL_TOGGLE_WIDTH + X_MARGINS;
int TARG_CHANNEL_Y = Y_START;
// Randomize/Reset Buttons -----------------------------------------------------
// TODO: remove RESET refs, take up full width
// Subtract toggles + margins from window width (also subtracting margins for this element)
int RAND_RESET_WIDTH = WINDOW_WIDTH - 2 * CHANNEL_TOGGLE_WIDTH - 3 * X_MARGINS;
// Half of panel + margin
int RAND_RESET_BTN_WIDTH = RAND_RESET_WIDTH / 2 - X_MARGIN;
int RAND_RESET_BTN_HEIGHT = 30;
// TODO: account for checkboxes panel, replace + 20 w/ PANEL_START or whatever
int RAND_RESET_X = WINDOW_WIDTH - (RAND_RESET_WIDTH + X_MARGIN);
int RAND_RESET_Y = Y_START;
// Randomize Button and Panel
int RAND_BTN_X = RAND_RESET_BTN_WIDTH + X_MARGIN;
int RAND_PANEL_X = RAND_BTN_X;
int RAND_PANEL_Y = RAND_RESET_BTN_HEIGHT;
int RAND_PANEL_WIDTH = RAND_RESET_BTN_WIDTH;
int RAND_CHECKBOX_WIDTH = RAND_PANEL_WIDTH;
int RAND_CHECKBOX_HEIGHT = 20;
int RAND_PANEL_HEIGHT = 4 * RAND_CHECKBOX_HEIGHT + PANEL_Y_START; 
// Use tallest child as basis for rand/reset panel height
int RAND_RESET_HEIGHT = RAND_RESET_BTN_HEIGHT + RAND_PANEL_HEIGHT;
// Sliders ---------------------------------------------------------------------
// General
int SLIDER_TOGGLE_WIDTH = 100;
int SLIDER_HEIGHT = 50;
int SLIDER_PANEL_WIDTH = WINDOW_WIDTH - X_MARGINS;
int SLIDER_PANEL_HEIGHT = SLIDER_HEIGHT + PANEL_Y_START;
int SLIDER_WIDTH = SLIDER_PANEL_WIDTH - SLIDER_TOGGLE_WIDTH;
int SLIDER_TOGGLE_HEIGHT = SLIDER_HEIGHT / 2;
// Horizontal Shift
int X_SLIDER_X = X_START;
int X_SLIDER_Y = RAND_RESET_Y + RAND_RESET_HEIGHT + Y_MARGIN; 
// Slider Y Positions
int Y_SLIDER_X = X_START;
int Y_SLIDER_Y = X_SLIDER_Y + SLIDER_PANEL_HEIGHT + Y_MARGIN;
// Load/Save Buttons -----------------------------------------------------------
int LOAD_SAVE_X = X_START;
int LOAD_SAVE_Y = Y_SLIDER_Y + SLIDER_PANEL_HEIGHT + Y_MARGIN;
int LOAD_SAVE_WIDTH = WINDOW_WIDTH / 2 - X_MARGINS;
int LOAD_SAVE_BTN_HEIGHT = 30;
int LOAD_SAVE_HEIGHT = 2*LOAD_SAVE_BTN_HEIGHT + 20;
// Preview/Confirm Buttons -----------------------------------------------------
// TODO: rename PREVIEW -> RESET
int PREVIEW_CONFIRM_Y = LOAD_SAVE_Y;
int PREVIEW_CONFIRM_X = LOAD_SAVE_X + LOAD_SAVE_WIDTH + X_MARGINS;
int PREVIEW_CONFIRM_WIDTH = LOAD_SAVE_WIDTH;
int PREVIEW_CONFIRM_BTN_HEIGHT = LOAD_SAVE_BTN_HEIGHT;
int RECURSIVE_CHECKBOX_HEIGHT = 30;
int PREVIEW_CONFIRM_HEIGHT = 2 * PREVIEW_CONFIRM_BTN_HEIGHT + RECURSIVE_CHECKBOX_HEIGHT + 20;


// Initialization ==============================================================

public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  // Controls window 
  controlsWindow = GWindow.getWindow(this, "Channel Shift", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, JAVA2D);
  controlsWindow.noLoop();
  controlsWindow.setActionOnClose(G4P.KEEP_OPEN);
  controlsWindow.addDrawHandler(this, "controlsWindow_draw");
  controlsWindow.addMouseHandler(this, "controlsWindow_mouse");
  // Source channel toggle 
  createSrcChannelPanel();
  // Target channel toggle 
  createTargChannelPanel();
  // Horizontal shift slider 
  createXShiftPanel();
  // Vertical shift slider 
  createYShiftPanel();
  // Randomize/reset buttons 
  createRandomizePanel();
  // Load/save buttons 
  createLoadSavePanel();
  // Preview/Confirm buttons
  createResetConfirmPanel();

  controlsWindow.loop();
}


// Helpers =====================================================================

// General Panels --------------------------------------------------------------

// Common panel formatting
public void setupGeneralPanel(GPanel panel) {
  panel.setTextBold();
  panel.setCollapsible(false);
  panel.setDraggable(false);
}

// Common panel formatting w/ colorscheme
public void setupGeneralPanel(GPanel panel, int colorScheme) {
  setupGeneralPanel(panel);
  panel.setLocalColorScheme(colorScheme);
  panel.setOpaque(true);
}

// Channel Toggle Panels -------------------------------------------------------

public void setupChannelOption(GOption option, int channel, String eventHandler) {
  // Common
  option.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  option.setOpaque(true);
  option.addEventHandler(this, eventHandler);
  // Per-channel
  switch(channel) {
    case 0:
      option.setText("R");
      option.setLocalColorScheme(GCScheme.RED_SCHEME);
      break;
    case 1:
      option.setText("G");
      option.setLocalColorScheme(GCScheme.GREEN_SCHEME);
      break;
    case 2:
      option.setText("B");
      option.setLocalColorScheme(GCScheme.BLUE_SCHEME);
      break;
    default:
      break;
  }
}

public void createChannelPanel(GPanel channelPanel, GToggleGroup channelToggle, GOption R, GOption G, GOption B, boolean src) {
  String handlerPrefix = src ? "src" : "targ";
  // Configure options
  setupChannelOption(R, 0, handlerPrefix + "R_clicked");
  setupChannelOption(G, 1, handlerPrefix + "G_clicked");
  setupChannelOption(B, 2, handlerPrefix + "B_clicked");
  // Add options to toggle group and panel
  channelToggle.addControl(R);
  channelPanel.addControl(R);
  R.setSelected(true);
  channelToggle.addControl(G);
  channelPanel.addControl(G);
  channelToggle.addControl(B);
  channelPanel.addControl(B);
}

public void createSrcChannelPanel() {
  // Initialize panel
  srcChannelPanel = new GPanel(controlsWindow, SRC_CHANNEL_X, SRC_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_PANEL_HEIGHT, "Source Channel");
  setupGeneralPanel(srcChannelPanel);
  // Initialize toggles 
  srcChannelToggle = new GToggleGroup();
  srcR = new GOption(controlsWindow, 0, R_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT);
  srcG = new GOption(controlsWindow, 0, G_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT);
  srcB = new GOption(controlsWindow, 0, B_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT);
  // Configure options
  createChannelPanel(srcChannelPanel, srcChannelToggle, srcR, srcG, srcB, true);
}

public void createTargChannelPanel() {
  // Initialize panel
  targChannelPanel = new GPanel(controlsWindow, TARG_CHANNEL_X, TARG_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_PANEL_HEIGHT, "Target Channel");
  setupGeneralPanel(targChannelPanel);
  // Initialize toggles 
  targChannelToggle = new GToggleGroup();
  targR = new GOption(controlsWindow, 0, R_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT);
  targG = new GOption(controlsWindow, 0, G_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT);
  targB = new GOption(controlsWindow, 0, B_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT);
  // Configure options
  createChannelPanel(targChannelPanel, targChannelToggle, targR, targG, targB, false);
}


// Channel Shift Panels --------------------------------------------------------

/**
 * Common setup for channel shift slider panels. GUI objects must be
 * initialized before calling to avoid weird null pointer exceptions
 */
public void createChannelShiftPanel(
    GPanel shiftPanel, int colorScheme, 
    GSlider slider, String sliderEventHandler, 
    GToggleGroup sliderToggle, 
    GOption sliderPercent, String percentEventHandler, 
    GOption sliderPixels, String pixelsEventHandler
    ) {
  setupGeneralPanel(shiftPanel, colorScheme);
  slider.setShowValue(true);
  slider.setShowLimits(true);
  slider.setLimits(0, 0, 100);
  slider.setShowTicks(true);
  slider.setNumberFormat(G4P.INTEGER, 0);
  slider.setLocalColorScheme(colorScheme);
  slider.setOpaque(true);
  slider.addEventHandler(this, sliderEventHandler);
  shiftPanel.addControl(slider);
  // TODO: extract common from toggles to method
  sliderPercent.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  sliderPercent.setText("Percent");
  sliderPercent.setLocalColorScheme(colorScheme);
  sliderPercent.setOpaque(true);
  sliderPercent.addEventHandler(this, percentEventHandler);
  sliderPixels.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  sliderPixels.setText("Pixels");
  sliderPixels.setLocalColorScheme(colorScheme);
  sliderPixels.setOpaque(true);
  sliderPixels.addEventHandler(this, pixelsEventHandler);
  sliderToggle.addControl(sliderPercent);
  shiftPanel.addControl(sliderPercent);
  sliderPercent.setSelected(true);
  sliderToggle.addControl(sliderPixels);
  shiftPanel.addControl(sliderPixels);
}

// TODO: better abstractions for positions/sizes (y shift too)
public void createXShiftPanel() {
  xShiftPanel = new GPanel(controlsWindow, X_SLIDER_X, X_SLIDER_Y, SLIDER_PANEL_WIDTH, SLIDER_PANEL_HEIGHT, "Horizontal Shift");
  xSlider = new GSlider(controlsWindow, 0, PANEL_Y_START, SLIDER_WIDTH, SLIDER_HEIGHT, 10.0);
  xSliderToggle = new GToggleGroup();
  xSliderPercent = new GOption(controlsWindow, SLIDER_WIDTH, PANEL_Y_START, SLIDER_TOGGLE_WIDTH, SLIDER_TOGGLE_HEIGHT);
  xSliderPixels = new GOption(controlsWindow, SLIDER_WIDTH, PANEL_Y_START + SLIDER_TOGGLE_HEIGHT, SLIDER_TOGGLE_WIDTH, SLIDER_TOGGLE_HEIGHT);
  createChannelShiftPanel(xShiftPanel, GCScheme.RED_SCHEME, xSlider, "xSlider_change", xSliderToggle, xSliderPercent, "xSliderPercent_clicked", xSliderPixels, "xSliderPixels_clicked");
}

// TODO: positioning variables
public void createYShiftPanel() {
  yShiftPanel = new GPanel(controlsWindow, Y_SLIDER_X, Y_SLIDER_Y, SLIDER_PANEL_WIDTH, SLIDER_PANEL_HEIGHT, "Vertical Shift");
  ySlider = new GSlider(controlsWindow, 0, PANEL_Y_START, SLIDER_WIDTH, SLIDER_HEIGHT, 10.0);
  ySliderToggle = new GToggleGroup();
  ySliderPercent = new GOption(controlsWindow, SLIDER_WIDTH, PANEL_Y_START, SLIDER_TOGGLE_WIDTH, SLIDER_TOGGLE_HEIGHT);
  ySliderPixels = new GOption(controlsWindow, SLIDER_WIDTH, PANEL_Y_START + SLIDER_TOGGLE_HEIGHT, SLIDER_TOGGLE_WIDTH, SLIDER_TOGGLE_HEIGHT);
  createChannelShiftPanel(yShiftPanel, GCScheme.GREEN_SCHEME, ySlider, "ySlider_change", ySliderToggle, ySliderPercent, "ySliderPercent_clicked", ySliderPixels, "ySliderPixels_clicked");
}

// Randomize/Reset Button Panel ------------------------------------------------

// TODO: Adjust layout
public void createRandomizePanel() {
  randomizePanel = new GPanel(controlsWindow, RAND_RESET_X, RAND_RESET_Y, RAND_RESET_WIDTH, RAND_RESET_HEIGHT);
  setupGeneralPanel(randomizePanel);
  randomizePanel.setOpaque(false);
  // Randomize Button
  randomizeBtn = new GButton(controlsWindow, RAND_BTN_X, 0, RAND_RESET_BTN_WIDTH, RAND_RESET_BTN_HEIGHT);
  randomizeBtn.setText("Randomize");
  randomizeBtn.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  randomizeBtn.addEventHandler(this, "randomizeBtn_click");
  randomizePanel.addControl(randomizeBtn);
  // Randomize Checkboxes
  randomizeCheckboxPanel = new GPanel(controlsWindow, RAND_PANEL_X, RAND_PANEL_Y, RAND_PANEL_WIDTH, RAND_PANEL_HEIGHT, "Randomize Options");
  setupGeneralPanel(randomizeCheckboxPanel, GCScheme.CYAN_SCHEME);
  randSrcCheckbox = new GCheckbox(controlsWindow, 0, PANEL_Y_START, RAND_CHECKBOX_WIDTH, RAND_CHECKBOX_HEIGHT, "Source Channel");
  randSrcCheckbox.setSelected(true);
  randSrcCheckbox.addEventHandler(this, "randSrcCheckbox_click");
  randomizeCheckboxPanel.addControl(randSrcCheckbox);
  randTargCheckbox = new GCheckbox(controlsWindow, 0, PANEL_Y_START + RAND_CHECKBOX_HEIGHT, RAND_CHECKBOX_WIDTH, RAND_CHECKBOX_HEIGHT, "Target Channel");
  randTargCheckbox.setSelected(true);
  randTargCheckbox.addEventHandler(this, "randTargCheckbox_click");
  randomizeCheckboxPanel.addControl(randTargCheckbox);
  randXShiftCheckbox = new GCheckbox(controlsWindow, 0, PANEL_Y_START + 2 * RAND_CHECKBOX_HEIGHT, RAND_CHECKBOX_WIDTH, RAND_CHECKBOX_HEIGHT, "Horizontal Shift");
  randXShiftCheckbox.setSelected(true);
  randXShiftCheckbox.addEventHandler(this, "randXShiftCheckbox_click");
  randomizeCheckboxPanel.addControl(randXShiftCheckbox);
  randYShiftCheckbox = new GCheckbox(controlsWindow, 0, PANEL_Y_START + 3 * RAND_CHECKBOX_HEIGHT, RAND_CHECKBOX_WIDTH, RAND_CHECKBOX_HEIGHT, "Vertical Shift");
  randYShiftCheckbox.setSelected(true);
  randYShiftCheckbox.addEventHandler(this, "randYShiftCheckbox_click");
  randomizeCheckboxPanel.addControl(randYShiftCheckbox);
  randomizePanel.addControl(randomizeCheckboxPanel);
}

// Load/Save Panel -------------------------------------------------------------

public void createLoadSavePanel() {
  loadSavePanel = new GPanel(controlsWindow, LOAD_SAVE_X, LOAD_SAVE_Y, LOAD_SAVE_WIDTH, LOAD_SAVE_HEIGHT);
  setupGeneralPanel(loadSavePanel);
  loadSavePanel.setOpaque(false);
  // Load button
  loadBtn = new GButton(controlsWindow, 0, 0, LOAD_SAVE_WIDTH, LOAD_SAVE_BTN_HEIGHT);
  loadBtn.setText("Load Image");
  loadBtn.setTextBold();
  loadBtn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  loadBtn.addEventHandler(this, "loadBtn_click");
  loadSavePanel.addControl(loadBtn);
  // Save button 
  saveBtn = new GButton(controlsWindow, 0, LOAD_SAVE_BTN_HEIGHT + 10, LOAD_SAVE_WIDTH, LOAD_SAVE_BTN_HEIGHT);
  saveBtn.setText("Save Result");
  saveBtn.setTextBold();
  saveBtn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  saveBtn.addEventHandler(this, "saveBtn_click");
  loadSavePanel.addControl(saveBtn);
}

// Preview/Confirm Panel -------------------------------------------------------

public void createResetConfirmPanel() {
  resetConfirmPanel = new GPanel(controlsWindow, PREVIEW_CONFIRM_X, PREVIEW_CONFIRM_Y, PREVIEW_CONFIRM_WIDTH, PREVIEW_CONFIRM_HEIGHT);
  setupGeneralPanel(resetConfirmPanel);
  resetConfirmPanel.setOpaque(false);
  // Reset Button
  resetBtn = new GButton(controlsWindow, 0, 0, PREVIEW_CONFIRM_WIDTH, PREVIEW_CONFIRM_BTN_HEIGHT);
  resetBtn.setText("Reset");
  resetBtn.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  resetBtn.addEventHandler(this, "resetBtn_click");
  resetConfirmPanel.addControl(resetBtn);
  // Confirm Button 
  // TODO: disable when SRC == TARG && sliders are 0
  confirmBtn = new GButton(controlsWindow, 0, PREVIEW_CONFIRM_BTN_HEIGHT + 10, PREVIEW_CONFIRM_WIDTH, PREVIEW_CONFIRM_BTN_HEIGHT);
  confirmBtn.setText("Confirm Step");
  confirmBtn.addEventHandler(this, "confirmBtn_click");
  resetConfirmPanel.addControl(confirmBtn);
  // Recursive checkbox
  recursiveCheckbox = new GCheckbox(controlsWindow, 0, 2*PREVIEW_CONFIRM_BTN_HEIGHT + 10, PREVIEW_CONFIRM_WIDTH, RECURSIVE_CHECKBOX_HEIGHT);
  recursiveCheckbox.setText("Recursive", GAlign.CENTER, GAlign.MIDDLE);
  recursiveCheckbox.setOpaque(true);
  recursiveCheckbox.addEventHandler(this, "recursiveCheckbox_click");
  resetConfirmPanel.addControl(recursiveCheckbox);
}

