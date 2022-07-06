// =============================================================================
// GUI Globals + G4P Variable Declarations
// =============================================================================

// =============================================================================
// Common
// =============================================================================

// GLOBALS =====================================================================

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

// FUNCTIONS ===================================================================

// Setup Helper Methods --------------------------------------------------------

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

// General Utilities -----------------------------------------------------------

// Show/hide a panel (w/ collapse)
public void togglePanelVisibility(GPanel panel, boolean show) {
  panel.setCollapsed(!show);
  panel.setVisible(show);
}


// =============================================================================
// Window
// =============================================================================

// GLOBALS =====================================================================

// Positioning and Dimensions --------------------------------------------------
// x/y to be set when creating window
int WINDOW_X = 0;
int WINDOW_Y = 0;
int WINDOW_HEIGHT = 475;
// The main sketch section
int WINDOW_MAIN_WIDTH = 650;
// Advanced options sidebar
int WINDOW_ADV_WIDTH = 200;
// Total width
int WINDOW_WIDTH = WINDOW_MAIN_WIDTH + WINDOW_ADV_WIDTH;
// G4P -------------------------------------------------------------------------
GWindow controlsWindow;

// FUNCTIONS ===================================================================

// Event Handlers --------------------------------------------------------------

synchronized public void controlsWindow_draw(PApplet appc, GWinData data) { 
  appc.background(230);
} 


// =============================================================================
// Channel Toggle Panels
// =============================================================================

// GLOBALS =====================================================================

// General ---------------------------------------------------------------------
int CHANNEL_TOGGLE_WIDTH = 150;
int CHANNEL_TOGGLE_HEIGHT = 25;
int CHANNEL_PANEL_HEIGHT = 3 * CHANNEL_TOGGLE_HEIGHT + PANEL_Y_START;
int R_CHANNEL_Y = PANEL_Y_START;
int G_CHANNEL_Y = PANEL_Y_START + CHANNEL_TOGGLE_HEIGHT;
int B_CHANNEL_Y = PANEL_Y_START + 2 * CHANNEL_TOGGLE_HEIGHT;
// Source ----------------------------------------------------------------------
int SRC_CHANNEL_X = X_START;
int SRC_CHANNEL_Y = Y_START;
// G4P
GPanel srcChannelPanel;
GToggleGroup srcChannelToggle; 
ChannelOption srcR, srcG, srcB; 
// Keep track of toggles in global w/ index corresponding to channel
ChannelOption[] srcToggles;
// Target ----------------------------------------------------------------------
int TARG_CHANNEL_X = SRC_CHANNEL_X + CHANNEL_TOGGLE_WIDTH + X_MARGINS;
int TARG_CHANNEL_Y = Y_START;
// G4P
GPanel targChannelPanel;
GToggleGroup targChannelToggle; 
ChannelOption targR, targG, targB; 
// Keep track of toggles in global w/ index corresponding to channel
ChannelOption[] targToggles;

// FUNCTIONS ===================================================================

// Parent panel setup
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

// Source channel panel
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
  // Initialize global
  srcToggles = new ChannelOption[]{ srcR, srcG, srcB };
}

// Target channel panel
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
  // Initialize global
  targToggles = new ChannelOption[]{ targR, targG, targB };
}


// =============================================================================
// Randomize Panel
// =============================================================================

// GLOBALS =====================================================================

// Panel -----------------------------------------------------------------------
// End of target channel panel + margins
int RAND_PANEL_X = TARG_CHANNEL_X + CHANNEL_TOGGLE_WIDTH + X_MARGINS;
int RAND_PANEL_Y = Y_START;
// Fill rest of window (minus right margin)
int RAND_PANEL_WIDTH = WINDOW_MAIN_WIDTH - RAND_PANEL_X - X_MARGIN;
// G4P
GPanel randomizePanel;
// Randomize Checkboxes + Panel ------------------------------------------------
int RAND_CHECKBOX_PANEL_X = X_MARGIN; 
int RAND_CHECKBOX_PANEL_Y = PANEL_Y_START;
int RAND_CHECKBOX_PANEL_WIDTH = RAND_PANEL_WIDTH - X_MARGINS;
// Half of panel width, 2 checkboxes per row
int RAND_CHECKBOX_WIDTH = (RAND_CHECKBOX_PANEL_WIDTH / 2) - X_MARGINS;
int RAND_CHECKBOX_HEIGHT = 30;
// Checkbox positioning
int RAND_CHECKBOX_LEFT_X = 0;
int RAND_CHECKBOX_RIGHT_X = RAND_CHECKBOX_LEFT_X + RAND_CHECKBOX_WIDTH + X_MARGINS;
int RAND_CHECKBOX_TOP_Y = 0;
int RAND_CHECKBOX_BOTTOM_Y = RAND_CHECKBOX_HEIGHT;
int RAND_CHECKBOX_PANEL_HEIGHT = 2 * RAND_CHECKBOX_HEIGHT; 
// G4P
GPanel randomizeCheckboxPanel;
GCheckbox randSrcCheckbox, randTargCheckbox, 
          randXShiftCheckbox, randYShiftCheckbox;
// Max Shift Inputs ------------------------------------------------------------
// Labels are full width for text alignment
int RAND_MAX_LABEL_WIDTH = RAND_PANEL_WIDTH / 2;
int RAND_MAX_LABEL_HEIGHT = 20;
// Inputs have margins (so they don't overlap)
int RAND_MAX_INPUT_WIDTH = RAND_MAX_LABEL_WIDTH - X_MARGINS;
int RAND_MAX_INPUT_HEIGHT = 20;
int RAND_MAX_TOTAL_HEIGHT = RAND_MAX_LABEL_HEIGHT + RAND_MAX_INPUT_HEIGHT + Y_MARGIN;
int RAND_MAX_LABEL_Y = RAND_CHECKBOX_PANEL_Y + RAND_CHECKBOX_PANEL_HEIGHT;
int RAND_MAX_INPUT_Y = RAND_MAX_LABEL_Y + RAND_MAX_LABEL_HEIGHT;
// Add margins to input but not label
int RAND_MAX_LABEL_LEFT_X = 0;
int RAND_MAX_INPUT_LEFT_X = X_MARGIN;
int RAND_MAX_LABEL_RIGHT_X = RAND_MAX_LABEL_WIDTH;
int RAND_MAX_INPUT_RIGHT_X = RAND_MAX_INPUT_LEFT_X + RAND_MAX_INPUT_WIDTH + X_MARGINS;
// G4P
GTextField randXMaxInput, randYMaxInput;
GLabel randXMaxLabel, randYMaxLabel;
GTabManager randMaxTabManager;
// Randomize Button ------------------------------------------------------------
int RAND_BTN_WIDTH = RAND_PANEL_WIDTH;
int RAND_BTN_HEIGHT = 30;
int RAND_BTN_X = 0;
int RAND_BTN_Y = RAND_MAX_LABEL_Y + RAND_MAX_TOTAL_HEIGHT;
int RAND_PANEL_HEIGHT = RAND_CHECKBOX_PANEL_HEIGHT + RAND_MAX_TOTAL_HEIGHT + RAND_BTN_HEIGHT + PANEL_Y_START;
// G4P
GButton randomizeBtn;

// FUNCTIONS ===================================================================

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

  // Tab manager for text inputs
  randMaxTabManager = new GTabManager();
  randMaxTabManager.addControls(randXMaxInput, randYMaxInput);
}


// =============================================================================
// Shift Type Select
// =============================================================================

// GLOBALS =====================================================================

