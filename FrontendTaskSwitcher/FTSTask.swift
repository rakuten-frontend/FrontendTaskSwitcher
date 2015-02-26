//
//  FTSTask.swift
//  FrontendTaskSwitcher
//
//  Created by Ogasawara, Tsutomu | Oga | CWDD on 2/20/15.
//  Copyright (c) 2015 Rakuten Front-end. All rights reserved.
//

import Cocoa

class FTSTask: NSObject {
    
    private var _task : NSTask!
    
    deinit {
        if ( self.isRunning() ) {
            _task.terminate()
        }
    }
    
    private func initializeTask() {
        if ( _task == nil ) {
            _task = NSTask()
        }
        _task.environment = ["PATH": "/bin:/usr/bin:/usr/local/bin"]
        
        let outPipe = NSPipe()
        _task.standardOutput = outPipe
        let errorPipe = NSPipe()
        _task.standardError = errorPipe
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self,
            selector: Selector("readCompleted:"),
            name: NSFileHandleReadCompletionNotification,
            object:outPipe.fileHandleForReading )
        outPipe.fileHandleForReading.readInBackgroundAndNotify()
        
        nc.addObserver(self,
            selector: Selector("taskDidTerminated:"),
            name: NSTaskDidTerminateNotification,
            object: _task)
    }

    func start(command: String, currentDirectory: String = "") {
        self.initializeTask()
        if ( currentDirectory != "" ) {
            _task.currentDirectoryPath = currentDirectory
        }
        if ( !self.isRunning() ) {
            _task.launchPath = "/bin/sh"
            _task.arguments = ["-c", command]
            _task.launch()
            println("task start")
        }
    }
    
    func interrupt() {
        if ( self.isRunning() ) {
            _task.interrupt()
        }
    }
    
    func isRunning() -> Bool {
        return _task != nil && _task.running
    }
    
    func readCompleted(notification: NSNotification) {
        let data: NSData? = notification.userInfo?[NSFileHandleNotificationDataItem] as? NSData
        if data?.length > 0 {
            println(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
        }
    }
    
    func taskDidTerminated(notification: NSNotification) {
        println("taskDidTerminated")
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self, name: NSTaskDidTerminateNotification, object: _task)
        _task = nil
    }

}
