# RGB Channel Shift Tool

This Processing sketch provides a GUI interface for datamoshing images by
manipulating RGB color channels.


<!-- vim-markdown-toc GFM -->

* [Overview](#overview)
* [Installation](#installation)
* [Features](#features)
    * [Swap Color Channels](#swap-color-channels)
    * [Shift Color Channels](#shift-color-channels)
    * [Recursive Iterations](#recursive-iterations)
    * [Randomization](#randomization)
    * [Experimental Shift Types](#experimental-shift-types)
* [Controls](#controls)
    * [Color Channels](#color-channels)
        * [Source Channel](#source-channel)
        * [Target Channel](#target-channel)
    * [Horizontal/Vertical Shift](#horizontalvertical-shift)
    * [Randomize Options](#randomize-options)
        * [Toggle Randomization Options](#toggle-randomization-options)
        * [Set Random Shift Threshold](#set-random-shift-threshold)
    * [Confirm Step](#confirm-step)
    * [Reset Step](#reset-step)
    * [Save Current Result](#save-current-result)
    * [Load a New Source Image](#load-a-new-source-image)
    * [Advanced Options](#advanced-options)
* [Experimental Shift Types](#experimental-shift-types-1)
    * [Scale](#scale)
        * [Options](#options)
        * [Shift Calculation](#shift-calculation)
    * [Linear](#linear)
        * [Options](#options-1)
        * [Shift Calculation](#shift-calculation-1)
            * [y=mx+b](#ymxb)
            * [x=my+b](#xmyb)
    * [Skew](#skew)
        * [Options](#options-2)
        * [Shift Calculation](#shift-calculation-2)
    * [XY Multiply](#xy-multiply)
        * [Options](#options-3)
        * [Shift Calculation](#shift-calculation-3)
    * [Noise](#noise)
        * [Options](#options-4)
        * [Shift Calculation](#shift-calculation-4)

<!-- vim-markdown-toc -->

## Overview

The basic features of this tool allow you to shift color channels vertically and
horizontally, as well as swap color channels with each other:

![Basic Showcase](../assets/samples/basic-showcase.png?raw=true)

It also includes experimental shift types that modify how pixels are shifted,
which can be combined for interesting effects:

![Advanced Showcase](../assets/samples/advanced-showcase.png?raw=true)


## Installation

This sketch requires [Processing 3+](https://processing.org/download/) (tested
using Processing 3.5). 

After installing Processing 3, clone the repo:

```
git clone https://github.com/connordelacruz/ChannelShiftGUI.git
```

This sketch uses the [G4P GUI library](http://www.lagers.org.uk/g4p/), which is
included in this repo, so no additional setup is required.


## Features

### Swap Color Channels

Swap the selected channel from the source image with the selected channel from
the target image.

### Shift Color Channels

Shift the selected source image channel horizontally and/or vertically on the
target image.

### Recursive Iterations

Use the target image as the source for subsequent iterations.

### Randomization

Target channel, source channel, horizontal shift, and vertical shift can all be
randomized. You can select/deselect which options to randomize, as well as set a
max threshold for vertical and horizontal shift amounts.

### Experimental Shift Types

By default, horizontal and vertical shifts translate the color channel along the
x and y axes, respectively. You can also select experimental shift types with
their own advanced options that modify how each pixel is shifted based on a
number of conditions in addition to the horizontal/vertical shift amounts. 

For explanations and examples of each type, see [Experimental Shift
Types](#experimental-shift-types-1).

## Controls

![GUI](../assets/screenshots/gui.png?raw=true)

### Color Channels

#### Source Channel

Selects the color channel from the source image to be shifted.

#### Target Channel

Selects the color channel from the result image to swap the source channel with.
If you don't want to swap channels, set this to the same option as the source
channel.


### Horizontal/Vertical Shift

The horizontal and vertical shift sliders offset the selected source channel
along the X and Y axis, respectively. 

By default, both sliders use percentage values. If you want to set an exact
pixel distance to shift by, select the **Pixels** option to the right of the
slider.

You can also set the shift value manually using the text input to the left of
the sliders.


### Randomize Options

The **Randomize Options** panel is used to randomize the current step.

#### Toggle Randomization Options

By default, all options are randomized. You can uncheck the boxes of any options
you do not want to randomize.

#### Set Random Shift Threshold

The **Max Horizontal/Vertical Shift %** inputs can be used to put a limit on the
randomized shift values. For example, setting **Max Horizontal Shift %** to 10
will only result in random horizontal shift values of 10% of the image width or
less. 

**Note:** that neither of these inputs will have any effect if the corresponding
**Horizontal/Vertical Shift** checkbox is unchecked.


### Confirm Step

To commit the current channel shift step, click the **Confirm Step** button.
This will update the working image to match the preview and reset all
configurations so you can apply another step.

If the **Recursive** checkbox is checked upon clicking the confirm button, the
source image pixels will be updated to match the shifted image, so further
channel shifts/swaps will be applied based on the shifted image instead of the
original image. Otherwise, further channel shifts/swaps will be based on the
original channels.


### Reset Step

To revert the current step to the default, click the **Reset Step** button. Note
that this will not affect any previously confirmed steps.


### Save Current Result

To save the current result shown in the preview window, click the **Save
Result** button. This will bring up the system "Save As" dialog.


### Load a New Source Image

To load a source image, click the **Load Image** button and select the desired
image file. Note that this will clear the current result, so be sure to save it
before loading if you don't want to lose your work.

### Advanced Options

The advanced options panel allows you to select the shift type and has
configurations specific to each one. The default shift type has no advanced
options, but selecting an experimental shift type from the dropdown will show
its specific settings in this panel. See the following section for details on
each experimental shift type.


## Experimental Shift Types

The following section describes the different experimental shift types in the
**Advanced Options** panel, as well as the way each pixel's horizontal and
vertical shift is calculated.

### Scale

![Scale shift type](../assets/samples/scale.png?raw=true)

Scales the width and length of the channel by the specified multiplier.
Multipliers greater than 1.0 shrink the image dimension and create a tiling
effect. Multipliers less than 1.0 scale the image dimension up.

#### Options

- **Horizontal Shift Multiplier:** Value to multiply the width by
- **Vertical Shift Multiplier:** Value to multiply the height by

#### Shift Calculation

```
(coordinate * multiplier) + shift
```

Where:

- `coordinate`: x if horizontal, y if vertical
- `multiplier`: the configured horizontal/vertical shift multiplier
- `shift`: the horizontal/vertical shift amount


### Linear

![Linear shift type](../assets/samples/linear.png?raw=true)

Uses a linear equation to calculate shift offset.

#### Options

- **Equation Type:** select whether the linear equation format is y=mx+b or
  x=my+b
- **Slope (m):** the slope of the linear equation
- **Negative Slope:** if checked, multiply slope (m) by -1

#### Shift Calculation

Calculations for x/y offset are determined by solving the equation for x/y,
respectively.

##### y=mx+b

**Horizontal Offset:**

```
x + (int)((y - shift) / (mSign * m))
```

**Vertical Offset:**

```
y + (int)((mSign * m) * x + shift)
```

Where:

- `x` and `y`: the coordinates of the pixel
- `shift`: the horizontal/vertical shift amount
- `m`: the configured slope
- `mSign`: 1 if positive slope, -1 if negative slope

##### x=my+b

**Horizontal Offset:**

```
x + (int)((mSign * m) * y + shift)
```

**Vertical Offset:**

```
y + (int)((x - shift) / (mSign * m))
```

Where:

- `x` and `y`: the coordinates of the pixel
- `shift`: the horizontal/vertical shift amount
- `m`: the configured slope
- `mSign`: 1 if positive slope, -1 if negative slope


### Skew

![Skew shift type](../assets/samples/skew.png?raw=true)

Skew/shear the channel.

#### Options

- **Horizontal/Vertical Skew:** the amount to skew along the x/y axis
- **Negative X/Y Skew:** if checked, invert the skew direction along the
  corresponding axis

#### Shift Calculation

**Horizontal Offset:**

```
x + shift + (int)(xSign * xSkew * y)
```

**Vertical Offset:**

```
y + shift + (int)(ySign * ySkew * x)
```

Where:

- `x` and `y`: the coordinates of the pixel
- `shift`: the horizontal/vertical shift amount
- `xSkew` and `ySkew`: the horizontal and vertical skew amounts, respectively
- `xSign` and `ySign`: 1 if positive skew, -1 if negative for the corresponding
  dimension

### XY Multiply

![XY Multiply shift type](../assets/samples/xy-mult.png?raw=true)

Multiply the x/y coordinates of a pixel and divide it by the corresponding
dimension, so the shift modifier becomes more drastic for one dimension as the
other dimension increases. (Kind of a weird one, leads to some cool results.
Recommend playing around with different configurations)

#### Options

- **x shift + (x*y/height):** if checked, add x\*y/height to horizontal shift
- **y shift + (y*x/width):** if checked, add y\*x/width to vertical shift
- **Negative X/Y Coefficient:** if checked, multiply the corresponding
  coordinate's shift modifier by -1

#### Shift Calculation

**Horizontal Offset:**

If **x shift + (x*y/height):** is checked:

```
x + shift + (int)(xSign*x*y / height)
```

(otherwise it's just `x + shift`)

**Vertical Offset:**

If **y shift + (y*x/width):** is checked:

```
y + shift + (int)(ySign*y*x / width)
```

(otherwise it's just `y + shift`)

Where:

- `x` and `y`: the coordinates of the pixel
- `shift`: the horizontal/vertical shift amount
- `xSign` and `ySign`: 1 if positive coefficient, -1 if negative for the
  corresponding dimension


### Noise

![Noise shift type](../assets/samples/noise.png?raw=true)

Apply [Perlin noise](https://en.wikipedia.org/wiki/Perlin_noise) to the shift amount.

#### Options

- **X Start:** Starting value for x noise
- **Y Start:** Starting value for y noise
- **X Step:** Amount to increment x by each time `noise()` is called. Use a smaller number for smoother results
- **Y Step:** Amount to increment y by each time `noise()` is called. Use a smaller number for smoother results
- **Noise Multiplier:** Value to multiply result of `noise()` by. Higher values create more drastic effects

#### Shift Calculation

**Horizontal Offset:**

```
x + shift + (int)(noiseMultiplier * noise(xNoise, yNoise))
```

**Vertical Offset:**


```
y + shift + (int)(noiseMultiplier * noise(xNoise, yNoise))
```

Where:

- `x` and `y`: the coordinates of the pixel
- `shift`: the horizontal/vertical shift amount
- `noiseMultiplier`: the noise multiplier value
- `xNoise` and `yNoise`: noise coordinates, calculated by adding offset to start value each time the corresponding coordinate (`x` or `y`) is incremented

