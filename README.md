# Channel Shift

## Overview

**TODO:** Explain what it does, example images


## Installation

This sketch requires [Processing 3+](https://processing.org/download/) (tested
using Processing 3.5). It uses the [G4P GUI
library](http://www.lagers.org.uk/g4p/), which is included in this repo.


## Controls

**TODO:** GUI screenshot (once finalized)

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

**Note:** If **Target Channel** is unchecked, but **Source Channel** is checked,
the selected target channel will be set to match the selected source channel
when the randomize button is clicked (i.e. the channels will not be swapped).

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

