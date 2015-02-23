//
//  FTSTask.swift
//  FrontendTaskSwitcher
//
//  Created by Ogasawara, Tsutomu | Oga | CWDD on 2/20/15.
//  Copyright (c) 2015 Rakuten Front-end. All rights reserved.
//

import Cocoa

class FTSTask: NSObject {

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
}
