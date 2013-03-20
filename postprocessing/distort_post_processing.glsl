uniform sampler2D bgl_RenderedTexture;
uniform float timer;

vec2 texcoord = vec2(gl_TexCoord[0]).st;
vec2 cancoord = vec2(gl_TexCoord[3]).st;

void main(void)
{
    texcoord.y = texcoord.y + (sin(cancoord.x*4+timer*2)*0.01);
    texcoord.x = texcoord.x + (cos(cancoord.y*4+timer*2)*0.01);


	gl_FragColor = texture2D(bgl_RenderedTexture, texcoord);
	
} 
