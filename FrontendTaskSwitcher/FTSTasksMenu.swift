//
//  FTSTasksMenu.swift
//  FrontendTaskSwitcher
//
//  Created by Ogasawara, Tsutomu | Oga | CWDD on 1/29/15.
//  Copyright (c) 2015 Rakuten Front-end. All rights reserved.
//

import Cocoa

class FTSTasksMenu: NSMenu {

    var statusItem : NSStatusItem!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // setup
        let systemStatusBar = NSStatusBar.systemStatusBar()
        let length : CGFloat = -1.0 // instead of NSVariableStatusItemLength
        self.statusItem = systemStatusBar.statusItemWithLength(length)
        self.statusItem.highlightMode = true
        self.statusItem.title = "Tasks"
        self.statusItem.menu = self
    }

    func getDirectoryURL() -> NSURL! {
        // show file open dialog
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = false
        panel.allowsMultipleSelection = false
        let result = panel.runModal()
        return (result == NSOKButton) ? panel.directoryURL : nil;
    }
    
    @IBAction func addProject(sender: AnyObject) {
        let directoryURL = self.getDirectoryURL()
        if ( directoryURL != nil ) {
            println(directoryURL)
        }
    }
    
}
