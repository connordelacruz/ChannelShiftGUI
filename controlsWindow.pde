// G4P Variable Declarations ===================================================

// Window ----------------------------------------------------------------------
GWindow controlsWindow;
// Source Toggle ---------------------------------------------------------------
GPanel srcChannelPanel;
GToggleGroup srcChannelToggle; 
ChannelOption srcR, srcG, srcB; 
// Target Toggle ---------------------------------------------------------------
GPanel targChannelPanel;
GToggleGroup targChannelToggle; 
ChannelOption targR, targG, targB; 
// X Slider --------------------------------------------------------------------
GPanel xShiftPanel;
GSlider xSlider; 
GToggleGroup xSliderToggle; 
GOption xSliderPercent, xSliderPixels; 
GTextField xSliderInput;
// Y Slider --------------------------------------------------------------------
GPanel yShiftPanel;
GSlider ySlider; 
GToggleGroup ySliderToggle; 
GOption ySliderPercent, ySliderPixels; 
GTextField ySliderInput;
// Randomize Button/Toggles ----------------------------------------------------
GPanel randomizePanel, randomizeCheckboxPanel;
GButton randomizeBtn; 
GCheckbox randSrcCheckbox, randTargCheckbox, 
          randXShiftCheckbox, randYShiftCheckbox;