// Panel -----------------------------------------------------------------------
int ADV_OPTS_PANEL_X = WINDOW_MAIN_WIDTH + X_MARGIN;
int ADV_OPTS_PANEL_Y = Y_START;
int ADV_OPTS_PANEL_WIDTH = WINDOW_ADV_WIDTH - X_MARGINS;
int ADV_OPTS_PANEL_HEIGHT = WINDOW_HEIGHT - (2 * Y_MARGIN);
// G4P
GPanel advancedOptionsPanel;
// Label -----------------------------------------------------------------------
int TYPE_LABEL_X = X_MARGIN;
int TYPE_LABEL_Y = PANEL_Y_START;
int TYPE_LABEL_WIDTH = ADV_OPTS_PANEL_WIDTH - X_MARGINS;
int TYPE_LABEL_HEIGHT = 20;
// G4P
GLabel shiftTypeLabel;
// Dropdown --------------------------------------------------------------------
int TYPE_SELECT_X = X_MARGIN;
int TYPE_SELECT_Y = TYPE_LABEL_Y + TYPE_LABEL_HEIGHT;
int TYPE_SELECT_WIDTH = ADV_OPTS_PANEL_WIDTH - X_MARGINS;
int TYPE_SELECT_HEIGHT = 100; 
int TYPE_SELECT_MAX_ITEMS = 4;
int TYPE_SELECT_BTN_WIDTH = TYPE_SELECT_WIDTH / 4;
// G4P
GDropList shiftTypeSelect;

// FUNCTIONS ===================================================================

// -----------------------------------------------------------------------------
// Functions are declared after the various advanced options configs since it
// uses on the setup functions for each of those.
// -----------------------------------------------------------------------------


// =============================================================================
// Advanced Options Panels
// =============================================================================

// GLOBALS =====================================================================

// Common ----------------------------------------------------------------------
int TYPE_PANEL_X = 0;
int TYPE_PANEL_Y = TYPE_SELECT_Y + TYPE_SELECT_HEIGHT + Y_MARGIN;
int TYPE_PANEL_WIDTH = ADV_OPTS_PANEL_WIDTH;
int TYPE_PANEL_HEIGHT = ADV_OPTS_PANEL_HEIGHT - TYPE_PANEL_Y;


// =============================================================================
// Shift Type Panels
// =============================================================================

// GLOBALS =====================================================================

// G4P -------------------------------------------------------------------------
GPanel defaultShiftTypePanel, scaleShiftTypePanel, linearShiftTypePanel, skewShiftTypePanel, xyMultShiftTypePanel, noiseShiftTypePanel;
// Keep track of shift type config panels w/ indices matching globals
GPanel[] shiftTypeConfigPanels;


// TODO ========================================================================
// TODO: MAKE THE STRUCTURE OF THESE SECTIONS CONSISTENT:
// TODO ========================================================================


// =============================================================================
// Default Shift Type Panel
// =============================================================================

// GLOBALS =====================================================================

// Positioning and Dimensions --------------------------------------------------
int DEFAULT_CONFIG_LABEL_X = X_MARGIN;
int DEFAULT_CONFIG_LABEL_Y = PANEL_Y_START;
int DEFAULT_CONFIG_LABEL_WIDTH = TYPE_PANEL_WIDTH - X_MARGINS;
int DEFAULT_CONFIG_LABEL_HEIGHT = TYPE_PANEL_HEIGHT - PANEL_Y_START;
// G4P -------------------------------------------------------------------------
GLabel defaultShiftConfigLabel;

// FUNCTIONS ===================================================================

// Setup -----------------------------------------------------------------------

public void createDefaultShiftTypePanel() {
  defaultShiftTypePanel = new GPanel(controlsWindow, TYPE_PANEL_X, TYPE_PANEL_Y, TYPE_PANEL_WIDTH, TYPE_PANEL_HEIGHT);
  setupShiftTypePanel(defaultShiftTypePanel, TYPE_DEFAULT);
  // Default has no configs, add a label explaining this
  defaultShiftConfigLabel = new GLabel(controlsWindow, DEFAULT_CONFIG_LABEL_X, DEFAULT_CONFIG_LABEL_Y, DEFAULT_CONFIG_LABEL_WIDTH, DEFAULT_CONFIG_LABEL_HEIGHT);
  defaultShiftConfigLabel.setText("No advanced options for default shift type");
  defaultShiftConfigLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  defaultShiftConfigLabel.setTextItalic();
  defaultShiftTypePanel.addControl(defaultShiftConfigLabel);
  // Default panel should be visible by default
  showShiftTypePanel(defaultShiftTypePanel);
  // Add to advanced options
  advancedOptionsPanel.addControl(defaultShiftTypePanel);
}


// =============================================================================
// Scale Shift Type Panel
// =============================================================================

// GLOBALS =====================================================================

// Positioning and Dimensions --------------------------------------------------
int SCALE_CONFIG_LABEL_WIDTH = TYPE_PANEL_WIDTH - X_MARGINS;
int SCALE_CONFIG_LABEL_HEIGHT = 20;
int SCALE_CONFIG_INPUT_WIDTH = SCALE_CONFIG_LABEL_WIDTH;
int SCALE_CONFIG_INPUT_HEIGHT = 20;
int SCALE_CONFIG_LABEL_X = X_MARGIN;
int SCALE_CONFIG_INPUT_X = X_MARGIN;
int SCALE_CONFIG_LABEL_TOP_Y = PANEL_Y_START;
int SCALE_CONFIG_INPUT_TOP_Y = SCALE_CONFIG_LABEL_TOP_Y + SCALE_CONFIG_LABEL_HEIGHT;
int SCALE_CONFIG_LABEL_BOTTOM_Y = SCALE_CONFIG_INPUT_TOP_Y + SCALE_CONFIG_INPUT_HEIGHT + Y_MARGIN;
int SCALE_CONFIG_INPUT_BOTTOM_Y = SCALE_CONFIG_LABEL_BOTTOM_Y + SCALE_CONFIG_LABEL_HEIGHT;
// G4P -------------------------------------------------------------------------
// TODO Rename to scale
GLabel xMultiplierLabel, yMultiplierLabel;
GTextField xMultiplierInput, yMultiplierInput;
GTabManager multiplierTabManager;

// FUNCTIONS ===================================================================

// Setup -----------------------------------------------------------------------

public void createScaleShiftTypePanel() {
  scaleShiftTypePanel = new GPanel(controlsWindow, TYPE_PANEL_X, TYPE_PANEL_Y, TYPE_PANEL_WIDTH, TYPE_PANEL_HEIGHT);
  setupShiftTypePanel(scaleShiftTypePanel, TYPE_SCALE);
  // TODO: merge common
  // X Multiplier
  xMultiplierLabel = new GLabel(controlsWindow, SCALE_CONFIG_LABEL_X, SCALE_CONFIG_LABEL_TOP_Y, SCALE_CONFIG_LABEL_WIDTH, SCALE_CONFIG_LABEL_HEIGHT);
  xMultiplierLabel.setText("Horizontal Shift Multiplier:");
  setupGeneralLabel(xMultiplierLabel);
  scaleShiftTypePanel.addControl(xMultiplierLabel);
  xMultiplierInput = new GTextField(controlsWindow, SCALE_CONFIG_INPUT_X, SCALE_CONFIG_INPUT_TOP_Y, SCALE_CONFIG_INPUT_WIDTH, SCALE_CONFIG_INPUT_HEIGHT);
  xMultiplierInput.setText("2.0"); // TODO: pull default from manager
  xMultiplierInput.addEventHandler(this, "xMultiplierInput_change");
  scaleShiftTypePanel.addControl(xMultiplierInput);
  // Y Multiplier
  yMultiplierLabel = new GLabel(controlsWindow, SCALE_CONFIG_LABEL_X, SCALE_CONFIG_LABEL_BOTTOM_Y, SCALE_CONFIG_LABEL_WIDTH, SCALE_CONFIG_LABEL_HEIGHT);
  yMultiplierLabel.setText("Vertical Shift Multiplier:");
  setupGeneralLabel(yMultiplierLabel);
  scaleShiftTypePanel.addControl(yMultiplierLabel);
  yMultiplierInput = new GTextField(controlsWindow, SCALE_CONFIG_INPUT_X, SCALE_CONFIG_INPUT_BOTTOM_Y, SCALE_CONFIG_INPUT_WIDTH, SCALE_CONFIG_INPUT_HEIGHT);
  yMultiplierInput.setText("2.0"); // TODO: pull default from manager
  yMultiplierInput.addEventHandler(this, "yMultiplierInput_change");
  scaleShiftTypePanel.addControl(yMultiplierInput);
  // Tab manager for inputs
  multiplierTabManager = new GTabManager();
  multiplierTabManager.addControls(xMultiplierInput, yMultiplierInput);
  // Add to advanced options
  advancedOptionsPanel.addControl(scaleShiftTypePanel);
}

