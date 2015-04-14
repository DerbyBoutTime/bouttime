'use strict';

var gulp = require('gulp');
var del = require('del');



// Load plugins
var $ = require('gulp-load-plugins')();
var browserify = require('browserify');
var watchify = require('watchify');
var source = require('vinyl-source-stream');
var mainBowerFiles = require('main-bower-files');

var sourceFile = './app/scripts/app.cjsx';
var destFolder = './dist/scripts';
var destFileName = 'app.js';

// Styles
gulp.task('styles', ['sass'  ]);

gulp.task('sass', function() {
    return gulp.src(['app/styles/**/*.scss', 'app/styles/**/*.css'])
        .pipe($.sass({errLogToConsole: true, includePaths: ['app/bower_components/bootstrap-sass/assets/stylesheets']}))
        .pipe($.autoprefixer('last 1 version'))
        .pipe(gulp.dest('dist/styles'))
        .pipe($.size());
});

var bundler = watchify(browserify({
    entries: [sourceFile],
    debug: true,
    insertGlobals: true,
    cache: {},
    packageCache: {},
    fullPaths: true
}));

bundler.on('update', rebundle);
bundler.on('log', $.util.log);

function rebundle() {
    return bundler.bundle()
        // log errors if they happen
        .on('error', $.util.log.bind($.util, 'Browserify Error'))
        .pipe(source(destFileName))
        .pipe(gulp.dest(destFolder));
}

gulp.task('coffee', function() {
    gulp.src('./app/**/*.coffee')
    .pipe($.coffee({bare: true}).on('error', $.util.log))
    .pipe(gulp.dest('./dist/'))
});
// Scripts
gulp.task('scripts', ['coffee'], rebundle);

// HTML
gulp.task('html', function() {
    return gulp.src('app/*.html')
        .pipe($.useref())
        .pipe(gulp.dest('dist'))
        .pipe($.size());
});

// Images
gulp.task('images', function() {
    return gulp.src('app/images/**/*')
        .pipe(gulp.dest('dist/images'))
        .pipe($.size());
});

// Fonts
gulp.task('fonts', function() {
    return gulp.src(mainBowerFiles({
            filter: '**/*.{eot,svg,ttf,woff,woff2}'
        }).concat('app/fonts/**/*'))
        .pipe(gulp.dest('dist/fonts'));
});

// Clean
gulp.task('clean', function() {
    $.cache.clearAll();
    del.sync(['dist/*']);
});

// Bundle
gulp.task('bundle', ['styles', 'scripts', 'bower'], function() {
    return gulp.src('./app/*.html')
        .pipe($.useref.assets())
        .pipe($.useref.assets().restore())
        .pipe($.useref())
        .pipe(gulp.dest('dist'));
});

// Bower helper
gulp.task('bower', function() {
    gulp.src('app/bower_components/**/*.js', {
            base: 'app/bower_components'
        })
        .pipe(gulp.dest('dist/bower_components/'));

});

gulp.task('json', function() {
    gulp.src('app/scripts/json/**/*.json', {
            base: 'app/scripts'
        })
        .pipe(gulp.dest('dist/scripts/'));
});

// Robots.txt and favicon.ico
gulp.task('extras', function() {
    return gulp.src(['app/*.txt', 'app/*.ico'])
        .pipe(gulp.dest('dist/'))
        .pipe($.size());
});

// Build
gulp.task('build', ['html', 'bundle', 'images', 'fonts', 'extras'], function() {
    gulp.src('dist/scripts/app.js')
        .pipe($.uglify())
        .pipe($.stripDebug())
        .pipe(gulp.dest('dist/scripts'));
});

// Watch
gulp.task('watch', ['build'], function() {
    gulp.watch('app/*.html', ['html']);

    gulp.watch(['app/styles/**/*.scss', 'app/styles/**/*.css'], ['styles'])

    gulp.watch(['app/**/*.coffee'], ['coffee'])

    gulp.watch('app/images/**/*', ['images'])

    gulp.watch('app/fonts/**/*', ['fonts'])

    gulp.watch(['app/*.txt', 'app/*.ico'], ['extras'])
});

// Web Server
gulp.task('webserver', ['build', 'watch'], function() {
    gulp.src('dist')
        .pipe($.webserver({
            livereload: true
        }));
});

// Default task
gulp.task('default', ['clean', 'build'  ]);
