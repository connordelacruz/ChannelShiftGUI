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
// Randomize Button/Toggles ----------------------------------------------------
GPanel randomizePanel, randomizeCheckboxPanel;
GButton randomizeBtn; 
GCheckbox randSrcCheckbox, randTargCheckbox, 
          randXShiftCheckbox, randYShiftCheckbox;
GTextField randXMaxInput, randYMaxInput;
GLabel randXMaxLabel, randYMaxLabel;
// Shift Type ------------------------------------------------------------------
// Type Select
GPanel shiftTypePanel;
GDropList shiftTypeSelect;
GLabel shiftTypeLabel;
// Per-Type configs
GPanel defaultShiftTypePanel, multiplyShiftTypePanel;
// Default (just a label)
GLabel defaultShiftConfigLabel;
// Multiply
GLabel xMultiplierLabel, yMultiplierLabel;
GTextField xMultiplierInput, yMultiplierInput;
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
// Start positioning at 10px to add some padding
int X_START = 10;
int Y_START = 10; 
// Margins ---------------------------------------------------------------------
// Single margin
int X_MARGIN = X_START;
int Y_MARGIN = Y_START;
// Subtract from widths to get margins on either side
int X_MARGINS = 2 * X_MARGIN;
// Panels ----------------------------------------------------------------------
// Panel labels are ~20, add this so children don't overlap
int PANEL_Y_START = 20;
// Window ----------------------------------------------------------------------
int WINDOW_X = 10;
int WINDOW_Y = 10;
int WINDOW_HEIGHT = 475;
// The main sketch section
int WINDOW_MAIN_WIDTH = 650;
// Advanced options sidebar
int WINDOW_ADV_WIDTH = 200;
// Total width
int WINDOW_WIDTH = WINDOW_MAIN_WIDTH + WINDOW_ADV_WIDTH;
// Toggles ---------------------------------------------------------------------
// General
int CHANNEL_TOGGLE_WIDTH = 150;
int CHANNEL_TOGGLE_HEIGHT = 25;
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
// End of target channel panel + margins
int RAND_PANEL_X = TARG_CHANNEL_X + CHANNEL_TOGGLE_WIDTH + X_MARGINS;
int RAND_PANEL_Y = Y_START;
// Fill rest of window (minus right margin)
int RAND_PANEL_WIDTH = WINDOW_MAIN_WIDTH - RAND_PANEL_X - X_MARGIN;
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
// Labels are full width for text alignment
int RAND_MAX_LABEL_WIDTH = RAND_CHECKBOX_WIDTH;
int RAND_MAX_LABEL_HEIGHT = 20;
// Inputs have margins (so they don't overlap)
int RAND_MAX_INPUT_WIDTH = RAND_CHECKBOX_WIDTH - X_MARGINS;
int RAND_MAX_INPUT_HEIGHT = 20;
int RAND_MAX_TOTAL_HEIGHT = RAND_MAX_LABEL_HEIGHT + RAND_MAX_INPUT_HEIGHT + Y_MARGIN;
int RAND_MAX_LABEL_Y = RAND_CHECKBOX_PANEL_Y + RAND_CHECKBOX_PANEL_HEIGHT;
int RAND_MAX_INPUT_Y = RAND_MAX_LABEL_Y + RAND_MAX_LABEL_HEIGHT;
// Add margins to input but not label
int RAND_MAX_LABEL_LEFT_X = 0;
int RAND_MAX_INPUT_LEFT_X = X_MARGIN;
int RAND_MAX_LABEL_RIGHT_X = RAND_MAX_LABEL_WIDTH;
int RAND_MAX_INPUT_RIGHT_X = RAND_MAX_INPUT_LEFT_X + RAND_MAX_INPUT_WIDTH + X_MARGINS;
// Randomize Button
int RAND_BTN_WIDTH = RAND_PANEL_WIDTH;
int RAND_BTN_HEIGHT = 30;
int RAND_BTN_X = 0;
int RAND_BTN_Y = RAND_MAX_LABEL_Y + RAND_MAX_TOTAL_HEIGHT;
int RAND_PANEL_HEIGHT = RAND_CHECKBOX_PANEL_HEIGHT + RAND_MAX_TOTAL_HEIGHT + RAND_BTN_HEIGHT + PANEL_Y_START;
// Shift Type Select -----------------------------------------------------------
// TODO RENAME SECTION TO ADVANCED WHERE APPLICABLE
// Panel
int TYPE_PANEL_X = WINDOW_MAIN_WIDTH + X_MARGIN;
int TYPE_PANEL_Y = Y_START;
int TYPE_PANEL_WIDTH = WINDOW_ADV_WIDTH - X_MARGINS;
int TYPE_PANEL_HEIGHT = WINDOW_HEIGHT - (2 * Y_MARGIN);
// Label
int TYPE_LABEL_X = X_MARGIN;
int TYPE_LABEL_Y = PANEL_Y_START;
int TYPE_LABEL_WIDTH = TYPE_PANEL_WIDTH - X_MARGINS;
int TYPE_LABEL_HEIGHT = 20;
// Dropdown
int TYPE_SELECT_X = X_MARGIN;
int TYPE_SELECT_Y = TYPE_LABEL_Y + TYPE_LABEL_HEIGHT;
int TYPE_SELECT_WIDTH = TYPE_PANEL_WIDTH - X_MARGINS;
int TYPE_SELECT_HEIGHT = 100; // TODO tweak these to get the height right
int TYPE_SELECT_MAX_ITEMS = 4;
int TYPE_SELECT_BTN_WIDTH = TYPE_SELECT_WIDTH / 4;
// Common shift type configs
int TYPE_CONFIG_PANEL_X = 0;
int TYPE_CONFIG_PANEL_Y = TYPE_SELECT_Y + TYPE_SELECT_HEIGHT + Y_MARGIN;
int TYPE_CONFIG_PANEL_WIDTH = TYPE_PANEL_WIDTH;
int TYPE_CONFIG_PANEL_HEIGHT = TYPE_PANEL_HEIGHT - TYPE_CONFIG_PANEL_Y - Y_MARGIN;
// Default Shift Type Panel ----------------------------------------------------
int DEFAULT_CONFIG_LABEL_X = X_MARGIN;
int DEFAULT_CONFIG_LABEL_Y = PANEL_Y_START;
int DEFAULT_CONFIG_LABEL_WIDTH = TYPE_CONFIG_PANEL_WIDTH - X_MARGINS;
int DEFAULT_CONFIG_LABEL_HEIGHT = TYPE_CONFIG_PANEL_HEIGHT - PANEL_Y_START;
// Sliders ---------------------------------------------------------------------
// General
int SLIDER_TOGGLE_WIDTH = 75;
int SLIDER_INPUT_WIDTH = 75;
int SLIDER_INPUT_HEIGHT = 20;
float SLIDER_TRACK_WIDTH = 12.0;
int SLIDER_HEIGHT = 60;
int SLIDER_PANEL_WIDTH = WINDOW_MAIN_WIDTH - X_MARGINS;
int SLIDER_PANEL_HEIGHT = SLIDER_HEIGHT + PANEL_Y_START;
int SLIDER_WIDTH = SLIDER_PANEL_WIDTH - (SLIDER_INPUT_WIDTH + SLIDER_TOGGLE_WIDTH);
int SLIDER_TOGGLE_HEIGHT = SLIDER_HEIGHT / 2;
int SLIDER_INPUT_X = 0;
int SLIDER_INPUT_Y = PANEL_Y_START + (SLIDER_HEIGHT - SLIDER_INPUT_HEIGHT) / 2;
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
int LOAD_SAVE_PANEL_X = X_START;
int LOAD_SAVE_PANEL_Y = Y_SLIDER_PANEL_Y + SLIDER_PANEL_HEIGHT + Y_MARGIN;
int LOAD_SAVE_PANEL_WIDTH = WINDOW_MAIN_WIDTH / 2 - X_MARGINS;
int LOAD_SAVE_BTN_HEIGHT = 30;
int LOAD_SAVE_PANEL_HEIGHT = 2 * (LOAD_SAVE_BTN_HEIGHT + Y_MARGIN);
int LOAD_BTN_X = 0;
int LOAD_BTN_Y = 0;
int SAVE_BTN_X = 0;
int SAVE_BTN_Y = LOAD_BTN_Y + LOAD_SAVE_BTN_HEIGHT + Y_MARGIN;
// Reset/Confirm Buttons -------------------------------------------------------
int RESET_CONFIRM_PANEL_X = LOAD_SAVE_PANEL_X + LOAD_SAVE_PANEL_WIDTH + X_MARGINS;
int RESET_CONFIRM_PANEL_Y = LOAD_SAVE_PANEL_Y;
int RESET_CONFIRM_PANEL_WIDTH = LOAD_SAVE_PANEL_WIDTH;
int RESET_CONFIRM_BTN_HEIGHT = LOAD_SAVE_BTN_HEIGHT;
int RECURSIVE_CHECKBOX_HEIGHT = 30;
int RESET_CONFIRM_PANEL_HEIGHT = 2 * (RESET_CONFIRM_BTN_HEIGHT + Y_MARGIN) + RECURSIVE_CHECKBOX_HEIGHT;
int RESET_BTN_X = 0;
int RESET_BTN_Y = 0;
int CONFIRM_BTN_X = 0;
int CONFIRM_BTN_Y = RESET_BTN_Y + RESET_CONFIRM_BTN_HEIGHT + Y_MARGIN;
int RECURSIVE_CHECKBOX_X = 0;
int RECURSIVE_CHECKBOX_Y = CONFIRM_BTN_Y + RESET_CONFIRM_BTN_HEIGHT;


