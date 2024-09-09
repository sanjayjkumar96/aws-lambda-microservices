import express from "express";

const sharedExpress = () => {
    const app = express();
    app.use(express.json());
    app.use(express.urlencoded({ extended: true }));
    return app;
};
export  { sharedExpress };