// Event Handlers --------------------------------------------------------------

void multiplierInputEventHandler(GTextField source, GEvent event, boolean horizontal) {
  switch(event) {
    case ENTERED:
      // Unfocus on enter, then do same actions as LOST_FOCUS case
      source.setFocus(false);
    case LOST_FOCUS:
      // Sanitize and update manager
      float val = sanitizeFloatInputValue(source);
      if (val > -1.0) {
        shiftTypeManager.scale_setMultiplier(val, horizontal);
        showPreview();
      } 
      // Update input text to match sanitized input 
      // Also reverts input text in the event that it was not a valid numeric
      // value after parsing
      source.setText("" + shiftTypeManager.scale_getMultiplier(horizontal));
      break;
    default:
      break;
  }
}

public void xMultiplierInput_change(GTextField source, GEvent event) {
  multiplierInputEventHandler(source, event, true);
}

public void yMultiplierInput_change(GTextField source, GEvent event) {
  multiplierInputEventHandler(source, event, false);
}


// =============================================================================
// Linear Shift Type Panel
// =============================================================================

// GLOBALS =====================================================================

// TODO extract common w/ multiply to type_config_ general vars
// Toggles ---------------------------------------------------------------------
int LINEAR_CONFIG_TOGGLE_WIDTH = TYPE_PANEL_WIDTH / 2;
int LINEAR_CONFIG_TOGGLE_HEIGHT = 20;
int LINEAR_CONFIG_TOGGLE_Y = PANEL_Y_START;
int LINEAR_CONFIG_TOGGLE_LEFT_X = 0;
int LINEAR_CONFIG_TOGGLE_RIGHT_X = LINEAR_CONFIG_TOGGLE_WIDTH;
// G4P
GToggleGroup linearEqTypeToggle;
GOption linearYEquals, linearXEquals;
// Coefficient Input -----------------------------------------------------------
int LINEAR_CONFIG_LABEL_WIDTH = TYPE_PANEL_WIDTH - X_MARGINS;
int LINEAR_CONFIG_LABEL_HEIGHT = 20;
int LINEAR_CONFIG_INPUT_WIDTH = LINEAR_CONFIG_LABEL_WIDTH;
int LINEAR_CONFIG_INPUT_HEIGHT = 20;
int LINEAR_CONFIG_LABEL_X = X_MARGIN;
int LINEAR_CONFIG_LABEL_Y = LINEAR_CONFIG_TOGGLE_Y + LINEAR_CONFIG_TOGGLE_HEIGHT + Y_MARGIN;
int LINEAR_CONFIG_INPUT_X = X_MARGIN;
int LINEAR_CONFIG_INPUT_Y = LINEAR_CONFIG_LABEL_Y + LINEAR_CONFIG_LABEL_HEIGHT;
// G4P
GLabel linearCoeffLabel;
GTextField linearCoeffInput;
// Coefficient Sign ------------------------------------------------------------
int LINEAR_CONFIG_CHECKBOX_WIDTH = TYPE_PANEL_WIDTH;
int LINEAR_CONFIG_CHECKBOX_HEIGHT = LINEAR_CONFIG_TOGGLE_HEIGHT;
int LINEAR_CONFIG_CHECKBOX_X = 0;
int LINEAR_CONFIG_CHECKBOX_Y = LINEAR_CONFIG_INPUT_Y + LINEAR_CONFIG_INPUT_HEIGHT + Y_MARGIN;
// G4P
GCheckbox linearNegativeCoeffCheckbox;

// FUNCTIONS ===================================================================

// Setup -----------------------------------------------------------------------

public void createLinearShiftTypePanel() {
  linearShiftTypePanel = new GPanel(controlsWindow, TYPE_PANEL_X, TYPE_PANEL_Y, TYPE_PANEL_WIDTH, TYPE_PANEL_HEIGHT);
  setupShiftTypePanel(linearShiftTypePanel, TYPE_LINEAR);
  // Equation Type Toggles
  // TODO extract common
  linearEqTypeToggle = new GToggleGroup();
  linearYEquals = new GOption(controlsWindow, LINEAR_CONFIG_TOGGLE_LEFT_X, LINEAR_CONFIG_TOGGLE_Y, LINEAR_CONFIG_TOGGLE_WIDTH, LINEAR_CONFIG_TOGGLE_HEIGHT);
  linearYEquals.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  linearYEquals.setText("y=mx+b");
  linearYEquals.addEventHandler(this, "linearYEquals_clicked");
  linearEqTypeToggle.addControl(linearYEquals);
  linearShiftTypePanel.addControl(linearYEquals);
  linearYEquals.setSelected(true);
  linearXEquals = new GOption(controlsWindow, LINEAR_CONFIG_TOGGLE_RIGHT_X, LINEAR_CONFIG_TOGGLE_Y, LINEAR_CONFIG_TOGGLE_WIDTH, LINEAR_CONFIG_TOGGLE_HEIGHT);
  linearXEquals.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  linearXEquals.setText("x=my+b");
  linearXEquals.addEventHandler(this, "linearXEquals_clicked");
  linearEqTypeToggle.addControl(linearXEquals);
  linearShiftTypePanel.addControl(linearXEquals);
  // Equation Coefficient
  linearCoeffLabel = new GLabel(controlsWindow, LINEAR_CONFIG_LABEL_X, LINEAR_CONFIG_LABEL_Y, LINEAR_CONFIG_LABEL_WIDTH, LINEAR_CONFIG_LABEL_HEIGHT);
  linearCoeffLabel.setText("Slope (m):");
  setupGeneralLabel(linearCoeffLabel);
  linearShiftTypePanel.addControl(linearCoeffLabel);
  linearCoeffInput = new GTextField(controlsWindow, LINEAR_CONFIG_INPUT_X, LINEAR_CONFIG_INPUT_Y, LINEAR_CONFIG_INPUT_WIDTH, LINEAR_CONFIG_INPUT_HEIGHT);
  linearCoeffInput.setText("1.0"); // TODO: pull default from manager
  linearCoeffInput.addEventHandler(this, "linearCoeffInput_change");
  linearShiftTypePanel.addControl(linearCoeffInput);
  // Coefficient Sign
  linearNegativeCoeffCheckbox = new GCheckbox(controlsWindow, LINEAR_CONFIG_CHECKBOX_X, LINEAR_CONFIG_CHECKBOX_Y, LINEAR_CONFIG_CHECKBOX_WIDTH, LINEAR_CONFIG_CHECKBOX_HEIGHT, "Negative Slope");
  linearNegativeCoeffCheckbox.addEventHandler(this, "linearNegativeCoeffCheckbox_click");
  linearShiftTypePanel.addControl(linearNegativeCoeffCheckbox);
  // Add to advanced options
  advancedOptionsPanel.addControl(linearShiftTypePanel);
}

