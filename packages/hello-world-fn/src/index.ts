import { configureErrorHandler, HandlerConfig,RouteConfig } from "@common/backend-core";
import helloRoutes from "./routes/hello.routes";
import serverless from "serverless-http";
import { APIGatewayEvent, APIGatewayProxyResult, Context } from "aws-lambda";

const app = HandlerConfig.sharedExpress();

RouteConfig.setRoutes(app,helloRoutes);

configureErrorHandler(app);

export const handler = async (event:APIGatewayEvent, context:Context): Promise<APIGatewayProxyResult> => {
    const instance = serverless(app);
    return instance (event,context) as Promise<APIGatewayProxyResult>;
}