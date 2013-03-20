varying vec3 T, B, N;
uniform sampler2D reflection,refraction, normals, diffuse;

float aberration = 0.005;
float bump = 0.2;
float texscale = 40.0;

vec3 TangentSpace(vec3 v)
{
	vec3 vec;
	vec.xy=v.xy;
	vec.z=sqrt(1.0-dot(vec.xy,vec.xy));
	vec.xyz= normalize(vec.x*T+vec.y*B+vec.z*N);
	return vec;
}

void main() {
   
    vec2 coord = gl_TexCoord[1].xy/gl_TexCoord[1].w*0.5+0.5;
    coord = clamp(coord,0.005,0.995);

    vec3 normal = texture2D(normals, gl_TexCoord[0].st*texscale).rgb*2.0-1.0;
    normal.x = -normal.x;
    normal.y = -normal.y;

    vec3 nVec = TangentSpace(vec3(normal*bump));     
    vec3 vVec = normalize(gl_TexCoord[2].xyz);
    
    float cosine = abs(dot(-vVec,nVec)); 
    float fresnel = pow(1.0-cosine+0.2,2.0); 
   
    vec3 reflect = texture2D(reflection, coord+nVec.st).rgb;
    
    vec3 luminosity = vec3(0.30, 0.59, 0.11);
	float reflectivity = pow(dot(luminosity, reflect.rgb),5.0);

    vec3 refract = vec3(0.0);
    refract.r = texture2D(refraction, (coord+nVec.st)*1.0).r;
    refract.g = texture2D(refraction, (coord+nVec.st)*1.0-(vVec.st*aberration)).g;
    refract.b = texture2D(refraction, (coord+nVec.st)*1.0-(vVec.st*aberration*2.0)).b;

    vec4 diffuse = texture2D(diffuse, gl_TexCoord[0].st*texscale).rgba;
    vec3 color = mix(diffuse.rgb*0.8+0.2,reflect,clamp(fresnel+reflectivity,0.0,1.0));
    
    gl_FragColor = vec4(color,1.0);
}