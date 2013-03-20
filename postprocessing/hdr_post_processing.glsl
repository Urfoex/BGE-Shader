uniform sampler2D bgl_LuminanceTexture;
uniform sampler2D bgl_RenderedTexture;

uniform float avgL;
uniform float HDRamount;

vec2 texcoord = vec2(gl_TexCoord[0]).st;

void main(void)
{
	float contrast = avgL;
	float brightness = avgL * HDRamount;
	
	vec4 value =  texture2D(bgl_RenderedTexture, texcoord);
	
	gl_FragColor = (value/contrast)-brightness;

}
 
