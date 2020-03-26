<template src='./Toggle.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Toggle.scss" lang="scss">
</style>

<script>


  export default {
    props: {
      label: null,
      checked: null
    },
    data() {
      return {
        label: this.label,
        isChecked: this.isChecked
      };
    },
    mounted() {

    },
    methods: {
      goToDiscoverPage() {
        console.log('TAP: go to discover page');

      },
      onBackTap() {
        console.log('TAP: go back');
      },
      onCheckedChange() {
        this.$emit('checkedChange', this.isChecked);
      },
      onToggleLabelTap() {
        this.isChecked = !this.isChecked;
      }
    }
  };
</script>
