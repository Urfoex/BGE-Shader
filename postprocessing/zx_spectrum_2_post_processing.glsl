uniform sampler2D bgl_RenderedTexture;

vec2 texCoord = vec2(gl_TexCoord[0]).st;
vec2 texDim = vec2 (abs(gl_TextureMatrix[0][0][0]),abs(gl_TextureMatrix[0][1][1]));

const float scale = 0.005; // amount of pixelization / size of glyphs

const float tolerance = 0.1;	//a tolerance used to determine the amount of blurring along the edge of the circle defining our "pixel region"
const float pixelRadius = 0.8;	//the radius of the circle that will be our "pixel region", values > 0.5 hit the edge of the "pixel region"

const int luminanceSteps = 10;	//number of shades of color
const float luminanceBoost = -0.1;	//used to brighten or darken image

uniform float width;
uniform float height;

vec4 colorseparator = vec4(0.2,0.55,0.85,1.0);
vec4 colorvalue = vec4(0.0,0.87,1.0,0.0);
vec2 screenSize = vec2(width, height);

const float colorBoost = 0.02;	//used to adjust the color intensity

vec4 applyLuminanceStepping(in vec4 color)
{
     float sum = color.r + color.g + color.b;
     
     //brightness or luminance of color
     float luminance = sum/3.0; 
     
     //ratio stores each channel's contribution to the luminance
     vec3 ratios = vec3(color.r/luminance, color.g/luminance, color.b/luminance); 

     float luminanceStep = 1.0/float(luminanceSteps); //how big each luminance bin is
     float luminanceBin = ceil(luminance/luminanceStep); //figure out which bin the color is in
     
     //store the luminance of the color we are making including luminanceBoost
     float luminanceFactor = luminanceStep * luminanceBin + luminanceBoost; 

     //use ratios * luminanceFactor as our new color so that original color hue is maintained
     return vec4(ratios * luminanceFactor,1.0); 
}


vec4 applyColorBoost(in vec4 color)
{
    vec4 boostedColor = color;
    float max = max(color.r,max(color.g, color.b));
    bvec3 maxes = equal(vec3(color),vec3(max));

    if(maxes.r)
        boostedColor += vec4(2.0*colorBoost,-colorBoost,-colorBoost,0.0);

    if(maxes.g)
        boostedColor += vec4(-colorBoost,2.0*colorBoost,-colorBoost,0.0);

    if(maxes.b)
        boostedColor += vec4(-colorBoost,-colorBoost,2.0*colorBoost,0.0);

    return boostedColor;
}


vec4 Spectrumize(vec4 tc)
{
	vec4 c = vec4(0.0,0.0,0.0,0.0);
	vec2 p =  gl_TexCoord[3].st;
	
	p.x=(p.x)/1.0*(screenSize[0]);
	p.y=(p.y)/1.0*(screenSize[1]);
	
	bool bright;
	int numpresent=0;

	for (int i=0;i<3;i++) {
		if (tc[i]<colorseparator[0])
		{
			c[i]=colorvalue[0];
		} else if (tc[i]>colorseparator[1]) {
			if (!bright) {
			c[i]=colorvalue[1];
			} else {
			c[i]=colorvalue[2];
			}
		} else {
			if (1-(int(p.x)+int(p.y))%2==0) {
				c[i]=colorvalue[0];
			} else {
				if (!bright) {
					c[i]=colorvalue[1];
				} else {
					c[i]=colorvalue[2];
				}
			}
		}
	}
	if (tc[3]>colorseparator[1]) {
		c[3]=colorvalue[2];
	} else {
		if ((int(p.x)+int(p.y))%2==0)  {
			c[3]=colorvalue[0];
		} else {
			c[3]=colorvalue[2];
		}
	}
  	return c;
}


void main (void) 
{ 	
	// pixelization based on LED resampling code found at http://www.lighthouse3d.com/opengl/ledshader/
	
	vec2 normalizedCoords = texCoord/texDim;

	vec2 texCoordsStep = 1.0/texDim*scale;
	vec2 pixelBin = floor(normalizedCoords/texCoordsStep);
	vec2 inPixelStep = texCoordsStep/4.0;
	vec2 inPixelHalfStep = inPixelStep/2.0;
	
	vec2 pixelRegionCoords = fract(gl_TexCoord[0].st/texCoordsStep);

	vec2 offset = pixelBin * texCoordsStep;
		
	vec2 offset0 = vec2(inPixelHalfStep.x, inPixelStep.y*2.0 + inPixelHalfStep.y) + offset;
	vec2 offset1 = vec2(inPixelStep.x + inPixelHalfStep.x, inPixelStep.y*2.0 + inPixelHalfStep.y) + offset;
	vec2 offset2 = vec2(inPixelStep.x*2.0 + inPixelHalfStep.x, inPixelStep.y*2.0 + inPixelHalfStep.y) + offset;
	vec2 offset3 = vec2(inPixelHalfStep.x, inPixelStep.y + inPixelHalfStep.y) + offset;
	vec2 offset4 = vec2(inPixelStep.x + inPixelHalfStep.x, inPixelStep.y + inPixelHalfStep.y) + offset;
	vec2 offset5 = vec2(inPixelStep.x*2.0 + inPixelHalfStep.x, inPixelStep.y + inPixelHalfStep.y) + offset;
	vec2 offset6 = vec2(inPixelHalfStep.x, inPixelHalfStep.y) + offset;
	vec2 offset7 = vec2(inPixelStep.x + inPixelHalfStep.x, inPixelHalfStep.y) + offset;
	vec2 offset8 = vec2(inPixelStep.x*2.0 + inPixelHalfStep.x, inPixelHalfStep.y) + offset;



	vec4 input0 = texture2D(bgl_RenderedTexture,offset0 * texDim);
	vec4 input1 = texture2D(bgl_RenderedTexture,offset1 * texDim);
	vec4 input2 = texture2D(bgl_RenderedTexture,offset2 * texDim);
	vec4 input3 = texture2D(bgl_RenderedTexture,offset3 * texDim);
	vec4 input4 = texture2D(bgl_RenderedTexture,offset4 * texDim);
	vec4 input5 = texture2D(bgl_RenderedTexture,offset5 * texDim);
	vec4 input6 = texture2D(bgl_RenderedTexture,offset6 * texDim);
	vec4 input7 = texture2D(bgl_RenderedTexture,offset7 * texDim);
	vec4 input8 = texture2D(bgl_RenderedTexture,offset8 * texDim);
	
	vec4 avgColor = input0 + input1 + input2 + input3 + input4 + input5 + input6 + input7 + input8;
	avgColor /= 9.0;

	
	avgColor = Spectrumize(avgColor);
//	avgColor = applyLuminanceStepping(avgColor);
//	avgColor = applyColorBoost(avgColor);

//	vec4 stripes; // our base 'stripe color'
//	stripes = vec4(floor(mod(gl_TexCoord[3].t*height, 1.0)));
//	stripes = clamp(stripes, 0.0, 1.0);
//	stripes = vec4(1.0) - stripes; // subtract


	vec2 powers = pow(abs(pixelRegionCoords - 0.5),vec2(2.0));
	float radiusSqrd = pow(pixelRadius,2.0);
	float gradient = smoothstep(radiusSqrd-tolerance, radiusSqrd+tolerance, powers.x+powers.y);

	gl_FragColor = mix(avgColor, vec4(0.1,0.1,0.1,1.0), gradient);
	gl_FragColor.a = 1.0;

}
 
