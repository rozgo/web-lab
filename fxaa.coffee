FXAA = {}

FXAA.createMaterial = (width, height) ->

	material = new THREE.ShaderMaterial
		uniforms:
			THREE.UniformsUtils.merge [
				tDiffuse:
					type: 't'
					value: new THREE.Texture
				resolution:
					type: 'v2'
					value: new THREE.Vector2 width, height
	    ]
		vertexShader: shaders['fxaa.vs']
		fragmentShader: shaders['fxaa.fs']

	material

window.FXAA = FXAA