// Event Handlers --------------------------------------------------------------

public void linearYEquals_clicked(GOption source, GEvent event) {
  shiftTypeManager.linear_setEquationType(true);
  showPreview();
}

public void linearXEquals_clicked(GOption source, GEvent event) {
  shiftTypeManager.linear_setEquationType(false);
  showPreview();
}

public void linearCoeffInput_change(GTextField source, GEvent event) {
  switch(event) {
    case ENTERED:
      // Unfocus on enter, then do same actions as LOST_FOCUS case
      source.setFocus(false);
    case LOST_FOCUS:
      // Sanitize and update manager
      float val = sanitizeFloatInputValue(source);
      if (val > -1.0) {
        shiftTypeManager.linear_setCoefficient(val);
        showPreview();
      } 
      // Update input text to match sanitized input 
      // Also reverts input text in the event that it was not a valid numeric
      // value after parsing
      source.setText("" + shiftTypeManager.linear_getCoefficient());
      break;
    default:
      break;
  }
}

public void linearNegativeCoeffCheckbox_click(GCheckbox source, GEvent event) {
  shiftTypeManager.linear_setCoefficientSign(!source.isSelected());
  showPreview();
}


// =============================================================================
// Skew Shift Type Panel
// =============================================================================

// GLOBALS =====================================================================

// Labels ----------------------------------------------------------------------
int SKEW_CONFIG_LABEL_WIDTH = TYPE_PANEL_WIDTH - X_MARGINS;
int SKEW_CONFIG_LABEL_HEIGHT = 20;
int SKEW_CONFIG_LABEL_X = X_MARGIN;
// Inputs ----------------------------------------------------------------------
int SKEW_CONFIG_INPUT_WIDTH = SKEW_CONFIG_LABEL_WIDTH;
int SKEW_CONFIG_INPUT_HEIGHT = 20;
int SKEW_CONFIG_INPUT_X = X_MARGIN;
// G4P Tab Manager
GTabManager skewTabManager;
// Checkboxes ------------------------------------------------------------------
int SKEW_CONFIG_CHECKBOX_WIDTH = TYPE_PANEL_WIDTH;
int SKEW_CONFIG_CHECKBOX_HEIGHT = 20;
int SKEW_CONFIG_CHECKBOX_X = 0;
// X Skew Label, Input, and Checkbox -------------------------------------------
int SKEW_CONFIG_LABEL_TOP_Y = PANEL_Y_START;
int SKEW_CONFIG_INPUT_TOP_Y = SKEW_CONFIG_LABEL_TOP_Y + SKEW_CONFIG_LABEL_HEIGHT;
int SKEW_CONFIG_CHECKBOX_TOP_Y = SKEW_CONFIG_INPUT_TOP_Y + SKEW_CONFIG_INPUT_HEIGHT;
// G4P
GLabel xSkewLabel;
GTextField xSkewInput;
GCheckbox xSkewNegativeCheckbox;
// Y Skew Label, Input, and Checkbox -------------------------------------------
int SKEW_CONFIG_LABEL_BOTTOM_Y = SKEW_CONFIG_CHECKBOX_TOP_Y + SKEW_CONFIG_CHECKBOX_HEIGHT + Y_MARGIN;
int SKEW_CONFIG_INPUT_BOTTOM_Y = SKEW_CONFIG_LABEL_BOTTOM_Y + SKEW_CONFIG_LABEL_HEIGHT;
int SKEW_CONFIG_CHECKBOX_BOTTOM_Y = SKEW_CONFIG_INPUT_BOTTOM_Y + SKEW_CONFIG_INPUT_HEIGHT;
// G4P
GLabel ySkewLabel;
GTextField ySkewInput;
GCheckbox ySkewNegativeCheckbox;

// FUNCTIONS ===================================================================

// Setup -----------------------------------------------------------------------

public void createSkewShiftTypePanel() {
  skewShiftTypePanel = new GPanel(controlsWindow, TYPE_PANEL_X, TYPE_PANEL_Y, TYPE_PANEL_WIDTH, TYPE_PANEL_HEIGHT);
  setupShiftTypePanel(skewShiftTypePanel, TYPE_SKEW);
  // TODO: merge common
  // X Skew
  xSkewLabel = new GLabel(controlsWindow, SKEW_CONFIG_LABEL_X, SKEW_CONFIG_LABEL_TOP_Y, SKEW_CONFIG_LABEL_WIDTH, SKEW_CONFIG_LABEL_HEIGHT);
  xSkewLabel.setText("Horizontal Skew:");
  setupGeneralLabel(xSkewLabel);
  skewShiftTypePanel.addControl(xSkewLabel);
  xSkewInput = new GTextField(controlsWindow, SKEW_CONFIG_INPUT_X, SKEW_CONFIG_INPUT_TOP_Y, SKEW_CONFIG_INPUT_WIDTH, SKEW_CONFIG_INPUT_HEIGHT);
  xSkewInput.setText("2.0"); // TODO: pull default from manager
  xSkewInput.addEventHandler(this, "xSkewInput_change");
  skewShiftTypePanel.addControl(xSkewInput);
  xSkewNegativeCheckbox = new GCheckbox(controlsWindow, SKEW_CONFIG_CHECKBOX_X, SKEW_CONFIG_CHECKBOX_TOP_Y, SKEW_CONFIG_CHECKBOX_WIDTH, SKEW_CONFIG_CHECKBOX_HEIGHT, "Negative X Skew");
  xSkewNegativeCheckbox.addEventHandler(this, "xSkewNegativeCheckbox_click");
  skewShiftTypePanel.addControl(xSkewNegativeCheckbox);
  // Y Skew
  ySkewLabel = new GLabel(controlsWindow, SKEW_CONFIG_LABEL_X, SKEW_CONFIG_LABEL_BOTTOM_Y, SKEW_CONFIG_LABEL_WIDTH, SKEW_CONFIG_LABEL_HEIGHT);
  ySkewLabel.setText("Vertical Skew:");
  setupGeneralLabel(ySkewLabel);
  skewShiftTypePanel.addControl(ySkewLabel);
  ySkewInput = new GTextField(controlsWindow, SKEW_CONFIG_INPUT_X, SKEW_CONFIG_INPUT_BOTTOM_Y, SKEW_CONFIG_INPUT_WIDTH, SKEW_CONFIG_INPUT_HEIGHT);
  ySkewInput.setText("2.0"); // TODO: pull default from manager
  ySkewInput.addEventHandler(this, "ySkewInput_change");
  skewShiftTypePanel.addControl(ySkewInput);
  ySkewNegativeCheckbox = new GCheckbox(controlsWindow, SKEW_CONFIG_CHECKBOX_X, SKEW_CONFIG_CHECKBOX_BOTTOM_Y, SKEW_CONFIG_CHECKBOX_WIDTH, SKEW_CONFIG_CHECKBOX_HEIGHT, "Negative Y Skew");
  ySkewNegativeCheckbox.addEventHandler(this, "ySkewNegativeCheckbox_click");
  skewShiftTypePanel.addControl(ySkewNegativeCheckbox);
  // Tab manager for inputs
  skewTabManager = new GTabManager();
  skewTabManager.addControls(xSkewInput, ySkewInput);
  // Add to advanced options
  advancedOptionsPanel.addControl(skewShiftTypePanel);
}

