import * as http from "http";
import * as AppService from './app.service';
import * as UserService from './user.service';
import * as axios from 'axios';
import * as Phx from "~/assets/js/phoenix";

export default new class {

  _baseSocketUrl = 'ws://api.kjer.si/socket';
  _baseUrl = 'http://api.kjer.si/api';
  socket = null;

  configureAxios(token) {
    axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
  }

  get(url, auth = true) {

    const config = {
      baseURL: this._baseUrl
    };

    // if (auth && UserService.default.user && UserService.default.user.uid) {
    //   config.headers = {
    //     Authorization: UserService.default.user.uid
    //   };
    // }

    return axios.default.get(url, config);

  }

  put(url, body, auth = true) {

    const config = {
      baseURL: this._baseUrl,
      headers: {}
    };

    // if (auth && UserService.default.user && UserService.default.user.uid) {
    //   config.headers.Authorization = UserService.default.user.uid;
    // }

    return axios.default.post(url, body, config);

  }

  post(url, body, auth = true) {

    const config = {
      baseURL: this._baseUrl,
      headers: {}
    };

    // console.log('UserService.default.user: ', UserService.default.user);

    // if (auth && UserService.default.user && UserService.default.user.uid) {
    //   console.log('Authorization');
    //   config.headers.Authorization = UserService.default.user.uid;
    // }

    return axios.default.post(url, body, config);

  }

  initSocket() {

    // to create a socket connection
    this.socket = new Phx.Socket(this._baseSocketUrl, {params: {token: UserService.default.user.token}});
    this.socket.connect();
    this.socket.onOpen((state) => {
      android.util.Log.v("KJERSI Socket:", this.socket.isConnected()+"");
      console.log('Socket: ', this.socket.isConnected());
    });

    this.socket.onError((error) => {
      android.util.Log.v("KJERSI Socket error:", String(error.error));
      console.log('Socket error: ', String(error.error));
    });

  }

  async getCategories() {

    try {
      const response = await this.get('/categories');
      return response.data.categories;
    } catch (e) {
      console.log('Error: ', e);
    }

  }

  async generateUsername() {

    try {
      const response = await this.get('/generate-username');
      console.log(response);
      return response.data;
    } catch (e) {
      console.log('Error: ', e);
    }

  }

  async createUser(uid, nickname) {

    try {
      const user = {
        uid,
        nickname
      };

      console.log('user: ', user);

      const response = await this.post('/users', {
        user
      });
      console.log('User creation response: ', response.data.data);
      return response.data.data;
    } catch (e) {
      console.log('Create user error: ', e.response.data);
      throw Error('Error when creating user ');
    }

  }

  async createRoom(name, lat, lng, radius, categoryId) {

    const room = {
      name, lat, lng, radius,
      category_id: categoryId
    };

    console.log('Create room: ', room);

    const response = await this.post('/rooms', {room}, false);
    return response.data;
  }

  async getRoomsInRadius(lat, lng) {
    const response = await this.post('/map/rooms', {
      lat, lng
    }, false);
    return response.data.data;
  }

  async fetchSelf(uuid) {

    const config = {
      baseURL: this._baseUrl
    };

    const response = await axios.default.post('/recover-self', {uid: uuid}, config);
    return response.data;

  }

  /**
   * Joins you to room
   * @param roomId
   * @returns {Promise<*>}
   */
  async joinRoom(roomId) {

    const postData = {
      subscription: {
        room_id: roomId,
        user_id: UserService.default.user.id
      }
    };

    console.log('postData: ', postData);

    const response = await this.post('/subscriptions', postData, true);
    const responseData = response.data.data;

    console.log('Join room: ', responseData);

    return responseData;

  }

}
