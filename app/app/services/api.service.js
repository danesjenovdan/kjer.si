import * as UserService from './user.service';
import * as axios from 'axios';

export default new class {

  _baseSocketUrl = 'http://10.0.0.11:3088';
  _baseUrl = 'https://api.kjer.si/api';
  socket = null;

  initSocket() {
    // placeholder
  }

  configureAxios() {
    if (!UserService.default.user || !UserService.default.user.token) {
      throw new Error('Configure axios error: no user or token available');
    }
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
      headers: {}
    };
    return axios.default.post(url, body, config);
  }

  post(url, body) {
    const config = {
      baseURL: this._baseUrl,
      headers: {}
    };
    return axios.default.post(url, body, config);
  }

  async getCategories() {
    try {
      const response = await this.get('/categories');
      return response.data.data;
    } catch (e) {
      console.log('Get categories error: ', e);
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
      console.log('user: ', user);
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

    const response = await this.post('/rooms', room, false);
    return response.data.data;
  }

  async getRoomsInRadius(lat, lng) {
    const response = await this.post('/v1/map/rooms', {
      lat, lng
    }, false);
    return response.data.data;
  }

  async fetchSelf(uuid) {
    const config = {
      baseURL: this._baseUrl
    };
    const response = await axios.default.post('/v1/users/self', {uid: uuid}, config);
    return response.data;
  }

  /**
   * Joins you to room
   * @param roomId
   * @returns {Promise<*>}
   */
  async joinRoom(roomId) {
    const response = await this.post(`/v1/rooms/${roomId}/join`, {}, true);
    const responseData = response.data.data;
    return responseData;
  }

  async leaveRoom(roomId) {
    const response = await this.post(`/v1/rooms/${roomId}/leave`, {}, true);
    const responseData = response.data.data;
    return responseData;
  }

  async getRoomMessages(roomId, beforeDate) {
    console.log('beforeDate: ', beforeDate);
    const response = await this.post(`/v1/rooms/${roomId}/messages`, {beforeDate}, true);
    const responseData = response.data.data;
    return responseData;
  }

}