// Event Handlers --------------------------------------------------------------

void skewInputEventHandler(GTextField source, GEvent event, boolean horizontal) {
  switch(event) {
    case ENTERED:
      // Unfocus on enter, then do same actions as LOST_FOCUS case
      source.setFocus(false);
    case LOST_FOCUS:
      // Sanitize and update manager
      float val = sanitizeFloatInputValue(source);
      if (val > -1.0) {
        shiftTypeManager.skew_setSkew(val, horizontal);
        showPreview();
      } 
      // Update input text to match sanitized input 
      // Also reverts input text in the event that it was not a valid numeric
      // value after parsing
      source.setText("" + shiftTypeManager.skew_getSkew(horizontal));
      break;
    default:
      break;
  }
}

public void xSkewInput_change(GTextField source, GEvent event) {
  skewInputEventHandler(source, event, true);
}

public void xSkewNegativeCheckbox_click(GCheckbox source, GEvent event) {
  shiftTypeManager.skew_setSign(!source.isSelected(), true);
  showPreview();
}

public void ySkewInput_change(GTextField source, GEvent event) {
  skewInputEventHandler(source, event, false);
}

public void ySkewNegativeCheckbox_click(GCheckbox source, GEvent event) {
  shiftTypeManager.skew_setSign(!source.isSelected(), false);
  showPreview();
}


// =============================================================================
// X*Y Mult Shift Type Panel
// =============================================================================

// GLOBALS =====================================================================

// Labels ----------------------------------------------------------------------
int XYMULT_CONFIG_LABEL_WIDTH = TYPE_PANEL_WIDTH;
int XYMULT_CONFIG_LABEL_HEIGHT = 20;
int XYMULT_CONFIG_LABEL_X = 0;
// Checkboxes ------------------------------------------------------------------
int XYMULT_CONFIG_CHECKBOX_WIDTH = TYPE_PANEL_WIDTH;
int XYMULT_CONFIG_CHECKBOX_HEIGHT = 20;
int XYMULT_CONFIG_CHECKBOX_X = 0;
// X Multiply Label and Checkboxes ---------------------------------------------
int XYMULT_CONFIG_X_LABEL_Y = PANEL_Y_START;
int XYMULT_CONFIG_XMULT_CHECKBOX_Y = XYMULT_CONFIG_X_LABEL_Y + XYMULT_CONFIG_LABEL_HEIGHT;
int XYMULT_CONFIG_XNEGATIVE_CHECKBOX_Y = XYMULT_CONFIG_XMULT_CHECKBOX_Y + XYMULT_CONFIG_CHECKBOX_HEIGHT;
int XYMULT_CONFIG_XDIVWIDTH_CHECKBOX_Y = XYMULT_CONFIG_XNEGATIVE_CHECKBOX_Y + XYMULT_CONFIG_CHECKBOX_HEIGHT;
// G4P
GLabel multXLabel;
GCheckbox multXCheckbox;
GCheckbox multXNegativeCheckbox;
GCheckbox xDivWidthCheckbox;
// Y Multiply Label and Checkboxes ---------------------------------------------
int XYMULT_CONFIG_Y_LABEL_Y = XYMULT_CONFIG_XDIVWIDTH_CHECKBOX_Y + XYMULT_CONFIG_CHECKBOX_HEIGHT + Y_MARGIN;
int XYMULT_CONFIG_YMULT_CHECKBOX_Y = XYMULT_CONFIG_Y_LABEL_Y + XYMULT_CONFIG_LABEL_HEIGHT;
int XYMULT_CONFIG_YNEGATIVE_CHECKBOX_Y = XYMULT_CONFIG_YMULT_CHECKBOX_Y + XYMULT_CONFIG_CHECKBOX_HEIGHT;
int XYMULT_CONFIG_YDIVHEIGHT_CHECKBOX_Y = XYMULT_CONFIG_YNEGATIVE_CHECKBOX_Y + XYMULT_CONFIG_CHECKBOX_HEIGHT;
// G4P
GLabel multYLabel;
GCheckbox multYCheckbox;
GCheckbox multYNegativeCheckbox;
GCheckbox yDivHeightCheckbox;

// FUNCTIONS ===================================================================

// Setup -----------------------------------------------------------------------

public void createXYMultShiftTypePanel() {
  xyMultShiftTypePanel = new GPanel(controlsWindow, TYPE_PANEL_X, TYPE_PANEL_Y, TYPE_PANEL_WIDTH, TYPE_PANEL_HEIGHT);
  setupShiftTypePanel(xyMultShiftTypePanel, TYPE_XYMULT);
  // X Mult --------------------------------------------------------------------
  // Label
  multXLabel = new GLabel(controlsWindow, XYMULT_CONFIG_LABEL_X, XYMULT_CONFIG_X_LABEL_Y, XYMULT_CONFIG_LABEL_WIDTH, XYMULT_CONFIG_LABEL_HEIGHT, "X Shift");
  setupGeneralLabel(multXLabel);
  xyMultShiftTypePanel.addControl(multXLabel);
  // Mult x
  // TODO: update div text
  multXCheckbox = new GCheckbox(controlsWindow, XYMULT_CONFIG_CHECKBOX_X, XYMULT_CONFIG_XMULT_CHECKBOX_Y, XYMULT_CONFIG_CHECKBOX_WIDTH, XYMULT_CONFIG_CHECKBOX_HEIGHT, "x shift + (x*y/width)");
  multXCheckbox.setSelected(true);
  multXCheckbox.addEventHandler(this, "multXCheckbox_click");
  xyMultShiftTypePanel.addControl(multXCheckbox);
  // x negative
  multXNegativeCheckbox = new GCheckbox(controlsWindow, XYMULT_CONFIG_CHECKBOX_X, XYMULT_CONFIG_XNEGATIVE_CHECKBOX_Y, XYMULT_CONFIG_CHECKBOX_WIDTH, XYMULT_CONFIG_CHECKBOX_HEIGHT, "Negative X Coefficient");
  multXNegativeCheckbox.addEventHandler(this, "multXNegativeCheckbox_click");
  xyMultShiftTypePanel.addControl(multXNegativeCheckbox);
  // x div width
  xDivWidthCheckbox = new GCheckbox(controlsWindow, XYMULT_CONFIG_CHECKBOX_X, XYMULT_CONFIG_XDIVWIDTH_CHECKBOX_Y, XYMULT_CONFIG_CHECKBOX_WIDTH, XYMULT_CONFIG_CHECKBOX_HEIGHT, "Divide Product by Width");
  xDivWidthCheckbox.setSelected(true);
  xDivWidthCheckbox.addEventHandler(this, "xDivWidthCheckbox_click");
  xyMultShiftTypePanel.addControl(xDivWidthCheckbox);
  // Y Mult --------------------------------------------------------------------
  multYLabel = new GLabel(controlsWindow, XYMULT_CONFIG_LABEL_X, XYMULT_CONFIG_Y_LABEL_Y, XYMULT_CONFIG_LABEL_WIDTH, XYMULT_CONFIG_LABEL_HEIGHT, "Y Shift");
  setupGeneralLabel(multYLabel);
  xyMultShiftTypePanel.addControl(multYLabel);
  // Mult y
  // TODO: update div text
  multYCheckbox = new GCheckbox(controlsWindow, XYMULT_CONFIG_CHECKBOX_X, XYMULT_CONFIG_YMULT_CHECKBOX_Y, XYMULT_CONFIG_CHECKBOX_WIDTH, XYMULT_CONFIG_CHECKBOX_HEIGHT, "y shift + (y*x/height)");
  multYCheckbox.addEventHandler(this, "multYCheckbox_click");
  xyMultShiftTypePanel.addControl(multYCheckbox);
  // y negative
  multYNegativeCheckbox = new GCheckbox(controlsWindow, XYMULT_CONFIG_CHECKBOX_X, XYMULT_CONFIG_YNEGATIVE_CHECKBOX_Y, XYMULT_CONFIG_CHECKBOX_WIDTH, XYMULT_CONFIG_CHECKBOX_HEIGHT, "Negative Y Coefficient");
  multYNegativeCheckbox.addEventHandler(this, "multYNegativeCheckbox_click");
  xyMultShiftTypePanel.addControl(multYNegativeCheckbox);
  // y div height
  yDivHeightCheckbox = new GCheckbox(controlsWindow, XYMULT_CONFIG_CHECKBOX_X, XYMULT_CONFIG_YDIVHEIGHT_CHECKBOX_Y, XYMULT_CONFIG_CHECKBOX_WIDTH, XYMULT_CONFIG_CHECKBOX_HEIGHT, "Divide Product by Height");
  yDivHeightCheckbox.setSelected(true);
  yDivHeightCheckbox.addEventHandler(this, "yDivHeightCheckbox_click");
  xyMultShiftTypePanel.addControl(yDivHeightCheckbox);
  // Add to advanced options ---------------------------------------------------
  advancedOptionsPanel.addControl(xyMultShiftTypePanel);
}

