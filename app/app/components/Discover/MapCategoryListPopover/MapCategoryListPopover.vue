<template src='./MapCategoryListPopover.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./MapCategoryListPopover.scss" lang="scss">
</style>

<script>

  import * as AppService from '../../../services/app.service';
  import * as utils from '@nativescript/core/utils/utils';
  import * as ApiService from '../../../services/api.service';
  import * as UiService from '../../../services/ui.service';

  export default {
    data() {
      return {
        layoutHeight: UiService.default.layoutHeight,
        categories: [],
        categoriesLoaded: false
      };
    },
    async mounted() {

      this.categories = await ApiService.default.getCategories();
      console.log('SHOWING  CATEGORIES');
      console.log(this.categories);
      this.categoriesLoaded = true;

      const height = this.$refs.container.nativeView.getMeasuredHeight();

    },
    methods: {
      onCloseListTap() {
        this.$emit('closeListTap');
      },
      onCategoryTap(category) {
        this.$emit('categorySelect', category);
      }
    }
  };
</script>
