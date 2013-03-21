########## 2D SCREEN FILTER LIBRARY (SFL) ##########
#
# Author: SolarLune and many others
# Date Updated: 3/9/13
#
# This is a library of 2D filters that either
# 1) I made, or
# 2) I Adapted from other scripts (I don't think any were direct copies, just re-adaptation. If I am wrong, though,
# please point it out to me).
#
# Hopefully someone can use them.
#

### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
###
### This script and the functions below
### are under the MIT license agreement, thouhg it would be
### greatly appreciated if you could do one thing if you use it.
###
###
###
### It would be appreciated if you would attribute usage of this module
### or any scripts within, mainly the names of any contributors or authors
### for the functions you use.
###
###
### By using this script, you agree to this license agreement.
###
### You may NOT edit this license agreement.
###
### ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Name: Pixellate
// Author: SolarLune
// Date: 6/6/11
//
// Notes: Pixellates the screen using blocks consisting of cellx size on the
// X-axis and celly size on the Y-axis.

uniform sampler2D bgl_RenderedTexture;
uniform float cellw;
uniform float cellh;
uniform vec2 winsize;

float Round(float value){       // Rounds off the specified number
	if (ceil(value) - value < 0.5)
		return ceil(value);
	else
		return floor(value);
}

void main(void)
{
	vec2 uv = gl_TexCoord[0].xy;

	float dx = cellw * (1.0 / winsize.x);
	float dy = cellh * (1.0 / winsize.y);

	vec2 coord = vec2(dx * Round(uv.x / dx), dy * Round(uv.y / dy));

	coord.x = min(max(0.0, coord.x), 1.0);
	coord.y = min(max(0.0, coord.y), 1.0);

	gl_FragColor = vec4(texture2D(bgl_RenderedTexture, coord));
}