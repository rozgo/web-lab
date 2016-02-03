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
  camera.position.set -17, 5, 17
  camera.lookAt scene.position
  scene.add camera

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

  params = [
    Shape.supershape 1, 1, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2 # sphere
    Shape.supershape 1, 1, 1, 37, 1, 19, 1, 1, 4, 100, 100, 100 # cylinder
    Shape.supershape 1, 1, 4, 100, 100, 100, 1, 1, 4, 100, 100, 100 # cube
    Shape.supershape 1, 1, 4, 1, 1, 1, 1, 1, 4, 1, 1, 1 # diamond
    Shape.supershape 1, 1, 4, 100, 1, 1, 1, 1, 4, 1, 1, 1 # cone
    Shape.supershape 1, 1, 3, 260, 500, 500, 1, 1, 4, 200, 200, 200 # prism
    Shape.supershape 1, 1, 5, 1000, 600, 600, 1, 1, 4, 300, 300, 300 # pentagon
    Shape.supershape 1, 1, 6, 1000, 400, 400, 1, 1, 4, 300, 300, 300 # hexagon

    Shape.supershape 1, 1, 5, 3, 6, 6, 1, 1, 5, 3, 6, 6 # star
    Shape.supershape 1, 1, 7, 3, 4, 17, 1, 1, 7, 3, 4, 17
    Shape.supershape 1, 1, 2, 14, 6, 16, 1, 1, 11, 5, 15, 9
    Shape.supershape 1, 1, 19, 9, 14, 11, 1, 1, 19, 9, 14, 11
    Shape.supershape 1, 1, 12, 19, 2, 3, 1, 1, 4, 3, 12, 8
    Shape.supershape 1, 1, 6, 10, 20, 15, 1, 1, 1, 2, 10, 10
    Shape.supershape 1, 1, 3, 2, 18, 3, 1, 1, 1, 5, 5, 2 # heart
    Shape.supershape 1, 1, 5, 1, 1, 2, 1, 1, 5, 1, 1, 3

    Shape.cylinder
    Shape.trumpet
    Shape.sphere
    Shape.astroidal
    Shape.cube
    Shape.plane
    Shape.torus
    Shape.radialWave
  ]

  makeShapes = ->

    texture = (new TG.Texture 8, 8)
    		.add( new TG.LinearGradient()
        # .center 128, 256
        # .radius 200
        .interpolation( 1 )
        .point( 0, [1.0,1.0,1.0,1] )
        .point( 0.2, [0.7,0.7,0.7,1])
        .point( 0.4, [0.5,0.5,0.5,1])
        .point( 1, [0.0,0.0,0.0,1]) )

        .set(new TG.Transform().angle(90))
        # .mul( new TG.SinX().frequency( Math.PI ).tint( 1.0, 1.0, 1.0 ) )

        # .add( new TG.Noise() )
    diffuse = new THREE.DataTexture (texture.toTHREE()), texture.buffer.width, texture.buffer.height, THREE.RGBAFormat
    diffuse.generateMipmaps = true
    diffuse.magFilter = THREE.LinearFilter
    diffuse.minFilter = THREE.LinearMipMapLinearFilter
    diffuse.wrapS = THREE.RepeatWrapping
    diffuse.wrapT = THREE.RepeatWrapping
    diffuse.needsUpdate = true
    # createMonitor diffuse

    shapeMaterial = Pixar.createMaterial()
    # textureLoader.load 'assets/wood-color.jpg', (texture) ->
    #   shapeMaterial.uniforms.map.value = texture

    shapeMaterial.uniforms.diffuse.value = new THREE.Color 0x808090
    # shapeMaterial.uniforms.map.value = diffuse
    shapeMaterial.uniforms.offsetRepeat.value = new THREE.Vector4 0, 0, 1, 1
    shapeMaterial.uniforms.rimColor.value = new THREE.Color 0x00edff
    shapeMaterial.uniforms.rimPower.value = 0.4
    shapeMaterial.uniforms.rimIntensity.value = 0.3

    spacing = 5
    offset = spacing * 2

    for i in [0 ... params.length]
      geometry = new THREE.ParametricGeometry params[i], 50, 50
      geometry.mergeVertices()
      geometry.computeFaceNormals()
      geometry.computeVertexNormals()

      instances = 3;
      instancedGeo = new THREE.InstancedBufferGeometry().fromGeometry(geometry)
      instancedGeo.maxInstancedCount = instances

      x = i % 5 * spacing - offset
      z = (Math.floor (i / 5)) * spacing - offset

      offsets = new THREE.InstancedBufferAttribute(new Float32Array(instances * 3), 3, 1)
      for j in [0 ... offsets.count]
        offsets.setXYZ j, 0, j * 4, 0
      instancedGeo.addAttribute 'offset', offsets

      mesh = new THREE.Mesh instancedGeo, shapeMaterial
      mesh.position.set x, 0, z
      mesh.castShadow = true
      scene.add mesh

  makeShapes()

  makeTerrain = ->
    texture = (new TG.Texture 64, 64)
      .set(new TG.FractalNoise()
        .baseFrequency(0.8)
        .persistence(0.7)
        .amplitude(0.1)
        # .octaves(8)
        .step(2)
        .interpolation(2))
      .add(new TG.Number()
        .tint(0.3, 0.3, 0.3))
    # huemap = new THREE.DataTexture (texture.toTHREE()), texture.buffer.width, texture.buffer.height
    # huemap.wrapS = THREE.RepeatWrapping
    # huemap.wrapT = THREE.RepeatWrapping
    # # huemap.repeat.set 20, 20
    # huemap.generateMipmaps = true
    # huemap.magFilter = THREE.LinearFilter
    # huemap.minFilter = THREE.LinearMipMapLinearFilter
    # huemap.needsUpdate = true

    texture = (new TG.Texture 64, 64)
      .add( new TG.CheckerBoard().size( 6, 6 ) )
      .mul( new TG.RadialGradient()
        .center( 32, 32 )
        .radius( 50 )
        .interpolation( 2 )
        .point( 0, [0,0,0,1] )
        .point( 0.4, [0,0,0,1])
        .point( 0.5, [0.5,0.5,0.5,1])
        .point( 0.6, [0,0,0,1])
        .point( 1.0, [0,0,0,1]) )
      .add( new TG.RadialGradient()
        .center( 32, 32 )
        .radius( 64 )
        .interpolation( 2 )
        .point( 0, [0,0,0,1] )
        .point( 0.4, [0,0,0,1])
        .point( 0.5, [0.8,0.8,0.8,1])
        .point( 0.6, [0,0,0,1])
        .point( 1.0, [0,0,0,1]) )
      .mul(new TG.FractalNoise().baseFrequency(16).persistence(0.5).amplitude(1.0).octaves(6).step(2).interpolation(2) )
      .mul(new TG.LinearGradient().interpolation( 2 )
        .point( 0, [1,1,1,1] )
        .point( 0.40, [1,1,1,1])
        .point( 0.48, [0,0,0,1])
        .point( 0.52, [0,0,0,1])
        .point( 0.60, [1,1,1,1])
        .point( 1, [1,1,1,1]) )

    heightmap = new THREE.DataTexture (texture.toTHREE()), texture.buffer.width, texture.buffer.height
    # heightmap.generateMipmaps = true
    # heightmap.magFilter = THREE.LinearFilter
    # heightmap.minFilter = THREE.LinearMipMapLinearFilter
    heightmap.needsUpdate = true
    material = Terrain.createMaterial()
    material.uniforms.offsetRepeat.value = new THREE.Vector4 0, 0, 2, 2
    # material.uniforms.rimColor.value = new THREE.Color 0xc2fff7
    material.uniforms.rimColor.value = new THREE.Color 0xff00ff
    material.uniforms.rimPower.value = 0.4
    material.uniforms.rimIntensity.value = 0.3
    material.uniforms.heightmap.value = heightmap
    material.uniforms.diffuse.value = new THREE.Color 0x587b91
    material.uniforms.diffuse2.value = new THREE.Color 0x587b91
    # material.uniforms.diffuse.value = new THREE.Color 0xFF0000
    # material.uniforms.diffuse2.value = new THREE.Color 0x0000FF
    # material.side = THREE.DoubleSide
    # textureLoader.load 'assets/desaturated-grass.jpg', (texture) ->
    #   texture.wrapS = THREE.RepeatWrapping
    #   texture.wrapT = THREE.RepeatWrapping
    #   material.uniforms.huemap.value = texture

    # material.uniforms.huemap.value = huemap
    # material.uniforms.map.value = huemap
    # textureLoader.load 'assets/vector-grass-2.jpg', (texture) ->
    #   texture.wrapS = THREE.RepeatWrapping
    #   texture.wrapT = THREE.RepeatWrapping
    #   material.uniforms.map.value = texture
    # textureLoader.load 'assets/mountain-3.jpg', (texture) ->
    #   texture.wrapS = THREE.RepeatWrapping
    #   texture.wrapT = THREE.RepeatWrapping
    #   material.uniforms.map2.value = texture
    deform = (u, v) ->
      unit = new THREE.Vector2(u - 0.5, v - 0.5)
      unitLength = Math.min(unit.length(), 0.5)
      unit = (unit.normalize()).multiplyScalar(unitLength)
      unit = new THREE.Vector2(unit.x + 0.5, unit.y + 0.5)
      uu = Math.floor (unit.x * texture.buffer.width)
      vv = Math.floor (unit.y * texture.buffer.height)
      y = (texture.buffer.array[texture.buffer.width * 4 * vv + uu * 4])
      new THREE.Vector3 -unit.x * 100 + 50, y * 20, unit.y * 100 - 50
    geo = new THREE.ParametricGeometry deform, 100, 100
    geo.mergeVertices()
    geo = new THREE.BufferGeometry().fromGeometry( geo )
    mesh = new THREE.Mesh geo, material
    mesh.position.y = -3
    mesh.receiveShadow = true
    mesh.castShadow = true
    scene.add mesh

    createMonitor heightmap

    # monitorPlane.position.set 0, 4, -8
    # camera.add monitorPlane

  makeTerrain()

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
    textureLoader.load 'assets/sky-03.jpg', (texture) ->
      material = new THREE.MeshBasicMaterial {side: THREE.FrontSide, map: texture}
      # texture.wrapS = THREE.RepeatWrapping
      # texture.wrapT = THREE.RepeatWrapping
      # material.uniforms.map.value = texture
      sky.object = new THREE.Mesh geo, material
      scene.add sky.object
    sky

  sky = makeSky()

  zero = new THREE.Vector3 0, 0, 0

  animate = ->
    requestAnimationFrame animate

    sky.object.rotation.z += 0.001
    sky.object.rotation.y += 0.001
    # sky.object.position = camera.worldToLocal zero

    # renderer.render scene, camera
    composer.render()

  domScene.animate = animate

window.sceneInit = scene
