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
  camera.lookAt scene.position
  scene.add camera

  renderer = new THREE.WebGLRenderer
    antialias: true
    alpha: true
  renderer.setSize SCREEN_WIDTH, SCREEN_HEIGHT
  renderer.setClearColor 0x222222, 1
  renderer.shadowMap.enabled = true
  renderer.gammaInput = true
  renderer.gammaOutput = true
  renderer.autoClear = false
  domScene.renderer = renderer

  controls = new THREE.OrbitControls camera, renderer.domElement

  composer = new THREE.EffectComposer renderer
  composer.addPass( new THREE.RenderPass( scene, camera ) )

  effectBloom = new THREE.BloomPass( 0.5, 25, 4, 256 );
  composer.addPass( effectBloom );

  effectCopy = new THREE.ShaderPass( THREE.CopyShader );
  composer.addPass( effectCopy );

  effectCopy.renderToScreen = true;

  textureLoader = new THREE.TextureLoader

  # gridHelper = new THREE.GridHelper 10, 1
  # scene.add gridHelper

  # directionalLight = new THREE.DirectionalLight 0xffaaaa, 2.0
  # directionalLight.position.set 0, 4, 5
  # scene.add directionalLight

  # dirLighthelper = new THREE.DirectionalLightHelper directionalLight, 1
  # scene.add dirLighthelper

  axisHelper = new THREE.AxisHelper 5
  scene.add axisHelper

  				# new TG.Texture(size, size)
  				# 	.set(new TG.FractalNoise().baseFrequency(128).octaves(6).step(2).interpolation(2) )
  				# 	.sub(new TG.Noise().tint(0, 0.1, 0) )
  				# 	.min(new TG.Number().tint(0, 0.63, 0) )
  				# 	.sub(new TG.Number().tint(0, 0.53, 0) )
  				# 	.mul(new TG.Number().tint(0, 6, 0) )
  				# 	.sub(new TG.SineDistort().sines(2, 2).amplitude(4, 4).tint(0, 0.75, 0) )
  				# 	.add(new TG.Number().tint(0.065, 0, 0.095) )

  texture = (new TG.Texture 256, 256)
    .set(new TG.FractalNoise().baseFrequency(32).octaves(6).step(2).interpolation(2) )
    # .sub(new TG.Noise().tint(0, 0.1, 0) )
    # .min(new TG.Number().tint(0, 0.63, 0) )
    # .sub(new TG.Number().tint(0, 0.53, 0) )
    # .mul(new TG.Number().tint(0, 6, 0) )
    # .sub(new TG.SineDistort().sines(2, 2).amplitude(4, 4).tint(0, 0.75, 0) )
    # .add(new TG.Number().tint(0.065, 0, 0.095) )
      # .set( new TG.Number().tint( 0.5, 0.5, 0.5 ) )
  			# .add( new TG.RadialGradient().center( 128, 0 ).radius( 200 ).interpolation( 2 ).point( 0, [1,1,0,0] ).point( 0.25, [0.2,0,0.5,1]).point( 0.5, [0.5,0.2,0.5,1]).point( 1, [1,0,1,1]) )
  gentexture = new THREE.DataTexture (texture.toTHREE()), texture.buffer.width, texture.buffer.height, THREE.RGBAFormat
  gentexture.needsUpdate = true
  material = new THREE.MeshBasicMaterial {side: THREE.FrontSide, map: gentexture}

  spacing = 2
  offset = spacing * 2

  for i in [0 ... 25]



    planeGEO = new THREE.PlaneGeometry 1, 1

    plane = new THREE.Mesh planeGEO, material
    # plane.rotation.x = -Math.PI / 2
    plane.position.x = i % 5 * spacing - offset
    plane.position.z = (Math.floor (i / 5)) * spacing - offset
    # plane.receiveShadow = true
    scene.add plane


  animate = ->
    requestAnimationFrame animate

    renderer.render scene, camera
    # composer.render()

  domScene.animate = animate

window.sceneInit = scene
