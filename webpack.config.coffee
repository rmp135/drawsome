module.exports =
  entry:"./client/app.coffee"
  output:
    path:"./server/public"
    filename:"app.js"
    fileinfo:true
  vue:
    loaders:
      sass: 'vue-style!css!sass?indentedStyle'
      scss: 'vue-style!css!sass'
  module:
    loaders:[
      {test: /\.coffee$/, loader:'coffee-loader'},
      {test: /\.json$/, loader:'json-loader'},
      {test: /\.jade$/, loader:'template-html-loader'},
      {test: /\.vue$/, loader:'vue-loader'}
      {test: /\.scss$/, loaders:['style','css', 'sass']}
    ]
