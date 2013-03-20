varying vec3 N;
varying vec3 v;    

void main (void)  
{  
   vec4 Iamb = vec4(0.0, 0.0, 0.0, 0.0);
   vec4 Idiff = vec4(0.0, 0.0, 0.0, 0.0);
   vec4 Ispec = vec4(0.0, 0.0, 0.0, 0.0); 
   
   for (int i=0;i<gl_MaxLights;i++)
   {
       vec3 L = normalize(gl_LightSource[i].position.xyz - v);   
       vec3 E = normalize(-v); // we are in Eye Coordinates, so EyePos is (0,0,0)  
       vec3 R = normalize(-reflect(L,N)); 
       
       //calculate Ambient Term:  
       Iamb += gl_FrontLightProduct[i].ambient;    
    
       //calculate Diffuse Term:  
       Idiff += gl_FrontLightProduct[i].diffuse * max(dot(N,L), 0.0);
       Idiff = clamp(Idiff, 0.0, 1.0);     
       
       // calculate Specular Term:
       Ispec += gl_FrontLightProduct[i].specular * pow(max(dot(R,E),0.0),0.3*gl_FrontMaterial.shininess);
       Ispec = clamp(Ispec, 0.0, 1.0); 
    }
   // write Total Color:  
   gl_FragColor = gl_FrontLightModelProduct.sceneColor + Iamb + Idiff + Ispec;     
}