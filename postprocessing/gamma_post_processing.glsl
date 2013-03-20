uniform sampler2D bgl_RenderedTexture;

vec2 texcoord = vec2(gl_TexCoord[0]).st;

void main(void)
{
	vec3 texcol = vec3(texture2D(bgl_RenderedTexture, texcoord));


	const float exponent = 0.455;// = 1/2.2
	gl_FragColor.r = pow(texcol.r, exponent);
	gl_FragColor.g = pow(texcol.g, exponent);
	gl_FragColor.b = pow(texcol.b, exponent);
	gl_FragColor.a = 1.0;

} 
