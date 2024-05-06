import { default as createExpressApp, Request, Response, NextFunction, Router, Express, json, urlencoded} from 'express';
import session from 'express-session';

type ExpressMiddleware = (req: Request, res: Response, next: NextFunction) => void;

const createExpressServer = (middlewares: ExpressMiddleware[], router: Router) => {
    const app: Express = createExpressApp();

    app.use(json())
    app.use(urlencoded({extended: true}))

    app.use(
        session({
            name: 'tictactoenode',
            secret: 'tictactoe',
            resave: false,
            saveUninitialized: false,
            cookie: {
                secure: false,
            },
        })
    );

    middlewares.forEach(middleware  => {
        app.use(middleware);
    });

    app.use('/', router);

    return app.listen(8081, () => {
        console.log('Server listening on port 8081');
    });
};

const createExpressRouter = () => {
    return Router();
}

export {createExpressServer, createExpressRouter, ExpressMiddleware}