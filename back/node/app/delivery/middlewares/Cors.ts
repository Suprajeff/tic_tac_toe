import {Request, Response, NextFunction} from 'express'
const corsMiddleware = (req: Request, res: Response, next: NextFunction) => {

    const corsOrigin = process.env.CORS_ORIGIN || 'http://localhost:8085';

    res.header('Access-Control-Allow-Origin', corsOrigin);
    res.header('Access-Control-Allow-Methods', 'GET,HEAD,OPTIONS,POST,PUT');
    res.header('Access-Control-Allow-Headers', '*');
    res.header('Access-Control-Allow-Credentials', 'true');

    if (req.method === 'OPTIONS') {
        console.log('this is a preflight');
        res.sendStatus(200);
    } else {
        next();
    }
};

export {corsMiddleware}