// =============================================================================
// Globals, logic, and event handlers related to shift type variations
// =============================================================================

// Constants ===================================================================

// Names of different shift types
// TODO update names (Multiply -> Scale? X*Y -> Multiply Dimensions?)
String[] SHIFT_TYPES = new String[]{"Default", "Multiply", "Linear", "Skew", "X*Y"};
// Indexes
int TYPE_DEFAULT = 0;
int TYPE_MULTIPLY = 1;
int TYPE_LINEAR = 2;
int TYPE_SKEW = 3;
int TYPE_XYMULT = 4;
// Total # of shift types
int TOTAL_SHIFT_TYPES = SHIFT_TYPES.length;


// Manager/State Classes =======================================================

// Shift Type Interface --------------------------------------------------------

public interface ShiftTypeState {
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

// Multiply --------------------------------------------------------------------

public class MultiplyShiftType implements ShiftTypeState {
  // Multiplier values specific to this shift type
  public float xMultiplier, yMultiplier;
  // TODO negative multipliers?

  public MultiplyShiftType(float xMult, float yMult) {
    xMultiplier = xMult;
    yMultiplier = yMult;
  }

  public MultiplyShiftType() {
    // Arbitrarily using 2 in the event that this doesn't get set
    this(2.0, 2.0);
  }

  public int calculateShiftOffset(int x, int y, int width, int height, int shift, boolean horizontal) {
    return (int)(horizontal ? x * xMultiplier : y * yMultiplier) + shift; 
  }

  public String stringifyStep() {
    return "-mult-x" + xMultiplier + "y" + yMultiplier;
  }

  // Set multipliers
  public void setXMultiplier(float val) { xMultiplier = val; }
  public void setYMultiplier(float val) { yMultiplier = val; }
  public void setMultiplier(float val, boolean horizontal) {
    if (horizontal)
      xMultiplier = val;
    else
      yMultiplier = val;
  }
  public void setMultipliers(float xMult, float yMult) {
    xMultiplier = xMult;
    yMultiplier = yMult;
  }

  // Get multipliers
  public float getMultiplier(boolean horizontal) {
    return horizontal ? xMultiplier : yMultiplier;
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
    if (yEquals) 
      offset = horizontal ? x + (int)((y - shift) / (mSign * m)) : y + (int)((mSign * m) * x + shift);
    // x= equation
    else 
      offset = horizontal ? x + (int)((mSign * m) * y + shift) : y + (int)((x - shift) / (mSign * m));
    return offset; 
  }

  public String stringifyStep() {
    String step = "-line-";
    String sign = isPositiveCoefficient() ? "" : "-";
    if (yEquals) {
      step += "y=" + sign + m + "x";
    } else {
      step += "x=" + sign + m + "y";
    }
    return step;
  }

  // Setters
  public void setCoefficient(float val) { m = val; }
  public void setCoefficientSign(boolean positive) { mSign = positive ? 1 : -1; }
  public void setEquationType(boolean isYEquals) { yEquals = isYEquals; }
  public void yEqualsEquation() { setEquationType(true); }
  public void xEqualsEquation() { setEquationType(false); }

  // Getters
  public float getCoefficient() { return m; }
  public boolean isPositiveCoefficient() { return mSign > 0.0; }
  public boolean isYEqualsEquation() { return yEquals; }
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
    return horizontal ? x + shift + (int)(xSign * xSkew * y) : y + shift + (int)(ySign * ySkew * x);
  }

  public String stringifyStep() {
    String step = "-skew";
    if (xSkew > 0.0)
      step += "-x=" + (isPositiveX() ? "" : "-") + xSkew;
    if (ySkew > 0.0)
      step += "-y=" + (isPositiveY() ? "" : "-") + ySkew;
    return step;
  }

