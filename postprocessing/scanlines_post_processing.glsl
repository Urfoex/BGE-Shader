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
// CRT scanline effect

uniform sampler2D bgl_RenderedTexture;
uniform float samplesize;
uniform float pixelcount;
uniform float scanwidth;
uniform float scandarkness;
uniform float scancontrast;

void main()
{
	vec4 sum = vec4(0);
	vec2 texcoord = vec2(gl_TexCoord[0]);
	vec4 center = texture2D(bgl_RenderedTexture, texcoord);

	float width = 0.002 * samplesize;       // width = how wide of a sample to use (is repeated 32 times below (8 times vertically, 4 times for each of those vertically)

	sum += texture2D(bgl_RenderedTexture, texcoord);
	sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(-1, -1)*width));
	sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(1, -1)*width));
	sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(1, 1)*width));
	sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(-1, 1)*width));

	sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(-0.5, -0.5)*width));
	sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(0.5, -0.5)*width));
	sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(0.5, 0.5)*width));
	sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(-0.5, 0.5)*width));

	sum /= 9.0;

	float brightness = (0.2126*sum.r) + (0.7152*sum.g) + (0.0722*sum.b);

	float scanline;

	ivec2 size = textureSize(bgl_RenderedTexture, 0);

	if (mod(floor(texcoord.y * size.y), pixelcount) < scanwidth)
	{
		scanline = (scandarkness + (brightness) * scancontrast);
		scanline = clamp(scanline, 0, 1);
	}
	else
		scanline = 1.0;


	gl_FragColor = center * scanline;
}