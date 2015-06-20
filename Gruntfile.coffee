module.exports = (grunt) ->
  webpack = require 'webpack'
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.registerTask 'build', ['coffeelint', 'clean', 'sass', 'coffee', 'webpack', 'copy', 'wiredep']

  grunt.initConfig(
    wiredep:
      task:
        src:'Build/server/views/base.jade'
    webpack:
      compile:
        # devtool: 'source-map'
        # Change entry point to.
        entry: './Dev/client/coffee/app.coffee'
        # Additional file paths for dependency resolving.
        resolve: modulesDirectories: [
          './services'
          './components'
          './filters'
        ]
        plugins:[
          # Comment to disable minification.
          new webpack.optimize.UglifyJsPlugin()
        ]
        output:
          path: './Build/client/js/'
          filename: 'app.js'
        module: loaders: [ {test: /\.coffee$/, loader: 'coffee-loader'} ]          
    sass:
      compile:
        files: [
          expand: true
          src:'*.scss'
          dest:'Build/client/css'
          cwd:'Dev/client/scss',
          ext:'.css'
          ]
    coffee: 
      server:
        files: [
          expand:true
          src:['**/*.coffee']
          dest:'Build/server/'
          cwd:'Dev/server/'
          ext:'.js'
          ]

    coffeelint:
      files: ["Dev/server/**/*.coffee", "Dev/client/coffee/*.coffee"]
      options:
        'max_line_length':
          'level':'ignore'
        'no_interpolation_in_single_quotes':
          'level':'warn'

    copy:
      devToTest:
        # Copy additional none preprocessed files.
        files:[ {expand:true, cwd:"Dev/server", src:["bin/www", "views/*"], dest: "Build/server"},
                {expand:true, cwd:"Dev/client", src:["assets/*"], dest:"Build/client"}
              ]

    clean:
      build:["./Build"]
        
    watch:
      client:
        files: ["Dev/client/coffee/**/*.coffee"]
        tasks:['webpack']
      clientSass:
        files: ["Dev/client/scss/*.scss"]
        tasks:['sass']
      serverJade: 
        files: ["Dev/server/views/*"]
        tasks:['copy']
      livereload:
        options:
          livereload:35729
        files: ["Build/client/**/*", "!Build/client/css/*.map", "Build/server/views/.*"]
  )