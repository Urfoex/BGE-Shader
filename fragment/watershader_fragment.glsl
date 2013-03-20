varying vec3 T, B, N;
uniform sampler2D reflectionSampler,refractionSampler,normalSampler;

float aberration = 0.003;
float bump = 0.06;
float scaling = 30.0;

vec3 TangentSpace(vec3 v)
{
	vec3 vec;
	vec.xy=v.xy;
	vec.z=sqrt(1.0-dot(vec.xy,vec.xy));
	vec.xyz= normalize(vec.x*T+vec.y*B+vec.z*N);
	return vec;
}

void main() {
   
    vec2 fragCoord = gl_TexCoord[1].xy/gl_TexCoord[1].w*0.5+0.5;
    fragCoord = clamp(fragCoord,0.005,0.995);

    vec3 normal = texture2D(normalSampler, gl_TexCoord[0].xy*vec2(100.0)).rgb*2.0-1.0;
    normal.x = normal.x;
    normal.y = normal.y;

    vec3 nVec = TangentSpace(normal*bump);     
    vec3 vVec = normalize(gl_TexCoord[2].xyz);
    
    float R0 = pow((1.0-1.33)/(1.0+1.33),2.0); 
    float cosine = abs(dot(-vVec,nVec)); 
    float fresnel = R0 + (1.0-R0)*pow(1.0-cosine,5.0); 
   
    vec3 reflection = texture2D(reflectionSampler, fragCoord+nVec.st).rgb;
    
    vec3 luminosity = vec3(0.30, 0.59, 0.11);
	float reflectivity = pow(dot(luminosity, reflection.rgb),12.0);
    vec2 rcoord = reflect(vVec,nVec).st;
    vec3 refraction = vec3(0.0);
    refraction.r = texture2D(refractionSampler, (fragCoord-nVec.st)*1.0).r;
    refraction.g = texture2D(refractionSampler, (fragCoord-nVec.st)*1.0-(rcoord*aberration)).g;
    refraction.b = texture2D(refractionSampler, (fragCoord-nVec.st)*1.0-(rcoord*aberration*2.0)).b;

    vec3 color = mix(refraction,reflection,clamp(fresnel,0.0,1.0));
    
    gl_FragColor = vec4(color,1.0);
}