  // Setters
  public void setXSkew(float val) { xSkew = val; }
  public void setYSkew(float val) { ySkew = val; }
  public void setSkew(float val, boolean horizontal) { 
    if (horizontal)
      xSkew = val;
    else
      ySkew = val;
  }
  public void setXSign(boolean positive) { xSign = positive ? 1 : -1; }
  public void setYSign(boolean positive) { ySign = positive ? 1 : -1; }
  public void setSign(boolean positive, boolean horizontal) {
    if (horizontal)
      setXSign(positive);
    else
      setYSign(positive);
  }

  // Getters
  public float getXSkew() { return xSkew; }
  public float getYSkew() { return ySkew; }
  public float getSkew(boolean horizontal) { return horizontal ? xSkew : ySkew; }
  public boolean isPositiveX() { return xSign > 0.0; }
  public boolean isPositiveY() { return ySign > 0.0; }
  public boolean isPositive(boolean horizontal) { return horizontal ? isPositiveX() : isPositiveY(); }
}

// TODO NAME -------------------------------------------------------------------

public class XYMultShiftType implements ShiftTypeState {
  public boolean multX, multY;
  public float xSign, ySign;

  // TODO coeff
  public XYMultShiftType(boolean multX, boolean xPositive, boolean multY, boolean yPositive) {
    this.multX = multX;
    this.multY = multY;
    this.xSign = xPositive ? 1 : -1;
    this.ySign = yPositive ? 1 : -1;
  }
  public XYMultShiftType() {
    // TODO: defaults?
    this(true, true, false, true);
  }

  // TODO make stuff configurable, try dimension * shift instead of x*y?
  // TODO flip divisor? (w/o dividing by 0)
  public int calculateShiftOffset(int x, int y, int width, int height, int shift, boolean horizontal) {
    if (horizontal)
      return x + shift + (multX ? (int)(xSign*x*y / height) : 0);
    else
      return y + shift + (multY ? (int)(ySign*y*x / width) : 0);
  }

  public String stringifyStep() {
    String step = "-xymult";
    // TODO config details
    return step;
  }

  // Setters
  public void setMultX(boolean multiply) { multX = multiply; }
  public void setMultY(boolean multiply) { multY = multiply; }
  public void setXSign(boolean positive) { xSign = positive ? 1 : -1; }
  public void setYSign(boolean positive) { ySign = positive ? 1 : -1; }

  // TODO Getters
}

// Manager ---------------------------------------------------------------------

public class ShiftTypeManager {
  // Array of state objects
  ShiftTypeState[] shiftTypes;
  // Current state index
  public int state;

  public ShiftTypeManager() {
    shiftTypes = new ShiftTypeState[TOTAL_SHIFT_TYPES];
    // Initialize state objects
    shiftTypes[TYPE_DEFAULT] = new DefaultShiftType();
    shiftTypes[TYPE_MULTIPLY] = new MultiplyShiftType();
    shiftTypes[TYPE_LINEAR] = new LinearShiftType();
    shiftTypes[TYPE_SKEW] = new SkewShiftType();
    shiftTypes[TYPE_XYMULT] = new XYMultShiftType();
    // Start w/ default
    state = TYPE_DEFAULT;
  }

  public int calculateShiftOffset(int x, int y, int width, int height, int shift, boolean horizontal) {
    return shiftTypes[state].calculateShiftOffset(x, y, width, height, shift, horizontal);
  }

  public void setShiftType(int shiftType) {
    // Handle out of bounds index
    state = shiftType < shiftTypes.length ? shiftType : 0;
  }

  public boolean isDefaultType() { return state == TYPE_DEFAULT; }

  public String stringifyStep() { return shiftTypes[state].stringifyStep(); }

  // Config Setters

  // Multiply
  public void multiply_setMultiplier(float val, boolean horizontal) {
    ((MultiplyShiftType)shiftTypes[TYPE_MULTIPLY]).setMultiplier(val, horizontal);
  }
  public float multiply_getMultiplier(boolean horizontal) {
    return ((MultiplyShiftType)shiftTypes[TYPE_MULTIPLY]).getMultiplier(horizontal);
  }

