Pixar = {}

gray = (new TG.Texture 8, 8).set(new TG.Number().tint(0.5, 0.5, 0.5))

graymap = new THREE.DataTexture (gray.toTHREE()), gray.buffer.width, gray.buffer.height, THREE.RGBAFormat
graymap.generateMipmaps = true
graymap.magFilter = THREE.LinearFilter
graymap.minFilter = THREE.LinearMipMapLinearFilter
graymap.needsUpdate = true

defines = {}
defines["USE_MAP"] = ""

Pixar.createMaterial = ->

	material = new THREE.ShaderMaterial
		uniforms:
			THREE.UniformsUtils.merge [
				THREE.UniformsLib['common']
				THREE.UniformsLib['lights']
				THREE.UniformsLib['shadowmap']
				rimPower:
				  type: 'f'
				  value: 0.4
				rimIntensity:
				  type: 'f'
				  value: 1.0
				rimColor:
				  type: 'c'
				  value: new THREE.Color 0xFF8000
	    ]
		vertexShader: shaders['pixar.vs']
		fragmentShader: shaders['pixar.fs']
		vertexColors: THREE.VertexColors
		transparent: false
		lights: true
		side: THREE.FrontSide
		defines: defines

	material.uniforms.diffuse.value = new THREE.Color 0x808080
	material.uniforms.map.value = graymap
	material


window.Pixar = Pixar
