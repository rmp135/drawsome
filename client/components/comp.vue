<script lang="coffee">
  module.exports =
    name:'comp'
    data: ->
      testData:'Hello World!'
    ready: ->
      console.log 'Hello World!'
</script>

<template lang="jade">
  #comp
    p Put some content here!
    p Some test data: {{testData}}
</template>

<style lang="scss">
  #comp {
    background-color:red;
  }
</style>
