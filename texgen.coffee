TG.Texture.prototype.toTHREE = () ->
  b = this.buffer
  a = b.array
  d = new Uint8Array a.length
  for i in [0 ... a.length] by 4
			d[ i + 0 ] = TG.Utils.clamp a[ i + 0 ] * 255, 0, 255
			d[ i + 1 ] = TG.Utils.clamp a[ i + 1 ] * 255, 0, 255
			d[ i + 2 ] = TG.Utils.clamp a[ i + 2 ] * 255, 0, 255
			d[ i + 3 ] = 255
  d
