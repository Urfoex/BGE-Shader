#version 330

uniform mat4 modelMatrix;
uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;

void main(){
    gl_TexCoord[0] = gl_MultiTexCoord0;
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * gl_Vertex;
}
