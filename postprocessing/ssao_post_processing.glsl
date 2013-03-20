uniform sampler2D bgl_DepthTexture;
uniform sampler2D bgl_RenderedTexture;

#define camx 0.8
#define camy 800
uniform float width;
uniform float height;

int j;
int i;

vec2 texCoord = gl_TexCoord[0].st;

float readDepth( in vec2 coord ) {
 return (2.0 * camx) / (camy + camx - texture2D(bgl_DepthTexture, coord ).x * (camy - camx)); 	
}

float compareDepths( in float depth1, in float depth2 ) {
	float aoCap = 2.0;
	float aoMultiplier=100.0;
	float depthTolerance=0.0000;
	float aorange = 20.0;// units in space the AO effect extends to (this gets divided by the camera far range
	float diff = sqrt( clamp(1.0-(depth1-depth2) / (aorange/(camy-camx)),0.0,1.0) );
	float ao = min(aoCap,max(0.0,depth1-depth2-depthTolerance) * aoMultiplier) * diff;
	return ao;
}

void main(void)
{	
	float depth = readDepth( texCoord );
	float d;
	
	float pw = 1.0 / float(width);
	float ph = 1.0 / float(height);

	float aoCap = 2.0;

	float ao = 5.0;
	
	float aoMultiplier=1.0;

	float depthTolerance = 0.0000;
	
	float aoscale=0.7;
	
	d=readDepth( vec2(texCoord.s+pw,texCoord.t+ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s-pw,texCoord.t+ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s+pw,texCoord.t-ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s-pw,texCoord.t-ph));
	ao+=compareDepths(depth,d)/aoscale;
	
	pw*=2.0;
	ph*=2.0;
	aoMultiplier/=2.0;
	aoscale*=1.2;
	
	d=readDepth( vec2(texCoord.s+pw,texCoord.t+ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s-pw,texCoord.t+ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s+pw,texCoord.t-ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s-pw,texCoord.t-ph));
	ao+=compareDepths(depth,d)/aoscale;

	pw*=2.0;
	ph*=2.0;
	aoMultiplier/=2.0;
	aoscale*=1.4;
	
	d=readDepth( vec2(texCoord.s+pw,texCoord.t+ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s-pw,texCoord.t+ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s+pw,texCoord.t-ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s-pw,texCoord.t-ph));
	ao+=compareDepths(depth,d)/aoscale;
	
	pw*=2.0;
	ph*=2.0;
	aoMultiplier/=2.0;
	aoscale*=1.6;
	
	d=readDepth( vec2(texCoord.s+pw,texCoord.t+ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s-pw,texCoord.t+ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s+pw,texCoord.t-ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s-pw,texCoord.t-ph));
	ao+=compareDepths(depth,d)/aoscale;
	
	pw*=2.0;
	ph*=2.0;
	aoMultiplier/=2.0;
	aoscale*=1.8;
	
	d=readDepth( vec2(texCoord.s+pw,texCoord.t+ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s-pw,texCoord.t+ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s+pw,texCoord.t-ph));
	ao+=compareDepths(depth,d)/aoscale;

	d=readDepth( vec2(texCoord.s-pw,texCoord.t-ph));
	ao+=compareDepths(depth,d)/aoscale;
	
	ao/=15.0;
	
    vec4 finalao = vec4(1.0-ao,1.0-ao,1.0-ao,1.0); 
	finalao = clamp(finalao,0.0,0.7)+0.3;	
    
	gl_FragColor = finalao * texture2D(bgl_RenderedTexture, texCoord );
	gl_FragColor.a = 1.0;  
}
 
