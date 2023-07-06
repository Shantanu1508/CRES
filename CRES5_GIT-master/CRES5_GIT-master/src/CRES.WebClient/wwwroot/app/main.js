"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var core_1 = require("@angular/core");
var platform_browser_dynamic_1 = require("@angular/platform-browser-dynamic");
var app_module_1 = require("./app.module");
var platform = (0, platform_browser_dynamic_1.platformBrowserDynamic)();
(0, core_1.enableProdMode)();
platform.bootstrapModule(app_module_1.AppModule);
//# sourceMappingURL=main.js.map