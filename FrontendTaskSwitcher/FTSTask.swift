//
//  FTSTask.swift
//  FrontendTaskSwitcher
//
//  Created by Ogasawara, Tsutomu | Oga | CWDD on 2/20/15.
//  Copyright (c) 2015 Rakuten Front-end. All rights reserved.
//

import Cocoa

protocol FTSTaskDelegate {
    func readCompleted(output: String)
}

class FTSTask: NSObject {
    
    private var _task : NSTask!
    
    var outPipe   : NSPipe!
    var errorPipe : NSPipe!
    
    var delegate : FTSTaskDelegate!
    
    convenience init(delegate: FTSTaskDelegate!) {
        self.init()
        self.delegate = delegate
    }
    
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
        
        outPipe = NSPipe()
        _task.standardOutput = outPipe
        errorPipe = NSPipe()
        _task.standardError = errorPipe
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self,
            selector: Selector("readCompleted:"),
            name: NSFileHandleReadCompletionNotification,
            object:nil)
        outPipe.fileHandleForReading.readInBackgroundAndNotify()
        
        nc.addObserver(self,
            selector: Selector("taskDidTerminated:"),
            name: NSTaskDidTerminateNotification,
            object:nil)
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
            println("=== task start ===")
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
        
        if notification.object! !== self._task.standardOutput.fileHandleForReading {
            return
        }
        
        let data: NSData? = notification.userInfo?[NSFileHandleNotificationDataItem] as? NSData
        if data?.length > 0 {
            /*
            let pattern = "\\[[0-9]+m"
            let replace = ""
            var text = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String ?? ""
            text = text.stringByReplacingOccurrencesOfString(pattern,
                withString: replace,
                options: NSStringCompareOptions.RegularExpressionSearch,
                range: text.rangeOfString(text))
            print(text)
            */
            if var text = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                print(text)
                if self.delegate != nil {
                    self.delegate.readCompleted(String(text))
                }
            }
            outPipe.fileHandleForReading.readInBackgroundAndNotify()
        }
    }
    
    func taskDidTerminated(notification: NSNotification) {
        println("=== taskDidTerminated ===")
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self, name: NSTaskDidTerminateNotification, object: nil)
        nc.removeObserver(self, name: NSFileHandleReadCompletionNotification, object: nil)
        _task = nil
    }

}
