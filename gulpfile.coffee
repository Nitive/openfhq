# css
stylus = require 'gulp-stylus'
cmq = require 'gulp-combine-media-queries'
autoprefixer = require 'gulp-autoprefixer'
cssmin = require 'gulp-cssmin'
sourcemaps = require 'gulp-sourcemaps'
bootstrap = require 'bootstrap-styl'

# svg
svgmin = require 'gulp-svgmin'

# js
uglify = require 'gulp-uglify'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
watchify = require 'watchify'
streamify = require 'gulp-streamify'

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
	html: './assets/template/*.html'
	stylus: './assets/stylus/*.styl'
	deep_stylus: './assets/stylus/**/*.styl'
	browserify: './assets/js/app.coffee'
	img: './assets/images/*.{png,jpg,svg}'
	png: './assets/images/*.png'
	jpg: './assets/images/*.jpg'
	svg: './assets/images/*.svg'
	dest: './public/'

gulp.task 'default', ->
	run 'imgfont', 'html', 'stylus', 'browserify'

gulp.task 'watch', ['browser-sync', 'watchjs'], ->
	gulp.watch paths.deep_stylus,                    ['stylus']
	gulp.watch paths.html,                     -> run 'html', 'stylus'
	gulp.watch paths.img,                      -> run 'imgfont', 'html'
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
			pathToFolder = './assets/images/'
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
				.pipe sync.reload stream: true

buildScript = (files, watch) ->
	rebundle = (callback) ->
		stream = bundler.bundle()
		stream
			.on "error", notify.onError
				title: "Compile Error"
				message: "<%= error.message %>"
			.pipe source 'app.js'
			.pipe gulpif production, streamify do uglify
			.pipe gulp.dest paths.dest
			.pipe sync.reload stream: true

		stream.on 'end', ->
			do callback if typeof callback == "function"

	props = watchify.args
	props.entries = files
	props.debug = not production

	bundler = if watch then watchify(browserify props) else browserify props
	bundler.transform "coffee-reactify"
	bundler.on "update", ->
		now = new Date().toTimeString()[..7]
		console.log "[#{now.gray}] Starting #{"'browserify'".cyan}..."
		startTime = new Date().getTime()
		rebundle ->
			time = (new Date().getTime() - startTime) / 1000
			now = new Date().toTimeString()[..7]
			console.log "[#{now.gray}] Finished #{"'browserify'".cyan} after #{(time + 's').magenta}"

	rebundle()

gulp.task "browserify", ->
	buildScript paths.browserify, false

gulp.task "watchjs", ->
	buildScript paths.browserify, true


gulp.task 'stylus', ->
	gulp.src(paths.stylus)
		.pipe plumber errorHandler: notify.onError "Error: <%= error.message %>"
		.pipe gulpif production, rename (path) -> path.basename = path.basename.replace '_', ''
		.pipe gulpif !production, ignore.exclude /^_.*\.styl$/
		.pipe gulpif not production, sourcemaps.init()
		.pipe stylus
			'include css': true
			compress: production
			use: [bootstrap()]
		.pipe gulpif production, cmq()
		.pipe autoprefixer browsers: ['last 2 version', '> 1%']
		.pipe gulpif production, cssmin()
		.pipe gulpif not production, sourcemaps.write()
		.pipe gulp.dest paths.dest
		.pipe sync.reload stream: true

gulp.task 'imgfont', ->
	gulp
		.src './assets/fonts/*/*'
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
