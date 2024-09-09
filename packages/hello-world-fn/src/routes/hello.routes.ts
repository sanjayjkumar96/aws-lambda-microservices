import express from "express";

const helloRoutes = express.Router();

helloRoutes.get("/hello", (req, res) => {
    res.send("Hello World!");
});

export default helloRoutes;