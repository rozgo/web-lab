#{ THREE.ShaderChunk[ "common" ] }

varying vec3 lightRGB;
varying vec3 lightHSV;
varying vec3 rim;

varying float map2blend;

#{ THREE.ShaderChunk[ "uv_pars_vertex" ] }

#{ THREE.ShaderChunk[ "shadowmap_pars_vertex" ] }

uniform vec3 directionalLightDirection[MAX_DIR_LIGHTS];
uniform vec3 directionalLightColor[MAX_DIR_LIGHTS];

uniform float rimPower;
uniform float rimIntensity;
uniform vec3 rimColor;

uniform sampler2D heightmap;

#{ shaders["hsv"] }

void main() {

    #{ THREE.ShaderChunk[ "uv_vertex" ] }

    vec4 heightmap = texture2D(heightmap, uv);
    float height = pow(length(position.y / 20.0), 1.0);
    map2blend = 0.0;
    if (height > 0.0) {
      map2blend = 1.0;
    }

    vec3 vecPos = (modelMatrix * vec4(position, 1.0 )).xyz;
    vec4 worldPosition = vec4(vecPos,1.0);
    vec3 vecNormal = normalize(normalMatrix * normal);
    gl_Position = projectionMatrix * viewMatrix * vec4(vecPos, 1.0);

    vec3 addedLights = vec3(0.0, 0.0, 0.0);
    for(int l = 0; l < MAX_DIR_LIGHTS; l++) {
        float n = dot(directionalLightDirection[l], vecNormal) * 0.5 + 0.5;
        addedLights += saturate(n) * directionalLightColor[l];
    }
    lightRGB = addedLights + 0.5;
    lightHSV = rgb2hsv(lightRGB);

    vec3 mvNormal = normalize(mat3(modelViewMatrix) * normal);
    vec3 mvPosition = (modelViewMatrix * vec4(position, 1.0)).xyz;
    vec3 mvToEye = -normalize(mvPosition);

    float rimDot = 1.0 - max(dot(mvToEye, mvNormal), 0.0);
    rim = vec3(smoothstep(rimPower, 1.0, rimDot)) * rimColor * rimIntensity * map2blend;

    #{ THREE.ShaderChunk[ "shadowmap_vertex" ] }
}
