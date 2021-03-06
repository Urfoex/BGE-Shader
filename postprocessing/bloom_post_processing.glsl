uniform sampler2D bgl_RenderedTexture;

const float BRIGHT_PASS_THRESHOLD = 0.5;
const float BRIGHT_PASS_OFFSET = 0.5;

#define blurclamp 0.002 
#define bias 0.01

#define KERNEL_SIZE  3.0

vec2 texcoord = vec2(gl_TexCoord[0]).st;

vec4 bright(vec2 coo)
{
	vec4 color = texture2D(bgl_RenderedTexture, coo);
	
	color = max(color - BRIGHT_PASS_THRESHOLD, 0.0);
	
	return color / (color + BRIGHT_PASS_OFFSET);	
}


void main(void)
{
	vec2 blur = vec2(clamp( bias, -blurclamp, blurclamp ));
	
	vec4 col = vec4( 0, 0, 0, 0 );
	for ( float x = -KERNEL_SIZE + 1.0; x < KERNEL_SIZE; x += 1.0 )
	{
	for ( float y = -KERNEL_SIZE + 1.0; y < KERNEL_SIZE; y += 1.0 )
	{
		 col += bright( texcoord + vec2( blur.x * x, blur.y * y ) );
	}
	}
	col /= ((KERNEL_SIZE+KERNEL_SIZE)-1.0)*((KERNEL_SIZE+KERNEL_SIZE)-1.0);
	gl_FragColor = col + texture2D(bgl_RenderedTexture, texcoord);
} 
