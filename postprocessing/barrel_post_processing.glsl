uniform sampler2D bgl_RenderedTexture;

vec2 texcoord = vec2(gl_TexCoord[0]).st;
vec2 cancoord = vec2(gl_TexCoord[3]).st;

void main(void)
{
	float f = 0.6;  // focal length

	float ox = 0.5; // center, x axis

	float oy = 0.5; // center, y axis
	
	float scale = 0.8; // texture scale



	float k1 = 0.7;    // constant for radial distortion correction

	float k2 = -0.5;



	vec2 xy = (texcoord.st - vec2(ox, oy))/vec2(f,f) * scale;



	vec2 r = vec2 (sqrt( dot(xy, xy) ));

	float r2 = float (r * r);

	float r4 = r2 * r2;

	float coeff = (k1 * r2 + k2 * r4); 

	xy = ((xy + xy * coeff) * f) + vec2(ox, oy);
	
	
	gl_FragColor = texture2D(bgl_RenderedTexture, xy);
	
} 
