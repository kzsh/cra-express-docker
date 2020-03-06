const { removeSync, copySync } = require("fs-extra");
const { exec } = require("child_process");

try {
  // Remove current build
  removeSync("./dist/");
  // Copy front-end files
  // copySync("./src/static", "./dist/static");
  copySync("./src/views", "./dist/views");
  // Transpile the typescript files
  exec("tsc --build tsconfig.prod.json");
} catch (err) {
  console.log(err);
}
