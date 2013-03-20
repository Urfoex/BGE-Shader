varying vec3 T, B, N, Wnormal;
uniform sampler2D reflection,refraction, normals, diffuse;

float aberration = 0.003;
float bump = 0.1;

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

    //vec3 normal = texture2D(normals, gl_TexCoord[0].st).rgb*2.0-1.0;
    //normal.x = normal.x;
    //normal.y = -normal.y;

    vec3 nVec = N*bump;
    vec3 WnVec = Wnormal*bump;
        
    vec3 vVec = normalize(gl_TexCoord[2].xyz);
    
    float R0 = pow((1.0-1.5)/(1.0+1.5),2.0); 
    float cosine = abs(dot(-vVec,nVec)); 
    float fresnel = R0 + (1.0-R0)*pow(1.0-cosine,1.0); 
   
    vec3 reflect = texture2D(reflection, coord+nVec.st).rgb;
    
    vec3 luminosity = vec3(0.30, 0.59, 0.11);
	float reflectivity = pow(dot(luminosity, reflect.rgb),12.0);

    vec3 refract = vec3(0.0);
    refract.r = texture2D(refraction, (coord+WnVec.st)*1.0).r;
    refract.g = texture2D(refraction, (coord+WnVec.st)*1.0-(aberration)).g;
    refract.b = texture2D(refraction, (coord+WnVec.st)*1.0-(aberration*2.0)).b;

    vec4 diffuse = texture2D(diffuse, gl_TexCoord[0].st).rgba;
    vec3 color = mix(refract*diffuse.a,reflect,clamp(fresnel,0.0,1.0));
    
    gl_FragColor = vec4(refract,1.0);
} 
