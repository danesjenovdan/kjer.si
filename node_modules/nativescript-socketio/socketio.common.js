"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var Common = (function () {
    function Common() {
    }
    Object.defineProperty(Common.prototype, "disconnected", {
        get: function () {
            return !this.connected;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(Common.prototype, "instance", {
        get: function () {
            return this.socket;
        },
        enumerable: true,
        configurable: true
    });
    Common.prototype.connect = function () {
        this.socket.connect();
    };
    Common.prototype.disconnect = function () {
        this.socket.disconnect();
    };
    return Common;
}());
exports.Common = Common;
//# sourceMappingURL=socketio.common.js.map