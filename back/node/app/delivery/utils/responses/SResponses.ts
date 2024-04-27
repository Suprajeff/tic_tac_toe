import { Response } from "express";
import {Format} from "./types/Format";
import {Channel} from "./types/Channel";
import { Status } from "./types/Status";

class GameResponses {
    
    informationR = (res: Response, data: any, statusCode: Status.Informational, format: Format, channel: Channel) => {
        
    } 
    
    successR = (res: Response, data: any, statusCode: Status.Success, format: Format, channel: Channel) => {
        
    }
    
    redirectionR = (res: Response, data: any, statusCode: Status.Redirection, format: Format, channel: Channel) => {
        
    }
    
    clientErrR = (res: Response, data: any, statusCode: Status.ClientError, format: Format, channel: Channel) => {
        
    }
    
    serverErrR = (res: Response, data: any, statusCode: Status.ServerError, format: Format, channel: Channel) => {
        
    }  
    
}