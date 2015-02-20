//
//  FTSActionMenu.swift
//  FrontendTaskSwitcher
//
//  Created by Ogasawara, Tsutomu | Oga | CWDD on 2/3/15.
//  Copyright (c) 2015 Rakuten Front-end. All rights reserved.
//

import Cocoa
import Foundation

class FTSActionMenu: NSMenu {

    var params : [String : AnyObject]!
    
    let items = [
        ["title": "Start",              "action": "start:",            "key": ""],
        ["title": "Open with Terminal", "action": "openWithTerminal:", "key": ""],
        ["title": "Open with Finder",   "action": "openWithFinder:",   "key": ""],
        ["separator": true],
        ["title": "Remove...",          "action": "remove",            "key": ""],
    ]

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(title aTitle: String) {
        super.init(title: aTitle)
    }
    
    init(params: [String: AnyObject]) {
        super.init()
        
        self.params = params
        self.initMenuItems()
    }
    
    private func initMenuItems() {
        for item in self.items {
            var menuItem : NSMenuItem!
            if ( item["separator"] == true ) {
                menuItem = NSMenuItem.separatorItem()
            }
            else {
                menuItem = NSMenuItem(title: item["title"] as String,
                    action: Selector(item["action"] as String),
                    keyEquivalent: item["key"] as String)
                menuItem.target = self
            }
            self.addItem(menuItem)
        }
    }
    
    func start(sender: AnyObject) {
        let dir = self.params["directory"] as String
        //self.executeCommand("cd " + dir + "; grunt serve;")
        self.runTask()
    }
    
    func openWithTerminal(sender: AnyObject) {
        let dir = self.params["directory"] as String
        self.executeCommand("open -a /Applications/Utilities/Terminal.app " + dir + ";")
    }
    
    func openWithFinder(sender: AnyObject) {
        let dir = self.params["directory"] as String
        self.executeCommand("open " + dir + ";")
    }
    
    func executeCommand(command: String) {
        autoreleasepool { () -> () in
            let task = NSTask()
            let pipe = NSPipe()
            
            task.launchPath = "/bin/sh"
            task.arguments = ["-c", command]
            task.standardOutput = pipe
            task.launch()
            
            let handle = pipe.fileHandleForReading
            let data = handle.readDataToEndOfFile()
            let result = NSString(data: data, encoding: NSUTF8StringEncoding)
        }
    }
    
    /*
    - (void)runTasfk {
    [[DSUnixTaskSubProcessManager sharedManager] setLoggingEnabled:TRUE];
    DSUnixTask *task = [DSUnixTaskSubProcessManager shellTask];
    [task setCommand:@"/bin/cat"];
    [task setStandardOutputHandler:^(DSUnixTask *task, NSString *output) {
    NSLog(@"%@", output);
    }];
    [task launch];
    [task writeStringToStandardInput:@"Hi!"];
    }
    */
    
    func runTask() {
        let task = DSUnixTaskSubProcessManager.shellTask()
        task.setCommand("/bin/cat")
        task.standardOutputHandler = {(task, output) in
            println("\(output)")
        }
        task.launch()
        task.writeStringToStandardInput("Hi!")
    }

}




