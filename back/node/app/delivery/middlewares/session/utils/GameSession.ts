//import {Request, Response, NextFunction} from 'express'
//
//const getGameSession = (req: Request, res: Response, next: NextFunction) => {
//    if (req.session && req.session.gameID, req.session.currentPlayer, req.session.gameState, req.session.state) {
//        res.locals.gameID = req.session.gameID;
//        res.locals.currentPlayer = req.session.currentPlayer;
//        res.locals.gameState = req.session.gameState;
//        res.locals.state = req.session.state;
//    }
////    else {
////        res.locals.userSettings = { darkMode: false };
////    }
//    next();
//};
//
//export {getGameSession}