// Event Handlers --------------------------------------------------------------

public void multXCheckbox_click(GCheckbox source, GEvent event) {
  shiftTypeManager.xymult_setMultX(source.isSelected());
  showPreview();
}

public void multXNegativeCheckbox_click(GCheckbox source, GEvent event) {
  shiftTypeManager.xymult_setXSign(!source.isSelected());
  showPreview();
}

public void multYCheckbox_click(GCheckbox source, GEvent event) {
  shiftTypeManager.xymult_setMultY(source.isSelected());
  showPreview();
}

public void multYNegativeCheckbox_click(GCheckbox source, GEvent event) {
  shiftTypeManager.xymult_setYSign(!source.isSelected());
  showPreview();
}

public void xDivWidthCheckbox_click(GCheckbox source, GEvent event) {
  shiftTypeManager.xymult_setXDivWidth(source.isSelected());
  showPreview();
}

public void yDivHeightCheckbox_click(GCheckbox source, GEvent event) {
  shiftTypeManager.xymult_setYDivHeight(source.isSelected());
  showPreview();
}


// =============================================================================
// Noise Shift Type Panel
// =============================================================================

// GLOBALS =====================================================================

// Labels ----------------------------------------------------------------------
int NOISE_CONFIG_LABEL_FULL_WIDTH = TYPE_PANEL_WIDTH - X_MARGINS;
int NOISE_CONFIG_LABEL_HALF_WIDTH = (TYPE_PANEL_WIDTH / 2) - X_MARGINS;
int NOISE_CONFIG_LABEL_HEIGHT = 20;
int NOISE_CONFIG_LABEL_LEFT_X = X_MARGIN;
int NOISE_CONFIG_LABEL_RIGHT_X = NOISE_CONFIG_LABEL_LEFT_X + NOISE_CONFIG_LABEL_HALF_WIDTH + X_MARGINS;
// Inputs ----------------------------------------------------------------------
int NOISE_CONFIG_INPUT_FULL_WIDTH = NOISE_CONFIG_LABEL_FULL_WIDTH;
int NOISE_CONFIG_INPUT_HALF_WIDTH = NOISE_CONFIG_LABEL_HALF_WIDTH;
int NOISE_CONFIG_INPUT_HEIGHT = NOISE_CONFIG_LABEL_HEIGHT;
int NOISE_CONFIG_INPUT_LEFT_X = X_MARGIN;
int NOISE_CONFIG_INPUT_RIGHT_X = NOISE_CONFIG_INPUT_LEFT_X + NOISE_CONFIG_INPUT_HALF_WIDTH + X_MARGINS;
// TODO: what about noise start/increment x?
// Noise Start Y ---------------------------------------------------------------
int NOISE_CONFIG_LABEL_START_Y = PANEL_Y_START;
int NOISE_CONFIG_INPUT_START_Y = NOISE_CONFIG_LABEL_START_Y + NOISE_CONFIG_LABEL_HEIGHT;
// Noise Increment Y -----------------------------------------------------------
int NOISE_CONFIG_LABEL_INCREMENT_Y = NOISE_CONFIG_INPUT_START_Y + NOISE_CONFIG_LABEL_HEIGHT + Y_MARGIN;
int NOISE_CONFIG_INPUT_INCREMENT_Y = NOISE_CONFIG_LABEL_INCREMENT_Y + NOISE_CONFIG_LABEL_HEIGHT;
// Noise Multiplier Y ----------------------------------------------------------
int NOISE_CONFIG_LABEL_MULTIPLIER_Y = NOISE_CONFIG_INPUT_INCREMENT_Y + NOISE_CONFIG_LABEL_HEIGHT + Y_MARGIN;
int NOISE_CONFIG_INPUT_MULTIPLIER_Y = NOISE_CONFIG_LABEL_MULTIPLIER_Y + NOISE_CONFIG_LABEL_HEIGHT;

// G4P TODO: MOVE TO RELEVANT SECTIONS ONCE X VARS ARE IMPLEMENTED!
// Start
GLabel xNoiseStartLabel, yNoiseStartLabel;
GTextField xNoiseStartInput, yNoiseStartInput;
// Increment
GLabel xNoiseIncrementLabel, yNoiseIncrementLabel;
GTextField xNoiseIncrementInput, yNoiseIncrementInput;
// Multiplier
GLabel noiseMultiplierLabel;
GTextField noiseMultiplierInput;
// Tab MGMT
GTabManager noiseTabManager;

// FUNCTIONS ===================================================================

// Setup -----------------------------------------------------------------------

