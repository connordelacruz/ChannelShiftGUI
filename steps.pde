// =============================================================================
// Globals, logic, and event handlers related to confirming, resetting, and
// recording sketch steps
// =============================================================================
import java.util.ArrayList;

// Globals =====================================================================

// TODO: step manager
// TODO manage index of current step, allow for it to be shared w/ ImgManager for history

// TODO use array, String.join("_", sketchSteps);
// Store shift values and which channels were shifted/swapped. Will be appended
// to default save filename 
String sketchSteps;

// TODO: move to manager?
// Use resulting image as the source for next iteration upon confirming step
boolean recursiveIteration = true;

// Manager =====================================================================

// TODO doc, implement
public class StepManager {
  // Store string representation of info about each step
  ArrayList<String> sketchSteps;

  public StepManager() {
    sketchSteps = new ArrayList<String>();
  }

  // TODO stringifyStep(), commitStep(), resetSteps(), stepsToString() (with way of appending current step)

  // TODO recursiveIteration move to manager?
  public String stringifyStep(ShiftManager xShiftManager, ShiftManager yShiftManager, ChannelManager channelManager, ShiftTypeManager shiftTypeManager, boolean recursiveIteration) {
    String step = "";
    step += channelManager.stringifyStep();
    step += xShiftManager.stringifyStep() + yShiftManager.stringifyStep();
    step += shiftTypeManager.stringifyStep();
    if (recursiveIteration)
      step += "-rec";
    return step;
  }

  // TODO store current stringified step in local so it doesn't have to be passed?
  public void commitStep(String step) {
    sketchSteps.add(step);
  }

  public String stepsToString() { return String.join("_", sketchSteps); }

  public void resetSteps() { sketchSteps.clear(); }

  // TODO return index of most recent step
}

// Helper Methods ==============================================================

// Sketch State ----------------------------------------------------------------

/**
 * Returns true if source and target channels match and x/y shift are both 0
 */
boolean noChangesInCurrentStep() {
  return channelManager.channelsMatch() && xShiftManager.shiftIsZero() && yShiftManager.shiftIsZero();
}

// Recording Steps -------------------------------------------------------------

// TODO handle shift type configs as well
/**
 * Returns a string representation of a channel shift step.
 * @param horizontalShift Amount channel was shifted horizontally
 * @param verticalShift Amount channel was shifted vertically
 * @param sourceChannel Channel from the source image (Index into CHANNELS)
 * @param targetChannel Channel from the target image (Index into CHANNELS)
 * @param recursiveIteration Whether this was a recursive iteration or not
 * @return String representation of the sketch step. The general format is:
 * "s{RGB}-t{RGB}-x{int}-y{int}{-rec}"
 * If source and target channels are the same, a single RGB channel will be
 * listed instead of "s{RGB}-t{RGB}".
 */
String stringifyStep(int horizontalShift, int verticalShift, int sourceChannel, int targetChannel, boolean recursiveIteration) {
  String step = "";
  // Only show what channel was shifted if not swapped
  if (sourceChannel == targetChannel)
    step += CHANNELS[sourceChannel];
  else
    step += "s" + CHANNELS[sourceChannel] + "t" + CHANNELS[targetChannel];
  step += "-x" + horizontalShift;
  step += "-y" + verticalShift;
  if (recursiveIteration)
    step += "-rec";
  return step;
}

/**
 * Returns a string representation of the current sketch step
 */
String stringifyCurrentStep() {
  // TODO: delegate stringify parts to manager classes
  return stringifyStep(xShiftManager.shiftAmount, yShiftManager.shiftAmount, channelManager.sourceChannel, channelManager.targetChannel, recursiveIteration);
}

/**
 * Update sketchSteps using globals
 */
void updateSteps() {
  sketchSteps += "_" + stringifyCurrentStep();
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
  updateSteps();
  // Update targetImg to match preview
  imgManager.copyPreviewToTarget();
  // If recursive, sourceImg.pixels = targetImg.pixels
  if (recursiveIteration)
    imgManager.copyTargetPixelsToSource();
  // Reset shift values and UI
  resetShift();
} 

// Recursive Checkbox ----------------------------------------------------------

public void recursiveCheckbox_click(GCheckbox source, GEvent event) {
  recursiveIteration = source.isSelected();
}

