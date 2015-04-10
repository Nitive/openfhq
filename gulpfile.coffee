# css
stylus = require 'gulp-stylus'
cmq = require 'gulp-combine-media-queries'
autoprefixer = require 'gulp-autoprefixer'
cssmin = require 'gulp-cssmin'

# svg
svgmin = require 'gulp-svgmin'

# js
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'

# utilities
run = require 'run-sequence'
inject = require 'gulp-inject'
parsePath = require 'parse-filepath'
fileset = require 'fileset'
rename = require 'gulp-rename'
replace = require 'gulp-replace'
gulpif = require 'gulp-if'
sync = require 'browser-sync'
gulp = require 'gulp'


# paths
htmlPath = 'assets/template/*.html'
stylusPath = 'assets/stylus/*.styl'
jsPath = 'assets/js/*.js'
coffeePath = 'assets/js/*.coffee'
svgPath = 'assets/images/*.svg'
imgPath = 'assets/images/*.{jpg,png}'
destPath = 'public/'

components = [
  'bower_components/jquery/dist/jquery.min.js'
  'bower_components/jquery.hotkeys/jquery.hotkeys.js'
]

gulp.task 'default', ['html', 'stylus']

gulp.task 'product', -> run 'imgfont', 'html', 'stylus', 'js'

gulp.task 'watch', ['browser-sync'], ->
  gulp.watch stylusPath,                    ['stylus']
  gulp.watch htmlPath,                -> run 'html', 'stylus'
  gulp.watch imgPath,                 -> run 'imgfont', 'html', 'stylus'
  gulp.watch [jsPath, coffeePath],          ['js']

gulp.task 'html', ->
  htmlSrc = gulp.src(htmlPath)

  fileContents = (filePath, file) ->
    file.contents.toString()

  fileset svgPath, (err, files) ->
    if err
      return console.error(err)
    i = 0
    while i < files.length
      extension = parsePath(files[i]).extname
      extnameFiles = files[i].replace(extension, '')
      htmlSrc = htmlSrc.pipe(inject(gulp.src(files[i]).pipe(svgmin(plugins: [
        { removeTitle: true }
        { removeDesc: true }
      ])),
        transform: fileContents
        name: extnameFiles))
      i++
      htmlSrc.pipe replace /<head>/i, '<head><link rel="stylesheet" href="main.css">'
             .pipe gulp.dest(destPath)
             .pipe sync.reload(stream: true)


gulp.task 'js', ->
  gulp.src components.concat([jsPath]).concat([coffeePath])
    .pipe(gulpif(/[.]coffee$/, coffee bare: true))
    .pipe concat 'main.js'
    .pipe uglify()
    .pipe gulp.dest(destPath)
    .pipe sync.reload(stream: true)

gulp.task 'stylus', ->
  gulp.src('assets/stylus/main.styl')
    .pipe stylus 'include css': true, compress: true
    .on 'error', console.log
    .pipe cmq()
    .pipe autoprefixer { browsers: ['last 2 version', '> 1%'] }
    .pipe cssmin()
    .pipe gulp.dest destPath
    .pipe sync.reload(stream: true)

gulp.task 'imgfont', ->
  gulp
    .src 'assets/fonts/*/*'
    .pipe gulp.dest(destPath + 'fonts')
  gulp
    .src imgPath
    .pipe gulp.dest(destPath + 'images')

gulp.task 'browser-sync', ->
  console.log __dirname
  sync
    server:
      baseDir: destPath
      index: 'index.html'
    snippetOptions: rule:
      match: /<\/body>/i
      fn: (snippet, match) ->
        snippet + match
