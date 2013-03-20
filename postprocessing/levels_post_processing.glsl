uniform sampler2D bgl_RenderedTexture;
vec2 texcoord = vec2(gl_TexCoord[0]).st;


vec4 gradient(vec4 coo)
{
	vec4 stripes = coo;
	stripes.r =  stripes.r*1.3+0.01;
	stripes.g = stripes.g*1.2;
	stripes.b = stripes.b*0.7+0.15;
	stripes.a = 1.0;
	return stripes;
}

void main (void) 
{ 		
	vec4 value = texture2D(bgl_RenderedTexture, texcoord);
		

// 	gl_FragColor = gradient(vec4(clamp(gl_TexCoord[3].s,0.0,1.0)));
	gl_FragColor.rgb = gradient(value).rgb;
	gl_FragColor.a = 1.0;	
} 
 
