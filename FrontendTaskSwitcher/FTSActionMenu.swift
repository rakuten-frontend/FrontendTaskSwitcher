//
//  FTSActionMenu.swift
//  FrontendTaskSwitcher
//
//  Created by Ogasawara, Tsutomu | Oga | CWDD on 2/3/15.
//  Copyright (c) 2015 Rakuten Front-end. All rights reserved.
//

import Cocoa
import Foundation

enum MenuItem : Int {
    case Start = 1
    case Stop
    case Remove
}

class FTSActionMenu: NSMenu, NSMenuDelegate {

    var params : [String : AnyObject]!
    var task : FTSTask!
    var logWindow : NSWindowController!
    
    let items = [
        ["title": "Start (grunt serve)", "action": "start:",            "key": "", "tag": MenuItem.Start.rawValue],
        ["title": "Stop",                "action": "stop:",             "key": "", "tag": MenuItem.Stop.rawValue],
        ["separator": true],
        ["title": "Open with Terminal",  "action": "openWithTerminal:", "key": ""],
        ["title": "Open with Finder",    "action": "openWithFinder:",   "key": ""],
        ["title": "Show Log",            "action": "showLog:",          "key": ""],
        ["separator": true],
        ["title": "Remove...",           "action": "remove:",           "key": "", "tag": MenuItem.Remove.rawValue],
    ]

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(title aTitle: String) {
        super.init(title: aTitle)
    }
    
    init(params: [String: AnyObject]) {
        super.init()
        
        self.delegate = self
        self.params = params
        self.autoenablesItems = false
        self.initMenuItems()
        self.task = FTSTask()
    }
    
    private func initMenuItems() {
        for item in self.items {
            var menuItem : NSMenuItem!
            if ( item["separator"] as? Bool == true ) {
                menuItem = NSMenuItem.separatorItem()
            }
            else {
                menuItem = NSMenuItem(title: item["title"] as! String,
                    action: Selector(item["action"] as! String),
                    keyEquivalent: item["key"] as! String)
                menuItem.target = self
                if let tag = item["tag"] as? Int {
                    menuItem.tag = tag
                }
            }
            self.addItem(menuItem)
        }
    }
    
    func start(sender: AnyObject) {
        let dir = self.params["directory"] as! String
        self.task.start("grunt --no-color serve | tee .log", currentDirectory: dir)
    }
    
    func stop(sender: AnyObject) {
        self.task.interrupt()
    }
    
    func openWithTerminal(sender: AnyObject) {
        let dir = self.params["directory"] as! String
        self.task.start("open -a /Applications/Utilities/Terminal.app " + dir + ";")
    }
    
    func openWithFinder(sender: AnyObject) {
        let dir = self.params["directory"] as! String
        self.task.start("open " + dir + ";")
    }
    
    func remove(sender: AnyObject) {
        let alert = NSAlert()
        alert.alertStyle = NSAlertStyle.InformationalAlertStyle
        alert.informativeText = NSLocalizedString("Confirmation", comment: "")
        alert.messageText = NSLocalizedString("Do you want to remove the task?",
            comment: "Message of confirmation Dialog")
        alert.addButtonWithTitle("Cancel")
        alert.addButtonWithTitle("Remove")
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)
        let result = alert.runModal()
        if ( result == NSAlertSecondButtonReturn ) {
            // remove
            self.removeProject()
        }
    }
    
    func showLog(sender: AnyObject) {
        if ( self.logWindow == nil ) {
            let logFilePath = self.params["directory"] as! String + "/.log"
            self.logWindow = LogWindowController(windowNibName: "LogWindow", logFilePath: logFilePath)
            let title = self.params["name"] as! String
            self.logWindow.window?.title = "Log - " + title
            self.logWindow.showWindow(self)
        }
        NSApp.activateIgnoringOtherApps(true)
    }
    
    // MARK: - 
    
    func removeProject() {
        // stop task
        if self.task.isRunning() {
            self.stop(self)
        }
        // remove project
        let path = self.params["path"] as! String
        FTSProjects.sharedInstance.removeValueForKey(path)
    }
    
    // MARK: - menu delegate
    
    func menuWillOpen(menu: NSMenu) {
        if ( self.task.isRunning() ) {
            menu.itemWithTag(MenuItem.Start.rawValue)?.hidden = true
            menu.itemWithTag(MenuItem.Stop.rawValue)?.hidden = false
            menu.itemWithTag(MenuItem.Remove.rawValue)?.enabled = false
        }
        else {
            menu.itemWithTag(MenuItem.Start.rawValue)?.hidden = false
            menu.itemWithTag(MenuItem.Stop.rawValue)?.hidden = true
            menu.itemWithTag(MenuItem.Remove.rawValue)?.enabled = true
        }
    }
}
