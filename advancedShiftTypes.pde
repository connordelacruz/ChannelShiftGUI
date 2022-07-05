// =============================================================================
// Globals, logic, and event handlers related to advanced shift type options
// =============================================================================

// GLOBALS =====================================================================
// Names of different shift types
String[] SHIFT_TYPES = new String[]{"Default", "Scale", "Linear", "Skew", "XY Multiply", "Noise"};
// Indexes
int TYPE_DEFAULT = 0;
int TYPE_SCALE = 1;
int TYPE_LINEAR = 2;
int TYPE_SKEW = 3;
int TYPE_XYMULT = 4;
int TYPE_NOISE = 5;
// Total # of shift types
int TOTAL_SHIFT_TYPES = SHIFT_TYPES.length;


// SHIFT TYPES =================================================================

// Shift Type Interface --------------------------------------------------------

public interface ShiftTypeState {
  // TODO add public String typeName
  // Calculate offset for this shift type
  public int calculateShiftOffset(int x, int y, int width, int height, int shift, boolean horizontal);
  // String representation of this step
  public String stringifyStep();
}

// Default ---------------------------------------------------------------------

public class DefaultShiftType implements ShiftTypeState {
  public int calculateShiftOffset(int x, int y, int width, int height, int shift, boolean horizontal) {
    return (horizontal ? x : y) + shift;
  }

  public String stringifyStep() {
    // Default requires no additional information
    return "";
  }
}


// Scale -----------------------------------------------------------------------

public class ScaleShiftType implements ShiftTypeState {
  // Multiplier values specific to this shift type
  public float xMultiplier, yMultiplier;

  public ScaleShiftType(float xMult, float yMult) {
    this.xMultiplier = xMult;
    this.yMultiplier = yMult;
  }

  public ScaleShiftType() {
    // Arbitrarily using 2 in the event that this doesn't get set
    this(2.0, 2.0);
  }

  public int calculateShiftOffset(int x, int y, int width, int height, int shift, boolean horizontal) {
    return (int)(horizontal ? x * this.xMultiplier : y * this.yMultiplier) + shift; 
  }

  public String stringifyStep() {
    return "-scale-x" + this.xMultiplier + "y" + this.yMultiplier;
  }

  // Set multipliers
  public void setXMultiplier(float val) { this.xMultiplier = val; }
  public void setYMultiplier(float val) { this.yMultiplier = val; }
  public void setMultiplier(float val, boolean horizontal) {
    if (horizontal)
      this.xMultiplier = val;
    else
      this.yMultiplier = val;
  }
  public void setMultipliers(float xMult, float yMult) {
    this.xMultiplier = xMult;
    this.yMultiplier = yMult;
  }

  // Get multipliers
  public float getMultiplier(boolean horizontal) {
    return horizontal ? this.xMultiplier : this.yMultiplier;
  }
}


// Linear ----------------------------------------------------------------------

public class LinearShiftType implements ShiftTypeState {
  // Coefficient for equation
  public float m;
  // Will be set to +/- 1 to determine coefficient sign
  public float mSign;
  // y=mx+b if true, x=my+b if false
  public boolean yEquals;

  public LinearShiftType(float m, boolean positiveCoeff, boolean yEquals) {
    this.m = m;
    this.mSign = positiveCoeff ? 1 : -1;
    this.yEquals = yEquals;
  }

  public LinearShiftType() {
    this(1.0, true, true);
  }

  public int calculateShiftOffset(int x, int y, int width, int height, int shift, boolean horizontal) {
    int offset;
    // y= equation
    if (this.yEquals) 
      offset = horizontal ? x + (int)((y - shift) / (this.mSign * this.m)) : y + (int)((this.mSign * this.m) * x + shift);
    // x= equation
    else 
      offset = horizontal ? x + (int)((this.mSign * this.m) * y + shift) : y + (int)((x - shift) / (this.mSign * this.m));
    return offset; 
  }

  public String stringifyStep() {
    String step = "-line-";
    String sign = this.isPositiveCoefficient() ? "" : "-";
    if (this.yEquals) {
      step += "y=" + sign + this.m + "x";
    } else {
      step += "x=" + sign + this.m + "y";
    }
    return step;
  }

  // Setters
  public void setCoefficient(float val) { this.m = val; }
  public void setCoefficientSign(boolean positive) { this.mSign = positive ? 1 : -1; }
  public void setEquationType(boolean isYEquals) { this.yEquals = isYEquals; }
  public void yEqualsEquation() { this.setEquationType(true); }
  public void xEqualsEquation() { this.setEquationType(false); }

  // Getters
  public float getCoefficient() { return this.m; }
  public boolean isPositiveCoefficient() { return this.mSign > 0.0; }
  public boolean isYEqualsEquation() { return this.yEquals; }
}


