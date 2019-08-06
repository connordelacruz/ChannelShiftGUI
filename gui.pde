// G4P Variable Declarations ===================================================

// TODO: move declarations to corresponding helper sections?
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
// Buttons ---------------------------------------------------------------------
GButton randomizeBtn; 
GButton resetBtn; 
GButton previewBtn; 
GButton confirmBtn; 
GButton loadBtn; 
GButton saveBtn; 


// Globals =====================================================================

// TODO: re-organize and use better calculations for easier changes (e.g. grouped items use relative sizes)
// Positioning -----------------------------------------------------------------
// Use 10 as the left-most position to add padding to the window
int X_START = 10;
// Margins ---------------------------------------------------------------------
// Single margin
int X_MARGIN = X_START;
// Subtract from widths to get margins on either side
int X_MARGINS = 2 * X_MARGIN;
// Window ----------------------------------------------------------------------
int WINDOW_WIDTH  = 500;
int WINDOW_HEIGHT = 400;
// Toggles ---------------------------------------------------------------------
int CHANNEL_TOGGLE_WIDTH = 120;
int CHANNEL_TOGGLE_HEIGHT = 20;
// Sliders ---------------------------------------------------------------------
// Slider and Toggle Widths
int SLIDER_TOGGLE_WIDTH = 100;
int SLIDER_WIDTH = WINDOW_WIDTH - SLIDER_TOGGLE_WIDTH - X_MARGINS;
// Slider and Toggle Heights
int SLIDER_HEIGHT = 50;
int SLIDER_TOGGLE_HEIGHT = SLIDER_HEIGHT / 2;
// Slider Y Positions
int X_SLIDER_Y = 140;
int Y_SLIDER_Y = 230;
// Slider Toggles --------------------------------------------------------------
int SLIDER_TOGGLE_X_START = X_START + SLIDER_WIDTH;


// Initialization ==============================================================

// TODO: split into groups
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  // Controls window -----------------------------------------------------------
  // TODO: window position
  controlsWindow = GWindow.getWindow(this, "Channel Shift", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, JAVA2D);
  controlsWindow.noLoop();
  controlsWindow.setActionOnClose(G4P.KEEP_OPEN);
  controlsWindow.addDrawHandler(this, "controlsWindow_draw");
  // Source channel toggle -----------------------------------------------------
  createSrcChannelPanel();
  // Target channel toggle -----------------------------------------------------
  createTargChannelPanel();
  // Horizontal shift slider ---------------------------------------------------
  createXShiftPanel();
  // Vertical shift slider -----------------------------------------------------
  createYShiftPanel();
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

// TODO: position vars
public void createSrcChannelPanel() {
  // Initialize panel
  srcChannelPanel = new GPanel(controlsWindow, X_START, 20, CHANNEL_TOGGLE_WIDTH, 4*CHANNEL_TOGGLE_HEIGHT, "Source Channel");
  setupGeneralPanel(srcChannelPanel);
  // Initialize toggles 
  srcChannelToggle = new GToggleGroup();
  srcR = new GOption(controlsWindow, 0, CHANNEL_TOGGLE_HEIGHT, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT);
  srcG = new GOption(controlsWindow, 0, 2*CHANNEL_TOGGLE_HEIGHT, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT);
  srcB = new GOption(controlsWindow, 0, 3*CHANNEL_TOGGLE_HEIGHT, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT);
  // Configure options
  createChannelPanel(srcChannelPanel, srcChannelToggle, srcR, srcG, srcB, true);
}

// TODO: position vars
public void createTargChannelPanel() {
  // Initialize panel
  targChannelPanel = new GPanel(controlsWindow, 150, 20, CHANNEL_TOGGLE_WIDTH, 4*CHANNEL_TOGGLE_HEIGHT, "Target Channel");
  setupGeneralPanel(targChannelPanel);
  // Initialize toggles 
  targChannelToggle = new GToggleGroup();
  targR = new GOption(controlsWindow, 0, CHANNEL_TOGGLE_HEIGHT, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT);
  targG = new GOption(controlsWindow, 0, 2*CHANNEL_TOGGLE_HEIGHT, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT);
  targB = new GOption(controlsWindow, 0, 3*CHANNEL_TOGGLE_HEIGHT, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT);
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


// TODO: positioning variables
public void createXShiftPanel() {
  xShiftPanel = new GPanel(controlsWindow, X_START, 120, WINDOW_WIDTH - X_MARGINS, SLIDER_HEIGHT + 20, "Horizontal Shift");
  xSlider = new GSlider(controlsWindow, 0, 20, SLIDER_WIDTH, SLIDER_HEIGHT, 10.0);
  xSliderToggle = new GToggleGroup();
  xSliderPercent = new GOption(controlsWindow, SLIDER_WIDTH, 20, SLIDER_TOGGLE_WIDTH, SLIDER_TOGGLE_HEIGHT);
  xSliderPixels = new GOption(controlsWindow, SLIDER_WIDTH, 20 + SLIDER_TOGGLE_HEIGHT, SLIDER_TOGGLE_WIDTH, SLIDER_TOGGLE_HEIGHT);
  createChannelShiftPanel(xShiftPanel, GCScheme.RED_SCHEME, xSlider, "xSlider_change", xSliderToggle, xSliderPercent, "xSliderPercent_clicked", xSliderPixels, "xSliderPixels_clicked");
}


// TODO: positioning variables
public void createYShiftPanel() {
  yShiftPanel = new GPanel(controlsWindow, X_START, 210, WINDOW_WIDTH - X_MARGINS, SLIDER_HEIGHT + 20, "Vertical Shift");
  ySlider = new GSlider(controlsWindow, 0, 20, SLIDER_WIDTH, SLIDER_HEIGHT, 10.0);
  ySliderToggle = new GToggleGroup();
  ySliderPercent = new GOption(controlsWindow, SLIDER_WIDTH, 20, SLIDER_TOGGLE_WIDTH, SLIDER_TOGGLE_HEIGHT);
  ySliderPixels = new GOption(controlsWindow, SLIDER_WIDTH, 20 + SLIDER_TOGGLE_HEIGHT, SLIDER_TOGGLE_WIDTH, SLIDER_TOGGLE_HEIGHT);
  createChannelShiftPanel(yShiftPanel, GCScheme.GREEN_SCHEME, ySlider, "ySlider_change", ySliderToggle, ySliderPercent, "ySliderPercent_clicked", ySliderPixels, "ySliderPixels_clicked");
}

