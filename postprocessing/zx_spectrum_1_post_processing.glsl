uniform sampler2D bgl_RenderedTexture;

vec2 texCoord = vec2(gl_TexCoord[0]).st;

uniform float width;
uniform float height;

vec4 sample = texture2D(bgl_RenderedTexture,texCoord);

vec4 colorseparator = vec4(0.2,0.55,0.85,1.0);

vec4 colorvalue = vec4(0.0,0.87,1.0,0.0);

vec2 screenSize = vec2(width, height);

const vec4 two = vec4(2.0);

vec4 Spectrumize(vec4 tc)
{
	vec4 c = vec4(0.0,0.0,0.0,0.0);
	vec2 p =  gl_TexCoord[3].st;
	
	p.x=(p.x)/2.0*(screenSize[0]);
	p.y=(p.y)/2.0*(screenSize[1]);
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
			if ((int(p.x)+int(p.y))%2==0) {
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
	vec4 stripes; // our base 'stripe color'
	
	stripes = vec4(floor(mod(gl_TexCoord[3].t*height, 2.0)));
	stripes = clamp(stripes, 0.0, 1.0);
	
	stripes = vec4(1.0) - stripes; // subtract
	
	gl_FragColor =stripes* Spectrumize(sample);
	gl_FragColor.a =1.0;

}
 
