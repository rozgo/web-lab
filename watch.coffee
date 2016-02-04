fs = require 'fs'
path = require 'path'
coffee = require 'coffee-script'
statico = require 'node-static'

date = ->
  new Date().toString()

fs.watch '.', (event, filename) ->
  try
    ext = path.extname filename
    basename = path.basename filename, ext

    if ext == '.coffee'
      file = fs.readFileSync filename, 'utf8'
      # code = code.replace /#inline{(.+)}/g, (match, file) ->
      #   fs.readFileSync file.trim()
      compiled = coffee.compile file
      newfilename = "bin/#{ basename }.js"
      fs.writeFileSync newfilename, compiled
      console.log "#{ date() }: #{ filename } > #{ newfilename }"

    if ext == '.glsl'
      file = fs.readFileSync filename, 'utf8'
      data = "shaders[\"#{ basename }\"] = \"\"\"\n#{ file }\n\"\"\""
      compiled = coffee.compile data
      newfilename = "bin/#{ basename }.js"
      fs.writeFileSync newfilename, compiled
      console.log "#{ date() }: #{ filename } > #{ newfilename }"

  catch e
    console.log "ERROR:\nType: #{e.type}\nArgs: #{e.arguments}\nMessage: #{e.message}"
    console.log "\nSTACKTRACE:\n", e.stack

file = new statico.Server '.'
server = require('http').createServer (request, response) ->
  listener = request.addListener 'end', () ->
    console.log request.url
    file.serve request, response
  listener.resume()
server.listen 8000
