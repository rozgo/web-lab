scene = (domScene) ->

  SCREEN_WIDTH = domScene.width
  SCREEN_HEIGHT = domScene.height
  VIEW_ANGLE = 60
  ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT
  NEAR = 0.1
  FAR = 1000

  torus = new THREE.Object3D

  scene = new THREE.Scene

  camera = new THREE.PerspectiveCamera VIEW_ANGLE, ASPECT, NEAR, FAR
  camera.position.set -2, 0, 2
  camera.lookAt scene.position
  scene.add camera

  envCamera = camera.clone()

  renderer = new THREE.WebGLRenderer
    antialias: true
    alpha: true
  renderer.setSize SCREEN_WIDTH, SCREEN_HEIGHT
  #renderer.setClearColor 0x222222, 1
  renderer.setClearColor 0x000000, 1
  renderer.shadowMap.enabled = true
  renderer.gammaInput = true
  renderer.gammaOutput = true
  renderer.autoClear = false
  domScene.renderer = renderer

  controls = new THREE.OrbitControls camera, renderer.domElement

  composer = new THREE.EffectComposer renderer
  composer.addPass( new THREE.RenderPass( scene, camera ) )

  effectBloom = new THREE.BloomPass 0.5, 25, 4, 256
  composer.addPass effectBloom

  effectCopy = new THREE.ShaderPass THREE.CopyShader
  composer.addPass effectCopy

  effectCopy.renderToScreen = true

  monitors = []

  createMonitor = (texture) ->
    material = new THREE.MeshBasicMaterial {
      side: THREE.FrontSide
      map: texture
      # depthTest: false
    }
    geo = new THREE.PlaneBufferGeometry 1, 1
    mesh = new THREE.Mesh geo, material
    monitors.push mesh
    camera.add mesh
    for i in [0 ... monitors.length]
      mesh.position.set ((i - monitors.length / 2.0) * 2), 4, -8

  textureLoader = new THREE.TextureLoader

  # gridHelper = new THREE.GridHelper 10, 1
  # scene.add gridHelper

  directionalLight = new THREE.DirectionalLight 0xFFFFFF, 2.0
  directionalLight.position.set 5, 4, 5
  directionalLight.castShadow = true
  directionalLight.shadow.darkness = 0.2
  directionalLight.shadow.bias = 0.001
  directionalLight.shadowCameraRight =  20
  directionalLight.shadowCameraLeft = -20
  directionalLight.shadowCameraTop =  20
  directionalLight.shadowCameraBottom = -20
  directionalLight.shadowCameraNear = 0.1
  directionalLight.shadowCameraFar = 20
  directionalLight.shadowMapWidth = 2048
  directionalLight.shadowMapHeight = 2048
  scene.add directionalLight

  # dirLighthelper = new THREE.DirectionalLightHelper directionalLight, 1
  # scene.add dirLighthelper

  # cameraHelper = new THREE.CameraHelper directionalLight.shadow.camera
  # scene.add cameraHelper

  # axisHelper = new THREE.AxisHelper 5
  # scene.add axisHelper

  makeWater = ->
    waterMaterial = new THREE.MeshBasicMaterial {
      color: 0x106387
      transparent: true
      opacity: 0.7
      wireframe: false
      # envMap: envCamera.renderTarget
    }
    # waterMaterial.uniforms.diffuse.value = new THREE.Color 0x202090
    # waterMaterial.uniforms.rimColor.value = new THREE.Color 0x8080ee
    # waterMaterial.uniforms.rimPower.value = 0.4
    # waterMaterial.uniforms.rimIntensity.value = 0.3
    # waterMaterial.transparent = true
    # waterMaterial.opacity = 0.5
    waterGEO = new THREE.IcosahedronGeometry 0.99, 2
    waterMesh = new THREE.Mesh waterGEO, waterMaterial
    scene.add waterMesh

  makeWater()

  makePlanet = ->

    planetMaterial = Pixar.createMaterial()
    textureLoader.load 'assets/grass-05.png', (texture) ->
      planetMaterial.uniforms.map.value = texture

    planetMaterial.uniforms.diffuse.value = new THREE.Color 0x808090
    # shapeMaterial.uniforms.map.value = diffuse
    # planetMaterial.uniforms.offsetRepeat.value = new THREE.Vector4 0, 0, 1, 1
    planetMaterial.uniforms.rimColor.value = new THREE.Color 0x00ed80
    planetMaterial.uniforms.rimPower.value = 0.4
    planetMaterial.uniforms.rimIntensity.value = 0.3
    # planetMaterial.wireframe = true

    planetGEO = new THREE.IcosahedronGeometry 1, 5

    noise.seed (Math.random())

    console.log planetGEO.vertices.length
    for i in [0 ... planetGEO.vertices.length]
      v = planetGEO.vertices[i]
      h = (noise.simplex3 v.x * 0.5, v.y * 0.5, v.z * 0.5)# + 0.1# % 2.0
      h = Math.floor((h * 4.0)) / 4.0
      # if h < 0.5 && h > -0.5 then h = 0

      # if h < 0.5 && h > -0.5 then h = 0
      # if h < -0.5 then h = -10
      # h = Math.sin h
      n = v.clone().normalize().multiplyScalar(h * 0.5)
      planetGEO.vertices[i].add n
      # console.log planetGEO.vertices[i]
    planetGEO.mergeVertices()
    planetGEO.computeFaceNormals()
    planetGEO.computeVertexNormals()

    planetMesh = new THREE.Mesh planetGEO, planetMaterial
    # planetMesh.scale.set 2, 2, 2
    scene.add planetMesh


  makePlanet()

  makeSky = ->

    texture = (new TG.Texture 64, 64)
      .set(new TG.LinearGradient().interpolation(2)
        .point( 0, [0.8,0.8,1,1] )
        .point( 0.25, [1,1,1,1])
        .point( 0.5, [0,0,0,1])
        .point( 0.75, [0,0,0,1])
        .point( 1, [1,1,1,1]) )
      .set(new TG.Transform().angle(90))

    skymap = new THREE.DataTexture (texture.toTHREE()), texture.buffer.width, texture.buffer.height
    # skymap.generateMipmaps = true
    # skymap.magFilter = THREE.LinearFilter
    # skymap.minFilter = THREE.LinearMipMapLinearFilter
    skymap.needsUpdate = true

    skysphere = (u, v) ->
      u = (u - 0.5) * 2 * Math.PI
      v =  (1.0 - v) * Math.PI
      x = (Math.sin v) * (Math.cos u)
      y = Math.cos v
      z = (Math.sin v) * (Math.sin u)
      p = new THREE.Vector3 x, y, z
      p.multiplyScalar(100)

    geo = new THREE.ParametricGeometry skysphere, 20, 20

    sky = {
      object: new THREE.Object3D()
    }

    # material.uniforms.diffuse.value = new THREE.Color 0xff0000
    textureLoader.load 'assets/sky-01.jpg', (texture) ->
      material = new THREE.MeshBasicMaterial {side: THREE.FrontSide, map: texture}
      # texture.wrapS = THREE.RepeatWrapping
      # texture.wrapT = THREE.RepeatWrapping
      # material.uniforms.map.value = texture
      sky.object = new THREE.Mesh geo, material
      # scene.add sky.object
    sky

  sky = makeSky()


  animate = ->
    requestAnimationFrame animate

    sky.object.rotation.z += 0.001
    sky.object.rotation.y += 0.001
    # sky.object.position = camera.worldToLocal zero


    # renderer.render scene, camera
    composer.render()

  domScene.animate = animate

window.sceneInit = scene
