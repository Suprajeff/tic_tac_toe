import { Response } from "express";
import { Status } from "./types/Status";
import { Socket } from "socket.io";

class GameResponses {
    
    private sendResponse = (res: Response | Socket, data: Record<string, any> | string, statusCode?: Status.Informational | Status.Success | Status.Redirection | Status.ClientError | Status.ServerError, room?: string) => {
        if (res instanceof Response && statusCode) {
            typeof data === "string" ? res.status(statusCode).send(data) : res.status(statusCode).json(data);
        } else {
            if (room) {
                typeof data === "string" ? io.to(room).emit("html", data) : io.to(room).emit("json", data);
            } else {
                typeof data === "string" ? res.emit("html", data) : res.emit("json", data);
            }
        }
    }

    informationR = (res: Response | Socket, data: Record<string, any> | string, statusCode?: Status.Informational, room?: string) => {
        this.sendResponse(res, data, statusCode, room)
    }

    successR = (res: Response | Socket, data: Record<string, any> | string, statusCode: Status.Success, room?: string) => {
        this.sendResponse(res, data, statusCode, room)
    }

    redirectionR = (res: Response | Socket, data: any, statusCode: Status.Redirection, room?: string) => {
        this.sendResponse(res, data, statusCode, room)
    }
    
    clientErrR = (res: Response | Socket, data: any, statusCode: Status.ClientError, room?: string) => {
        this.sendResponse(res, data, statusCode, room)
    }

    serverErrR = (res: Response | Socket, data: any, statusCode: Status.ServerError, room?: string) => {
        this.sendResponse(res, data, statusCode, room)
    }
    
}

export {GameResponses}