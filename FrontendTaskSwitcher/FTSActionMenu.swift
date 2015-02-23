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
        FTSTask().start("cd " + dir + " && grunt serve")
    }
    
    func openWithTerminal(sender: AnyObject) {
        let dir = self.params["directory"] as String
        FTSTask().start("open -a /Applications/Utilities/Terminal.app " + dir + ";")
    }
    
    func openWithFinder(sender: AnyObject) {
        let dir = self.params["directory"] as String
        FTSTask().start("open " + dir + ";")
    }

}
