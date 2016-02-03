libs =
  test: """
    #inline{ pixar.vs.glsl }
    """

  hsv: """
		vec3 rgb2hsv(vec3 c)
		{
		    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
		    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
		    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

		    float d = q.x - min(q.w, q.y);
		    float e = 1.0e-10;
		    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		vec3 hsv2rgb(vec3 c)
		{
		    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
		    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
		    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
		}
    """
pixar =

  vs: """
		varying vec2 vUv;
		varying vec4 vecColor;
		varying vec3 hsv;
    // varying vec3 hsv;
		varying vec3 rim;

    #{ THREE.ShaderChunk[ "shadowmap_pars_vertex" ] }

		uniform vec3 directionalLightDirection[MAX_DIR_LIGHTS];
		uniform vec3 directionalLightColor[MAX_DIR_LIGHTS];

		#{ libs.hsv }

		void main() {
		    vUv = uv;
		    vec3 vecPos = (modelMatrix * vec4(position, 1.0 )).xyz;
				vec4 worldPosition = vec4(vecPos,1.0);
		    vec3 vecNormal = normalize((normalMatrix) * normal);
		    gl_Position = projectionMatrix * viewMatrix * vec4(vecPos, 1.0);

				vec4 addedLights = vec4(0.0,0.0,0.0, 1.0);
		    for(int l = 0; l < MAX_DIR_LIGHTS; l++) {
				    float n = clamp(dot(directionalLightDirection[l], vecNormal * 0.5 + 0.5), 0.0, 1.0);
		        addedLights.rgb += n * directionalLightColor[l];
		    }

				vecColor = addedLights;

				vec3 mvNormal = normalize(mat3(modelViewMatrix) * normal);
				vec3 mvPosition = (modelViewMatrix * vec4(position, 1.0 )).xyz;
				vec3 mvToEye = normalize(-mvPosition);
				float rimPower = 1.0 - max(dot(mvToEye, mvNormal), 0.0);

				rim = vec3(smoothstep(0.3, 1.0, rimPower)) * vec3(0.0, 0.5, 0.9) * 1.0;

				hsv = rgb2hsv(vecColor.rgb);

        #{ THREE.ShaderChunk[ "shadowmap_vertex" ] }
		}
    """

  fs: """
		precision highp float;

		const float PI = 3.1415926535897932384626433832795;
		const float PI_2 = 1.57079632679489661923;
		const float PI_4 = 0.785398163397448309616;

		varying vec2 vUv;
		varying vec4 vecColor;
		varying vec3 hsv;
		varying vec3 rim;

		uniform float color;
		uniform sampler2D diffuse;

    #{ THREE.ShaderChunk[ "shadowmap_pars_fragment" ] }

		#{ libs.hsv }

		void main(void) {
				vec4 c = vec4(hsv2rgb(hsv), 1.0);

				vec4 diffuse = texture2D(diffuse, vUv);

				if (diffuse.a > 0.1) {

					vec3 diffuseHSV = rgb2hsv(diffuse.rgb * (vecColor.rgb * 0.5 + 0.5) );

					vec3 outgoingLight = vec3(1.0);

          #{ THREE.ShaderChunk[ "shadowmap_fragment" ] }

					diffuseHSV.g = (max(diffuseHSV.g + max(1.0 - hsv.b * outgoingLight.r, 0.0), 0.0)) * 1.0;
					diffuseHSV.b = diffuseHSV.b * outgoingLight.r;
					vec4 diffuseRGB = vec4(hsv2rgb(diffuseHSV), 1.0);

					gl_FragColor = diffuseRGB + vec4(rim,1.0);
				}
				else {
					discard;
				}

		}
    """
