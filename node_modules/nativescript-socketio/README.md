[![npm](https://img.shields.io/npm/v/nativescript-socketio.svg)](https://www.npmjs.com/package/nativescript-socketio)
[![npm](https://img.shields.io/npm/dt/nativescript-socketio.svg?label=npm%20downloads)](https://www.npmjs.com/package/nativescript-socketio)
[![Build Status](https://travis-ci.org/triniwiz/nativescript-socketio.svg?branch=master)](https://travis-ci.org/triniwiz/nativescript-socketio)
# nativescript-socketio
# Usage

```
npm install nativescript-socketio
```

or

```
tns plugin add nativescript-socketio
```

## NativeScript Core

Set connection string and options then connect

```js
var SocketIO = require('nativescript-socketio').SocketIO; 
var socketIO = new SocketIO(url, opts);
```
Alternatively:
```js
import { SocketIO } from 'nativescript-socketio';
var socketIO = new SocketIO(url, opts);
```

Connect to server
```js
socketIO.connect()
```

Send data to the server
```js
socketIO.emit(event,data)
```
Listen for data 
```js
socketIO.on(event,callback)
```
Set instance
```js
new SocketIO(null,null,oldInstance)
```

## Angular

``` ts
// app.module.ts
import { SocketIOModule } from "nativescript-socketio/angular";

@NgModule({
  imports: [
    SocketIOModule.forRoot(server),
  ]
})
```

``` ts
// app.component.ts
import { Component, OnInit, OnDestroy } from "@angular/core";
import { SocketIO } from "nativescript-socketio";

@Component({
  // ...
})
export class AppComponent implements OnInit, OnDestroy {
  constructor(private socketIO: SocketIO) { }

  ngOnInit() {
    this.socketIO.connect();
  }

  ngOnDestroy() {
    this.socketIO.disconnect();
  }
}
```

``` ts
// test.component.ts
import { Component, OnInit, NgZone } from "@angular/core";
import { SocketIO } from "nativescript-socketio";

@Component({
  // ...
})
export class TestComponent implements OnInit {
  constructor(
    private socketIO: SocketIO,
    private ngZone: NgZone
  ) { }

  ngOnInit() {
    this.socketIO.on("test", data => {
      this.ngZone.run(() => {
        // Do stuff here
      });
    });
  }

  test() {
    this.socketIO.emit("test", { test: "test" });
  }
}
```

## Running Demo

Start socketio server
``` bash
cd demo/demo-server
npm install
node app
```

## Api

| Method                                   | Default | Type                         | Description                                           |
| ---------------------------------------- | ------- | ---------------------------- | ----------------------------------------------------- |
| constructor(url) |         | `void`                     | Creates a SocketIO instance with a url |
| constructor(url, options:{}) |         | `void`                     | Creates a SocketIO instance with url and options|
| constructor(null,null,nativeSocket) |         | `void`                     | Creates a SocketIO instance from a native socket instance |
| connect()                    |         | `void`                 | Connect to the server.                  |
| disconnect()                    |         | `void`                 | Disconnects the socket.                   |
| connected()   |         | `boolean` | Checks if the socket is connected                              |  |
| on(event: string,(data: Object , ack? : Function))                       |         | `Function`                       | Adds a handler for a client event. Return a function to remove the handler.                             |
| once(event: string,(data: Object , ack? : Function))                       |         | `Function`                       | Adds a single-use handler for a client event. Return a function to remove the handler.                             |
| off(event: string)                        |         | `void`                       | Removes handler(s) based on an event name.                               |
| emit(event: string,data: {},ack?: Function)                      |         | `void`                       | Send an event to the server, with optional data items.                  |
| joinNamespace(name: string)                      |         | `SocketIO`                       | Return SocketIO instance with the namespace                   |
| leaveNamespace()                      |         | `void`                       | Call when you wish to leave a namespace and disconnect this socket.                  |

## Example Image
![socketio](https://i.imgur.com/4xi4h3r.gif)