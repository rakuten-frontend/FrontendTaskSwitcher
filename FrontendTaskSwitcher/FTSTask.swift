//
//  FTSTask.swift
//  FrontendTaskSwitcher
//
//  Created by Ogasawara, Tsutomu | Oga | CWDD on 2/20/15.
//  Copyright (c) 2015 Rakuten Front-end. All rights reserved.
//

import Cocoa

class FTSTask: NSObject {

    var task : DSUnixTask!
    
    override init() {
        super.init()
        self.task = DSUnixTaskSubProcessManager.shellTask()
        self.task.environment = ["PATH": "/bin:/usr/bin:/usr/local/bin"]
    }
    
    func start(command: String,
        outputHandler: (String!) -> Void = { (output) in },
        errorHandler: (String!) -> Void = { (output) in } ) {
        self.task.setCommand(command)
        self.task.standardOutputHandler = { (task, output) in
            println(output)
            outputHandler(output)
        }
        self.task.standardErrorHandler = { (task, output) in
            println(output)
            errorHandler(output)
        }
        self.task.launch()
    }
}
