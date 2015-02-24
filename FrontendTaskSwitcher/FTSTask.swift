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
            selector: Selector("taskExited:"),
            name: NSTaskDidTerminateNotification,
            object: _task)
    }
    
    convenience init(currentDirectory: String) {
        self.init()
        _task.currentDirectoryPath = currentDirectory
    }
    
    deinit {
        _task.terminate()
    }

    func start(command: String) {
        _task.launchPath = "/bin/sh"
        _task.arguments = ["-c", command]
        _task.launch()
    }
    
    func stop() {
        if ( _task.running ) {
            _task.interrupt()
        }
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
    
    func taskExited(notification: NSNotification) {
        println("taskExited")
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self, name: NSTaskDidTerminateNotification, object: _task)
    }

    /*
    private var _task : DSUnixTask!
    
    override init() {
        super.init()
        _task = DSUnixTaskSubProcessManager.shellTask()
        _task.environment = ["PATH": "/bin:/usr/bin:/usr/local/bin"]
    }
    
    convenience init(workingDirectory: String) {
        self.init()
        _task.workingDirectory = workingDirectory
    }
    
    func start(command: String,
        outputHandler: (String!) -> Void = { (output) in },
        errorHandler: (String!) -> Void = { (output) in } ) -> FTSTask {
        _task.setCommand(command)
        _task.standardOutputHandler = { (task, output) in
            println(output)
            outputHandler(output)
        }
        _task.standardErrorHandler = { (task, output) in
            println(output)
            errorHandler(output)
        }
        _task.launch()
        return self
    }
    
    func stop() {
    }
    */
    
}
