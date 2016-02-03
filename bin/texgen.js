(function() {
  TG.Texture.prototype.toTHREE = function() {
    var a, b, d, i, j, ref;
    b = this.buffer;
    a = b.array;
    d = new Uint8Array(a.length);
    for (i = j = 0, ref = a.length; j < ref; i = j += 4) {
      d[i + 0] = TG.Utils.clamp(a[i + 0] * 255, 0, 255);
      d[i + 1] = TG.Utils.clamp(a[i + 1] * 255, 0, 255);
      d[i + 2] = TG.Utils.clamp(a[i + 2] * 255, 0, 255);
      d[i + 3] = 255;
    }
    return d;
  };

}).call(this);
