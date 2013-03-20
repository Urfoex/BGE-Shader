attribute vec4 Tangent;
varying vec4 fragPos;
varying vec3 wT, wB, wN; //tangent binormal normal
varying vec3 wPos, pos, viewPos, sunPos;
uniform mat4 ModelMatrix;
uniform vec3 cameraPos;

mat3 m3( mat4 m )
{
	mat3 result;
	
	result[0][0] = m[0][0]; 
	result[0][1] = m[0][1]; 
	result[0][2] = m[0][2]; 

	result[1][0] = m[1][0]; 
	result[1][1] = m[1][1]; 
	result[1][2] = m[1][2]; 
	
	result[2][0] = m[2][0]; 
	result[2][1] = m[2][1]; 
	result[2][2] = m[2][2]; 
	
	return result;
}

void main() 
{
    wPos = vec3(ModelMatrix * gl_Vertex);
	//pos = vec3(gl_Vertex);

	wT   = m3(ModelMatrix)*Tangent.xyz;
	wB   = m3(ModelMatrix)*cross(gl_Normal, Tangent.xyz);
	wN   = m3(ModelMatrix)*gl_Normal;

    //fragPos = ftransform();
    viewPos = wPos - cameraPos.xyz;
    sunPos = m3(ModelMatrix)*vec3(gl_ModelViewMatrixInverse*gl_LightSource[0].position);
    gl_Position = ftransform();
}