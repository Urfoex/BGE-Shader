uniform sampler2D bgl_RenderedTexture;
uniform sampler2D bgl_DepthTexture;

const float exposure = 0.50;
const float decay = 0.92;
const float density = 0.3;
const float weight = 0.3;

uniform float x;
uniform float y;

uniform vec2 lightPositionOnScreen;


const int NUM_SAMPLES = 50 ;

void main()
{

    vec4 light = vec4(0);
    vec4 sample = vec4(0);
    vec4 mask = vec4(0);

    vec2 lightPositionOnScreen = vec2(x*0.82,y*0.925);

    vec2 deltaTexCoord = vec2(gl_TexCoord[3]) - lightPositionOnScreen;
	vec2 texCoo = gl_TexCoord[0].st;
	deltaTexCoord *= 1.0 / float(NUM_SAMPLES) * density;
	float illuminationDecay = 1.0;

//doing light-rays    

   for(int i=0; i < NUM_SAMPLES ; i++)
   {
   texCoo -= deltaTexCoord;


if (texture2D(bgl_DepthTexture, texCoo).r > 0.9989)
{
    sample += texture2D(bgl_RenderedTexture, texCoo);
}

    
    sample *= illuminationDecay * weight;

    light += sample;
    illuminationDecay *= decay;
    }
    vec2 texcoord = vec2(gl_TexCoord[0]);
 
gl_FragColor = texture2D(bgl_RenderedTexture, texcoord) + (light*exposure);

}




    
