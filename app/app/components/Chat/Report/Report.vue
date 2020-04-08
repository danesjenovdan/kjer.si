<template src='./Report.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./Report.scss" lang="scss">
</style>

<script>

  import Discover from "../../Discover/Discover";
  import * as dialogs from "tns-core-modules/ui/dialogs";

  export default {
    data() {
      return {
        reportText: ''
      }
    },
    computed: {
      message() {
        return "Blank {N}-Vue app";
      }
    },
    mounted() {

    },
    methods: {
      async cancelTap() {
        const result = await dialogs.confirm('Ste prepričani da želite zapustiti prijavo neprimerne vsebine?');

        if (result) {
          this.$modal.close();
        }
      },
      async confirmTap() {

        const result = await dialogs.confirm('Ste prepričani da želite poslati prijavo neprimerne vsebine?');

        if (result) {
          this.$modal.close();
        }
      },
      onReportTextChange() {

      },
      goToDiscoverPage() {
        console.log('TAP: go to discover page');
        this.$navigateTo(Discover);
      },
      onBackTap() {
        console.log('TAP: go back');
        this.$navigateBack();
      }
    }
  };
</script>
