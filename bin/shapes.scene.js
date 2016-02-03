(function() {
  var scene;

  scene = function(domScene) {
    var ASPECT, FAR, NEAR, SCREEN_HEIGHT, SCREEN_WIDTH, VIEW_ANGLE, animate, camera, composer, controls, createMonitor, directionalLight, effectBloom, effectCopy, makeShapes, makeSky, makeTerrain, monitors, params, renderer, sky, textureLoader, torus, zero;
    SCREEN_WIDTH = domScene.width;
    SCREEN_HEIGHT = domScene.height;
    VIEW_ANGLE = 60;
    ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT;
    NEAR = 0.1;
    FAR = 1000;
    torus = new THREE.Object3D;
    scene = new THREE.Scene;
    camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
    camera.position.set(-17, 5, 17);
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
    monitors = [];
    createMonitor = function(texture) {
      var geo, i, k, material, mesh, ref, results;
      material = new THREE.MeshBasicMaterial({
        side: THREE.FrontSide,
        map: texture
      });
      geo = new THREE.PlaneBufferGeometry(1, 1);
      mesh = new THREE.Mesh(geo, material);
      monitors.push(mesh);
      camera.add(mesh);
      results = [];
      for (i = k = 0, ref = monitors.length; 0 <= ref ? k < ref : k > ref; i = 0 <= ref ? ++k : --k) {
        results.push(mesh.position.set((i - monitors.length / 2.0) * 2, 4, -8));
      }
      return results;
    };
    textureLoader = new THREE.TextureLoader;
    directionalLight = new THREE.DirectionalLight(0xFFFFFF, 2.0);
    directionalLight.position.set(5, 4, 5);
    directionalLight.castShadow = true;
    directionalLight.shadow.darkness = 0.2;
    directionalLight.shadow.bias = 0.001;
    directionalLight.shadowCameraRight = 20;
    directionalLight.shadowCameraLeft = -20;
    directionalLight.shadowCameraTop = 20;
    directionalLight.shadowCameraBottom = -20;
    directionalLight.shadowCameraNear = 0.1;
    directionalLight.shadowCameraFar = 20;
    directionalLight.shadowMapWidth = 2048;
    directionalLight.shadowMapHeight = 2048;
    scene.add(directionalLight);
    params = [Shape.supershape(1, 1, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2), Shape.supershape(1, 1, 1, 37, 1, 19, 1, 1, 4, 100, 100, 100), Shape.supershape(1, 1, 4, 100, 100, 100, 1, 1, 4, 100, 100, 100), Shape.supershape(1, 1, 4, 1, 1, 1, 1, 1, 4, 1, 1, 1), Shape.supershape(1, 1, 4, 100, 1, 1, 1, 1, 4, 1, 1, 1), Shape.supershape(1, 1, 3, 260, 500, 500, 1, 1, 4, 200, 200, 200), Shape.supershape(1, 1, 5, 1000, 600, 600, 1, 1, 4, 300, 300, 300), Shape.supershape(1, 1, 6, 1000, 400, 400, 1, 1, 4, 300, 300, 300), Shape.supershape(1, 1, 5, 3, 6, 6, 1, 1, 5, 3, 6, 6), Shape.supershape(1, 1, 7, 3, 4, 17, 1, 1, 7, 3, 4, 17), Shape.supershape(1, 1, 2, 14, 6, 16, 1, 1, 11, 5, 15, 9), Shape.supershape(1, 1, 19, 9, 14, 11, 1, 1, 19, 9, 14, 11), Shape.supershape(1, 1, 12, 19, 2, 3, 1, 1, 4, 3, 12, 8), Shape.supershape(1, 1, 6, 10, 20, 15, 1, 1, 1, 2, 10, 10), Shape.supershape(1, 1, 3, 2, 18, 3, 1, 1, 1, 5, 5, 2), Shape.supershape(1, 1, 5, 1, 1, 2, 1, 1, 5, 1, 1, 3), Shape.cylinder, Shape.trumpet, Shape.sphere, Shape.astroidal, Shape.cube, Shape.plane, Shape.torus, Shape.radialWave];
    makeShapes = function() {
      var geometry, i, instancedGeo, instances, j, k, l, mesh, offset, offsets, ref, ref1, results, shapeMaterial, spacing, x, z;
      shapeMaterial = Pixar.createMaterial();
      textureLoader.load('assets/uv-guide-02.jpg', function(texture) {
        return shapeMaterial.uniforms.map.value = texture;
      });
      shapeMaterial.uniforms.offsetRepeat.value = new THREE.Vector4(0, 0, 1, 1);
      shapeMaterial.uniforms.rimPower.value = 0.4;
      shapeMaterial.uniforms.rimIntensity.value = 0.5;
      spacing = 5;
      offset = spacing * 2;
      results = [];
      for (i = k = 0, ref = params.length; 0 <= ref ? k < ref : k > ref; i = 0 <= ref ? ++k : --k) {
        geometry = new THREE.ParametricGeometry(params[i], 50, 50);
        geometry.mergeVertices();
        geometry.computeFaceNormals();
        geometry.computeVertexNormals();
        instances = 1;
        instancedGeo = new THREE.InstancedBufferGeometry().fromGeometry(geometry);
        instancedGeo.maxInstancedCount = instances;
        x = i % 5 * spacing - offset;
        z = (Math.floor(i / 5)) * spacing - offset;
        offsets = new THREE.InstancedBufferAttribute(new Float32Array(instances * 3), 3, 1);
        for (j = l = 0, ref1 = offsets.count; 0 <= ref1 ? l < ref1 : l > ref1; j = 0 <= ref1 ? ++l : --l) {
          offsets.setXYZ(j, 0, j * 4, 0);
        }
        instancedGeo.addAttribute('offset', offsets);
        mesh = new THREE.Mesh(instancedGeo, shapeMaterial);
        mesh.position.set(x, 0, z);
        mesh.castShadow = true;
        results.push(scene.add(mesh));
      }
      return results;
    };
    makeShapes();
    makeTerrain = function() {
      var deform, geo, heightmap, material, mesh, texture;
      texture = (new TG.Texture(64, 64)).set(new TG.FractalNoise().baseFrequency(0.8).persistence(0.7).amplitude(0.1).step(2).interpolation(2)).add(new TG.Number().tint(0.3, 0.3, 0.3));
      texture = (new TG.Texture(64, 64)).add(new TG.CheckerBoard().size(6, 6)).mul(new TG.RadialGradient().center(32, 32).radius(50).interpolation(2).point(0, [0, 0, 0, 1]).point(0.4, [0, 0, 0, 1]).point(0.5, [0.5, 0.5, 0.5, 1]).point(0.6, [0, 0, 0, 1]).point(1.0, [0, 0, 0, 1])).add(new TG.RadialGradient().center(32, 32).radius(64).interpolation(2).point(0, [0, 0, 0, 1]).point(0.4, [0, 0, 0, 1]).point(0.5, [0.8, 0.8, 0.8, 1]).point(0.6, [0, 0, 0, 1]).point(1.0, [0, 0, 0, 1])).mul(new TG.FractalNoise().baseFrequency(16).persistence(0.5).amplitude(1.0).octaves(6).step(2).interpolation(2)).mul(new TG.LinearGradient().interpolation(2).point(0, [1, 1, 1, 1]).point(0.40, [1, 1, 1, 1]).point(0.48, [0, 0, 0, 1]).point(0.52, [0, 0, 0, 1]).point(0.60, [1, 1, 1, 1]).point(1, [1, 1, 1, 1]));
      heightmap = new THREE.DataTexture(texture.toTHREE(), texture.buffer.width, texture.buffer.height);
      heightmap.needsUpdate = true;
      material = Terrain.createMaterial();
      material.uniforms.offsetRepeat.value = new THREE.Vector4(0, 0, 2, 2);
      material.uniforms.rimColor.value = new THREE.Color(0xff00ff);
      material.uniforms.rimPower.value = 0.4;
      material.uniforms.rimIntensity.value = 0.3;
      material.uniforms.heightmap.value = heightmap;
      material.uniforms.diffuse.value = new THREE.Color(0x587b91);
      material.uniforms.diffuse2.value = new THREE.Color(0x587b91);
      deform = function(u, v) {
        var unit, unitLength, uu, vv, y;
        unit = new THREE.Vector2(u - 0.5, v - 0.5);
        unitLength = Math.min(unit.length(), 0.5);
        unit = (unit.normalize()).multiplyScalar(unitLength);
        unit = new THREE.Vector2(unit.x + 0.5, unit.y + 0.5);
        uu = Math.floor(unit.x * texture.buffer.width);
        vv = Math.floor(unit.y * texture.buffer.height);
        y = texture.buffer.array[texture.buffer.width * 4 * vv + uu * 4];
        return new THREE.Vector3(-unit.x * 100 + 50, y * 20, unit.y * 100 - 50);
      };
      geo = new THREE.ParametricGeometry(deform, 100, 100);
      geo.mergeVertices();
      geo = new THREE.BufferGeometry().fromGeometry(geo);
      mesh = new THREE.Mesh(geo, material);
      mesh.position.y = -3;
      mesh.receiveShadow = true;
      mesh.castShadow = true;
      scene.add(mesh);
      return createMonitor(heightmap);
    };
    makeSky = function() {
      var geo, sky, skymap, skysphere, texture;
      texture = (new TG.Texture(64, 64)).set(new TG.LinearGradient().interpolation(2).point(0, [0.8, 0.8, 1, 1]).point(0.25, [1, 1, 1, 1]).point(0.5, [0, 0, 0, 1]).point(0.75, [0, 0, 0, 1]).point(1, [1, 1, 1, 1])).set(new TG.Transform().angle(90));
      skymap = new THREE.DataTexture(texture.toTHREE(), texture.buffer.width, texture.buffer.height);
      skymap.needsUpdate = true;
      skysphere = function(u, v) {
        var p, x, y, z;
        u = (u - 0.5) * 2 * Math.PI;
        v = (1.0 - v) * Math.PI;
        x = (Math.sin(v)) * (Math.cos(u));
        y = Math.cos(v);
        z = (Math.sin(v)) * (Math.sin(u));
        p = new THREE.Vector3(x, y, z);
        return p.multiplyScalar(100);
      };
      geo = new THREE.ParametricGeometry(skysphere, 20, 20);
      sky = {
        object: new THREE.Object3D()
      };
      textureLoader.load('assets/sky-03.jpg', function(texture) {
        var material;
        material = new THREE.MeshBasicMaterial({
          side: THREE.FrontSide,
          map: texture
        });
        return sky.object = new THREE.Mesh(geo, material);
      });
      return sky;
    };
    sky = makeSky();
    zero = new THREE.Vector3(0, 0, 0);
    animate = function() {
      requestAnimationFrame(animate);
      sky.object.rotation.z += 0.001;
      sky.object.rotation.y += 0.001;
      return composer.render();
    };
    return domScene.animate = animate;
  };

  window.sceneInit = scene;

}).call(this);
