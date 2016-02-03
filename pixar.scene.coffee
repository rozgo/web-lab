scene = (domScene) ->

  SCREEN_WIDTH = domScene.width
  SCREEN_HEIGHT = domScene.height
  VIEW_ANGLE = 60
  ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT
  NEAR = 0.1
  FAR = 1000

  scene = new THREE.Scene

  camera = new THREE.PerspectiveCamera VIEW_ANGLE, ASPECT, NEAR, FAR
  camera.position.set 7, 5, 7
  # camera.lookAt scene.position
  scene.add camera

  renderer = new THREE.WebGLRenderer
    antialias: false
    alpha: false
  renderer.setSize SCREEN_WIDTH, SCREEN_HEIGHT
  renderer.setClearColor 0x222222, 1
  renderer.shadowMap.enabled = true
  renderer.gammaInput = true
  renderer.gammaOutput = true
  renderer.autoClear = false
  domScene.renderer = renderer

  lookObj = new THREE.Object3D

  controls = new THREE.OrbitControls camera, renderer.domElement
  controls.target.set 0, 2, 0

  composer = new THREE.EffectComposer renderer
  composer.addPass (new THREE.RenderPass scene, camera)

  effectFXAA = new THREE.ShaderPass (FXAA.createMaterial SCREEN_WIDTH, SCREEN_HEIGHT)
  # composer.addPass effectFXAA

  effectBloom = new THREE.BloomPass 0.6, 25, 4, 256
  composer.addPass effectBloom

  effectCopy = new THREE.ShaderPass THREE.CopyShader
  composer.addPass effectCopy

  effectCopy.renderToScreen = true

  textureLoader = new THREE.TextureLoader

  customMaterial = Pixar.createMaterial()
  textureLoader.load 'assets/uv-guide.jpg', (texture) ->
    customMaterial.uniforms.map.value = texture

  loader = new THREE.OBJLoader

  bumblebee =
    source: 'assets/Bumblebee/Bumblebee.obj'
    diffuse: 'assets/Bumblebee/Bumblebee.png'
    object: new THREE.Object3D

  spiderman =
    source: 'assets/Spiderman/Spiderman.obj'
    diffuse: 'assets/Spiderman/Spiderman.png'
    object: new THREE.Object3D

  hulk =
    source: 'assets/Hulk/Hulk.obj'
    diffuse: 'assets/Hulk/Hulk2.png'
    object: new THREE.Object3D

  loadOBJ = (entity, onload) ->
    onloadOBJ = (object) ->
      material = Pixar.createMaterial()
      # material.uniforms.rimColor.value = new THREE.Color 0x5dd2f1
      material.uniforms.rimPower.value = 0.4
      material.uniforms.rimIntensity.value = 0.5
      textureLoader.load entity.diffuse, (texture) ->
        material.uniforms.map.value = texture
      object.traverse (child) ->
        if child instanceof THREE.Mesh
          child.material = material
          child.castShadow = true
          # child.receiveShadow = true
      onload object, material
      scene.add object
      entity.object = object
    loader.load entity.source, onloadOBJ

  loadOBJ bumblebee, (object, material) ->
    material.uniforms.diffuse.value = new THREE.Color 0x707070
    object.position.x = -1
    object.position.z = 2
    object.scale.set 0.007, 0.007, 0.007
    object.rotation.x = -Math.PI / 2

  loadOBJ spiderman, (object, material) ->
    material.uniforms.diffuse.value = new THREE.Color 0x909090
    object.position.x = 2
    object.position.z = -1

  loadOBJ hulk, (object, material) ->
    material.uniforms.diffuse.value = new THREE.Color 0x707070
    object.position.x = -3
    object.position.z = -3
    object.scale.set 70, 70, 70

  planeGEO = new THREE.PlaneGeometry 20, 20, 100, 100
  planeMat = Pixar.createMaterial()
  # planeMat.uniforms.diffuse.value = new THREE.Color 0x606060
  planeMat.uniforms.rimIntensity.value = 0
  textureLoader.load 'assets/uv-guide.jpg', (texture) ->
    planeMat.uniforms.map.value = texture
  plane = new THREE.Mesh planeGEO, planeMat
  plane.rotation.x = -Math.PI / 2
  plane.receiveShadow = true
  scene.add plane

  # gridHelper = new THREE.GridHelper 10, 1
  # scene.add gridHelper

  directionalLight = new THREE.DirectionalLight 0xffffff, 2.0
  directionalLight.position.set 0, 4, 5
  directionalLight.castShadow = true
  directionalLight.shadow.darkness = 0.5
  directionalLight.shadow.bias = 0.001
  directionalLight.shadowCameraRight =  10
  directionalLight.shadowCameraLeft = -10
  directionalLight.shadowCameraTop =  10
  directionalLight.shadowCameraBottom = -10
  directionalLight.shadowCameraNear = 0.1
  directionalLight.shadowCameraFar = 20
  directionalLight.shadowMapWidth = 2048
  directionalLight.shadowMapHeight = 2048
  scene.add directionalLight

  # dirLighthelper = new THREE.DirectionalLightHelper directionalLight, 1
  # scene.add dirLighthelper

  cameraHelper = new THREE.CameraHelper directionalLight.shadow.camera
  scene.add cameraHelper

  torusMat = Pixar.createMaterial()
  torusMat.uniforms.diffuse.value = new THREE.Color 0xf08020
  torusGeo = new THREE.TorusGeometry 0.7, 0.3, 16, 100
  torusObj = new THREE.Mesh torusGeo, torusMat
  torusObj.castShadow = true
  # torusObj.receiveShadow = true
  torusObj.position.set 3, 2, 3
  scene.add torusObj

  animate = ->
    requestAnimationFrame animate

    controls.update()

    bumblebee.object.rotation.z += 0.01
    spiderman.object.rotation.y += 0.01
    hulk.object.rotation.y += 0.01

    torusObj.rotation.x += 0.01
    torusObj.rotation.y += 0.01

    # renderer.render scene, camera
    composer.render()

  domScene.animate = animate

window.sceneInit = scene
