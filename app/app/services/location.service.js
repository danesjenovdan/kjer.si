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

  lastLocationTime;

  async requestLocation() {

    try {
      const location = await geolocation.getCurrentLocation({
        desiredAccuracy: Accuracy.any,
        maximumAge: 5000,
        timeout: 20000
      });
      this.location = location;
      this.lastLocationTime = new Date();
      return location;
    } catch (e) {
      console.log('Location error: ', e);
      throw Error(e);
    }

  }

  getDistance(p1, p2) {
    const R = 6378137; // Earth’s mean radius in meter
    const dLat = this.rad(p2.lat - p1.lat);
    const dLong = this.rad(p2.lng - p1.lng);
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.rad(p1.lat)) * Math.cos(this.rad(p2.lat)) *
      Math.sin(dLong / 2) * Math.sin(dLong / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const d = R * c;
    return d; // returns the distance in meter
  }

  rad(x) {
    return x * Math.PI / 180;
  };

}
