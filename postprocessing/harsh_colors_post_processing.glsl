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
// Name: Harsh Colors
// Author: SolarLune
// Date Updated: 2/21/11

// This filter is actually quite like the Reduce filter, but uses if-statements
// instead of rounding, achieving a more numerically correct version. Also, it's a bit
// more difficult to deal with - customizing the bit filters is easy.

uniform sampler2D bgl_RenderedTexture;

void main(void)
{
	vec4 color;

	color = texture2D(bgl_RenderedTexture, gl_TexCoord[0].st);

	if (color.r > 0.75)
		color.r = 1;
	else if (color.r > 0.5)
		color.r = 0.75;
	else if (color.r > 0.25)
		color.r = 0.5;
	else
		color.r = 0;

	if (color.g > 0.75)
		color.g = 1;
	else if (color.g > 0.5)
		color.g = 0.75;
	else if (color.g > 0.25)
		color.g = 0.5;
	else
		color.g = 0;

	if (color.b > 0.75)
		color.b = 1;
	else if (color.b > 0.5)
		color.b = 0.75;
	else if (color.b > 0.25)
		color.b = 0.5;
	else
		color.b = 0;

	gl_FragColor = color;

}