import {SocketIO} from 'nativescript-socketio';
import {isAndroid} from "@nativescript/core";
import * as ApiService from '../services/api.service';
import * as UserService from '../services/user.service';
import * as EventEmitter from 'wolfy87-eventemitter';

export default new class {

  socketIO;
  server = isAndroid ? `${ApiService.default._baseSocketUrl}` : `${ApiService.default._baseSocketUrl}`;

  messageEmitter = new EventEmitter();

  init() {

    this.socketIO = new SocketIO(this.server);
    this.socketIO.connect();

    this.socketIO.on('disconnect', this.onDisconnect.bind(this));
    this.socketIO.on('connect', this.onConnected.bind(this));
    this.socketIO.on('message', this.onMessage.bind(this));

    return new Promise((resolve, reject) => {
      this.socketIO.once('connect', () => {
        console.log('Socket connected');
        resolve();
      });
    });

  }

  sendMessage(roomId, text) {
    this.socketIO.emit('message', {
      roomId, text, type: 'TEXT'
    }, (data) => {
      console.log('DONE: ', data);
    });
  }

  joinRoom(roomId) {
    this.socketIO.emit('joinRoom', {
      roomId
    }, (data) => {
      console.log('DONE: ', data);
    });
  }

  authenticate(token) {
    if (!this.connected) {
      throw new Error('Socket not connected');
    }

    console.log('Authenticate');

    this.socketIO.emit('authenticate', {
      accessToken: token
    }, (data) => {
      console.log('DONE: ', data);
    });
  }

  onMessage(message) {
    this.messageEmitter.emit('message', message);
  }

  onDisconnect() {
    // ...
  }

  onConnected() {
    // ...
    if (UserService.default.user && UserService.default.user.token) {
      this.authenticate(UserService.default.user.token);
    }
  }

  get connected() {
    if (this.socketIO) {
      return this.socketIO.connected;
    } else {
      return false;
    }
  }

}
