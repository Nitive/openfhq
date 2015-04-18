# css
stylus = require 'gulp-stylus'
cmq = require 'gulp-combine-media-queries'
autoprefixer = require 'gulp-autoprefixer'
cssmin = require 'gulp-cssmin'
sourcemaps = require 'gulp-sourcemaps'

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
replace = require 'gulp-replace'
gulpif = require 'gulp-if'
ignore = require 'gulp-ignore'
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
	'bower_components/hammer.js/hammer.min.js'
	'bower_components/jquery.hammer.js/jquery.hammer.js'
	# 'bower_components/jquery.hotkeys/jquery.hotkeys.js'
]

gulp.task 'default', ['watch']

gulp.task 'product', -> run 'imgfont', 'html', 'stylus', 'components', 'js'

gulp.task 'watch', ['browser-sync'], ->
	gulp.watch 'assets/stylus/**/*.styl',            ['stylus']
	gulp.watch htmlPath,                       -> run 'html', 'stylus'
	gulp.watch imgPath,                        -> run 'imgfont', 'html'
	gulp.watch [jsPath, coffeePath],                 ['js']

gulp.task 'html', ->
	htmlSrc = gulp.src(htmlPath)

	fileContents = (filePath, file) ->
		file.contents.toString()

	fileset svgPath, (err, files) ->
		if err
			return console.error(err)
		i = 0
		while i < files.length
			pathToFolder = 'assets/images/'
			file = files[i].replace(pathToFolder, '')
			# console.log file
			extension = parsePath(file).extname
			extnameFiles = file.replace(extension, '')
			htmlSrc = htmlSrc.pipe(inject(gulp.src(pathToFolder + file).pipe(svgmin(plugins: [
				{ removeTitle: true }
				{ removeDesc: true }
			])),
				transform: fileContents
				name: extnameFiles))
			i++
			htmlSrc.pipe gulp.dest(destPath)
						 .pipe sync.reload(stream: true)


gulp.task 'js', ->
	gulp.src [jsPath, coffeePath]
		.pipe gulpif(/[.]coffee$/, coffee bare: true)
		.on 'error', (err) -> console.log("Goffee parse error\n#{err}"); this.emit('end')
		.pipe concat 'main.js'
		.pipe uglify()
		.pipe gulp.dest(destPath)
		.pipe sync.reload(stream: true)

gulp.task 'components', ->
	gulp.src components
		.pipe concat 'components.js'
		.pipe uglify()
		.pipe gulp.dest(destPath)
		.pipe sync.reload(stream: true)

gulp.task 'stylus', ->
	gulp.src(stylusPath)
		.pipe ignore.exclude /_.*\.styl$/
		.pipe sourcemaps.init()
		.pipe stylus 'include css': true, compress: true
		.on 'error', (err) -> console.log("Stylus parse error\n#{err}"); this.emit('end')
		.pipe cmq()
		.pipe autoprefixer { browsers: ['last 2 version', '> 1%'] }
		.pipe cssmin()
		.pipe sourcemaps.write()
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
		open: false
		server:
			baseDir: destPath
		snippetOptions: rule:
			match: /<\/body>/i
			fn: (snippet, match) ->
				snippet + match
