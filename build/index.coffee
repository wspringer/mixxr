Metalsmith = require 'metalsmith'
serve = require 'metalsmith-serve'
watch = require 'metalsmith-watch'
pug = require 'metalsmith-pug'
coffee = require 'metalsmith-coffee'
ignore = require 'metalsmith-ignore'
_ = require 'lodash'
path = require 'path'
fs = require 'fs'
process = require 'process'

noop = (files, metalsmith, done) -> done()

meta = () ->
  (files, metalsmith, done) ->
    metadata = metalsmith.metadata()
    metadata.components = metadata.components or []
    _.each files, (file, name) -> 
      if /index\.pug/.test name
        dir = path.dirname(name)
        if dir isnt '.'
          metadata.components.push(
            dir: dir
            module: { name: dir }
          )
          _.assign file, module: { name: dir }
    done()
    

Metalsmith(__dirname)
.source('../modules')
.destination('../dist')
.use(ignore [
  "layout.pug",
  "component.pug",
  "globals.pug",
  "*/*.pug"
])
.use(meta())
.use(pug(
  useMetadata: true
))
.use(coffee({}))
.use(require('metalsmith-sense-sass')(
  sass:
    sourceMap: true
    sourceMapContents: true 
  postcss: plugins:
    cssnano:
      preset: 'default'
))
.use(
  if process.env.SERVER 
    watch(
      paths:
        '${source}/**/*': '**/*'
      livereload: true
    )
  else noop
)
.use(
  if process.env.SERVER 
    serve(
      port: 8090
      verbose: true
    )
  else noop
)
.build (err) ->
  if err then console.info(err)