// Skew ------------------------------------------------------------------------

public class SkewShiftType implements ShiftTypeState {
  public float xSkew, ySkew;
  public float xSign, ySign;

  public SkewShiftType(float xSkew, boolean xPositive, float ySkew, boolean yPositive) {
    this.xSkew = xSkew;
    this.ySkew = ySkew;
    this.xSign = xPositive ? 1 : -1;
    this.ySign = yPositive ? 1 : -1;
  }

  public SkewShiftType() {
    this(2.0, true, 2.0, true);
  }

  public int calculateShiftOffset(int x, int y, int width, int height, int shift, boolean horizontal) {
    return horizontal ? x + shift + (int)(this.xSign * this.xSkew * y) : y + shift + (int)(this.ySign * this.ySkew * x);
  }

  public String stringifyStep() {
    String step = "-skew";
    if (this.xSkew > 0.0)
      step += "-x=" + (this.isPositiveX() ? "" : "-") + this.xSkew;
    if (ySkew > 0.0)
      step += "-y=" + (this.isPositiveY() ? "" : "-") + this.ySkew;
    return step;
  }

  // Setters
  public void setXSkew(float val) { this.xSkew = val; }
  public void setYSkew(float val) { this.ySkew = val; }
  public void setSkew(float val, boolean horizontal) { 
    if (horizontal)
      this.xSkew = val;
    else
      this.ySkew = val;
  }
  public void setXSign(boolean positive) { this.xSign = positive ? 1 : -1; }
  public void setYSign(boolean positive) { this.ySign = positive ? 1 : -1; }
  public void setSign(boolean positive, boolean horizontal) {
    if (horizontal)
      this.setXSign(positive);
    else
      this.setYSign(positive);
  }

  // Getters
  public float getXSkew() { return this.xSkew; }
  public float getYSkew() { return this.ySkew; }
  public float getSkew(boolean horizontal) { return horizontal ? this.xSkew : this.ySkew; }
  public boolean isPositiveX() { return this.xSign > 0.0; }
  public boolean isPositiveY() { return this.ySign > 0.0; }
  public boolean isPositive(boolean horizontal) { return horizontal ? this.isPositiveX() : this.isPositiveY(); }
}


// X*Y -------------------------------------------------------------------------

public class XYMultShiftType implements ShiftTypeState {
  public boolean multX, multY;
  public float xSign, ySign;
  public boolean xDivWidth, yDivHeight;
  // TODO: bool to div by different dimension?

  public XYMultShiftType(boolean multX, boolean xPositive, boolean xDivWidth, 
                         boolean multY, boolean yPositive, boolean yDivHeight) {
    this.multX = multX;
    this.multY = multY;
    this.xSign = xPositive ? 1 : -1;
    this.ySign = yPositive ? 1 : -1;
    this.xDivWidth = xDivWidth;
    this.yDivHeight = yDivHeight;
  }
  public XYMultShiftType() {
    this(true, true, true, false, true, true);
  }

  // TODO: play around with this, find way to scale effect when divided by 1?
  public int calculateShiftOffset(int x, int y, int width, int height, int shift, boolean horizontal) {
    if (horizontal)
      return x + shift + (this.multX ? (int)(this.xSign*x*y / (this.xDivWidth ? width : 1)) : 0);
    else
      return y + shift + (this.multY ? (int)(this.ySign*y*x / (this.yDivHeight ? height : 1)) : 0);
  }

  public String stringifyStep() {
    String step = "-xymult";
    if (multX)
      step += (this.isPositiveX() ? "+" : "-") + "x" + (this.xDivWidth ? "divW" : "");
    if (multY)
      step += (this.isPositiveY() ? "+" : "-") + "y" + (this.yDivHeight ? "divH" : "");
    return step;
  }

  // Setters
  public void setMultX(boolean multiply) { this.multX = multiply; }
  public void setMultY(boolean multiply) { this.multY = multiply; }
  public void setXSign(boolean positive) { this.xSign = positive ? 1 : -1; }
  public void setYSign(boolean positive) { this.ySign = positive ? 1 : -1; }
  public void setXDivWidth(boolean divWidth) { this.xDivWidth = divWidth; }
  public void setYDivHeight(boolean divHeight) { this.yDivHeight = divHeight; }

  // Getters
  public boolean multX() { return this.multX; }
  public boolean multY() { return this.multY; }
  public boolean isPositiveX() { return this.xSign > 0.0; }
  public boolean isPositiveY() { return this.ySign > 0.0; }
  public boolean divideXByWidth() { return this.xDivWidth; }
  public boolean divideYByHeight() { return this.yDivHeight; }
}


// Noise -----------------------------------------------------------------------

