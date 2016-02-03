(function() {
  var Shape, abs, cos, pi, pow, sin;

  Shape = {};

  sin = Math.sin;

  cos = Math.cos;

  pow = Math.pow;

  abs = Math.abs;

  pi = Math.PI;

  Shape.superformula = function(a, b, m, n1, n2, n3) {
    return function(r) {
      var p0, p1;
      p0 = pow(abs((cos((m * r) / 4)) / a), n2);
      p1 = pow(abs((sin((m * r) / 4)) / b), n3);
      return pow(p0 + p1, -1 / n1);
    };
  };

  Shape.supershape = function(a0, b0, m0, n10, n20, n30, a1, b1, m1, n11, n21, n31) {
    var sfu, sfv;
    sfu = Shape.superformula(a0, b0, m0, n10, n20, n30);
    sfv = Shape.superformula(a1, b1, m1, n11, n21, n31);
    return function(u, v) {
      var ru, rv, x, y, z;
      u = -(u - 0.5) * 2 * pi;
      v = (v - 0.5) * 1 * pi;
      ru = sfu(u);
      rv = sfv(v);
      x = (ru * (cos(u))) * (rv * (cos(v)));
      y = rv * (sin(v));
      z = (ru * (sin(u))) * (rv * (cos(v)));
      return new THREE.Vector3(x, y, z);
    };
  };

  Shape.sphere = function(u, v) {
    var x, y, z;
    u = -(u - 0.5) * 2 * pi;
    v = (1.0 - v) * pi;
    x = (sin(v)) * (cos(u));
    y = cos(v);
    z = (sin(v)) * (sin(u));
    return new THREE.Vector3(x, y, z);
  };

  Shape.radialWave = function(u, v) {
    var r, x, y, z;
    u -= 0.5;
    v -= 0.5;
    r = 2;
    x = (sin(u)) * r;
    z = -(sin(v / 2)) * 2 * r;
    y = (sin(u * 4 * pi) + cos(v * 2 * pi)) / 10.0;
    return new THREE.Vector3(x, y, z);
  };

  Shape.trumpet = function(u, v) {
    var h, x, y, z;
    u = u * 2 * pi;
    h = 1 / pow((1 - v) + 1, 4);
    x = -h * cos(u);
    y = 2 * (v - 0.5);
    z = -h * sin(u);
    return new THREE.Vector3(x, y, z);
  };

  Shape.helmet = function(u, v) {
    var h, x, y, z;
    u = u * 2 * pi;
    h = 1 - 1 / pow(v + 1, 4);
    x = -h * cos(u);
    y = 1 - v;
    z = h * sin(u);
    return new THREE.Vector3(x, y, z);
  };

  Shape.torus = function(u, v) {
    var x, y, z;
    u = -(u - 0.5) * 2 * pi;
    v = (v - 0.5) * 2 * pi;
    x = 0.7 * (cos(u)) + 0.3 * (cos(v)) * (cos(u));
    y = (sin(v)) * 0.3;
    z = 0.7 * (sin(u)) + 0.3 * (cos(v)) * (sin(u));
    return new THREE.Vector3(x, y, z);
  };

  Shape.plane = function(u, v) {
    var x, y, z;
    u = u - 0.5;
    v = -(v - 0.5);
    x = u * 2;
    y = 0;
    z = v * 2;
    return new THREE.Vector3(x, y, z);
  };

  Shape.cylinder = function(_u, v) {
    var u, x, y, z;
    u = _u * 2 * pi;
    v = v;
    x = -cos(u);
    y = 2 * (v - 0.5);
    z = sin(u);
    return new THREE.Vector3(x, y, z);
  };

  Shape.cube = function(v, u) {
    var cu, cv, d, pcu, pcv, psu, psv, su, sv, x, y, z;
    u = u * pi;
    v = v * 2 * pi;
    su = sin(u);
    sv = sin(v);
    cu = cos(u);
    cv = cos(v);
    psu = pow(su, 6);
    psv = pow(sv, 6);
    pcu = pow(cu, 6);
    pcv = pow(cv, 6);
    d = pow(psu * (psv + pcv) + pcu, 1 / 6);
    x = -(su * cv) / d;
    y = -cu / d;
    z = (su * sv) / d;
    return new THREE.Vector3(x, y, z);
  };

  Shape.astroidal = function(u, v) {
    var x, y, z;
    u = -(u - 0.5) * 2 * pi;
    v = (v - 0.5) * pi;
    x = pow((cos(u)) * (cos(v)), 3);
    y = pow(sin(v), 3);
    z = pow((sin(u)) * (cos(v)), 3);
    return new THREE.Vector3(x, y, z);
  };

  window.Shape = Shape;

}).call(this);
