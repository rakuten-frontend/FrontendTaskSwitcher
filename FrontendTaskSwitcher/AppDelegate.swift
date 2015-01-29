//
//  AppDelegate.swift
//  FrontendTaskSwitcher
//
//  Created by Ogasawara, Tsutomu | Oga | CWDD on 1/29/15.
//  Copyright (c) 2015 Rakuten Front-end. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var taskMenu: NSMenu!
    var statusItem : NSStatusItem!

    private func setupMenu() {
        let systemStatusBar = NSStatusBar.systemStatusBar()
        //self.statusItem = systemStatusBar.statusItemWithLength(NSVariableStatusItemLength)
        self.statusItem = systemStatusBar.statusItemWithLength(-1)
        self.statusItem.highlightMode = true
        self.statusItem.title = "Tasks"
        self.statusItem.menu = self.taskMenu
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // setup menu
        self.setupMenu()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}
