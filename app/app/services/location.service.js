import * as geolocation from "nativescript-geolocation";
import {Accuracy} from "tns-core-modules/ui/enums"; // used to describe at what accuracy the location should be get

export default new class {

  location = {
    latitude: 0,
    longitude: 0,
    altitude: 0,
    horizontalAccuracy: 0,
    verticalAccuracy: 0,
    speed: 0,
    direction: 0,
    timestamp: null
  };

  async requestLocation() {

    try {
      const location = await geolocation.getCurrentLocation({
        desiredAccuracy: Accuracy.high,
        maximumAge: 5000,
        timeout: 20000
      });
      this.location = location;
      return location;
    } catch (e) {
      console.log('Location error: ', e);
      throw Error(e);
    }

  }

}
