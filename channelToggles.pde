// =============================================================================
// Globals, logic, and event handlers related to source/target color channels
// =============================================================================
// TODO rename file? "toggles" is sorta specific to GUI

// Constants ===================================================================

// Maps index 0-2 to corresponding color channel. Used as a shorthand when
// making operations more human readable
String[] CHANNELS = new String[]{"R","G","B"};


// Manager Class ===============================================================

/**
 * Manage the state of selected color channels
 */
public class ChannelManager {
  // Source and target channels
  public int sourceChannel, targetChannel;

  public ChannelManager() {
    sourceChannel = targetChannel = 0;
  }

  // Getter/Setter Methods

  public void setSourceChannel(int channel) {
    sourceChannel = channel;
  }

  public void setTargetChannel(int channel) {
    targetChannel = channel;
  }

  public void setChannel(boolean source, int channel) {
    if (source)
      sourceChannel = channel;
    else
      targetChannel = channel;
  }

  public int getChannel(boolean source) {
    return source ? sourceChannel : targetChannel;
  }

  public void setChannels(int source, int target) {
    sourceChannel = source;
    targetChannel = target;
  }

  public int[] getChannels() { 
    return new int[]{ sourceChannel, targetChannel }; 
  }

  // Set target to match source (i.e. don't swap)
  public void linkTargetToSource() { targetChannel = sourceChannel; }

  // Return true if channels match
  public boolean channelsMatch() { return sourceChannel == targetChannel; }

  // Reset channels to default
  public void resetChannels() { sourceChannel = targetChannel = 0; }

  // Randomize channels
  public void randomize(boolean source, boolean target) {
    if (source) {
      sourceChannel = int(random(3));
      // Set target to match source if we're not randomizing it
      if (!target) {
        targetChannel = sourceChannel;
      }
    }
    if (target) {
      targetChannel = int(random(3));
    }
  }

}


// Event Handlers ==============================================================

// Source/Target Channel -------------------------------------------------------

/**
 * Select a source/target channel toggle
 * @param source If true, set sourceChannel, else set targetChannel
 * @param channel Channel to set (Index into CHANNELS)
 */
void setChannelToggle(boolean source, int channel) {
  ChannelOption toggle = source ? srcToggles[channel] : targToggles[channel];
  toggle.setSelected(true);
}

/**
 * Update the selected source/target channel toggle to match the corresponding
 * global variable
 * @param source If true, set sourceChannel, else set targetChannel
 */
void updateChannelToggle(boolean source) {
  setChannelToggle(source, channelManager.getChannel(source));
}

/**
 * Update the selected source and target channel toggles to match global
 * variables. Wrapper that calls updateChannelToggle() for both source and
 * target
 */
void updateChannelToggles() {
  updateChannelToggle(true);
  updateChannelToggle(false);
}

public void channelOption_clicked(ChannelOption source, GEvent event) {
  channelManager.setChannel(source.isSource(), source.getChannel());
  showPreview();
}

