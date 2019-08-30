// =============================================================================
// Extended G4P classes
// =============================================================================

// Channel Toggles =============================================================

// TODO: doc
public class ChannelOption extends GOption {
  // Color channel associated w/ this option
  int channel;
  // Whether this is source or target
  boolean source;

  // TODO: figure out error about constant declarations
  // Text associated w/ channel indices
  String[] CHANNELS = {"R","G","B"};
  // GCSchemes associated w/ channel indices
  int[] SCHEMES = {GCScheme.RED_SCHEME, GCScheme.GREEN_SCHEME, GCScheme.BLUE_SCHEME};

  public ChannelOption(PApplet theApplet, float p0, float p1, float p2, float p3, int channel, boolean source) {
    super(theApplet, p0, p1, p2, p3, "");
    this.channel = channel;
    this.source = source;
    this.setText(this.CHANNELS[this.channel]);
    this.setLocalColorScheme(this.SCHEMES[this.channel]);
    this.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
    this.setOpaque(true);
  }

  public int getChannel() { return this.channel; }

  public boolean isSource() { return this.source; }
}

