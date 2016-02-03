#{ THREE.ShaderChunk[ "common" ] }

varying vec3 lightRGB;
varying vec3 lightHSV;
varying vec3 rim;

uniform vec3 diffuse;
uniform sampler2D map;

#{ THREE.ShaderChunk[ "uv_pars_fragment" ] }
#{ THREE.ShaderChunk[ "color_pars_fragment" ] }

#{ THREE.ShaderChunk[ "shadowmap_pars_fragment" ] }

#{ shaders["hsv"] }

void main(void) {

    vec4 diffuseColor = vec4(1.0, 1.0, 1.0, 1.0);
    #{ THREE.ShaderChunk[ "color_fragment" ] }

    vec4 diffuseRGB = texture2D(map, vUv) * diffuseColor;
    diffuseRGB.rgb = diffuseRGB.rgb * diffuse;

    if (diffuseRGB.a > 0.1) {

      vec3 shadowMask = vec3(1.0);
      #{ THREE.ShaderChunk[ "shadowmap_fragment" ] }

      vec3 diffuseHSV = rgb2hsv(diffuseRGB.rgb);
      diffuseHSV.g = diffuseHSV.g + (1.0 - min(lightHSV.b * shadowMask.r, 1.0));
      diffuseHSV.b = diffuseHSV.b * shadowMask.r;
      diffuseRGB = vec4(hsv2rgb(diffuseHSV) * lightRGB, 1.0);
      gl_FragColor = diffuseRGB + vec4(rim,1.0);
    }
    else {
      discard;
    }
}
