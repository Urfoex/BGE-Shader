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
// Name: Cross Bloom Screen Filter
// Author: SolarLune
// Date Updated: 2/21/11
		
uniform sampler2D bgl_RenderedTexture;
uniform float widthf;
uniform float strengthf;
uniform int shape;

float samples[11];

void main()
{
	samples[0] = 0.0222244;
	samples[1] = 0.0378346;
	samples[2] = 0.0755906;
	samples[3] = 0.1309775;
	samples[4] = 0.1756663;
	samples[5] = 0.1974126;
	samples[6] = 0.1756663;
	samples[7] = 0.1309775;
	samples[8] = 0.0755906;
	samples[9] = 0.0378346;
	samples[10] = 0.0222244;

	vec4 sum = vec4(0);
	vec2 texcoord = vec2(gl_TexCoord[0]);

	vec4 center = texture2D(bgl_RenderedTexture, texcoord);

	float width = 0.002 * widthf;    // width = how wide of a sample to use (is repeated 16 times below (4 times horizontally, 4 times for each of those vertically)
	// Usually 0.002, but as can be seen below, sum would USUALLY be calculated 8 * 8 times (absurd CPU drain); should probably be around 0.001

	if ((shape == 0) || (shape == 2))

	{
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(-4, -4)*width) * samples[0];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(-3, -3)*width) * samples[1];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(-2, -2)*width) * samples[2];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(-1, -1)*width) * samples[3];

		//sum += texture2D(bgl_RenderedTexture, texcoord + vec2(0, 0)*width) * samples[4];

		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(1, 1)*width) * samples[5];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(2, 2)*width) * samples[6];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(3, 3)*width) * samples[7];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(4, 4)*width) * samples[8];

		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(-4, 4)*width) * samples[0];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(-3, 3)*width) * samples[1];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(-2, 2)*width) * samples[2];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(-1, 1)*width) * samples[3];

		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(1, -1)*width) * samples[5];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(2, -2)*width) * samples[6];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(3, -3)*width) * samples[7];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(4, -4)*width) * samples[8];
	}

	if ((shape == 1) || (shape == 2))
	{
		
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(-4, 0)*width) * samples[0];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(-3, 0)*width) * samples[1];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(-2, 0)*width) * samples[2];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(-1, 0)*width) * samples[3];

		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(1, 0)*width) * samples[5];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(2, 0)*width) * samples[6];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(3, 0)*width) * samples[7];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(4, 0)*width) * samples[8];

		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(0, 4)*width) * samples[0];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(0, 3)*width) * samples[1];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(0, 2)*width) * samples[2];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(0, 1)*width) * samples[3];

		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(0, -1)*width) * samples[5];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(0, -2)*width) * samples[6];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(0, -3)*width) * samples[7];
		sum += texture2D(bgl_RenderedTexture, texcoord + vec2(0, -4)*width) * samples[8];
				
	}

	if (shape == 2)
		sum /= 1.5;    

	vec4 bloom = sum*(strengthf / 1.5);

	bloom.a = 1.0;

	//gl_FragColor = sum*(""" + str(float(strength)) + """ / 1.5) + texture2D(bgl_RenderedTexture, texcoord);       // Usually sum*0.08; 0.08 < is how bright the bloom effect appears on the screen; should probably be around 0.32

	gl_FragColor = center + bloom;  // Usually sum*0.08; 0.08 < is how bright the bloom effect appears on the screen; should probably be around 0.32
}