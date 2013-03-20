uniform sampler2D bgl_RenderedTexture;
uniform sampler2D bgl_DepthTexture;

const int NUM_SAMPLES = 30;
const float density = 0.1;

void main()
{

    vec2 deltaTexCoord = gl_TexCoord[3].st - vec2(0.5,0.5);
	vec2 texCoo = gl_TexCoord[0].st;
	deltaTexCoord *= 1.0 / float(NUM_SAMPLES) * density;
	vec4 sample = vec4(1.0);
	float decay = 1.0;
  
for(int i=0; i < NUM_SAMPLES ; i++)
{
	texCoo -= deltaTexCoord;
    sample += texture2D(bgl_RenderedTexture, texCoo);
}

gl_FragColor = sample/float(NUM_SAMPLES);
gl_FragColor.a = 1.0;
}
 
