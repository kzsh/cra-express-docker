import { join } from "path";
import { Router } from "express";
import UserRouter from "./Users";

// Init router and path
const router = Router();

router.get("/", function(req, res, next) {
  res.sendFile(join(__dirname, "..", "static", "index.html"));
});

// Add sub-routes
router.use("/users", UserRouter);

// Export the base-router
export default router;
