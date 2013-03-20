// simple fragment shader

// 'time' contains seconds since the program was linked.
uniform float timer;
uniform sampler2D difuse;
void main()
{
    vec4 dif = texture2D(difuse,gl_TexCoord[0].st);
    gl_FragColor = dif * gl_Color;
}