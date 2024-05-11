//import {Request, Response, NextFunction} from 'express'
//
//const getSettingsPreferences = (req: Request, res: Response, next: NextFunction) => {
//    if (req.session && req.session.darkMode) {
//        res.locals.userSettings = req.session.darkMode;
//    } else {
//        res.locals.userSettings = { darkMode: false };
//    }
//    next();
//};
//
//export {getSettingsPreferences}