GTextField randXMaxInput, randYMaxInput;
GLabel randXMaxLabel, randYMaxLabel;
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
int WINDOW_HEIGHT = 500;
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
// Randomize Button/Toggles ----------------------------------------------------
// TODO: Cleanup, simplify calculations?
// End of target channel panel + margins
int RAND_PANEL_X = TARG_CHANNEL_X + CHANNEL_TOGGLE_WIDTH + X_MARGINS;
int RAND_PANEL_Y = Y_START;
// Fill rest of window (minus right margin)
int RAND_PANEL_WIDTH = WINDOW_WIDTH - RAND_PANEL_X - X_MARGIN;
// Randomize Checkboxes + Panel
int RAND_CHECKBOX_PANEL_X = 0; 
int RAND_CHECKBOX_PANEL_Y = PANEL_Y_START;
int RAND_CHECKBOX_PANEL_WIDTH = RAND_PANEL_WIDTH;
// Half of panel width, 2 checkboxes per row
int RAND_CHECKBOX_WIDTH = RAND_CHECKBOX_PANEL_WIDTH / 2;
int RAND_CHECKBOX_HEIGHT = 30;
// Checkbox positioning
int RAND_CHECKBOX_LEFT_X = 0;
int RAND_CHECKBOX_RIGHT_X = RAND_CHECKBOX_WIDTH;
int RAND_CHECKBOX_TOP_Y = 0;
int RAND_CHECKBOX_BOTTOM_Y = RAND_CHECKBOX_HEIGHT;
int RAND_CHECKBOX_PANEL_HEIGHT = 2 * RAND_CHECKBOX_HEIGHT; 
// Max Shift Inputs
// TODO: BETTER MARGINS/POSITIONING
int RAND_MAX_LABEL_WIDTH = RAND_CHECKBOX_WIDTH - X_MARGIN;
int RAND_MAX_LABEL_HEIGHT = 20;
int RAND_MAX_INPUT_WIDTH = RAND_CHECKBOX_WIDTH - X_MARGIN;
int RAND_MAX_INPUT_HEIGHT = 20;
int RAND_MAX_TOTAL_HEIGHT = RAND_MAX_LABEL_HEIGHT + RAND_MAX_INPUT_HEIGHT;
int RAND_MAX_LABEL_Y = RAND_CHECKBOX_PANEL_Y + RAND_CHECKBOX_PANEL_HEIGHT;
int RAND_MAX_INPUT_Y = RAND_MAX_LABEL_Y + RAND_MAX_LABEL_HEIGHT;
int RAND_MAX_LEFT_X = 0;
int RAND_MAX_RIGHT_X = RAND_MAX_INPUT_WIDTH + X_MARGINS;
// Randomize Button
int RAND_BTN_WIDTH = RAND_PANEL_WIDTH;
int RAND_BTN_HEIGHT = 30;
int RAND_BTN_X = 0;
int RAND_BTN_Y = RAND_MAX_LABEL_Y + RAND_MAX_TOTAL_HEIGHT;
int RAND_PANEL_HEIGHT = RAND_CHECKBOX_PANEL_HEIGHT + RAND_MAX_TOTAL_HEIGHT + RAND_BTN_HEIGHT + PANEL_Y_START;
// Sliders ---------------------------------------------------------------------
// General
int SLIDER_TOGGLE_WIDTH = 75;
int SLIDER_INPUT_WIDTH = 75;
int SLIDER_INPUT_HEIGHT = 20;
float SLIDER_TRACK_WIDTH = 12.0;
int SLIDER_HEIGHT = 60;
int SLIDER_PANEL_WIDTH = WINDOW_WIDTH - X_MARGINS;
int SLIDER_PANEL_HEIGHT = SLIDER_HEIGHT + PANEL_Y_START;
int SLIDER_WIDTH = SLIDER_PANEL_WIDTH - (SLIDER_INPUT_WIDTH + SLIDER_TOGGLE_WIDTH);
int SLIDER_TOGGLE_HEIGHT = SLIDER_HEIGHT / 2;
int SLIDER_INPUT_X = 0;
int SLIDER_INPUT_Y = PANEL_Y_START + (SLIDER_HEIGHT / 2) - (SLIDER_INPUT_HEIGHT / 2);
int SLIDER_X = SLIDER_INPUT_X + SLIDER_INPUT_WIDTH;
int SLIDER_Y = PANEL_Y_START;
int SLIDER_TOGGLE_X = SLIDER_X + SLIDER_WIDTH;
int SLIDER_PERCENT_TOGGLE_Y = PANEL_Y_START;
int SLIDER_PIXELS_TOGGLE_Y = SLIDER_PERCENT_TOGGLE_Y + SLIDER_TOGGLE_HEIGHT;
// Horizontal Shift
int X_SLIDER_PANEL_X = X_START; 
int X_SLIDER_PANEL_Y = RAND_PANEL_Y + RAND_PANEL_HEIGHT + Y_MARGIN; 
// Vertical Shift
int Y_SLIDER_PANEL_X = X_START; 
int Y_SLIDER_PANEL_Y = X_SLIDER_PANEL_Y + SLIDER_PANEL_HEIGHT + Y_MARGIN;
// Load/Save Buttons -----------------------------------------------------------
int LOAD_SAVE_X = X_START;
int LOAD_SAVE_Y = Y_SLIDER_PANEL_Y + SLIDER_PANEL_HEIGHT + Y_MARGIN;
int LOAD_SAVE_WIDTH = WINDOW_WIDTH / 2 - X_MARGINS;
int LOAD_SAVE_BTN_HEIGHT = 30;
int LOAD_SAVE_HEIGHT = 2*LOAD_SAVE_BTN_HEIGHT + 20;
// Reset/Confirm Buttons -------------------------------------------------------
int RESET_CONFIRM_Y = LOAD_SAVE_Y;
int RESET_CONFIRM_X = LOAD_SAVE_X + LOAD_SAVE_WIDTH + X_MARGINS;
int RESET_CONFIRM_WIDTH = LOAD_SAVE_WIDTH;
int RESET_CONFIRM_BTN_HEIGHT = LOAD_SAVE_BTN_HEIGHT;
int RECURSIVE_CHECKBOX_HEIGHT = 30;
int RESET_CONFIRM_HEIGHT = 2 * RESET_CONFIRM_BTN_HEIGHT + RECURSIVE_CHECKBOX_HEIGHT + 20;


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

