#version 330

uniform sampler2D diffuseTexture;

out vec4 glFragColor;

void main(){
    glFragColor = texture(diffuseTexture, gl_TexCoord[0].st);
}
