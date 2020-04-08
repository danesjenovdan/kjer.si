<template src='./MapCategoryListPopover.html'>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped src="./MapCategoryListPopover.scss" lang="scss">
</style>

<script>

  import * as ApiService from '../../../services/api.service';
  import * as UiService from '../../../services/ui.service';

  export default {
    data() {
      return {
        ViewState: {
          CATEGORY: 'CATEGORY',
          DESCRIPTION: 'DESCRIPTION'
        },
        layoutHeight: UiService.default.layoutHeight,
        categories: [],
        description: null,
        categoriesLoaded: false,
        currentViewState: 'CATEGORY',
        selectedCategory: null,
        tooLong: false
      };
    },
    computed: {
      descriptionCharactersLabelString() {
        return `Število znakov: ${this.description ? this.description.length : 0}/60`;
      }
    },
    async mounted() {
      this.categories = await ApiService.default.getCategories();
      console.log('Categories: ', this.categories);
      this.categoriesLoaded = true;
      const height = this.$refs.container.nativeView.getMeasuredHeight();
    },
    methods: {
      onCloseListTap() {
        this.$emit('closeListTap');
      },
      catchTap() {

      },
      onCategoryTap(category) {
        this.selectedCategory = category;
        this.currentViewState = this.ViewState.DESCRIPTION;
      },
      confirmTap() {

        if (this.tooLong) {
          return;
        }

        this.$emit('categorySelect', {
          category: this.selectedCategory,
          description: this.description
        });
      },
      onDescriptionChange() {
        setTimeout(() => {
          if (!this.description) {
            this.tooLong = false;
            return;
          }
          if (this.description.length > 60) {
            this.tooLong = true;
          } else {
            this.tooLong = false;
          }
        });
      }
    }
  };
</script>
