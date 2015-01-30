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

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        FTSProjects.sharedInstance.load()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        FTSProjects.sharedInstance.save()
    }
}
