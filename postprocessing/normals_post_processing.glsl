uniform sampler2D bgl_DepthTexture;

float near = 0.5;
float far = 5.0;


vec2 texcoord = vec2(gl_TexCoord[0]).st;

//getting normals in view space
vec4 normal(vec2 co){

vec4 depth =  texture2D(bgl_DepthTexture, co);
float depth1 = -near / (-1.0+float(depth) * ((far-near)/far));
vec4 worldPoint = vec4(co,depth1,1) * depth1;
vec3 normal = normalize(cross(dFdx(worldPoint.xyz),dFdy(worldPoint.xyz)));
return vec4(normal*0.5+0.5,0);

}


void main(void)
{

gl_FragColor = normal(texcoord);
gl_FragColor.a = 1.0;
} 