public void createChannelPanel(GPanel channelPanel, GToggleGroup channelToggle, ChannelOption R, ChannelOption G, ChannelOption B, boolean src) {
  // Configure options
  R.addEventHandler(this, "channelOption_clicked");
  G.addEventHandler(this, "channelOption_clicked");
  B.addEventHandler(this, "channelOption_clicked");
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
  srcR = new ChannelOption(controlsWindow, 0, R_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT, 0, true);
  srcG = new ChannelOption(controlsWindow, 0, G_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT, 1, true);
  srcB = new ChannelOption(controlsWindow, 0, B_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT, 2, true);
  // Configure options
  createChannelPanel(srcChannelPanel, srcChannelToggle, srcR, srcG, srcB, true);
}

public void createTargChannelPanel() {
  // Initialize panel
  targChannelPanel = new GPanel(controlsWindow, TARG_CHANNEL_X, TARG_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_PANEL_HEIGHT, "Target Channel");
  setupGeneralPanel(targChannelPanel);
  // Initialize toggles 
  targChannelToggle = new GToggleGroup();
  targR = new ChannelOption(controlsWindow, 0, R_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT, 0, false);
  targG = new ChannelOption(controlsWindow, 0, G_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT, 1, false);
  targB = new ChannelOption(controlsWindow, 0, B_CHANNEL_Y, CHANNEL_TOGGLE_WIDTH, CHANNEL_TOGGLE_HEIGHT, 2, false);
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
    GTextField sliderInput, String sliderInputEventHandler,
    GToggleGroup sliderToggle, 
    GOption sliderPercent, String percentEventHandler, 
    GOption sliderPixels, String pixelsEventHandler
    ) {
  setupGeneralPanel(shiftPanel, colorScheme);
  // Slider
  slider.setShowValue(true);
  slider.setShowLimits(true);
  slider.setLimits(0, 0, 100);
  slider.setShowTicks(true);
  slider.setNumberFormat(G4P.INTEGER, 0);
  slider.setLocalColorScheme(colorScheme);
  slider.setOpaque(true);
  slider.addEventHandler(this, sliderEventHandler);
  shiftPanel.addControl(slider);
  // Text Input
  sliderInput.setLocalColorScheme(colorScheme);
  sliderInput.setOpaque(true);
  sliderInput.setText("0");
  sliderInput.addEventHandler(this, sliderInputEventHandler);
  shiftPanel.addControl(sliderInput);
  // Percent/Pixel toggles
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

public void createXShiftPanel() {
  xShiftPanel = new GPanel(controlsWindow, X_SLIDER_PANEL_X, X_SLIDER_PANEL_Y, SLIDER_PANEL_WIDTH, SLIDER_PANEL_HEIGHT, "Horizontal Shift");
  xSlider = new GSlider(controlsWindow, SLIDER_X, SLIDER_Y, SLIDER_WIDTH, SLIDER_HEIGHT, SLIDER_TRACK_WIDTH);
  xSliderInput = new GTextField(controlsWindow, SLIDER_INPUT_X, SLIDER_INPUT_Y, SLIDER_INPUT_WIDTH, SLIDER_INPUT_HEIGHT);
  xSliderToggle = new GToggleGroup();
  xSliderPercent = new GOption(controlsWindow, SLIDER_TOGGLE_X, SLIDER_PERCENT_TOGGLE_Y, SLIDER_TOGGLE_WIDTH, SLIDER_TOGGLE_HEIGHT);
  xSliderPixels = new GOption(controlsWindow, SLIDER_TOGGLE_X, SLIDER_PIXELS_TOGGLE_Y, SLIDER_TOGGLE_WIDTH, SLIDER_TOGGLE_HEIGHT);
  createChannelShiftPanel(xShiftPanel, GCScheme.RED_SCHEME, xSlider, "xSlider_change", xSliderInput, "xSliderInput_change", xSliderToggle, xSliderPercent, "xSliderPercent_clicked", xSliderPixels, "xSliderPixels_clicked");
}

public void createYShiftPanel() {
  yShiftPanel = new GPanel(controlsWindow, Y_SLIDER_PANEL_X, Y_SLIDER_PANEL_Y, SLIDER_PANEL_WIDTH, SLIDER_PANEL_HEIGHT, "Vertical Shift");
  ySlider = new GSlider(controlsWindow, SLIDER_X, SLIDER_Y, SLIDER_WIDTH, SLIDER_HEIGHT, SLIDER_TRACK_WIDTH);
  ySliderInput = new GTextField(controlsWindow, SLIDER_INPUT_X, SLIDER_INPUT_Y, SLIDER_INPUT_WIDTH, SLIDER_INPUT_HEIGHT);
  ySliderToggle = new GToggleGroup();
  ySliderPercent = new GOption(controlsWindow, SLIDER_TOGGLE_X, SLIDER_PERCENT_TOGGLE_Y, SLIDER_TOGGLE_WIDTH, SLIDER_TOGGLE_HEIGHT);
  ySliderPixels = new GOption(controlsWindow, SLIDER_TOGGLE_X, SLIDER_PIXELS_TOGGLE_Y, SLIDER_TOGGLE_WIDTH, SLIDER_TOGGLE_HEIGHT);
  createChannelShiftPanel(yShiftPanel, GCScheme.GREEN_SCHEME, ySlider, "ySlider_change", ySliderInput, "ySliderInput_change", ySliderToggle, ySliderPercent, "ySliderPercent_clicked", ySliderPixels, "ySliderPixels_clicked");
}

// Randomize/Reset Button Panel ------------------------------------------------

public void createRandomizePanel() {
  randomizePanel = new GPanel(controlsWindow, RAND_PANEL_X, RAND_PANEL_Y, RAND_PANEL_WIDTH, RAND_PANEL_HEIGHT, "Randomize Options");
  setupGeneralPanel(randomizePanel, GCScheme.CYAN_SCHEME);
  // Randomize Button
  randomizeBtn = new GButton(controlsWindow, RAND_BTN_X, RAND_BTN_Y, RAND_BTN_WIDTH, RAND_BTN_HEIGHT);
  randomizeBtn.setText("Randomize");
  randomizeBtn.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  randomizeBtn.addEventHandler(this, "randomizeBtn_click");
  randomizePanel.addControl(randomizeBtn);
  // Randomize Checkboxes
  randomizeCheckboxPanel = new GPanel(controlsWindow, RAND_CHECKBOX_PANEL_X, RAND_CHECKBOX_PANEL_Y, RAND_CHECKBOX_PANEL_WIDTH, RAND_CHECKBOX_PANEL_HEIGHT);
  setupGeneralPanel(randomizeCheckboxPanel);
  randomizeCheckboxPanel.setOpaque(false);
  // Source and Target
  randSrcCheckbox = new GCheckbox(controlsWindow, RAND_CHECKBOX_LEFT_X, RAND_CHECKBOX_TOP_Y, RAND_CHECKBOX_WIDTH, RAND_CHECKBOX_HEIGHT, "Source Channel");
  randSrcCheckbox.setSelected(true);
  randSrcCheckbox.addEventHandler(this, "randSrcCheckbox_click");
  randomizeCheckboxPanel.addControl(randSrcCheckbox);
  randTargCheckbox = new GCheckbox(controlsWindow, RAND_CHECKBOX_RIGHT_X, RAND_CHECKBOX_TOP_Y, RAND_CHECKBOX_WIDTH, RAND_CHECKBOX_HEIGHT, "Target Channel");
  randTargCheckbox.setSelected(true);
  randTargCheckbox.addEventHandler(this, "randTargCheckbox_click");
  randomizeCheckboxPanel.addControl(randTargCheckbox);
  // X and Y Shift
  randXShiftCheckbox = new GCheckbox(controlsWindow, RAND_CHECKBOX_LEFT_X, RAND_CHECKBOX_BOTTOM_Y, RAND_CHECKBOX_WIDTH, RAND_CHECKBOX_HEIGHT, "Horizontal Shift");
  randXShiftCheckbox.setSelected(true);
  randXShiftCheckbox.addEventHandler(this, "randXShiftCheckbox_click");
  randomizeCheckboxPanel.addControl(randXShiftCheckbox);
  randYShiftCheckbox = new GCheckbox(controlsWindow, RAND_CHECKBOX_RIGHT_X, RAND_CHECKBOX_BOTTOM_Y, RAND_CHECKBOX_WIDTH, RAND_CHECKBOX_HEIGHT, "Vertical Shift");
  randYShiftCheckbox.setSelected(true);
  randYShiftCheckbox.addEventHandler(this, "randYShiftCheckbox_click");
  randomizeCheckboxPanel.addControl(randYShiftCheckbox);
  randomizePanel.addControl(randomizeCheckboxPanel);
  // Max Shift Inputs and Labels
  randXMaxLabel = new GLabel(controlsWindow, RAND_MAX_LEFT_X, RAND_MAX_LABEL_Y, RAND_MAX_LABEL_WIDTH, RAND_MAX_LABEL_HEIGHT, "Max Horizontal Shift %");
  randXMaxLabel.setTextBold();
  randomizePanel.addControl(randXMaxLabel);
  randXMaxInput = new GTextField(controlsWindow, RAND_MAX_LEFT_X, RAND_MAX_INPUT_Y, RAND_MAX_INPUT_WIDTH, RAND_MAX_INPUT_HEIGHT);
  randXMaxInput.setText("100");
  // TODO: randXMaxInput.addEventHandler(this, "randXMaxInput_change");
  randomizePanel.addControl(randXMaxInput);
  // TODO: Y shift; Extract common for both inputs
  randYMaxLabel = new GLabel(controlsWindow, RAND_MAX_RIGHT_X, RAND_MAX_LABEL_Y, RAND_MAX_LABEL_WIDTH, RAND_MAX_LABEL_HEIGHT, "Max Vertical Shift %");
  randYMaxLabel.setTextBold();
  randomizePanel.addControl(randYMaxLabel);
  randYMaxInput = new GTextField(controlsWindow, RAND_MAX_RIGHT_X, RAND_MAX_INPUT_Y, RAND_MAX_INPUT_WIDTH, RAND_MAX_INPUT_HEIGHT);
  randYMaxInput.setText("100");
  // TODO: randYMaxInput.addEventHandler(this, "randYMaxInput_change");
  randomizePanel.addControl(randYMaxInput);
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
  resetConfirmPanel = new GPanel(controlsWindow, RESET_CONFIRM_X, RESET_CONFIRM_Y, RESET_CONFIRM_WIDTH, RESET_CONFIRM_HEIGHT);
  setupGeneralPanel(resetConfirmPanel);
  resetConfirmPanel.setOpaque(false);
  // Reset Button
  resetBtn = new GButton(controlsWindow, 0, 0, RESET_CONFIRM_WIDTH, RESET_CONFIRM_BTN_HEIGHT);
  resetBtn.setText("Reset");
  resetBtn.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  resetBtn.addEventHandler(this, "resetBtn_click");
  resetConfirmPanel.addControl(resetBtn);
  // Confirm Button 
  // TODO: disable when SRC == TARG && sliders are 0
  confirmBtn = new GButton(controlsWindow, 0, RESET_CONFIRM_BTN_HEIGHT + 10, RESET_CONFIRM_WIDTH, RESET_CONFIRM_BTN_HEIGHT);
  confirmBtn.setText("Confirm Step");
  confirmBtn.addEventHandler(this, "confirmBtn_click");
  resetConfirmPanel.addControl(confirmBtn);
  // Recursive checkbox
  recursiveCheckbox = new GCheckbox(controlsWindow, 0, 2*RESET_CONFIRM_BTN_HEIGHT + 10, RESET_CONFIRM_WIDTH, RECURSIVE_CHECKBOX_HEIGHT);
  recursiveCheckbox.setSelected(true);
  recursiveCheckbox.setText("Recursive", GAlign.CENTER, GAlign.MIDDLE);
  recursiveCheckbox.setOpaque(true);
  recursiveCheckbox.addEventHandler(this, "recursiveCheckbox_click");
  resetConfirmPanel.addControl(recursiveCheckbox);
}

