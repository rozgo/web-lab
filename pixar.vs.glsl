#{ THREE.ShaderChunk[ "common" ] }

varying vec3 lightRGB;
varying vec3 lightHSV;
varying vec3 rim;

#{ THREE.ShaderChunk[ "color_pars_vertex" ] }
#{ THREE.ShaderChunk[ "uv_pars_vertex" ] }

#{ THREE.ShaderChunk[ "shadowmap_pars_vertex" ] }

uniform vec3 directionalLightDirection[MAX_DIR_LIGHTS];
uniform vec3 directionalLightColor[MAX_DIR_LIGHTS];

uniform float rimPower;
uniform float rimIntensity;
uniform vec3 rimColor;

attribute vec3 offset;

#{ shaders["hsv"] }

void main() {

    #{ THREE.ShaderChunk[ "uv_vertex" ] }
    #{ THREE.ShaderChunk[ "color_vertex" ] }

    vec3 vecPos = (modelMatrix * vec4(position + offset, 1.0 )).xyz;
    vec4 worldPosition = vec4(vecPos,1.0);
    vec3 vecNormal = normalize(normalMatrix * normal);
    gl_Position = projectionMatrix * viewMatrix * vec4(vecPos, 1.0);

    vec3 addedLights = vec3(0.0,0.0,0.0);
    for(int l = 0; l < MAX_DIR_LIGHTS; l++) {
      // float n = mod(-dot(directionalLightDirection[l], vecNormal) * 0.5 + 0.5, 0.3) + 0.5;
      float n = dot(directionalLightDirection[l], vecNormal) * 0.5 + 0.5;
        addedLights += saturate(n) * directionalLightColor[l];
    }
    lightRGB = addedLights + 0.5;
    lightHSV = rgb2hsv(lightRGB);

    vec3 mvNormal = normalize(mat3(modelViewMatrix) * normal);
    vec3 mvPosition = (modelViewMatrix * vec4(position, 1.0)).xyz;
    vec3 mvToEye = -normalize(mvPosition);

    float rimDot = 1.0 - max(dot(mvToEye, mvNormal), 0.0);
    rim = vec3(smoothstep(rimPower, 1.0, rimDot)) * rimColor * rimIntensity;

    #{ THREE.ShaderChunk[ "shadowmap_vertex" ] }
}
