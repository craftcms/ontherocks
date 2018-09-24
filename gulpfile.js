var gulp = require('gulp');
var notifier = require('node-notifier');

gulp.task('css', function () {
    var postcss = require('gulp-postcss');
    var rename = require('gulp-rename');

    return gulp.src('./web/styles/src/styles.pcss')
        .pipe(postcss([
            require('postcss-import'),
            require('tailwindcss')('./tailwind.js'),
            require('autoprefixer'),
        ], {
            from: './web/styles/src/styles.pcss'
        }))
        .pipe(rename('styles.css'))
        .pipe(gulp.dest('./web/styles/dist'));
});

gulp.task('watch', function() {
    return require('gulp-watch')('./web/styles/src/**/*.pcss', function() {
        gulp.start('css');
        notifier.notify({
            message: 'Finished building CSS',
            timeout: 1
        });
    });
});

gulp.task('default', ['watch']);
