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
// Name: Ink
// Author: SolarLune
// Date Updated: 6/6/11

// Notes: Achieves an ink and paint or charcoal type of effect without use of a depth texture - it works on
// the difference from one color to the next.

uniform sampler2D bgl_RenderedTexture;
uniform float thickness;
uniform float edgef;
uniform vec4 col;

void main(void)
{
	float value = 0.001 * thickness;    // Value here controls how large the samples (and hence how thick the lines) are
	vec4 sample = texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x + value, gl_TexCoord[0].st.y + value));
	sample += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x - value, gl_TexCoord[0].st.y - value));
	sample += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x + value, gl_TexCoord[0].st.y - value));
	sample += texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x - value, gl_TexCoord[0].st.y + value));
	sample /= 4.0;
	vec4 center = texture2D(bgl_RenderedTexture, vec2(gl_TexCoord[0].st.x, gl_TexCoord[0].st.y));

	float edge = 0.1 / edgef;          // 'Edge' here controls how easy it is to get an outline on objects

	vec4 diff = vec4(abs(sample.r - center.r), abs(sample.g - center.g), abs(sample.b- center.b), abs(sample.a - center.a));

	if ((diff.r > edge) || (diff.g > edge) || (diff.b > edge))
	{
		vec4 color = vec4(col.rgb, 1.0);
		gl_FragColor = mix(center, color, col.a);
	}
	else
		gl_FragColor = center;
}