import express from "express";

const setRoutes = (app: express.Application, routes: express.Router) => {
    app.use(routes);
};


export { setRoutes };