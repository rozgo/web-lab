(function() {
  var scene;

  scene = function(domScene) {
    var ASPECT, FAR, NEAR, SCREEN_HEIGHT, SCREEN_WIDTH, VIEW_ANGLE, animate, axisHelper, camera, cameraHelper, char, composer, controls, customMaterial, dirLighthelper, directionalLight, effectBloom, effectCopy, effectFXAA, focusObj, gridHelper, loadOBJ, loader, plane, planeGEO, planeMat, renderer, textureLoader, torus;
    SCREEN_WIDTH = domScene.width;
    SCREEN_HEIGHT = domScene.height;
    VIEW_ANGLE = 60;
    ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT;
    NEAR = 0.1;
    FAR = 1000;
    torus = new THREE.Object3D;
    focusObj = new THREE.Object3D;
    scene = new THREE.Scene;
    camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
    camera.position.set(7, 5, 7);
    camera.lookAt(scene.position);
    scene.add(camera);
    renderer = new THREE.WebGLRenderer({
      antialias: false,
      alpha: false
    });
    renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    renderer.setClearColor(0x000000, 1);
    renderer.shadowMap.enabled = true;
    renderer.gammaInput = true;
    renderer.gammaOutput = true;
    renderer.autoClear = false;
    domScene.renderer = renderer;
    controls = new THREE.OrbitControls(camera, renderer.domElement);
    composer = new THREE.EffectComposer(renderer);
    composer.addPass(new THREE.RenderPass(scene, camera));
    effectFXAA = new THREE.ShaderPass(FXAA.createMaterial(SCREEN_WIDTH, SCREEN_HEIGHT));
    composer.addPass(effectFXAA);
    effectBloom = new THREE.BloomPass(0.6, 25, 4, 256);
    composer.addPass(effectBloom);
    effectCopy = new THREE.ShaderPass(THREE.CopyShader);
    composer.addPass(effectCopy);
    effectCopy.renderToScreen = true;
    textureLoader = new THREE.TextureLoader;
    customMaterial = Pixar.createMaterial();
    textureLoader.load('assets/uv-guide.jpg', function(texture) {
      return customMaterial.uniforms.map.value = texture;
    });
    loader = new THREE.ObjectLoader;
    char = {
      source: 'assets/Char/char.json',
      diffuse: 'assets/Char/eye.jpg',
      object: new THREE.Object3D
    };
    loadOBJ = function(entity, onload) {
      var onloadOBJ;
      onloadOBJ = function(object) {
        var material;
        console.log(object);
        material = Pixar.createMaterial();
        material.uniforms.diffuse.value = new THREE.Color(0x808080);
        material.uniforms.rimPower.value = 0.4;
        material.uniforms.rimIntensity.value = 0.6;
        object.traverse(function(child) {
          if (child instanceof THREE.Mesh) {
            if (child.material.map != null) {
              material.uniforms.map.value = child.material.map;
            }
            child.material = material;
            child.castShadow = true;
            return child.receiveShadow = false;
          }
        });
        onload(object, material);
        scene.add(object);
        return entity.object = object;
      };
      return loader.load(entity.source, onloadOBJ);
    };
    loadOBJ(char, function(object, material) {
      return object.rotation.y = -Math.PI;
    });
    planeGEO = new THREE.PlaneGeometry(20, 20, 100, 100);
    planeMat = Pixar.createMaterial();
    planeMat.uniforms.rimIntensity.value = 0;
    textureLoader.load('assets/uv-guide.jpg', function(texture) {
      return planeMat.uniforms.map.value = texture;
    });
    plane = new THREE.Mesh(planeGEO, planeMat);
    plane.rotation.x = -Math.PI / 2;
    plane.receiveShadow = true;
    gridHelper = new THREE.GridHelper(10, 1);
    axisHelper = new THREE.AxisHelper(5);
    directionalLight = new THREE.DirectionalLight(0xffffff, 1.0);
    directionalLight.position.set(5, 5, 5);
    directionalLight.castShadow = true;
    directionalLight.shadow.darkness = 0.5;
    directionalLight.shadow.bias = 0.001;
    directionalLight.shadowCameraRight = 10;
    directionalLight.shadowCameraLeft = -10;
    directionalLight.shadowCameraTop = 10;
    directionalLight.shadowCameraBottom = -10;
    directionalLight.shadowCameraNear = 0.1;
    directionalLight.shadowCameraFar = 20;
    directionalLight.shadowMapWidth = 2048;
    directionalLight.shadowMapHeight = 2048;
    scene.add(directionalLight);
    dirLighthelper = new THREE.DirectionalLightHelper(directionalLight, 1);
    scene.add(dirLighthelper);
    cameraHelper = new THREE.CameraHelper(directionalLight.shadow.camera);
    animate = function() {
      requestAnimationFrame(animate);
      return composer.render();
    };
    return domScene.animate = animate;
  };

  window.sceneInit = scene;

}).call(this);
