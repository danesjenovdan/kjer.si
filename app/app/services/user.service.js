import * as ApiService from './api.service';
import * as platform from "@nativescript/core/platform";

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
    console.log(user);

    // if (user) {
    //   console.log('User already generated');
    // } else {

      const fetchedUser = await ApiService.default.fetchSelf(platform.device.uuid);
      console.log('fetchedUser: ', fetchedUser);
      if (!fetchedUser) {
        const username = await ApiService.default.generateUsername();
        const user = await ApiService.default.createUser(platform.device.uuid, username);

        this.saveLocalUserData(
          user.id,
          platform.device.uuid,
          user.nickname,
        );
        ApiService.default.initSocket();
      } else {
        this.saveLocalUserData(
          fetchedUser.data.id,
          platform.device.uuid,
          fetchedUser.data.nickname,
          fetchedUser.data.token,
        );
        console.log('ABOUT TO CONFIGURE AXIOS');
        console.log(fetchedUser);
        ApiService.default.configureAxios(fetchedUser.data.token);
        ApiService.default.initSocket();
      }

    // }

  }

}