  // Linear
  public void linear_setCoefficient(float val) {
    ((LinearShiftType)shiftTypes[TYPE_LINEAR]).setCoefficient(val);
  }
  public float linear_getCoefficient() {
    return ((LinearShiftType)shiftTypes[TYPE_LINEAR]).getCoefficient();
  }
  public void linear_setCoefficientSign(boolean positive) {
    ((LinearShiftType)shiftTypes[TYPE_LINEAR]).setCoefficientSign(positive);
  }
  public boolean linear_isPositiveCoefficient() {
    return ((LinearShiftType)shiftTypes[TYPE_LINEAR]).isPositiveCoefficient();
  }
  public void linear_setEquationType(boolean isYEquals) {
    ((LinearShiftType)shiftTypes[TYPE_LINEAR]).setEquationType(isYEquals);
  }
  public boolean linear_isYEqualsEquation() {
    return ((LinearShiftType)shiftTypes[TYPE_LINEAR]).isYEqualsEquation();
  }

  // Skew
  public void skew_setSkew(float val, boolean horizontal) {
    ((SkewShiftType)shiftTypes[TYPE_SKEW]).setSkew(val, horizontal);
  }
  public float skew_getSkew(boolean horizontal) {
    return ((SkewShiftType)shiftTypes[TYPE_SKEW]).getSkew(horizontal);
  }
  public void skew_setSign(boolean positive, boolean horizontal) {
    ((SkewShiftType)shiftTypes[TYPE_SKEW]).setSign(positive, horizontal);
  }
  public boolean skew_isPositive(boolean horizontal) {
    return ((SkewShiftType)shiftTypes[TYPE_SKEW]).isPositive(horizontal);
  }

  // X*Y
  // TODO getters
  public void xymult_setMultX(boolean multiply) {
    ((XYMultShiftType)shiftTypes[TYPE_XYMULT]).setMultX(multiply);
  }
  public void xymult_setMultY(boolean multiply) {
    ((XYMultShiftType)shiftTypes[TYPE_XYMULT]).setMultY(multiply);
  }
  public void xymult_setXSign(boolean positive) {
    ((XYMultShiftType)shiftTypes[TYPE_XYMULT]).setXSign(positive);
  }
  public void xymult_setYSign(boolean positive) {
    ((XYMultShiftType)shiftTypes[TYPE_XYMULT]).setYSign(positive);
  }

}


// Event Handlers ==============================================================

// Shift Type ------------------------------------------------------------------

public void shiftTypeSelect_change(GDropList source, GEvent event) {
  // Hide previously selected panel
  hideShiftTypePanel(shiftTypeConfigPanels[shiftTypeManager.state]);
  shiftTypeManager.setShiftType(source.getSelectedIndex());
  // Show newly selected panel
  showShiftTypePanel(shiftTypeConfigPanels[shiftTypeManager.state]);
  showPreview();
}

// Multiply Configs ------------------------------------------------------------

void multiplierInputEventHandler(GTextField source, GEvent event, boolean horizontal) {
  switch(event) {
    case ENTERED:
      // Unfocus on enter, then do same actions as LOST_FOCUS case
      source.setFocus(false);
    case LOST_FOCUS:
      // Sanitize and update manager
      float val = sanitizeFloatInputValue(source);
      if (val > -1.0) {
        shiftTypeManager.multiply_setMultiplier(val, horizontal);
        showPreview();
      } 
      // Update input text to match sanitized input 
      // Also reverts input text in the event that it was not a valid numeric
      // value after parsing
      source.setText("" + shiftTypeManager.multiply_getMultiplier(horizontal));
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

// Linear Configs --------------------------------------------------------------

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

// TODO FIXME sometimes reverts even when checkbox isn't checked
public void linearNegativeCoeffCheckbox_click(GCheckbox source, GEvent event) {
  shiftTypeManager.linear_setCoefficientSign(!source.isSelected());
  showPreview();
}

// Skew Configs ----------------------------------------------------------------

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

// X*Y Configs -----------------------------------------------------------------

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

