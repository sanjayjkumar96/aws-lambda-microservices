import express from "express";
import helmet from "helmet";
import cors from "cors";

const sharedExpress = () => {
    const app = express();
    app.use(helmet())
    .use(cors())
    .use(express.json())
    .use(express.urlencoded({ extended: false }));
    return app;
};
export  { sharedExpress };