public class NoiseShiftType implements ShiftTypeState {
  public float xNoiseStart, yNoiseStart;
  public float xNoiseIncrement, yNoiseIncrement;
  public float noiseMultiplier;

  // TODO: noiseSeed??
  public NoiseShiftType(float xNoiseStart, float yNoiseStart, float xNoiseIncrement, float yNoiseIncrement, float noiseMultiplier) {
    this.xNoiseStart = xNoiseStart;
    this.yNoiseStart = yNoiseStart;
    this.xNoiseIncrement = xNoiseIncrement;
    this.yNoiseIncrement = yNoiseIncrement;
    this.noiseMultiplier = noiseMultiplier;
  }

  public NoiseShiftType() {
    this(0.01, 0.01, 0.001, 0.001, 25.0);
  }

  public int calculateShiftOffset(int x, int y, int width, int height, int shift, boolean horizontal) {
    float xNoise = this.xNoiseStart + (this.xNoiseIncrement * x);
    float yNoise = this.yNoiseStart + (this.yNoiseIncrement * y);
    return (horizontal ? x : y) + shift + (int)(this.noiseMultiplier * noise(xNoise, yNoise));
  }

  public String stringifyStep() {
    String step = "-noise-x" + this.xNoiseStart + "+" + this.xNoiseIncrement + "-y" + this.yNoiseStart + "+" + this.yNoiseIncrement + "mult" + this.noiseMultiplier;
    return step;
  }
  
  // Setters
  public void setXNoiseStart(float val) { this.xNoiseStart = val; }
  public void setYNoiseStart(float val) { this.yNoiseStart = val; }
  public void setXNoiseIncrement(float val) { this.xNoiseIncrement = val; }
  public void setYNoiseIncrement(float val) { this.yNoiseIncrement = val; }
  public void setNoiseMultiplier(float val) { this.noiseMultiplier = val; }
  // Getters
  public float getXNoiseStart() { return this.xNoiseStart; }
  public float getYNoiseStart() { return this.yNoiseStart; }
  public float getXNoiseIncrement() { return this.xNoiseIncrement; }
  public float getYNoiseIncrement() { return this.yNoiseIncrement; }
  public float getNoiseMultiplier() { return this.noiseMultiplier; }
}


// Manager =====================================================================

public class ShiftTypeManager {
  // Array of state objects
  ShiftTypeState[] shiftTypes;
  // Current state index
  public int state;

  public ShiftTypeManager() {
    this.shiftTypes = new ShiftTypeState[TOTAL_SHIFT_TYPES];
    // Initialize state objects
    this.shiftTypes[TYPE_DEFAULT] = new DefaultShiftType();
    this.shiftTypes[TYPE_SCALE] = new ScaleShiftType();
    this.shiftTypes[TYPE_LINEAR] = new LinearShiftType();
    this.shiftTypes[TYPE_SKEW] = new SkewShiftType();
    this.shiftTypes[TYPE_XYMULT] = new XYMultShiftType();
    this.shiftTypes[TYPE_NOISE] = new NoiseShiftType();
    // Start w/ default
    this.state = TYPE_DEFAULT;
  }

  public int calculateShiftOffset(int x, int y, int width, int height, int shift, boolean horizontal) {
    return this.shiftTypes[state].calculateShiftOffset(x, y, width, height, shift, horizontal);
  }

  public void setShiftType(int shiftType) {
    // Handle out of bounds index
    state = shiftType < this.shiftTypes.length ? shiftType : 0;
  }

  public boolean isDefaultType() { return this.state == TYPE_DEFAULT; }

  public String stringifyStep() { return this.shiftTypes[state].stringifyStep(); }

  // Config Setters

  // Scale
  public void scale_setMultiplier(float val, boolean horizontal) {
    ((ScaleShiftType)this.shiftTypes[TYPE_SCALE]).setMultiplier(val, horizontal);
  }
  public float scale_getMultiplier(boolean horizontal) {
    return ((ScaleShiftType)this.shiftTypes[TYPE_SCALE]).getMultiplier(horizontal);
  }

  // Linear
  public void linear_setCoefficient(float val) {
    ((LinearShiftType)this.shiftTypes[TYPE_LINEAR]).setCoefficient(val);
  }
  public float linear_getCoefficient() {
    return ((LinearShiftType)this.shiftTypes[TYPE_LINEAR]).getCoefficient();
  }
  public void linear_setCoefficientSign(boolean positive) {
    ((LinearShiftType)this.shiftTypes[TYPE_LINEAR]).setCoefficientSign(positive);
  }
  public boolean linear_isPositiveCoefficient() {
    return ((LinearShiftType)this.shiftTypes[TYPE_LINEAR]).isPositiveCoefficient();
  }
  public void linear_setEquationType(boolean isYEquals) {
    ((LinearShiftType)this.shiftTypes[TYPE_LINEAR]).setEquationType(isYEquals);
  }
  public boolean linear_isYEqualsEquation() {
    return ((LinearShiftType)this.shiftTypes[TYPE_LINEAR]).isYEqualsEquation();
  }

