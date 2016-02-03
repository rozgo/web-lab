(function() {
  var coffee, date, fs, path, statico;

  fs = require('fs');

  path = require('path');

  coffee = require('coffee-script');

  statico = require('node-static');

  date = function() {
    return new Date().toString();
  };

  fs.watch('.', function(event, filename) {
    var basename, compiled, data, e, error, ext, file, newfilename;
    try {
      ext = path.extname(filename);
      basename = path.basename(filename, ext);
      if (ext === '.coffee') {
        file = fs.readFileSync(filename, 'utf8');
        compiled = coffee.compile(file);
        newfilename = "bin/" + basename + ".js";
        fs.writeFileSync(newfilename, compiled);
        console.log((date()) + ": " + filename + " > " + newfilename);
      }
      if (ext === '.glsl') {
        file = fs.readFileSync(filename, 'utf8');
        data = "shaders[\"" + basename + "\"] = \"\"\"\n" + file + "\n\"\"\"";
        compiled = coffee.compile(data);
        newfilename = "bin/" + basename + ".js";
        fs.writeFileSync(newfilename, compiled);
        return console.log((date()) + ": " + filename + " > " + newfilename);
      }
    } catch (error) {
      e = error;
      console.log("ERROR:\nType: " + e.type + "\nArgs: " + e["arguments"] + "\nMessage: " + e.message);
      return console.log("\nSTACKTRACE:\n", e.stack);
    }
  });

}).call(this);
