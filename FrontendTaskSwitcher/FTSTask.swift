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
    
    override init() {
        super.init()
        _task = NSTask()
        _task.environment = ["PATH": "/bin:/usr/bin:/usr/local/bin"]
        
        let outPipe = NSPipe()
        _task.standardOutput = outPipe
        let errorPipe = NSPipe()
        _task.standardError = errorPipe
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self,
            selector: Selector("getData:"),
            name: NSFileHandleReadCompletionNotification,
            object:outPipe.fileHandleForReading )
        outPipe.fileHandleForReading.readInBackgroundAndNotify()

        nc.addObserver(self,
            selector: Selector("taskDidTerminated:"),
            name: NSTaskDidTerminateNotification,
            object: _task)
    }
    
    convenience init(currentDirectory: String) {
        self.init()
        _task.currentDirectoryPath = currentDirectory
    }
    
    deinit {
        if ( _task.running ) {
            _task.terminate()
        }
    }

    func start(command: String) {
        if ( !_task.running ) {
            _task.launchPath = "/bin/sh"
            _task.arguments = ["-c", command]
            _task.launch()
            println("task start")
        }
    }
    
    func interrupt() {
        if ( _task.running ) {
            _task.interrupt()
            println("task interrupt")
        }
    }
    
    func isRunning() -> Bool {
        return _task.running
    }
    
    func getData(notification: NSNotification) {
        println("getData")
        let data: NSData? = notification.userInfo?[NSFileHandleNotificationDataItem] as? NSData
        if data?.length > 0 {
            println(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        else {
            println("no data")
        }
    }
    
    func taskDidTerminated(notification: NSNotification) {
        println("taskDidTerminated")
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self, name: NSTaskDidTerminateNotification, object: _task)        
    }

}
