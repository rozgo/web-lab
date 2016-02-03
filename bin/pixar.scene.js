(function() {
  var scene;

  scene = function(domScene) {
    var ASPECT, FAR, NEAR, SCREEN_HEIGHT, SCREEN_WIDTH, VIEW_ANGLE, animate, bumblebee, camera, cameraHelper, composer, controls, customMaterial, directionalLight, effectBloom, effectCopy, effectFXAA, hulk, loadOBJ, loader, lookObj, plane, planeGEO, planeMat, renderer, spiderman, textureLoader, torusGeo, torusMat, torusObj;
    SCREEN_WIDTH = domScene.width;
    SCREEN_HEIGHT = domScene.height;
    VIEW_ANGLE = 60;
    ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT;
    NEAR = 0.1;
    FAR = 1000;
    scene = new THREE.Scene;
    camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
    camera.position.set(7, 5, 7);
    scene.add(camera);
    renderer = new THREE.WebGLRenderer({
      antialias: false,
      alpha: false
    });
    renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
    renderer.setClearColor(0x222222, 1);
    renderer.shadowMap.enabled = true;
    renderer.gammaInput = true;
    renderer.gammaOutput = true;
    renderer.autoClear = false;
    domScene.renderer = renderer;
    lookObj = new THREE.Object3D;
    controls = new THREE.OrbitControls(camera, renderer.domElement);
    controls.target.set(0, 2, 0);
    composer = new THREE.EffectComposer(renderer);
    composer.addPass(new THREE.RenderPass(scene, camera));
    effectFXAA = new THREE.ShaderPass(FXAA.createMaterial(SCREEN_WIDTH, SCREEN_HEIGHT));
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
    loader = new THREE.OBJLoader;
    bumblebee = {
      source: 'assets/Bumblebee/Bumblebee.obj',
      diffuse: 'assets/Bumblebee/Bumblebee.png',
      object: new THREE.Object3D
    };
    spiderman = {
      source: 'assets/Spiderman/Spiderman.obj',
      diffuse: 'assets/Spiderman/Spiderman.png',
      object: new THREE.Object3D
    };
    hulk = {
      source: 'assets/Hulk/Hulk.obj',
      diffuse: 'assets/Hulk/Hulk2.png',
      object: new THREE.Object3D
    };
    loadOBJ = function(entity, onload) {
      var onloadOBJ;
      onloadOBJ = function(object) {
        var material;
        material = Pixar.createMaterial();
        material.uniforms.rimPower.value = 0.4;
        material.uniforms.rimIntensity.value = 0.5;
        textureLoader.load(entity.diffuse, function(texture) {
          return material.uniforms.map.value = texture;
        });
        object.traverse(function(child) {
          if (child instanceof THREE.Mesh) {
            child.material = material;
            return child.castShadow = true;
          }
        });
        onload(object, material);
        scene.add(object);
        return entity.object = object;
      };
      return loader.load(entity.source, onloadOBJ);
    };
    loadOBJ(bumblebee, function(object, material) {
      material.uniforms.diffuse.value = new THREE.Color(0x707070);
      object.position.x = -1;
      object.position.z = 2;
      object.scale.set(0.007, 0.007, 0.007);
      return object.rotation.x = -Math.PI / 2;
    });
    loadOBJ(spiderman, function(object, material) {
      material.uniforms.diffuse.value = new THREE.Color(0x909090);
      object.position.x = 2;
      return object.position.z = -1;
    });
    loadOBJ(hulk, function(object, material) {
      material.uniforms.diffuse.value = new THREE.Color(0x707070);
      object.position.x = -3;
      object.position.z = -3;
      return object.scale.set(70, 70, 70);
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
    scene.add(plane);
    directionalLight = new THREE.DirectionalLight(0xffffff, 2.0);
    directionalLight.position.set(0, 4, 5);
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
    cameraHelper = new THREE.CameraHelper(directionalLight.shadow.camera);
    scene.add(cameraHelper);
    torusMat = Pixar.createMaterial();
    torusMat.uniforms.diffuse.value = new THREE.Color(0xf08020);
    torusGeo = new THREE.TorusGeometry(0.7, 0.3, 16, 100);
    torusObj = new THREE.Mesh(torusGeo, torusMat);
    torusObj.castShadow = true;
    torusObj.position.set(3, 2, 3);
    scene.add(torusObj);
    animate = function() {
      requestAnimationFrame(animate);
      controls.update();
      bumblebee.object.rotation.z += 0.01;
      spiderman.object.rotation.y += 0.01;
      hulk.object.rotation.y += 0.01;
      torusObj.rotation.x += 0.01;
      torusObj.rotation.y += 0.01;
      return composer.render();
    };
    return domScene.animate = animate;
  };

  window.sceneInit = scene;

}).call(this);
