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
vec4 colround(float value, vec4 color){
	vec4 c = color;
	c *= value;
	c = vec4( ceil(c.r), ceil(c.g), ceil(c.b), ceil(c.a) );
	c /= value;
	return c;
}
       
uniform sampler2D bgl_RenderedTexture;
uniform float coloramt;

void main(void)
{
	vec4 color = texture2D(bgl_RenderedTexture, gl_TexCoord[0].st);
	color = colround(coloramt, color);
	gl_FragColor = color;
}