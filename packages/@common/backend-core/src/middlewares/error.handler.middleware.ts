import { Express, NextFunction, Request, Response } from "express";
import { Logger } from "@common/logger";

const notFoundErrorHandler = (req: Request, res: Response, next: NextFunction) => {
    res.status(404).json({ message: `Requested Path ${req.path} not found and/or not handled` });
};

const internalServerErrorHandler = (err: any, req: Request, res: Response, next: NextFunction) => {
    const statusCode = err.statusCode || err.status || 500;
    Logger.error(`Error occurred: ` + JSON.stringify(err, Object.getOwnPropertyNames(err)) + `code ${statusCode}`);
    res.status(statusCode).json({ name: err.name, message: `${err.message}` });
};

const configureErrorHandler = (app: Express) => {
    app.use(notFoundErrorHandler);
    app.use(internalServerErrorHandler);
};

export {
    configureErrorHandler
};