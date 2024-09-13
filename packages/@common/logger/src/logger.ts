import { createLogger, format, transports } from "winston";
import httpContext from "express-http-context";
import { sanitize } from "./secure.logger";

type MessageLogger = object | string | unknown;

const winstonLogger = createLogger({
    level: process.env.DEBUG == "true" ? "debug" : "info",
    transports: [new transports.Console({
        format: format.simple()
    })],
    exitOnError: false
});

function templated(title: string | undefined, message: unknown): string {
    return `${getCorrelationID()}::${title ?? ""} ${sanitize(message)}`;
}

function getCorrelationID(): string {
    const correlationId = httpContext.get("X-Correlation-ID");
    return correlationId ? `${correlationId}` : "";
}

function debug(message: MessageLogger, title?: string): void {
    winstonLogger.debug(templated(title, message));
}

function info(message: MessageLogger, title?: string): void {
    winstonLogger.info(templated(title, message));
}

function warn(message: MessageLogger, title?: string): void {
    winstonLogger.warn(templated(title, message));
}

function error(message: MessageLogger, title?: string): void {
    winstonLogger.error(templated(title, message));
}

function profile(id: string | number, message?: string, level?: string) {
    winstonLogger.profile(id, {
        message: `${getCorrelationID()}::${id} ${message ?? ""}`,
        level: level ?? "debug"
    })
}


export const Logger = { debug, info, error, warn, profile };