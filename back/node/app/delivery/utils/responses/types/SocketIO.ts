import { Socket, Server } from "socket.io";

type SocketR = {
    single: Socket,
    multi: Server
}

export {SocketR}