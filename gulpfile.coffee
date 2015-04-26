# css
stylus = require 'gulp-stylus'
cmq = require 'gulp-combine-media-queries'
autoprefixer = require 'gulp-autoprefixer'
cssmin = require 'gulp-cssmin'
sourcemaps = require 'gulp-sourcemaps'

# svg
svgmin = require 'gulp-svgmin'

# js
cjsx = require 'gulp-cjsx'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'

# utilities
args = require('yargs').argv
run = require 'run-sequence'
inject = require 'gulp-inject'
parsePath = require 'parse-filepath'
fileset = require 'fileset'
replace = require 'gulp-replace'
gulpif = require 'gulp-if'
ignore = require 'gulp-ignore'
sync = require 'browser-sync'
rename = require 'gulp-rename'
notify = require 'gulp-notify'
plumber = require 'gulp-plumber'
nodemon = require 'gulp-nodemon'
gulp = require 'gulp'

fs = require 'fs'

production = args.p or args.production

paths =
	html: 'assets/template/*.html'
	stylus: 'assets/stylus/*.styl'
	js: 'assets/js/**/*.{js,json}'
	coffee: 'assets/js/**/*.{coffee,cjsx,json}'
	img: 'assets/images/*.{png,jpg,svg}'
	png: 'assets/images/*.png'
	jpg: 'assets/images/*.jpg'
	svg: 'assets/images/*.svg'
	dest: 'public/'
	jsmap: JSON.parse(fs.readFileSync('assets/js/jsmap.json').toString()).map (filename) -> 'assets/js/' + filename
	jscomponents: JSON.parse fs.readFileSync('assets/js/jscomponents.json').toString()

gulp.task 'default', ->
	run 'imgfont', 'html', 'stylus', 'components', 'js'

gulp.task 'watch', ['browser-sync'], ->
	gulp.watch 'assets/stylus/**/*.styl',            ['stylus']
	gulp.watch paths.html,                     -> run 'html', 'stylus'
	gulp.watch paths.img,                      -> run 'imgfont', 'html'
	gulp.watch [paths.js, paths.coffee],             ['js']
	gulp.watch 'assets/js/jscomponents.json',        ['components']
	nodemon
		script: 'index.coffee'
		watch: 'index.coffee'

gulp.task 'html', ->
	htmlSrc = gulp.src(paths.html)

	fileContents = (filePath, file) ->
		file.contents.toString()

	fileset paths.svg, (err, files) ->
		if err
			return console.error(err)
		i = 0
		while i < files.length
			pathToFolder = 'assets/images/'
			file = files[i].replace(pathToFolder, '')
			extension = parsePath(file).extname
			extnameFiles = file.replace(extension, '')
			htmlSrc = htmlSrc.pipe(inject(gulp.src(pathToFolder + file).pipe(svgmin(plugins: [
				{ removeTitle: true }
				{ removeDesc: true }
			])),
				transform: fileContents
				name: extnameFiles))
			i++
			htmlSrc.pipe gulp.dest(paths.dest)
						 .pipe sync.reload(stream: true)

gulp.task 'js', ->
	gulp.src paths.jsmap
		.pipe plumber errorHandler: notify.onError "Error(<%= error.location.first_line %>:<%= error.location.first_column %>): <%= error.message %>"
		.pipe gulpif '**/*.{coffee,cjsx}', do cjsx
		.pipe concat 'app.js'
		.pipe gulpif production, uglify()
		.pipe gulp.dest paths.dest
		.pipe sync.reload(stream: true)

gulp.task 'components', ->
	gulp.src paths.jscomponents
		.pipe concat 'components.js'
		.pipe gulpif production, uglify()
		.pipe gulp.dest paths.dest
		.pipe sync.reload(stream: true)

gulp.task 'stylus', ->
	gulp.src(paths.stylus)
		.pipe plumber errorHandler: notify.onError "Error: <%= error.message %>"
		.pipe gulpif production, rename (path) -> path.basename = path.basename.replace '_', ''
		.pipe gulpif !production, ignore.exclude /_.*\.styl$/
		.pipe gulpif not production, sourcemaps.init()
		.pipe stylus 'include css': true, compress: production
		.pipe gulpif production, cmq()
		.pipe autoprefixer browsers: ['last 2 version', '> 1%']
		.pipe gulpif production, cssmin()
		.pipe gulpif not production, sourcemaps.write()
		.pipe gulp.dest paths.dest
		.pipe sync.reload(stream: true)

gulp.task 'imgfont', ->
	gulp
		.src 'assets/fonts/*/*'
		.pipe gulp.dest(paths.dest + 'fonts')
	gulp
		.src paths.img
		.pipe gulpif paths.svg, do svgmin
		.pipe gulp.dest(paths.dest + 'images')

gulp.task 'browser-sync', ->
	sync
		notify: false
		open: false
		proxy: 'localhost:5000'
		snippetOptions: rule:
			match: /<\/body>/i
			fn: (snippet, match) ->
				snippet + match
