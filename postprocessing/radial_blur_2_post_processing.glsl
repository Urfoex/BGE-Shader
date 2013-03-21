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
// Name: 16-Sample Radial Blur
// Author: SolarLune
// Date Updated: 6/6/11
//
// Notes: Really, it's more of a diamond blur, but it's blurry enough for me not to care (LOL).

uniform sampler2D bgl_RenderedTexture;
uniform float minimum;
uniform float percentage;

void main(void)
{
	float x = gl_TexCoord[3].st.x;
	float y = gl_TexCoord[3].st.y;
	float value;
	float min = 0.1 * minimum;

	value = ((abs(x - 0.5) - min) + (abs(y - 0.5) - min)) * percentage;

	if (value < 0.0)
		value = 0.0;

	vec4 color = texture2D(bgl_RenderedTexture, gl_TexCoord[0].st);

	value /= 100.0;
	color = texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x + value * 0.25, gl_TexCoord[0].st.y + value * 0.25));
	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x - value * 0.25, gl_TexCoord[0].st.y - value * 0.25));
	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x + value * 0.25, gl_TexCoord[0].st.y - value * 0.25));
	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x - value * 0.25, gl_TexCoord[0].st.y + value * 0.25));

	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x + value * 0.5, gl_TexCoord[0].st.y + value * 0.5));
	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x - value * 0.5, gl_TexCoord[0].st.y - value * 0.5));
	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x + value * 0.5, gl_TexCoord[0].st.y - value * 0.5));
	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x - value * 0.5, gl_TexCoord[0].st.y + value * 0.5));

	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x + value * 0.75, gl_TexCoord[0].st.y + value * 0.75));
	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x - value * 0.75, gl_TexCoord[0].st.y - value * 0.75));
	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x + value * 0.75, gl_TexCoord[0].st.y - value * 0.75));
	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x - value * 0.75, gl_TexCoord[0].st.y + value * 0.75));

	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x + value, gl_TexCoord[0].st.y + value));
	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x - value, gl_TexCoord[0].st.y - value));
	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x + value, gl_TexCoord[0].st.y - value));
	color += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x - value, gl_TexCoord[0].st.y + value));
	color /= 16.0;

	gl_FragColor = color;
}