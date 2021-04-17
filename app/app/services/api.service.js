import * as UserService from './user.service';
import * as axios from 'axios';
import * as Phx from "~/assets/js/phoenix";

export default new class {

  // _baseSocketUrl = 'ws://api.kjer.si/socket';
  // _baseUrl = 'http://api.kjer.si/api';
  _baseSocketUrl = 'wss://kjersi.lb.djnd.si/socket';
  _baseUrl = 'https://kjersi.lb.djnd.si/api';
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
    this.socket = new Phx.Socket(this._baseSocketUrl, { params: { token: UserService.default.user.token } });
    this.socket.connect();
    this.socket.onOpen((state) => {
      console.log('Socket: ', this.socket.isConnected());
    });

    this.socket.onError((error) => {
      console.log('Socket error: ', String(error.error));
    });

  }

  async getCategories() {
    try {
      const response = await this.get('/categories');
      return response.data.data;
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
      category_id: categoryId,
      description: 'Fake description',
    };

    const response = await this.post('/rooms', room, false);
    return response.data;
  }

  async getRoomsInRadius(lat, lng) {
    const response = await this.get(`/rooms?lat=${lat}&lng=${lng}`, false);
    return response.data.data;
  }

  async fetchSelf(uuid) {
    const config = {
      baseURL: this._baseUrl
    };

    const response = await axios.default.post('/users', { uid: uuid }, config);
    return response.data;
  }

  /**
   * Joins you to room
   * @param roomId
   * @returns {Promise<*>}
   */
  async joinRoom(roomId) {

    const postData = {
      room_id: roomId,
    };

    console.log('postData: ', postData);

    const response = await this.post('/subscriptions', postData, true);
    const responseData = response.data.data;

    console.log('Join room: ', responseData);

    return responseData;

  }

  /**
   * Gets messages from room, since time with limit
   * @param roomId 
   * @param {Number} limit 
   * @param {Date} before
   * @returns {Promise<*>}
   */

   async getMessagesFromRoom(roomId, limit, before) {

    const url = `/rooms/${roomId}/messages?limit=${limit}&before=${encodeURIComponent(before.toISOString())}`;
    console.log(url);
    const response = await this.get(url, true);
    const responseData = response.data.data;

    console.log('Messages: ', responseData);

    return responseData;
  }

}
