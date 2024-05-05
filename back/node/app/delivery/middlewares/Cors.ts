import {Request, Response, NextFunction} from 'express'
export const corsMiddleware = (req: Request, res: Response, next: NextFunction) => {
    // Get the CORS origin from the environment variable or set a default value
    const corsOrigin = process.env.CORS_ORIGIN || 'http://localhost:8085';

    res.header('Access-Control-Allow-Origin', corsOrigin);
    res.header('Access-Control-Allow-Methods', 'POST, GET, OPTIONS');
    res.header('Access-Control-Allow-Headers', 'Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization');
    res.header('Access-Control-Allow-Credentials', 'true');

    // If it's a preflight (OPTIONS) request, then stop here
    if (req.method === 'OPTIONS') {
        console.log('this is a preflight');
        res.sendStatus(200);
    } else {
        // Otherwise, proceed to the next middleware or handler
        next();
    }
};