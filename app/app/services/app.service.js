import * as http from "http";
import {getUUID} from "nativescript-uuid";

export default new class {

  get uid() {
    return getUUID();
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
