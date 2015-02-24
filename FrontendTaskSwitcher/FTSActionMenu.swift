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
}

class FTSActionMenu: NSMenu, NSMenuDelegate {

    var params : [String : AnyObject]!
    var task : FTSTask!
    
    let items = [
        ["title": "Start",              "action": "start:",            "key": "", "tag": MenuItem.Start.rawValue],
        ["title": "Stop",               "action": "stop:",             "key": "", "tag": MenuItem.Stop.rawValue],
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
        
        self.delegate = self
        self.params = params
        self.initMenuItems()
        
        let dir = params["directory"] as String
        self.task = FTSTask(currentDirectory: dir)
    }
    
    private func initMenuItems() {
        for item in self.items {
            var menuItem : NSMenuItem!
            if ( item["separator"] as? Bool == true ) {
                menuItem = NSMenuItem.separatorItem()
            }
            else {
                menuItem = NSMenuItem(title: item["title"] as String,
                    action: Selector(item["action"] as String),
                    keyEquivalent: item["key"] as String)
                menuItem.target = self
                menuItem.tag = item["tag"] as? Int ?? 0
            }
            self.addItem(menuItem)
        }
    }
    
    func start(sender: AnyObject) {
        let dir = self.params["directory"] as String
        self.task.start("grunt serve")
    }
    
    func stop(sender: AnyObject) {
        self.task.interrupt()
    }
    
    func openWithTerminal(sender: AnyObject) {
        let dir = self.params["directory"] as String
        self.task.start("open -a /Applications/Utilities/Terminal.app " + dir + ";")
    }
    
    func openWithFinder(sender: AnyObject) {
        let dir = self.params["directory"] as String
        self.task.start("open " + dir + ";")
    }
    
    // MARK: - menu delegate
    
    func menuWillOpen(menu: NSMenu) {
        if ( self.task.isRunning() ) {
            menu.itemWithTag(MenuItem.Start.rawValue)?.hidden = true
            menu.itemWithTag(MenuItem.Stop.rawValue)?.hidden = false
        }
        else {
            menu.itemWithTag(MenuItem.Start.rawValue)?.hidden = false
            menu.itemWithTag(MenuItem.Stop.rawValue)?.hidden = true
        }
    }
}
