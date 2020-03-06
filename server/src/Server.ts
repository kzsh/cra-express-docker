import cookieParser from "cookie-parser";
import express from "express";
import { Request, Response } from "express";
import logger from "morgan";
import path from "path";
import BaseRouter from "./routes";
import compression from "compression";
import history from "connect-history-api-fallback";

// Init express
const app = express();

// Add middleware/settings/routes to express.
app.use(logger("dev"));
app.use(express.json());
/* app.use( */
/*   history({ */
/*     rewrites: [{ from: /\/(?!api)/, to: "/soccer.html" }], */
/*   }), */
/* ); */
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(compression());
/* app.use("/", express.static(path.join(__dirname, "static"))); */

app.use("/api", BaseRouter);

/**
 * Point express to the 'views' directory. If you're using a
 * single-page-application framework like react or angular
 * which has its own development server, you might want to
 * configure this to only serve the index file while in
 * production mode.
 */
const staticDir = path.join(__dirname, "static");
app.use(express.static(staticDir));

// Export express instance
export default app;
