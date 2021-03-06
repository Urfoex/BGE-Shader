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

uniform sampler2D bgl_RenderedTexture;
uniform float dist;

void main()
{
	vec2 texcoord = gl_TexCoord[0].xy;
	vec3 sum = vec3(0.0);

	sum.r = vec3(texture2D(bgl_RenderedTexture, texcoord * 1 + vec2(0.00,0.00))).r;
	sum.g = vec3(texture2D(bgl_RenderedTexture, texcoord * (1.0 - (0.005 * dist)) + vec2(0.002,0.002))).g;
	sum.b = vec3(texture2D(bgl_RenderedTexture, texcoord * (1.0 - (0.01 * dist)) + vec2(0.004,0.004))).b;

	gl_FragColor = vec4(sum, 1.0);
}