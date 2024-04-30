import { Request, Response } from "express";
import { Status } from "./types/Status";
import { Socket } from "socket.io";
import {SocketR} from "./types/SocketIO";

class GameResponses {
    
    private sendHTTPResponse = (res: Response, data: Record<string, any> | string, statusCode: number) => {
            typeof data === "string" ? res.status(statusCode).send(data) : res.status(statusCode).json(data);
    }

    private sendSocketResponse = (socketR: SocketR, data: Record<string, any> | string, room?: string) => {
        if (room) {
            typeof data === "string" ? socketR.multi.to(room).emit("html", data) : socketR.multi.to(room).emit("json", data);
        } else {
            typeof data === "string" ? socketR.single.emit("html", data) : socketR.single.emit("json", data);
        }
    }

    informationR = (res: Response, data: Record<string, any> | string, statusCode: Status.Informational) => {
        this.sendHTTPResponse(res, data, statusCode)
    }

    successR = (res: Response, data: Record<string, any> | string, statusCode: Status.Success) => {
        this.sendHTTPResponse(res, data, statusCode)
    }

    redirectionR = (res: Response, data: any, statusCode: Status.Redirection) => {
        this.sendHTTPResponse(res, data, statusCode)
    }

    clientErrR = (res: Response, data: any, statusCode: Status.ClientError) => {
        this.sendHTTPResponse(res, data, statusCode)
    }

    serverErrR = (res: Response, data: any, statusCode: Status.ServerError) => {
        this.sendHTTPResponse(res, data, statusCode)
    }

    socketR = (socketR: SocketR, data: any, room?: string) => {
        this.sendSocketResponse(socketR, data, room)
    }
    
}

export {GameResponses}