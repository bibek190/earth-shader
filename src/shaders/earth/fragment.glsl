uniform sampler2D uEarthDay;
uniform sampler2D uEarthNight;
uniform sampler2D uEarthSpecularClouds;
uniform vec3 uSunDirection;
uniform vec3 uAtmosphereTwilightColor;
uniform vec3 uAtmosphereDayColor;


varying vec2 vUv;
varying vec3 vNormal;
varying vec3 vPosition;

void main()
{
  
    vec3 viewDirection = normalize(vPosition - cameraPosition);
    vec3 normal = normalize(vNormal);
    vec3 color = vec3(0.0);

      //Sun Orientation 
    float sunOrientation = dot(uSunDirection,normal);


// 
float dayMix = smoothstep(-0.25,0.5,sunOrientation);
vec3 dayColor = texture(uEarthDay,vUv).rgb;
vec3 nightColor = texture(uEarthNight,vUv).rgb;

color = mix(nightColor,dayColor,dayMix);

// SpecularClouds Color
vec2 specularCloudsColor = texture(uEarthSpecularClouds,vUv).rg;
// clouds
float cloudMix = smoothstep(0.5,1.0,specularCloudsColor.g);
cloudMix *= dayMix;
color = mix(color,vec3(1.0),cloudMix);

// Fresnel
float fresnel = dot(viewDirection,normal) + 1.0;
fresnel = pow(fresnel,2.0);

// ATMOSPHERE
float atmosphereDayMix = smoothstep(-0.5,1.0,sunOrientation);
vec3 atmosphereColor = mix(uAtmosphereTwilightColor,uAtmosphereDayColor,atmosphereDayMix);
color = mix(color,atmosphereColor,fresnel*atmosphereDayMix);


    //
    // Final color
    gl_FragColor = vec4(color, 1.0);
    #include <tonemapping_fragment>
    #include <colorspace_fragment>
}