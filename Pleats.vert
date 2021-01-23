#version 330 compatibility


uniform float uK;
uniform float uP;


flat out vec3 vNf;
out vec3 vNs;
flat out vec3 vLf;
out vec3 vLs;
flat out vec3 vEf;
out vec3 vEs;

uniform float uLightX, uLightY, uLightZ;

uniform vec4 uObjectColor;
vec4 lightPosition = vec4(uLightX,uLightY,uLightZ, 1.);
out vec2 vST;
out vec3 vColor;

const float Y0 = 1.;

out vec3 vMC;


const float PI = 3.14159265;
void
main( )
{
	vec4 newPosition = gl_Vertex;
	
	//pleats here
	float newZ = uK * (Y0-newPosition.y) * sin(2.*PI*newPosition.x/uP);
	newPosition.z = newZ;
	float dzdx = uK * (Y0-newPosition.y) * (2.*PI/uP) * cos( 2.*PI*newPosition.x/uP );
	float dzdy = -uK * sin( 2.*PI*newPosition.x/uP );
	vec3 Tx = vec3(1., 0., dzdx );
	vec3 Ty = vec3(0., 1., dzdy );

	vec3 newNormal = normalize(cross(Tx, Ty));
	vec4 eyeLightPosition =  gl_ModelViewMatrix* lightPosition;
	vST = gl_MultiTexCoord0.st;



	vColor = uObjectColor.rgb;
	vec4 ECposition = gl_ModelViewMatrix * newPosition;
	vNf = normalize( gl_NormalMatrix * newNormal ); // surface normal vector
	vNs = vNf;
	vLf = eyeLightPosition.xyz - ECposition.xyz; // vector from the point
	vLs = vLf; // to the light position
	vEf = vec3( 0., 0., 0. ) - ECposition.xyz; // vector from the point
	vEs = vEf ; // to the eye position

	gl_Position = gl_ModelViewProjectionMatrix * newPosition;
	vMC = gl_Position.xyz;
}