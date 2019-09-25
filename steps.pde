// =============================================================================
// Globals, logic, and event handlers related to confirming, resetting, and
// recording sketch steps
// =============================================================================
import java.util.ArrayList;

// Manager =====================================================================

public class StepManager {
  // Store string representation of info about each step
  ArrayList<String> sketchSteps;
  // References to manager objects for generating step strings
  ChannelManager channelManager;
  ShiftManager xShiftManager, yShiftManager;
  ShiftTypeManager shiftTypeManager;
  ImgManager imgManager;

  public StepManager(ShiftManager xShiftManager, ShiftManager yShiftManager, ChannelManager channelManager, ShiftTypeManager shiftTypeManager, ImgManager imgManager) {
    sketchSteps = new ArrayList<String>();
    this.channelManager = channelManager;
    this.xShiftManager = xShiftManager;
    this.yShiftManager = yShiftManager;
    this.shiftTypeManager = shiftTypeManager;
    this.imgManager = imgManager;
  }

  public String stringifyStep() {
    String step = "";
    step += channelManager.stringifyStep();
    step += xShiftManager.stringifyStep() + yShiftManager.stringifyStep();
    step += shiftTypeManager.stringifyStep();
    if (imgManager.recursiveIteration)
      step += "-rec";
    return step;
  }

  public void commitStep(String step) {
    sketchSteps.add(step);
  }

  public void commitCurrentStep() {
    commitStep(stringifyStep());
  }

  /**
   * Returns true if source and target channels match and x/y shift are both 0
   * and we're using the default shift type
   */
  public boolean noChangesInCurrentStep() {
    return channelManager.channelsMatch() && xShiftManager.shiftIsZero() && yShiftManager.shiftIsZero() && shiftTypeManager.isDefaultType();
  }

  /** 
   * Returns a string representation of the sketch steps so far. Each step is
   * separated by an underscore 
   * 
   * @param includeCurrent If true, append the current step as well
   * @return String representation of the sketch steps
   */
  public String stepsToString(boolean includeCurrent) { 
    String steps = "";
    if (sketchSteps.size() > 0)
      steps += "_" + String.join("_", sketchSteps); 
    if (includeCurrent)
      steps += "_" + stringifyStep();
    return steps; 
  }

  /** 
   * Returns a string representation of the sketch steps so far. Each step is
   * separated by an underscore. If changes were made in the current step,
   * append it to the resulting string
   * 
   * @return String representation of the sketch steps
   */
  public String stepsToString() { return stepsToString(!noChangesInCurrentStep()); }

  public void resetSteps() { sketchSteps.clear(); }
}

// Event Handlers ==============================================================

// Reset Button ----------------------------------------------------------------

/**
 * Reset selected source/target channels and horizontal/vertical shift values
 * for current step
 */
void resetShift() {
  channelManager.resetChannels();
  updateChannelToggles();
  xShiftManager.resetShift();
  yShiftManager.resetShift();
  updateShiftSliders();
}

public void resetBtn_click(GButton source, GEvent event) { 
  resetShift();
  showPreview();
} 

// Confirm Button --------------------------------------------------------------

public void confirmBtn_click(GButton source, GEvent event) { 
  // Display preview
  showPreview();
  // Update sketch steps
  stepManager.commitCurrentStep();
  // Confirm changes from previewImg and update sourceImg if the recursive
  // iteration box is checked
  imgManager.confirmStep();
  // Reset shift values and UI
  resetShift();
} 

