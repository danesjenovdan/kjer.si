import { InjectionToken, ModuleWithProviders } from '@angular/core';
import { SocketIO } from '../socketio';
export interface IOOptions {
    compress?: boolean;
    debug?: boolean;
    query?: {
        [key: string]: any;
    };
    cookies?: string[];
    extraHeaders?: {
        [key: string]: any;
    };
    forceNew?: boolean;
    forcePolling?: boolean;
    forceWebsockets?: boolean;
    log?: boolean;
    path?: string;
    reconnects?: boolean;
    reconnectAttempts?: number;
    reconnectWait?: number;
    secure?: boolean;
}
export declare type SocketIOOptions = Partial<IOOptions>;
export declare const SOCKETIO_URL: InjectionToken<string>;
export declare const SOCKETIO_OPTIONS: InjectionToken<Partial<IOOptions>>;
export declare function socketIOFactory(url: string, options: SocketIOOptions): SocketIO;
export declare class SocketIOModule {
    static forRoot(url: string, options?: SocketIOOptions): ModuleWithProviders;
}
