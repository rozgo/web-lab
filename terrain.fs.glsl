#{ THREE.ShaderChunk[ "common" ] }

varying vec3 lightRGB;
varying vec3 lightHSV;
varying vec3 rim;

varying float map2blend;

// uniform vec3 ambient;
uniform vec3 diffuse;
uniform vec3 diffuse2;
uniform sampler2D map;
uniform sampler2D map2;

#{ THREE.ShaderChunk[ "uv_pars_fragment" ] }

#{ THREE.ShaderChunk[ "shadowmap_pars_fragment" ] }

#{ shaders["hsv"] }

// uniform sampler2D heightmap;

void main(void) {

    // vec4 srcColor = texture2D(map2, vUv * 1.0);
    // vec4 dstColor = texture2D(map, vUv);
    vec3 srcColor = diffuse2 * (map2blend);
    vec3 dstColor = diffuse * (1.0 - map2blend);
    float srcAlpha = map2blend;

    vec4 diffuseRGB = texture2D(map, vUv) * vec4(srcColor + dstColor, 1.0);

    if (diffuseRGB.a > 0.1) {

      vec3 shadowMask = vec3(1.0);

      #{ THREE.ShaderChunk[ "shadowmap_fragment" ] }

      vec3 diffuseHSV = rgb2hsv(diffuseRGB.rgb);
      diffuseHSV.g = diffuseHSV.g + (1.0 - min(lightHSV.b * shadowMask.r * 0.5, 1.0));
      diffuseHSV.b = diffuseHSV.b * shadowMask.r;
      diffuseRGB = vec4(hsv2rgb(diffuseHSV) * lightRGB, 1.0);
      gl_FragColor = diffuseRGB + vec4(rim,1.0);
    }
    else {
      discard;
    }

}
