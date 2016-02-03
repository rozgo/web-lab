(function() {
  var FXAA;

  FXAA = {};

  FXAA.createMaterial = function(width, height) {
    var material;
    material = new THREE.ShaderMaterial({
      uniforms: THREE.UniformsUtils.merge([
        {
          tDiffuse: {
            type: 't',
            value: new THREE.Texture
          },
          resolution: {
            type: 'v2',
            value: new THREE.Vector2(width, height)
          }
        }
      ]),
      vertexShader: shaders['fxaa.vs'],
      fragmentShader: shaders['fxaa.fs']
    });
    return material;
  };

  window.FXAA = FXAA;

}).call(this);
