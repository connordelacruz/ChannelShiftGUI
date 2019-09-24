// =============================================================================
// Globals, logic, and event handlers related to randomizing values
// =============================================================================

// Manager =====================================================================

public class RandomizeManager {
  // TODO: more informative names now that these are public 
  // If true, randomize the corresponding settings
  public boolean src, targ, xShift, yShift; 
  // Maximum percent channels can be shifted
  public int xShiftMax, yShiftMax;

  public RandomizeManager() {
    src = targ = xShift = yShift = true; 
    xShiftMax = yShiftMax = 100;
  }

  // Getter/Setter Methods

  // Source channel
  public void toggleSource(boolean val) { src = val; }

  // Target channel
  public void toggleTarget(boolean val) { targ = val; }

  // Either channel (let ChannelManager determine which one(s))
  public boolean randomizeChannel() { return src || targ; }

  // Horizontal shift
  public void toggleXShift(boolean val) { xShift = val; }
  // Horizontal shift max percent
  public void setXShiftMaxPercent(int percent) {
    xShiftMax = getPercentWithinBounds(percent);
  }

  // Vertical shift
  public void toggleYShift(boolean val) { yShift = val; }
  // Vertical shift max percent
  public void setYShiftMaxPercent(int percent) {
    yShiftMax = getPercentWithinBounds(percent);
  }

  // Conditional max shift getter/setters
  public void setShiftMaxPercent(int percent, boolean horizontal) {
    if (horizontal)
      setXShiftMaxPercent(percent);
    else
      setYShiftMaxPercent(percent);
  }
  public int shiftMaxPercent(boolean horizontal) {
    return horizontal ? xShiftMax : yShiftMax;
  }

  // Helpers

  int getPercentWithinBounds(int percent) {
    if (percent > 100)
      percent = 100;
    else if (percent < 0)
      percent = 0;
    return percent;
  }

}


// Event Handlers ==============================================================

// Randomize Button ------------------------------------------------------------

/** 
 * Calls the randomize() methods of managers based on the configuration of
 * randomizeManager. Updates GUI on change
 */
void randomizeValues() {
  // Channels
  if (randomizeManager.randomizeChannel()) {
    channelManager.randomize(randomizeManager.src, randomizeManager.targ);
    updateChannelToggles();
  }
  // Shift
  if (randomizeManager.xShift) {
    xShiftManager.randomize(randomizeManager.xShiftMax);
    updateShiftSlider(true);
  }
  if (randomizeManager.yShift) {
    yShiftManager.randomize(randomizeManager.yShiftMax);
    updateShiftSlider(false);
  }
}

public void randomizeBtn_click(GButton source, GEvent event) {
  randomizeValues();
  showPreview();
} 

// Randomize Checkboxes --------------------------------------------------------

public void randSrcCheckbox_click(GCheckbox source, GEvent event) {
  randomizeManager.toggleSource(source.isSelected());
}

public void randTargCheckbox_click(GCheckbox source, GEvent event) {
  randomizeManager.toggleTarget(source.isSelected());
}

// TODO: enable/disable corresponding input
public void randXShiftCheckbox_click(GCheckbox source, GEvent event) {
  randomizeManager.toggleXShift(source.isSelected());
}

// TODO: enable/disable corresponding input
public void randYShiftCheckbox_click(GCheckbox source, GEvent event) {
  randomizeManager.toggleYShift(source.isSelected());
}

// Max Shift Percent Inputs ----------------------------------------------------

// TODO: doc, merge common w/ slider inputs
void randMaxInputEventHandler(GTextField source, GEvent event, boolean horizontal) {
  switch(event) {
    case ENTERED:
      // Unfocus on enter, then do same actions as LOST_FOCUS case
      source.setFocus(false);
    case LOST_FOCUS:
      // Sanitize and update manager
      // NOTE: RandomizeManager percent setter methods ensure the value is
      // between 0 and 100
      int val = sanitizeIntegerInputValue(source);
      if (val > -1) {
        randomizeManager.setShiftMaxPercent(val, horizontal);
      } 
      // Update input text to match sanitized input (after RandomizeManager
      // ensures it's a valid percentage)
      // Also reverts input text in the event that it was not a valid numeric
      // value after parsing
      source.setText("" + randomizeManager.shiftMaxPercent(horizontal));
      break;
    default:
      break;
  }
}

public void randXMaxInput_change(GTextField source, GEvent event) {
  randMaxInputEventHandler(source, event, true);
}

public void randYMaxInput_change(GTextField source, GEvent event) {
  randMaxInputEventHandler(source, event, false);
}


