// import {getUUID} from "@owen-it/nativescript-uuid";
// TODO this is android only, fork above repo to get full functionality

const { device } = require('@nativescript/core/platform');

function createUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
     var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
     return v.toString(16);
  });
}

function getUUID() {
  return device ? device.uuid : null;
}

exports.getUUID = getUUID;

export default new class {

  get uid() {
    return getUUID();
  }

  screen = {
    width: 0,
    height: 0
  };
}
