import * as UserService from './user.service';
import * as axios from 'axios';
import * as Phx from "../assets/js/phoenix";

export default new class {

  _baseSocketUrl = 'ws://10.0.0.11:4000/socket';
  _baseUrl = 'http://10.0.0.11:4000/api';
  socket = null;

  initSocket() {

    console.log('INIT SOCKET');
    console.log('Socket token: ', UserService.default.user.token);

    // to create a socket connection
    this.socket = new Phx.Socket(this._baseSocketUrl, {params: {token: `${UserService.default.user.token}`}});
    this.socket.connect();
    this.socket.onOpen((state) => {
      console.log('Socket: ', this.socket.isConnected());
    });

    this.socket.onError((error) => {
      console.log('Socket error: ', String(error.error));
    });
  }

  configureAxios() {
    if (!UserService.default.user || !UserService.default.user.token) {
      console.log('Configure axios error: no user or token available');
    }
    console.log('Token: ', `Bearer ${UserService.default.user.token}`);
    axios.defaults.headers.common['Authorization'] = `Bearer ${UserService.default.user.token}`;
  }

  get(url, auth = true) {
    const config = {
      baseURL: this._baseUrl
    };
    return axios.default.get(url, config);
  }

  put(url, body, auth = true) {
    const config = {
      baseURL: this._baseUrl,
    };
    return axios.default.post(url, body, config);
  }

  post(url, body) {
    const config = {
      baseURL: this._baseUrl,
    };
    return axios.default.post(url, body, config);
  }

  delete(url) {
    const config = {
      baseURL: this._baseUrl,
    };
    return axios.default.delete(url, config);
  }

  async getCategories() {
    try {
      const response = await this.get('/categories');
      return response.data.data;
    } catch (e) {
      console.log('Get categories error : ', e);
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

  async createUser(uid) {
    try {
      const user = {
        uid,
        firebaseToken: UserService.default.firebaseToken
      };
      const response = await this.post('/users', user);
      return response.data.data;
    } catch (e) {
      throw Error('Error when creating user');
    }
  }

  async updateFirebaseToken() {
    const response = await this.post('/v1/users/self/firebaseToken', {
      firebaseToken: UserService.default.firebaseToken
    }, false);
    return response.data.data;
  }

  async createRoom(name, lat, lng, radius, categoryId, description) {
    const room = {
      name, lat, lng, radius, description,
      category_id: categoryId
    };

    const response = await this.post('/rooms', room);
    return response.data.data;
  }

  async getRoomsInRadius(lat, lng) {
    const response = await this.get(`/rooms?lat=${lat}&lng=${lng}`);
    return response.data.data;
  }

  async fetchSelf(uuid) {
    const response = await this.get('/users/self');
    return response.data;
  }

  /**
   * Joins you to room
   * @param roomId
   * @returns {Promise<*>}
   */
  async joinRoom(roomId) {

    const response = await this.post('/subscriptions', {room_id: roomId});
    const responseData = response.data.data;

    return responseData;
  }

  async leaveRoom(roomId) {
    const url = `/subscriptions/${roomId}`;
    console.log('Url: ', url);
    const response = await this.delete(url);
    const responseData = response.data.data;
    return responseData;
  }

  async getRoomMessages(roomId, beforeDate) {
    const url = `/rooms/${roomId}/messages?before=${beforeDate}&limit=10`;
    const response = await this.get(url, {beforeDate});
    const responseData = response.data.data;
    return responseData;
  }

}
