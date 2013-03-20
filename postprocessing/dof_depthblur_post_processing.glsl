uniform sampler2D bgl_RenderedTexture;
uniform sampler2D bgl_DepthTexture;

const float blurclamp = 0.003;	// max blur amount
const float bias = 0.1;	//aperture - bigger values for shallower depth of field
uniform float focus;	// this value comes from ReadDepth script.

#define KERNEL_SIZE  3.0	//sample amount - quality of blur


vec4 depth(vec2 coo)	//blurring the depth
{
	vec2 dofblur = vec2 (clamp( bias, -blurclamp, blurclamp ));
	
	vec4 col = vec4( 0, 0, 0, 0 );
	for ( float x = -KERNEL_SIZE + 1.0; x < KERNEL_SIZE; x += 1.0 )
	{
	for ( float y = -KERNEL_SIZE + 1.0; y < KERNEL_SIZE; y += 1.0 )
	{
		 col += texture2D(bgl_DepthTexture, coo + vec2( dofblur.x * x, dofblur.y * y ) );
	}
	}
	col /= ((KERNEL_SIZE+KERNEL_SIZE)-1.0)*((KERNEL_SIZE+KERNEL_SIZE)-1.0);
	return col;
}

 
void main() 
{
	vec4 depth1   = depth(gl_TexCoord[0].xy );

	float factor = ( depth1.x - focus );
	 
	vec2 dofblur = vec2 (clamp( factor * bias, -blurclamp, blurclamp ));


	vec4 col = vec4(0.0);
	for ( float x = -KERNEL_SIZE + 1.0; x < KERNEL_SIZE; x += 1.0 )
	{
	for ( float y = -KERNEL_SIZE + 1.0; y < KERNEL_SIZE; y += 1.0 )
	{
		 col += texture2D(bgl_RenderedTexture, gl_TexCoord[0].xy + vec2( dofblur.x * x, dofblur.y * y ) );
	}
	}
	col /= ((KERNEL_SIZE+KERNEL_SIZE)-1.0)*((KERNEL_SIZE+KERNEL_SIZE)-1.0);
	 
	gl_FragColor = col;
	gl_FragColor.a = 1.0;
}
 
