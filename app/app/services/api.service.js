import * as http from "http";
import * as AppService from './app.service';
import * as axios from 'axios';

export default new class {

  _baseUrl = 'http://192.168.3.193:4000/api';

  get(url) {

    return axios.default.get(url, {
      baseURL: this._baseUrl,
      headers: {
        uid: AppService.default.uid
      }
    });

  }

  put(url, body) {

    return axios.default.post(url, body, {
      baseURL: this._baseUrl,
      headers: {
        uid: AppService.default.uid
      }
    });

  }

  post(url, body) {

    return axios.default.post(url, body, {
      baseURL: this._baseUrl,
      headers: {
        uid: AppService.default.uid
      }
    });

  }

  delete(url, body) {

    return axios.default.delete(url, {
      baseURL: this._baseUrl,
      headers: {
        uid: AppService.default.uid
      }
    });

  }

}