// Initialization ==============================================================

public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  // Controls window 
  controlsWindow = GWindow.getWindow(this, "Channel Shift", WINDOW_X, WINDOW_Y, WINDOW_WIDTH, WINDOW_HEIGHT, JAVA2D);
  controlsWindow.noLoop();
  controlsWindow.setActionOnClose(G4P.KEEP_OPEN);
  controlsWindow.addDrawHandler(this, "controlsWindow_draw");
  controlsWindow.addMouseHandler(this, "controlsWindow_mouse");
  // Source channel toggle 
  createSrcChannelPanel();
  // Target channel toggle 
  createTargChannelPanel();
  // Randomize  options
  createRandomizePanel();
  // Shift type
  createShiftTypePanel();
  // Horizontal shift slider 
  createXShiftPanel();
  // Vertical shift slider 
  createYShiftPanel();
  // Load/save buttons 
  createLoadSavePanel();
  // Preview/Confirm buttons
  createResetConfirmPanel();

  controlsWindow.loop();
}


// Helpers =====================================================================

// General Configs -------------------------------------------------------------
// TODO extended class that uses these defaults?

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

// Common label formatting
public void setupGeneralLabel(GLabel label) {
  label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label.setTextBold();
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

// TODO: extract common?
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
  randXMaxLabel = new GLabel(controlsWindow, RAND_MAX_LABEL_LEFT_X, RAND_MAX_LABEL_Y, RAND_MAX_LABEL_WIDTH, RAND_MAX_LABEL_HEIGHT, "Max Horizontal Shift %");
  setupGeneralLabel(randXMaxLabel);
  randomizePanel.addControl(randXMaxLabel);
  randXMaxInput = new GTextField(controlsWindow, RAND_MAX_INPUT_LEFT_X, RAND_MAX_INPUT_Y, RAND_MAX_INPUT_WIDTH, RAND_MAX_INPUT_HEIGHT);
  randXMaxInput.setText("100");
  randXMaxInput.addEventHandler(this, "randXMaxInput_change");
  randomizePanel.addControl(randXMaxInput);
  // TODO: Extract common for both inputs
  randYMaxLabel = new GLabel(controlsWindow, RAND_MAX_LABEL_RIGHT_X, RAND_MAX_LABEL_Y, RAND_MAX_LABEL_WIDTH, RAND_MAX_LABEL_HEIGHT, "Max Vertical Shift %");
  setupGeneralLabel(randYMaxLabel);
  randomizePanel.addControl(randYMaxLabel);
  randYMaxInput = new GTextField(controlsWindow, RAND_MAX_INPUT_RIGHT_X, RAND_MAX_INPUT_Y, RAND_MAX_INPUT_WIDTH, RAND_MAX_INPUT_HEIGHT);
  randYMaxInput.setText("100");
  randYMaxInput.addEventHandler(this, "randYMaxInput_change");
  randomizePanel.addControl(randYMaxInput);
}

