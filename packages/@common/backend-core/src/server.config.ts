import { Logger } from "@common/logger";
import { Express } from "express";


const startServer = (app: Express, runningPort: number = 9000) => {
    const port = Number(process.env.PORT) || runningPort;
    const server = app.listen(port, () => {
        Logger.info(`Server running on port ${port}`);
    });

    process.on("Lambda-Express", () => {
        Logger.info(`Stopping server ...`);
        server.close(() => {
            Logger.info(`Server stopped.`);
            process.exit(0);
        });
    });
};

export { startServer };