import * as http from "http";
import {getUUID} from "nativescript-uuid";
import * as ApiService from "./api.service";

export default new class {

  categories = [];

  get uid() {
    return getUUID();
  }

  async getCategories(){
    this.categories = await ApiService.default.getCategories();
  }

  screen = {
    width: 0,
    height: 0
  };

  neki() {

    http.request({
      method: 'POST',
      url: 'test'
    });

    http.getJSON("https://pokeapi.co/api/v2/pokemon/?limit=151").then(result => {
      this.pokemon = result.results;
    }, error => {
      console.log(error);
    });

  }
}
