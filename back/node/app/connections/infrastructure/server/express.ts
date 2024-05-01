import { default as createExpressApp, Request, Response, NextFunction, Router, Express, json, urlencoded} from 'express';

type ExpressMiddleware = (req: Request, res: Response, next: NextFunction) => void;

const createExpressServer = (middlewares: ExpressMiddleware[], router: Router) => {
    const app: Express = createExpressApp();

    app.use(json())
    app.use(urlencoded({extended: true}))

    middlewares.forEach(middleware  => {
        app.use(middleware);
    });

    app.use('/', router);

    return app.listen(8081, () => {
        console.log('Server listening on port 3001');
    });
};

const createExpressRouter = () => {
    return Router();
}

export {createExpressServer, createExpressRouter, ExpressMiddleware}