public void createNoiseShiftTypePanel() {
  noiseShiftTypePanel = new GPanel(controlsWindow, TYPE_PANEL_X, TYPE_PANEL_Y, TYPE_PANEL_WIDTH, TYPE_PANEL_HEIGHT);
  setupShiftTypePanel(noiseShiftTypePanel, TYPE_NOISE);
  // X Noise Start
  xNoiseStartLabel = new GLabel(controlsWindow, NOISE_CONFIG_LABEL_LEFT_X, NOISE_CONFIG_LABEL_START_Y, NOISE_CONFIG_LABEL_HALF_WIDTH, NOISE_CONFIG_LABEL_HEIGHT);
  xNoiseStartLabel.setText("X Start:");
  setupGeneralLabel(xNoiseStartLabel);
  noiseShiftTypePanel.addControl(xNoiseStartLabel);
  xNoiseStartInput = new GTextField(controlsWindow, NOISE_CONFIG_INPUT_LEFT_X, NOISE_CONFIG_INPUT_START_Y, NOISE_CONFIG_INPUT_HALF_WIDTH, NOISE_CONFIG_INPUT_HEIGHT);
  xNoiseStartInput.setText("0.01"); // TODO pull from manager
  xNoiseStartInput.addEventHandler(this, "xNoiseStartInput_change");
  noiseShiftTypePanel.addControl(xNoiseStartInput);
  // Y Noise Start
  yNoiseStartLabel = new GLabel(controlsWindow, NOISE_CONFIG_LABEL_RIGHT_X, NOISE_CONFIG_LABEL_START_Y, NOISE_CONFIG_LABEL_HALF_WIDTH, NOISE_CONFIG_LABEL_HEIGHT);
  yNoiseStartLabel.setText("Y Start:");
  setupGeneralLabel(yNoiseStartLabel);
  noiseShiftTypePanel.addControl(yNoiseStartLabel);
  yNoiseStartInput = new GTextField(controlsWindow, NOISE_CONFIG_INPUT_RIGHT_X, NOISE_CONFIG_INPUT_START_Y, NOISE_CONFIG_INPUT_HALF_WIDTH, NOISE_CONFIG_INPUT_HEIGHT);
  yNoiseStartInput.setText("0.01"); // TODO pull from manager
  yNoiseStartInput.addEventHandler(this, "yNoiseStartInput_change");
  noiseShiftTypePanel.addControl(yNoiseStartInput);
  // X Noise Increment
  xNoiseIncrementLabel = new GLabel(controlsWindow, NOISE_CONFIG_LABEL_LEFT_X, NOISE_CONFIG_LABEL_INCREMENT_Y, NOISE_CONFIG_LABEL_HALF_WIDTH, NOISE_CONFIG_LABEL_HEIGHT);
  xNoiseIncrementLabel.setText("X Step:");
  setupGeneralLabel(xNoiseIncrementLabel);
  noiseShiftTypePanel.addControl(xNoiseIncrementLabel);
  xNoiseIncrementInput = new GTextField(controlsWindow, NOISE_CONFIG_INPUT_LEFT_X, NOISE_CONFIG_INPUT_INCREMENT_Y, NOISE_CONFIG_INPUT_HALF_WIDTH, NOISE_CONFIG_INPUT_HEIGHT);
  xNoiseIncrementInput.setText("0.001"); // TODO pull from manager
  xNoiseIncrementInput.addEventHandler(this, "xNoiseIncrementInput_change");
  noiseShiftTypePanel.addControl(xNoiseIncrementInput);
  // Y Noise Increment
  yNoiseIncrementLabel = new GLabel(controlsWindow, NOISE_CONFIG_LABEL_RIGHT_X, NOISE_CONFIG_LABEL_INCREMENT_Y, NOISE_CONFIG_LABEL_HALF_WIDTH, NOISE_CONFIG_LABEL_HEIGHT);
  yNoiseIncrementLabel.setText("Y Step:");
  setupGeneralLabel(yNoiseIncrementLabel);
  noiseShiftTypePanel.addControl(yNoiseIncrementLabel);
  yNoiseIncrementInput = new GTextField(controlsWindow, NOISE_CONFIG_INPUT_RIGHT_X, NOISE_CONFIG_INPUT_INCREMENT_Y, NOISE_CONFIG_INPUT_HALF_WIDTH, NOISE_CONFIG_INPUT_HEIGHT);
  yNoiseIncrementInput.setText("0.001"); // TODO pull from manager
  yNoiseIncrementInput.addEventHandler(this, "yNoiseIncrementInput_change");
  noiseShiftTypePanel.addControl(yNoiseIncrementInput);
  // Noise Multiplier
  noiseMultiplierLabel = new GLabel(controlsWindow, NOISE_CONFIG_LABEL_LEFT_X, NOISE_CONFIG_LABEL_MULTIPLIER_Y, NOISE_CONFIG_LABEL_FULL_WIDTH, NOISE_CONFIG_LABEL_HEIGHT);
  noiseMultiplierLabel.setText("Noise Multiplier:");
  setupGeneralLabel(noiseMultiplierLabel);
  noiseShiftTypePanel.addControl(noiseMultiplierLabel);
  noiseMultiplierInput = new GTextField(controlsWindow, NOISE_CONFIG_INPUT_LEFT_X, NOISE_CONFIG_INPUT_MULTIPLIER_Y, NOISE_CONFIG_INPUT_FULL_WIDTH, NOISE_CONFIG_INPUT_HEIGHT);
  noiseMultiplierInput.setText("25.0"); // TODO pull from manager
  noiseMultiplierInput.addEventHandler(this, "noiseMultiplierInput_change");
  noiseShiftTypePanel.addControl(noiseMultiplierInput);

  // Tab manager for inputs
  noiseTabManager = new GTabManager();
  noiseTabManager.addControls(
      xNoiseStartInput, yNoiseStartInput,
      xNoiseIncrementInput, yNoiseIncrementInput,
      noiseMultiplierInput
      );

  // Add to advanced options
  advancedOptionsPanel.addControl(noiseShiftTypePanel);
}

// Event Handlers --------------------------------------------------------------

// Noise Start

void noiseStartInputEventHandler(GTextField source, GEvent event, boolean isX) {
  switch(event) {
    case ENTERED:
      // Unfocus on enter, then do same actions as LOST_FOCUS case
      source.setFocus(false);
    case LOST_FOCUS:
      // Sanitize and update manager
      float val = sanitizeFloatInputValue(source);
      if (val >= 0.0) {
        if (isX)
          shiftTypeManager.noise_setXNoiseStart(val);
        else
          shiftTypeManager.noise_setYNoiseStart(val);
        showPreview();
      } 
      // Update input text to match sanitized input 
      // Also reverts input text in the event that it was not a valid numeric
      // value after parsing
      source.setText("" + (isX ? shiftTypeManager.noise_xNoiseStart() : shiftTypeManager.noise_yNoiseStart()));
      break;
    default:
      break;
  }
}

public void xNoiseStartInput_change(GTextField source, GEvent event) {
  noiseStartInputEventHandler(source, event, true);
}

public void yNoiseStartInput_change(GTextField source, GEvent event) {
  noiseStartInputEventHandler(source, event, false);
}

// Noise Increment

void noiseIncrementInputEventHandler(GTextField source, GEvent event, boolean isX) {
  switch(event) {
    case ENTERED:
      // Unfocus on enter, then do same actions as LOST_FOCUS case
      source.setFocus(false);
    case LOST_FOCUS:
      // Sanitize and update manager
      float val = sanitizeFloatInputValue(source);
      if (val >= 0.0) {
        if (isX)
          shiftTypeManager.noise_setXNoiseIncrement(val);
        else
          shiftTypeManager.noise_setYNoiseIncrement(val);
        showPreview();
      } 
      // Update input text to match sanitized input 
      // Also reverts input text in the event that it was not a valid numeric
      // value after parsing
      source.setText("" + (isX ? shiftTypeManager.noise_xNoiseIncrement() : shiftTypeManager.noise_yNoiseIncrement()));
      break;
    default:
      break;
  }
}

public void xNoiseIncrementInput_change(GTextField source, GEvent event) {
  noiseIncrementInputEventHandler(source, event, true);
}

public void yNoiseIncrementInput_change(GTextField source, GEvent event) {
  noiseIncrementInputEventHandler(source, event, false);
}

// Noise Multiplier

public void noiseMultiplierInput_change(GTextField source, GEvent event) {
  switch(event) {
    case ENTERED:
      // Unfocus on enter, then do same actions as LOST_FOCUS case
      source.setFocus(false);
    case LOST_FOCUS:
      // Sanitize and update manager
      float val = sanitizeFloatInputValue(source);
      if (val >= 0.0) {
        shiftTypeManager.noise_setNoiseMultiplier(val);
        showPreview();
      } 
      // Update input text to match sanitized input 
      // Also reverts input text in the event that it was not a valid numeric
      // value after parsing
      source.setText("" + shiftTypeManager.noise_noiseMultiplier());
      break;
    default:
      break;
  }
}


// TODO ========================================================================
// TODO: CONTINUE CLEANUP FROM HERE
// TODO ========================================================================


// SHIFT SLIDERS ===============================================================
// General ---------------------------------------------------------------------
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

