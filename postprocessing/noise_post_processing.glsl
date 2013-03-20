uniform sampler2D bgl_RenderedTexture;

uniform float timer;
uniform float noise_amount;

void main(void)
{ 	
	float noise =  (fract(sin(dot(gl_TexCoord[0].st ,vec2(12.9898,78.233)+timer)) * 43758.5453));
	    
	gl_FragColor = texture2D(bgl_RenderedTexture, gl_TexCoord[0].st) + noise*noise_amount;
} 
