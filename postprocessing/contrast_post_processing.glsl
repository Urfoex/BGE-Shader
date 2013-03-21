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

// Name: Contrast Filter
// Author: SolarLune
// Date Updated: 6/6/11

uniform sampler2D bgl_RenderedTexture;
uniform float contrast;// Multiplication value for contrast (high = more, 0 = none)

void main(void)
{
	vec4 color = texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x, gl_TexCoord[0].st.y));
	float avg = dot(color.rgb, vec3(0.299, 0.587, 0.114));

	float diff = 1.0 + ((avg - 0.5) * contrast);

	color *= diff;

	gl_FragColor = color;
}