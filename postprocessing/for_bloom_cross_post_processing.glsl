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
uniform int shape;
uniform float widthf;
uniform float strengthf;
uniform int numberofsamples;

void main()
{                      
	vec4 sum = vec4(0);
	vec2 texcoord = vec2(gl_TexCoord[0]);
	vec4 center = texture2D(bgl_RenderedTexture, texcoord);
	float width = 0.002 * widthf;    // width = how wide of a sample to use (is repeated 32 times below (8 times vertically, 4 times for each of those vertically)


	if ((shape == 0) || (shape == 2))
	{
		for (int i = -numberofsamples; i < numberofsamples; i += 1)
		{
			sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(i, i)*width));
			sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(-i, -i)*width));
			sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(i, -i)*width));
			sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(-i, i)*width));
		}
	}

	if ((shape == 1) || (shape == 2))
	{
		for (int i = -numberofsamples; i < numberofsamples; i += 1)
		{
			sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(i, 0)*width));
			sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(-i, 0)*width));
			sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(0, -i)*width));
			sum += texture2D(bgl_RenderedTexture, texcoord + (vec2(0, i)*width));
		}
	}

	if ((shape == 0) || (shape == 1))
		sum /= (numberofsamples * 2) * 4;
	else
		sum /= ((numberofsamples * 2) * 4) * 2;

	float brightness = (max(sum.r, max(sum.g, sum.b)) + min(sum.r, min(sum.g, sum.b))) / 2.0;

	vec4 bloom = sum * (strengthf);

	bloom.a = 1.0;

	gl_FragColor = center + (bloom * brightness);   // Usually sum*0.08; 0.08 < is how bright the bloom effect appears on the screen; should probably be around 0.32
}