  // Skew
  public void skew_setSkew(float val, boolean horizontal) {
    ((SkewShiftType)this.shiftTypes[TYPE_SKEW]).setSkew(val, horizontal);
  }
  public float skew_getSkew(boolean horizontal) {
    return ((SkewShiftType)this.shiftTypes[TYPE_SKEW]).getSkew(horizontal);
  }
  public void skew_setSign(boolean positive, boolean horizontal) {
    ((SkewShiftType)this.shiftTypes[TYPE_SKEW]).setSign(positive, horizontal);
  }
  public boolean skew_isPositive(boolean horizontal) {
    return ((SkewShiftType)this.shiftTypes[TYPE_SKEW]).isPositive(horizontal);
  }

  // X*Y
  public void xymult_setMultX(boolean multiply) {
    ((XYMultShiftType)this.shiftTypes[TYPE_XYMULT]).setMultX(multiply);
  }
  public boolean xymult_multX() {
    return ((XYMultShiftType)this.shiftTypes[TYPE_XYMULT]).multX();
  }
  public void xymult_setMultY(boolean multiply) {
    ((XYMultShiftType)this.shiftTypes[TYPE_XYMULT]).setMultY(multiply);
  }
  public boolean xymult_multY() {
    return ((XYMultShiftType)this.shiftTypes[TYPE_XYMULT]).multY();
  }
  public void xymult_setXSign(boolean positive) {
    ((XYMultShiftType)this.shiftTypes[TYPE_XYMULT]).setXSign(positive);
  }
  public boolean xymult_isPositiveX() {
    return ((XYMultShiftType)this.shiftTypes[TYPE_XYMULT]).isPositiveX();
  }
  public void xymult_setYSign(boolean positive) {
    ((XYMultShiftType)this.shiftTypes[TYPE_XYMULT]).setYSign(positive);
  }
  public boolean xymult_isPositiveY() {
    return ((XYMultShiftType)this.shiftTypes[TYPE_XYMULT]).isPositiveY();
  }
  public void xymult_setXDivWidth(boolean divWidth) {
    ((XYMultShiftType)this.shiftTypes[TYPE_XYMULT]).setXDivWidth(divWidth);
  }
  public boolean xymult_divideXByWidth() {
    return ((XYMultShiftType)this.shiftTypes[TYPE_XYMULT]).divideXByWidth();
  }
  public void xymult_setYDivHeight(boolean divHeight) {
    ((XYMultShiftType)this.shiftTypes[TYPE_XYMULT]).setYDivHeight(divHeight);
  }
  public boolean xymult_divideYByHeight() {
    return ((XYMultShiftType)this.shiftTypes[TYPE_XYMULT]).divideYByHeight();
  }

  // Noise
  public void noise_setXNoiseStart(float val) {
    ((NoiseShiftType)this.shiftTypes[TYPE_NOISE]).setXNoiseStart(val);
  }
  public float noise_xNoiseStart() {
    return ((NoiseShiftType)this.shiftTypes[TYPE_NOISE]).getXNoiseStart();
  }
  public void noise_setYNoiseStart(float val) {
    ((NoiseShiftType)this.shiftTypes[TYPE_NOISE]).setYNoiseStart(val);
  }
  public float noise_yNoiseStart() {
    return ((NoiseShiftType)this.shiftTypes[TYPE_NOISE]).getYNoiseStart();
  }
  public void noise_setXNoiseIncrement(float val) {
    ((NoiseShiftType)this.shiftTypes[TYPE_NOISE]).setXNoiseIncrement(val);
  }
  public float noise_xNoiseIncrement() {
    return ((NoiseShiftType)this.shiftTypes[TYPE_NOISE]).getXNoiseIncrement();
  }
  public void noise_setYNoiseIncrement(float val) {
    ((NoiseShiftType)this.shiftTypes[TYPE_NOISE]).setYNoiseIncrement(val);
  }
  public float noise_yNoiseIncrement() {
    return ((NoiseShiftType)this.shiftTypes[TYPE_NOISE]).getYNoiseIncrement();
  }
  public void noise_setNoiseMultiplier(float val) {
    ((NoiseShiftType)this.shiftTypes[TYPE_NOISE]).setNoiseMultiplier(val);
  }
  public float noise_noiseMultiplier() {
    return ((NoiseShiftType)this.shiftTypes[TYPE_NOISE]).getNoiseMultiplier();
  }
}

