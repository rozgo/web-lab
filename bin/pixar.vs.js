(function() {
  shaders["pixar.vs"] = THREE.ShaderChunk["common"] + "\n\nvarying vec3 lightRGB;\nvarying vec3 lightHSV;\nvarying vec3 rim;\n\n" + THREE.ShaderChunk["color_pars_vertex"] + "\n" + THREE.ShaderChunk["uv_pars_vertex"] + "\n\n" + THREE.ShaderChunk["shadowmap_pars_vertex"] + "\n\nuniform vec3 directionalLightDirection[MAX_DIR_LIGHTS];\nuniform vec3 directionalLightColor[MAX_DIR_LIGHTS];\n\nuniform float rimPower;\nuniform float rimIntensity;\nuniform vec3 rimColor;\n\nattribute vec3 offset;\n\n" + shaders["hsv"] + "\n\nvoid main() {\n\n    " + THREE.ShaderChunk["uv_vertex"] + "\n    " + THREE.ShaderChunk["color_vertex"] + "\n\n    vec3 vecPos = (modelMatrix * vec4(position + offset, 1.0 )).xyz;\n    vec4 worldPosition = vec4(vecPos,1.0);\n    vec3 vecNormal = normalize(normalMatrix * normal);\n    gl_Position = projectionMatrix * viewMatrix * vec4(vecPos, 1.0);\n\n    vec3 addedLights = vec3(0.0,0.0,0.0);\n    for(int l = 0; l < MAX_DIR_LIGHTS; l++) {\n      // float n = mod(-dot(directionalLightDirection[l], vecNormal) * 0.5 + 0.5, 0.3) + 0.5;\n      float n = dot(directionalLightDirection[l], vecNormal) * 0.5 + 0.5;\n        addedLights += saturate(n) * directionalLightColor[l];\n    }\n    lightRGB = addedLights + 0.5;\n    lightHSV = rgb2hsv(lightRGB);\n\n    vec3 mvNormal = normalize(mat3(modelViewMatrix) * normal);\n    vec3 mvPosition = (modelViewMatrix * vec4(position, 1.0)).xyz;\n    vec3 mvToEye = -normalize(mvPosition);\n\n    float rimDot = 1.0 - max(dot(mvToEye, mvNormal), 0.0);\n    rim = vec3(smoothstep(rimPower, 1.0, rimDot)) * rimColor * rimIntensity;\n\n    " + THREE.ShaderChunk["shadowmap_vertex"] + "\n}\n";

}).call(this);
