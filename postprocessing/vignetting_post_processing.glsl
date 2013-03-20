uniform sampler2D bgl_RenderedTexture;

uniform float vignette_size;

void main(void)
{
	float vignette = sqrt(pow(0.5 - gl_TexCoord[0].s, 2.0) + pow(0.5 - gl_TexCoord[0].t, 2.0));
   	    
	gl_FragColor = mix(texture2D(bgl_RenderedTexture, gl_TexCoord[0].st), vec4(0.0), vignette*vignette_size);
} 
