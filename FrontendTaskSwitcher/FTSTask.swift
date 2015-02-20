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
    }
    
    func start(command: String) {
        self.task.setCommand(command)
        self.task.standardOutputHandler = { (task, output) in
            println(output)
        }
        self.task.launch()
    }
}
