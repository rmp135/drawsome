<script lang="coffee">
  module.exports =
    name:'play-reveal-comp'
    props:
      game:
        type:Object
        required:true
      player:
        type:Object
        requird:true
</script>

<template lang="pug">
  #play-reveal-comp Eyes on the big board!
</template>

<style lang="scss">
  #play-reveal-comp {
    display: flex;
    justify-content: center;
    flex-direction: column;
    font-size: 2rem;
    text-align: center;
  }
</style>
