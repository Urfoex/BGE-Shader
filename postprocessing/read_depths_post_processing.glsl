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
uniform sampler2D bgl_DepthTexture;

void main(void)
{
	vec4 color = texture2D(bgl_DepthTexture, gl_TexCoord[0].st);
	float value = (color.r + color.g + color.b) / 3.0;
	float factor = (1.000 - value) * 16.0000;
	color -= vec4(factor, factor, factor, factor);
	gl_FragColor = color;
}