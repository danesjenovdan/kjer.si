import * as Toast from 'nativescript-toast';
import * as ApiService from './api.service';
import * as platform from "tns-core-modules/platform";

export default new class {

  user = null;
  firebaseToken = null;

  initLocalUserData() {
    const userData = JSON.parse(localStorage.getItem('user'));
    this.user = userData;
    return userData;
  }

  saveLocalUserData(_id, deviceUid, nickname, token) {
    const userData = {_id, uid: deviceUid, nickname, token};
    localStorage.setItem('user', JSON.stringify(userData));
    this.user = userData;
    return userData;
  }

  isRoomMuted(roomId) {
    const mutedRooms = JSON.parse(localStorage.getItem('mutedRooms'));
    if (!mutedRooms || !Array.isArray(mutedRooms)) {
      return false;
    }
    const isMuted = !!mutedRooms.filter((r) => r === roomId)[0];
    return isMuted;
  }

  removeFromMutedRooms(roomId) {
    const mutedRooms = JSON.parse(localStorage.getItem('mutedRooms'));
    if (!mutedRooms || !Array.isArray(mutedRooms)) {
      return;
    }
    const index = mutedRooms.indexOf(roomId);
    mutedRooms.splice(index, 1);
    localStorage.setItem('mutedRooms', JSON.stringify(mutedRooms));
  }

  addMutedRoom(roomId) {
    let mutedRooms = JSON.parse(localStorage.getItem('mutedRooms'));
    if (!mutedRooms || !Array.isArray(mutedRooms)) {
      mutedRooms = [];
    }
    const exists = !!mutedRooms.filter((id) => roomId === id).length;
    if (exists) {
      return;
    }
    mutedRooms.push(roomId);
    localStorage.setItem('mutedRooms', JSON.stringify(mutedRooms));
  }

  async setupUser() {

    this.initLocalUserData();

    let fetchedUser;
    try {
      fetchedUser = await ApiService.default.fetchSelf(platform.device.uuid);
      console.log('Fetched user: ', fetchedUser);
    } catch (e) {
      console.log('Fetched user error: ', e);
    }

    if (!fetchedUser) {
      const user = await ApiService.default.createUser(platform.device.uuid);

      this.saveLocalUserData(
        user._id,
        platform.device.uuid,
        user.nickname,
        user.token
      );
      ApiService.default.configureAxios();
      this.initLocalUserData();
      ApiService.default.initSocket();
    } else {
      this.saveLocalUserData(
        fetchedUser._id,
        platform.device.uuid,
        fetchedUser.nickname,
        fetchedUser.token,
      );
      ApiService.default.configureAxios();
      ApiService.default.initSocket();
    }

  }

}
