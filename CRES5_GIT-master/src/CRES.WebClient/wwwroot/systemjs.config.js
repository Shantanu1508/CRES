/**
 * System configuration for Angular samples
 * Adjust as necessary for your application needs.
 */
(function (global) {
    System.appVersion = $.getVersion();
  System.config({
    paths: {
      // paths serve as alias
        'npm:': 'libs/'
    },
    // map tells the System loader where to look for things
    map: {
      // our app is within the app folder
      app: 'app',
      // angular bundles
      '@angular/core': 'npm:@angular/core/bundles/core.umd.js',
      '@angular/common': 'npm:@angular/common/bundles/common.umd.js',
      '@angular/compiler': 'npm:@angular/compiler/bundles/compiler.umd.js',
      '@angular/platform-browser': 'npm:@angular/platform-browser/bundles/platform-browser.umd.js',
      '@angular/platform-browser-dynamic': 'npm:@angular/platform-browser-dynamic/bundles/platform-browser-dynamic.umd.js',
      '@angular/http': 'npm:@angular/http/bundles/http.umd.js',
      '@angular/router': 'npm:@angular/router/bundles/router.umd.js',
      '@angular/forms': 'npm:@angular/forms/bundles/forms.umd.js',

       // other libraries
      'rxjs':                      'npm:rxjs',
      'angular-in-memory-web-api': 'npm:angular-in-memory-web-api',
      'wijmo': 'npm:wijmo',
       'powerbi-client': 'npm:powerbi-client/dist/powerbi.js',
       'powerbi-models': 'npm:powerbi-models/dist/models.js',
      
        //Document uploader
        'ng2-file-input': 'npm:ng2-file-input/dist/bundles/ng2-file-input.umd.js',
        'bergben-angular2-file-drop': 'npm:bergben-angular2-file-drop/dist/bundles/bergben-angular2-file-drop.umd.js',
        'fileapi': 'npm:fileapi/dist/FileAPI.js',
        'webworkify': 'npm:webworkify',
        'object-assign': 'npm:object-assign',
        'glur/mono16': 'npm:glur/mono16',
        
     },
    // packages tells the System loader how to load when no filename and/or no extension
    packages: {
        app: {
            main: './main',
            defaultExtension: 'js?v=' + System.appVersion
        },
      rxjs: {
        defaultExtension: 'js'
      },
      'angular-in-memory-web-api': {
        main: './index.js',
        defaultExtension: 'js'
      },
      src: {
          defaultExtension: 'js'
      },
      wijmo: {
          defaultExtension: 'js'
      }
    }
  });
})(this);