// Horizontal Shift ------------------------------------------------------------
int X_SLIDER_PANEL_X = X_START; 
int X_SLIDER_PANEL_Y = RAND_PANEL_Y + RAND_PANEL_HEIGHT + Y_MARGIN; 

// G4P
GPanel xShiftPanel;
GSlider xSlider; 
GToggleGroup xSliderToggle; 
GOption xSliderPercent, xSliderPixels; 
GTextField xSliderInput;

// Vertical Shift --------------------------------------------------------------
int Y_SLIDER_PANEL_X = X_START; 
int Y_SLIDER_PANEL_Y = X_SLIDER_PANEL_Y + SLIDER_PANEL_HEIGHT + Y_MARGIN;

// G4P
GPanel yShiftPanel;
GSlider ySlider; 
GToggleGroup ySliderToggle; 
GOption ySliderPercent, ySliderPixels; 
GTextField ySliderInput;


// =============================================================================
// Load/Save Panel
// =============================================================================

// GLOBALS =====================================================================

// Panel -----------------------------------------------------------------------
int LOAD_SAVE_PANEL_X = X_START;
int LOAD_SAVE_PANEL_Y = Y_SLIDER_PANEL_Y + SLIDER_PANEL_HEIGHT + Y_MARGIN;
int LOAD_SAVE_PANEL_WIDTH = WINDOW_MAIN_WIDTH / 2 - X_MARGINS;
// G4P
GPanel loadSavePanel;
// Buttons ---------------------------------------------------------------------
int LOAD_SAVE_BTN_HEIGHT = 30;
int LOAD_SAVE_PANEL_HEIGHT = 2 * (LOAD_SAVE_BTN_HEIGHT + Y_MARGIN);
int LOAD_BTN_X = 0;
int LOAD_BTN_Y = 0;
int SAVE_BTN_X = 0;
int SAVE_BTN_Y = LOAD_BTN_Y + LOAD_SAVE_BTN_HEIGHT + Y_MARGIN;
// G4P
GButton loadBtn; 
GButton saveBtn;

// FUNCTIONS ===================================================================

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


// =============================================================================
// Reset/Confirm Panel
// =============================================================================

// GLOBALS =====================================================================

// Buttons ---------------------------------------------------------------------
int RESET_CONFIRM_BTN_HEIGHT = LOAD_SAVE_BTN_HEIGHT;
int RESET_BTN_X = 0;
int RESET_BTN_Y = 0;
int CONFIRM_BTN_X = 0;
int CONFIRM_BTN_Y = RESET_BTN_Y + RESET_CONFIRM_BTN_HEIGHT + Y_MARGIN;
// G4P
GButton resetBtn, confirmBtn; 
// Recursive Checkbox ----------------------------------------------------------
int RECURSIVE_CHECKBOX_HEIGHT = 30;
int RECURSIVE_CHECKBOX_X = 0;
int RECURSIVE_CHECKBOX_Y = CONFIRM_BTN_Y + RESET_CONFIRM_BTN_HEIGHT;
// G4P
GCheckbox recursiveCheckbox;
// Panel -----------------------------------------------------------------------
int RESET_CONFIRM_PANEL_X = LOAD_SAVE_PANEL_X + LOAD_SAVE_PANEL_WIDTH + X_MARGINS;
int RESET_CONFIRM_PANEL_Y = LOAD_SAVE_PANEL_Y;
int RESET_CONFIRM_PANEL_WIDTH = LOAD_SAVE_PANEL_WIDTH;
int RESET_CONFIRM_PANEL_HEIGHT = 2 * (RESET_CONFIRM_BTN_HEIGHT + Y_MARGIN) + RECURSIVE_CHECKBOX_HEIGHT;
// G4P
GPanel resetConfirmPanel;

// FUNCTIONS ===================================================================

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


// =============================================================================
// Setup Window and Panels
// =============================================================================

public void createGUI() {
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  // Put to the left of preview window w/ 50 pixels for padding
  WINDOW_X = windowManager.windowX - (WINDOW_WIDTH + 50);
  // Vertically center
  WINDOW_Y = (displayHeight / 2) - (WINDOW_HEIGHT / 2);
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
  createAdvancedOptionsPanel();
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


// TODO ========================================================================
// TODO: RE-ORGANIZE THESE TO ALSO BE DECLARED IN THEIR RELEVANT SECTIONS??:
// TODO ========================================================================

// =============================================================================
// CHANNEL SHIFT PANELS 
// =============================================================================

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


// =============================================================================
// ADVANCED OPTIONS PANEL
// =============================================================================

// Setup -----------------------------------------------------------------------

public void createAdvancedOptionsPanel() {
  advancedOptionsPanel = new GPanel(controlsWindow, ADV_OPTS_PANEL_X, ADV_OPTS_PANEL_Y, ADV_OPTS_PANEL_WIDTH, ADV_OPTS_PANEL_HEIGHT, "Advanced Options");
  setupGeneralPanel(advancedOptionsPanel, GCScheme.PURPLE_SCHEME);
  // Shift Type Dropdown
  shiftTypeLabel = new GLabel(controlsWindow, TYPE_LABEL_X, TYPE_LABEL_Y, TYPE_LABEL_WIDTH, TYPE_LABEL_HEIGHT, "Shift Type:");
  setupGeneralLabel(shiftTypeLabel);
  advancedOptionsPanel.addControl(shiftTypeLabel);
  shiftTypeSelect = new GDropList(controlsWindow, TYPE_SELECT_X, TYPE_SELECT_Y, TYPE_SELECT_WIDTH, TYPE_SELECT_HEIGHT, TYPE_SELECT_MAX_ITEMS, TYPE_SELECT_BTN_WIDTH);
  shiftTypeSelect.setItems(SHIFT_TYPES, TYPE_DEFAULT);
  shiftTypeSelect.addEventHandler(this, "shiftTypeSelect_change");
  advancedOptionsPanel.addControl(shiftTypeSelect);
  // Keep track of each config panel in global
  shiftTypeConfigPanels = new GPanel[TOTAL_SHIFT_TYPES];
  // Add type config panels and add them to shiftTypeConfigPanels
  createDefaultShiftTypePanel();
  createScaleShiftTypePanel();
  createLinearShiftTypePanel();
  createSkewShiftTypePanel();
  createXYMultShiftTypePanel();
  createNoiseShiftTypePanel();
}

// Helpers ---------------------------------------------------------------------

public void hideShiftTypePanel(GPanel panel) {
  togglePanelVisibility(panel, false);
  // Move off screen to avoid issues w/ click through lag
  panel.moveTo(WINDOW_WIDTH, WINDOW_HEIGHT);
}
public void showShiftTypePanel(GPanel panel) {
  // Move on screen
  panel.moveTo(TYPE_PANEL_X, TYPE_PANEL_Y);
  togglePanelVisibility(panel, true);
}

// Event Handlers --------------------------------------------------------------

public void shiftTypeSelect_change(GDropList source, GEvent event) {
  // Hide previously selected panel
  hideShiftTypePanel(shiftTypeConfigPanels[shiftTypeManager.state]);
  shiftTypeManager.setShiftType(source.getSelectedIndex());
  // Show newly selected panel
  showShiftTypePanel(shiftTypeConfigPanels[shiftTypeManager.state]);
  showPreview();
}

// Type config panels (called above) -------------------------------------------

public void setupShiftTypePanel(GPanel panel, int shiftTypeIndex) {
  setupGeneralPanel(panel);
  panel.setText(SHIFT_TYPES[shiftTypeIndex] + " Shift Settings");
  // Hide by default
  hideShiftTypePanel(panel);
  // Add to global
  shiftTypeConfigPanels[shiftTypeIndex] = panel;
}

