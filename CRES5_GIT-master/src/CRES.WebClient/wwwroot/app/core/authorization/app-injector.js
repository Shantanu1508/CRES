"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.appInjector = void 0;
var appInjectorRef;
exports.appInjector = function (injector) {
    if (injector) {
        appInjectorRef = injector;
    }
    return appInjectorRef;
};
//# sourceMappingURL=app-injector.js.map