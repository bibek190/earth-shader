uniform sampler2D uEarthDay;
uniform sampler2D uEarthNight;
uniform sampler2D uEarthSpecularClouds;


varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vPosition;

void main()
{
  
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);
    vec3 color = vec3(0.0);

      //Sun Orientation 
    vec3 uSunDirection = vec3(0.0,0.0,1.0);
    float sunOrientation = dot(uSunDirection,normal);


// 
float dayMix = smoothstep(-0.25,0.5,sunOrientation);
vec3 earthDay = texture(uEarthDay,vUv).xyz;
vec3 earthNight = texture(uEarthNight,vUv).xyz;

color = mix(earthNight,earthDay,dayMix);

    // 

   

    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}