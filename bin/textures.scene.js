(function() {
  var scene;

  scene = function(domScene) {
    var ASPECT, FAR, NEAR, SCREEN_HEIGHT, SCREEN_WIDTH, VIEW_ANGLE, animate, axisHelper, camera, composer, controls, effectBloom, effectCopy, gentexture, i, j, material, offset, plane, planeGEO, renderer, spacing, texture, textureLoader;
    SCREEN_WIDTH = domScene.width;
    SCREEN_HEIGHT = domScene.height;
    VIEW_ANGLE = 60;
    ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT;
    NEAR = 0.1;
    FAR = 1000;
    scene = new THREE.Scene;
    camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
    camera.position.set(7, 5, 7);
    camera.lookAt(scene.position);
    scene.add(camera);
    renderer = new THREE.WebGLRenderer({
      antialias: true,
      alpha: true
    });
    renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    renderer.setClearColor(0x222222, 1);
    renderer.shadowMap.enabled = true;
    renderer.gammaInput = true;
    renderer.gammaOutput = true;
    renderer.autoClear = false;
    domScene.renderer = renderer;
    controls = new THREE.OrbitControls(camera, renderer.domElement);
    composer = new THREE.EffectComposer(renderer);
    composer.addPass(new THREE.RenderPass(scene, camera));
    effectBloom = new THREE.BloomPass(0.5, 25, 4, 256);
    composer.addPass(effectBloom);
    effectCopy = new THREE.ShaderPass(THREE.CopyShader);
    composer.addPass(effectCopy);
    effectCopy.renderToScreen = true;
    textureLoader = new THREE.TextureLoader;
    axisHelper = new THREE.AxisHelper(5);
    scene.add(axisHelper);
    texture = (new TG.Texture(256, 256)).set(new TG.FractalNoise().baseFrequency(32).octaves(6).step(2).interpolation(2));
    gentexture = new THREE.DataTexture(texture.toTHREE(), texture.buffer.width, texture.buffer.height, THREE.RGBAFormat);
    gentexture.needsUpdate = true;
    material = new THREE.MeshBasicMaterial({
      side: THREE.FrontSide,
      map: gentexture
    });
    spacing = 2;
    offset = spacing * 2;
    for (i = j = 0; j < 25; i = ++j) {
      planeGEO = new THREE.PlaneGeometry(1, 1);
      plane = new THREE.Mesh(planeGEO, material);
      plane.position.x = i % 5 * spacing - offset;
      plane.position.z = (Math.floor(i / 5)) * spacing - offset;
      scene.add(plane);
    }
    animate = function() {
      requestAnimationFrame(animate);
      return renderer.render(scene, camera);
    };
    return domScene.animate = animate;
  };

  window.sceneInit = scene;

}).call(this);