// Shift Type Panel ------------------------------------------------------------
// TODO move down, rename advanced panel

// Advanced options panel
public void createShiftTypePanel() {
  shiftTypePanel = new GPanel(controlsWindow, TYPE_PANEL_X, TYPE_PANEL_Y, TYPE_PANEL_WIDTH, TYPE_PANEL_HEIGHT, "Advanced Options");
  setupGeneralPanel(shiftTypePanel, GCScheme.PURPLE_SCHEME);
  // Shift Type Dropdown
  shiftTypeLabel = new GLabel(controlsWindow, TYPE_LABEL_X, TYPE_LABEL_Y, TYPE_LABEL_WIDTH, TYPE_LABEL_HEIGHT, "Shift Type:");
  setupGeneralLabel(shiftTypeLabel);
  shiftTypePanel.addControl(shiftTypeLabel);
  shiftTypeSelect = new GDropList(controlsWindow, TYPE_SELECT_X, TYPE_SELECT_Y, TYPE_SELECT_WIDTH, TYPE_SELECT_HEIGHT, TYPE_SELECT_MAX_ITEMS, TYPE_SELECT_BTN_WIDTH);
  // TODO UPDATE; this global will be moved
  shiftTypeSelect.setItems(SHIFT_TYPES, 0);
  shiftTypeSelect.addEventHandler(this, "shiftTypeSelect_change");
  shiftTypePanel.addControl(shiftTypeSelect);
  // TODO Add type config panels
  createDefaultShiftTypePanel();
}

