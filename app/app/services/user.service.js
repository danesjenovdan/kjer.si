import * as Toast from 'nativescript-toast';
import * as ApiService from './api.service';
import * as platform from "tns-core-modules/platform";

export default new class {

  user = null;

  initLocalUserData() {
    const userData = JSON.parse(localStorage.getItem('user'));
    this.user = userData;
    return userData;
  }

  saveLocalUserData(id, deviceUid, nickname, token) {
    const userData = {id, uid: deviceUid, nickname, token};
    localStorage.setItem('user', JSON.stringify(userData));
    this.user = userData;
    return userData;
  }

  async setupUser() {

    const user = this.initLocalUserData();

    // if (user) {
    //   console.log('User already generated');
    // } else {

    // android.util.Log.v("KJERSI device uuid:", platform.device.uuid);
    console.log('platform.device.uuid: ', platform.device.uuid);

    let fetchedUser;
    try {
      fetchedUser = await ApiService.default.fetchSelf(platform.device.uuid);
    } catch (e) {
      console.log('Fetched user error: ', e);
    }
    // android.util.Log.v("KJERSI fetched user:", fetchedUser);
    if (!fetchedUser) {
      const username = await ApiService.default.generateUsername();
      // android.util.Log.v("KJERSI username:", username);
      const user = await ApiService.default.createUser(platform.device.uuid, username);
      // android.util.Log.v("KJERSI user:", user);

      this.saveLocalUserData(
        user.id,
        platform.device.uuid,
        user.nickname,
      );
      this.initLocalUserData();
      ApiService.default.initSocket();
    } else {
      this.saveLocalUserData(
        fetchedUser.id,
        platform.device.uuid,
        fetchedUser.nickname,
        fetchedUser.token,
      );
      ApiService.default.configureAxios(fetchedUser.token);
      ApiService.default.initSocket();
    }

    // }

  }

}
