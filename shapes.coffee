Shape = {}

sin = Math.sin
cos = Math.cos
pow = Math.pow
abs = Math.abs
pi = Math.PI

Shape.superformula = (a, b, m, n1, n2, n3) ->
  (r) ->
    p0 = pow (abs (cos (m * r) / 4) / a), n2
    p1 = pow (abs (sin (m * r) / 4) / b), n3
    pow p0 + p1, -1 / n1

Shape.supershape = (a0, b0, m0, n10, n20, n30, a1, b1, m1, n11, n21, n31) ->
  sfu = Shape.superformula a0, b0, m0, n10, n20, n30
  sfv = Shape.superformula a1, b1, m1, n11, n21, n31
  (u, v) ->
    u =  -(u - 0.5) * 2 * pi
    v =  (v - 0.5) * 1 * pi
    ru = sfu u
    rv = sfv v
    x = (ru * (cos u)) * (rv * (cos v))
    y = (rv * (sin v))
    # y = if y > 0.5 then 0.5 else y
    z = (ru * (sin u)) * (rv * (cos v))
    new THREE.Vector3 x, y, z

Shape.sphere = (u, v) ->
	u = -(u - 0.5) * 2 * pi
	v =  (1.0 - v) * pi
	x = (sin v) * (cos u)
	y = cos v
	z = (sin v) * (sin u)
	new THREE.Vector3 x, y, z

Shape.radialWave = (u, v) ->
  u -= 0.5
  v -= 0.5
  r = 2
  x = (sin u) * r
  z = -(sin v / 2) * 2 * r
  y = (sin(u * 4 * pi) + cos(v * 2 * pi)) / 10.0
  new THREE.Vector3 x, y, z

Shape.trumpet = (u, v) ->
  u = u * 2 * pi
  h = 1 / pow ((1 - v) + 1), 4
  x = -h * cos u
  y = 2 * (v - 0.5)
  z = -h * sin u
  new THREE.Vector3 x, y, z

Shape.helmet = (u, v) ->
  u = u * 2 * pi
  h = 1 - 1 / pow (v + 1), 4
  x = -h * cos u
  y = 1 - v
  z = h * sin u
  new THREE.Vector3 x, y, z

Shape.torus = (u, v) ->
	u = -(u - 0.5) * 2 * pi
	v =  (v - 0.5) * 2 * pi
	x = 0.7 * (cos u) + 0.3 * (cos v) * (cos u)
	y = (sin v) * 0.3
	z = 0.7 * (sin u) + 0.3 * (cos v) * (sin u)
	new THREE.Vector3 x, y, z

Shape.plane = (u, v) ->
	u =  (u - 0.5)
	v = -(v - 0.5)
	x = u * 2
	y = 0
	z = v * 2
	new THREE.Vector3 x, y, z

Shape.cylinder = (_u, v) ->
  u = _u * 2 * pi
  v = v
  x = -cos u
  y = 2 * (v - 0.5)
  z = sin u
  new THREE.Vector3 x, y, z

Shape.cube = (v, u) ->
  u = u * pi
  v = v * 2 * pi
  su = sin u
  sv = sin v
  cu = cos u
  cv = cos v
  psu = pow su, 6
  psv = pow sv, 6
  pcu = pow cu, 6
  pcv = pow cv, 6
  d = pow (psu * (psv + pcv) + pcu), 1/6
  x = -(su * cv) / d
  y = -cu / d
  z = (su * sv) / d
  new THREE.Vector3 x, y, z

Shape.astroidal = (u, v) ->
	u = -(u - 0.5) * 2 * pi
	v =  (v - 0.5) * pi
	x = pow((cos u) * (cos v), 3)
	y = pow((sin v), 3)
	z = pow((sin u) * (cos v), 3)
	new THREE.Vector3 x, y, z

window.Shape = Shape
