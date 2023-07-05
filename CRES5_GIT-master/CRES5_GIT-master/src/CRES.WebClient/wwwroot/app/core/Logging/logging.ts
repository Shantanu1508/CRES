import { Injectable } from '@angular/core';
import { LoggingService } from '../services/loggingService';
import { Component, OnInit, AfterViewInit, ViewChild } from "@angular/core";

@Component({ 
    providers: [LoggingService]
})

export class Logging
{
    constructor(public loggingService: LoggingService)
    {
        
    }
    writeToLog(module: string, logtype: string, logtext: string)
    {
        //var text = module + "||" + logtype + "||" + logtext;
        //this.loggingService.writeToLog(text).subscribe(res => {
        //    if (res.Succeeded) {
        //    }
        //    else {

        //    }
        //});
    }    

}

 