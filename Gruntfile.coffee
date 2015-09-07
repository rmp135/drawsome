module.exports = (grunt) ->
  webpack = require 'webpack'
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  grunt.registerTask 'build', ['clean', 'sass', 'coffee', 'webpack', 'copy', 'wiredep']
  grunt.registerTask 'test', ['karma', 'mochaTest']

  grunt.initConfig(
    karma:
      unit: 
        options:
          frameworks: ['bower', 'mocha', 'chai']
          bowerPackages: ['vue'] # Load bower packages here.
          singleRun:true
          browsers:['PhantomJS']
          files:["Dev/client/**/*Tests.coffee"]
          preprocessors:
            'Dev/client/**/*.coffee': ['webpack']
          webpackMiddleware:
            noInfo:true
          webpack:
            resolve:
              # Additioaal resolvers; should be the same as webpack.
              modulesDirectories: ['./services', './components', './filters']
            module:
              loaders: [
                { test: /\.coffee$/, loader: 'coffee-loader' }
                { test: /\.(coffee\.md|litcoffee)$/, loader: "coffee-loader?literate" }
                { test: /\.jade$/, loader: 'template-html-loader' }
                { test: /\.json$/, loader: 'json-loader' }
              ]
    mochaTest:
      test:
        options:
          reporter: 'spec'
          require: 'coffee-script/register'
        src: ["Dev/server/**/*Tests.coffee"]
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
          # new webpack.optimize.UglifyJsPlugin()
        ]
        output:
          path: './Build/client/js/'
          filename: 'app.js'
          pathinfo:true
        module:
          loaders: [
            { test: /\.coffee$/, loader: 'coffee-loader' }
            { test: /\.(coffee\.md|litcoffee)$/, loader: "coffee-loader?literate" }
            { test: /\.jade$/, loader: 'template-html-loader' }
            { test: /\.json$/, loader: 'json-loader' }
          ]
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
        tasks:['copy', 'wiredep']
      livereload:
        options:
          livereload:35729
        files: ["Build/client/**/*", "!Build/client/css/*.map", "Build/server/views/*"]
  )