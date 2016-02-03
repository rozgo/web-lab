SCREEN_WIDTH = window.innerWidth
SCREEN_HEIGHT = window.innerHeight
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
window.renderer = renderer

controls = new THREE.OrbitControls camera, renderer.domElement

composer = new THREE.EffectComposer renderer
composer.addPass( new THREE.RenderPass( scene, camera ) )

effectBloom = new THREE.BloomPass 0.5, 25, 4, 256
composer.addPass effectBloom

effectCopy = new THREE.ShaderPass THREE.CopyShader
composer.addPass effectCopy

effectCopy.renderToScreen = true

textureLoader = new THREE.TextureLoader

gridHelper = new THREE.GridHelper 10, 1
scene.add gridHelper

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

  shapeMaterial = Pixar.createMaterial()
  textureLoader.load 'assets/wood-color.jpg', (texture) ->
    shapeMaterial.uniforms.map.value = texture

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



zero = new THREE.Vector3 0, 0, 0

animate = ->
  requestAnimationFrame animate
  # sky.object.position = camera.worldToLocal zero


  # renderer.render scene, camera
  composer.render()

window.animate = animate

obj = { x: 5 }
gui = new dat.GUI()
gui.add obj, 'x'

# ws = new WebSocket("ws://127.0.0.1:8080")
# ws.open = (evt) -> console.log evt
