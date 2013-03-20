uniform sampler2D bgl_RenderedTexture;
uniform float bgl_RenderedTextureWidth;
uniform float bgl_RenderedTextureHeight;

void main(void)
{
  float width = bgl_RenderedTextureWidth; 
  float height = bgl_RenderedTextureHeight;
     
  vec2 Scoord = gl_TexCoord[0].xy;
  
  vec2 Vcoord1 = gl_TexCoord[0].xy + (vec2(0.0,1.0) / height);
  vec2 Vcoord2 = gl_TexCoord[0].xy + (vec2(0.0,1.5) / height);
  vec2 Vcoord3 = gl_TexCoord[0].xy - (vec2(0.0,1.0) / height);
  vec2 Vcoord4 = gl_TexCoord[0].xy - (vec2(0.0,1.5) / height);
  
  vec2 Hcoord1 = gl_TexCoord[0].xy + (vec2(1.0,0.0) / width);
  vec2 Hcoord2 = gl_TexCoord[0].xy + (vec2(1.5,0.0) / width);
  vec2 Hcoord3 = gl_TexCoord[0].xy - (vec2(1.0,0.0) / width);
  vec2 Hcoord4 = gl_TexCoord[0].xy - (vec2(1.5,0.0) / width);
  
  vec2 VE1 = gl_TexCoord[0].xy + (vec2(1.0,0.0) / width);
  vec2 VE2 = gl_TexCoord[0].xy - (vec2(1.0,0.0) / width);  
  
  vec2 HE1 = gl_TexCoord[0].xy + (vec2(0.0,1.0) / height);
  vec2 HE2 = gl_TexCoord[0].xy - (vec2(0.0,1.0) / height); 
  
      
  vec4 Msample = texture2D(bgl_RenderedTexture, Scoord);
  
  vec4 Vsample1 = texture2D(bgl_RenderedTexture, Vcoord1);
  vec4 Vsample2 = texture2D(bgl_RenderedTexture, Vcoord2);
  vec4 Vsample3 = texture2D(bgl_RenderedTexture, Vcoord3);
  vec4 Vsample4 = texture2D(bgl_RenderedTexture, Vcoord4);
  
  vec4 Hsample1 = texture2D(bgl_RenderedTexture, Hcoord1);
  vec4 Hsample2 = texture2D(bgl_RenderedTexture, Hcoord2);
  vec4 Hsample3 = texture2D(bgl_RenderedTexture, Hcoord3);
  vec4 Hsample4 = texture2D(bgl_RenderedTexture, Hcoord4);
  
  vec4 VEsample1 = texture2D(bgl_RenderedTexture, VE1);
  vec4 VEsample2 = texture2D(bgl_RenderedTexture, VE2);
  
  vec4 HEsample1 = texture2D(bgl_RenderedTexture, HE1);
  vec4 HEsample2 = texture2D(bgl_RenderedTexture, HE2); 

   
  vec4 VEsum = VEsample1 + VEsample2;  
  vec4 HEsum = HEsample1 + HEsample2;
  
  vec4 VblurRGB = (Msample + Vsample1 + Vsample2 + Vsample3 + Vsample4) / 5.0;
  vec4 HblurRGB = (Msample + Hsample1 + Hsample2 + Hsample3 + Hsample4) / 5.0;
  
  vec4 VE0 = abs( VEsum - (2.0 * Msample) ); 
  vec4 HE0 = abs( HEsum - (2.0 * Msample) ); 
  
  float VE = clamp(1.5 * (dot(VE0, vec4(1.0)) - 0.16666), 0.0, 1.0);  
  float HE = clamp(1.5 * (dot(HE0, vec4(1.0)) - 0.16666), 0.0, 1.0);
  
  if (((dot(VEsample1, vec4(1.0)) > dot(Msample, vec4(1.0)) + .05 ) && (dot(VEsample2, vec4(1.0)) > dot(Msample, vec4(1.0)) + .05 )) || ((dot(VEsample1, vec4(1.0)) < dot(Msample, vec4(1.0)) - .01 ) && (dot(VEsample2, vec4(1.0)) < dot(Msample, vec4(1.0)) - .05 )))
  		HE = 0.0;
  
  if (((dot(HEsample1, vec4(1.0)) > dot(Msample, vec4(1.0)) + .05 ) && (dot(HEsample2, vec4(1.0)) > dot(Msample, vec4(1.0)) + .05 )) || ((dot(HEsample1, vec4(1.0)) < dot(Msample, vec4(1.0)) - .01 ) && (dot(HEsample2, vec4(1.0)) < dot(Msample, vec4(1.0)) - .05 )))
  		VE = 0.0;
  
  float VHweight = (HE - VE + 1.0) / 2.0;
  
  vec4 FinalBlur = mix(VblurRGB, HblurRGB, VHweight);
  
  float FinalMask = clamp((VE + HE), 0.0, 1.0);
  
  vec4 Final = mix(Msample, FinalBlur, FinalMask);  
      
  gl_FragColor = Final;
} 
