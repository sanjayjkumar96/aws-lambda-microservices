import { HandlerConfig,RouteConfig } from "@common/backend-core";
import helloRoutes from "./src/routes/hello.routes";

const app = HandlerConfig.sharedExpress();

RouteConfig.setRoutes(app,helloRoutes);

app.listen(3000, () => {
    console.log("Server is running on port 3000");
});