// Type config panels (called above)

public void setupShiftTypePanel(GPanel panel, String typeName) {
  setupGeneralPanel(panel);
  panel.setText(typeName + " Shift Settings");
}

public void createDefaultShiftTypePanel() {
  defaultShiftTypePanel = new GPanel(controlsWindow, TYPE_CONFIG_PANEL_X, TYPE_CONFIG_PANEL_Y, TYPE_CONFIG_PANEL_WIDTH, TYPE_CONFIG_PANEL_HEIGHT);
  // TODO: store name in constant
  setupShiftTypePanel(defaultShiftTypePanel, "Default");
  // Default has no configs, add a label explaining this
  defaultShiftConfigLabel = new GLabel(controlsWindow, DEFAULT_CONFIG_LABEL_X, DEFAULT_CONFIG_LABEL_Y, DEFAULT_CONFIG_LABEL_WIDTH, DEFAULT_CONFIG_LABEL_HEIGHT);
  defaultShiftConfigLabel.setText("No advanced options for default shift type");
  defaultShiftConfigLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  defaultShiftConfigLabel.setTextItalic();
  defaultShiftTypePanel.addControl(defaultShiftConfigLabel);
  // Add to advanced options
  shiftTypePanel.addControl(defaultShiftTypePanel);
}

// TODO createMultiplyShiftTypePanel()

// Load/Save Panel -------------------------------------------------------------

public void createLoadSavePanel() {
  loadSavePanel = new GPanel(controlsWindow, LOAD_SAVE_PANEL_X, LOAD_SAVE_PANEL_Y, LOAD_SAVE_PANEL_WIDTH, LOAD_SAVE_PANEL_HEIGHT);
  setupGeneralPanel(loadSavePanel);
  loadSavePanel.setOpaque(false);
  // Load button
  loadBtn = new GButton(controlsWindow, LOAD_BTN_X, LOAD_BTN_Y, LOAD_SAVE_PANEL_WIDTH, LOAD_SAVE_BTN_HEIGHT);
  loadBtn.setText("Load Image");
  loadBtn.setTextBold();
  loadBtn.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  loadBtn.addEventHandler(this, "loadBtn_click");
  loadSavePanel.addControl(loadBtn);
  // Save button 
  saveBtn = new GButton(controlsWindow, SAVE_BTN_X, SAVE_BTN_Y, LOAD_SAVE_PANEL_WIDTH, LOAD_SAVE_BTN_HEIGHT);
  saveBtn.setText("Save Result");
  saveBtn.setTextBold();
  saveBtn.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  saveBtn.addEventHandler(this, "saveBtn_click");
  loadSavePanel.addControl(saveBtn);
}

// Preview/Confirm Panel -------------------------------------------------------

public void createResetConfirmPanel() {
  resetConfirmPanel = new GPanel(controlsWindow, RESET_CONFIRM_PANEL_X, RESET_CONFIRM_PANEL_Y, RESET_CONFIRM_PANEL_WIDTH, RESET_CONFIRM_PANEL_HEIGHT);
  setupGeneralPanel(resetConfirmPanel);
  resetConfirmPanel.setOpaque(false);
  // Reset Button
  resetBtn = new GButton(controlsWindow, RESET_BTN_X, RESET_BTN_Y, RESET_CONFIRM_PANEL_WIDTH, RESET_CONFIRM_BTN_HEIGHT);
  resetBtn.setText("Reset Step");
  resetBtn.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  resetBtn.addEventHandler(this, "resetBtn_click");
  resetConfirmPanel.addControl(resetBtn);
  // Confirm Button 
  // TODO: disable when SRC == TARG && sliders are 0
  confirmBtn = new GButton(controlsWindow, CONFIRM_BTN_X, CONFIRM_BTN_Y, RESET_CONFIRM_PANEL_WIDTH, RESET_CONFIRM_BTN_HEIGHT);
  confirmBtn.setText("Confirm Step");
  confirmBtn.addEventHandler(this, "confirmBtn_click");
  resetConfirmPanel.addControl(confirmBtn);
  // Recursive checkbox
  recursiveCheckbox = new GCheckbox(controlsWindow, RECURSIVE_CHECKBOX_X, RECURSIVE_CHECKBOX_Y, RESET_CONFIRM_PANEL_WIDTH, RECURSIVE_CHECKBOX_HEIGHT);
  recursiveCheckbox.setSelected(true);
  recursiveCheckbox.setText("Recursive", GAlign.CENTER, GAlign.MIDDLE);
  recursiveCheckbox.setOpaque(true);
  recursiveCheckbox.addEventHandler(this, "recursiveCheckbox_click");
  resetConfirmPanel.addControl(recursiveCheckbox);
}

