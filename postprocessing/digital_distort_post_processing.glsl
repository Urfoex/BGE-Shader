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

float Round(float value){       // Rounds off the specified number
	if (ceil(value) - value < 0.5)
		return ceil(value);
	else
		return floor(value);
}

void main(void)
{
	vec2 glst = gl_TexCoord[0].st;
	vec4 wtc = gl_TexCoord[3];
	vec2 step;
	vec4 dc = vec4(1, 1, 1, 1);
	float ps = 32.0;

	if ((wtc.y > 0.1) && (wtc.y < 0.2)){
		step = glst + vec2(0.1, 0.0);
		dc = vec4(0.4, 0.2, 0.1, 1.0);
	}else
		step = glst;

	if ((wtc.y > 0.4) && (wtc.y < 0.41)){
		dc = vec4(0.3, 0.5, 0.8, 1.0);
		step = glst - vec2(0.1, 0.0);
	}

	if ((wtc.y > 0.4) && (wtc.y < 0.41)){
		dc = vec4(0.9, 0.5, 0.1, 1.0);
		step = glst + vec2(0.1, 0.05);
	}

	if ((wtc.y > 0.6) && (wtc.y < 0.7)){
		dc = vec4(.3, .3, .3, 1.0);
		step = glst + vec2(0.3, 0.0);
	}

	if ((wtc.x > 0.7) && (wtc.x < 0.71)){
		dc = vec4(.3, .3, .3, 1.0);
		step = glst + vec2(-0.3, 0.0);
	}

	if ((wtc.y > 0.3) && (wtc.y < 0.35)){
		dc = vec4(.3, .3, .3, 1.0);
		step = glst + vec2(0.0, 0.2);
	}

	if (wtc.y > 0.9){
		dc = vec4(.3, .3, .3, 1.0);
		step = glst + vec2(0.0, -0.2);
	}

	//if ((wtc.x < 0.25) && (wtc.y < 0.5))
	//{
	//      step.x = floor(step.x / ps) * ps;
	//      step.y = floor(step.y / ps) * ps;
	//}

	if ((wtc.x < 0.15) || (wtc.x > 0.95))
	{
		step.x = Round(step.x * ps) / ps;
		step.y = Round(step.y * ps) / ps;
	}

	if (wtc.y > 0.85)
	{
		step.x = Round(step.x * (ps*2)) / (ps*2);
		step.y = Round(step.y * (ps*2)) / (ps*2);
	}

	vec4 color = texture2D(bgl_RenderedTexture, step);

	color /= dc;

	if (step.x < 0.0)
		step.x += wtc.x;
	else if (step.x > 1.0)
		step.x -= 1.0;

	gl_FragColor = color;
}