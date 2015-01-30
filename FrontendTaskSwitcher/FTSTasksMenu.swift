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
        
        // observe
        FTSProjects.sharedInstance.addObserver(self,
            forKeyPath: "length", options: NSKeyValueObservingOptions.New, context: nil);
        
        // update
        self.updateProjects()
    }
    
    // MARK: -
    
    private func getDirectoryURL() -> NSURL! {
        // show file open dialog
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = false
        panel.allowsMultipleSelection = false
        let result = panel.runModal()
        return (result == NSOKButton) ? panel.directoryURL : nil;
    }

    private func getTaskConfigFilePathAndType(directory: NSURL) -> [String: String]! {
        let manager = NSFileManager.defaultManager()
        if ( directory.path != nil && directory.path?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 ) {
            let path = directory.path!+"/Gruntfile.js"
            if manager.fileExistsAtPath(path) {
                let name = directory.path?.pathComponents.last as String?
                return ["name": name ?? "", "path": path, "type": "grunt"]
            }
        }
        return nil
    }

    private func removeProjects() {
        // remove current menu items
        for item in self.itemArray as [NSMenuItem] {
            if ( item.separatorItem ) {
                break
            }
            else {
                self.removeItem(item)
            }
        }
    }
    
    private func updateProjects() {
        // remove projects
        self.removeProjects()
        // add projects
        if ( FTSProjects.sharedInstance.length > 0 ) {
            // add new menu items
            for (path, item) in FTSProjects.sharedInstance.data {
                self.insertItem(NSMenuItem(title: item["name"] as String, action: "", keyEquivalent: ""), atIndex: 0)
            }
        }
        else {
            self.insertItem(NSMenuItem(title: "No project", action: "", keyEquivalent: ""), atIndex: 0)
        }
    }
    
    // MARK: -
    
    /**
    *  MARK: Observe
    */
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if  keyPath == "length" {
            self.updateProjects()
        }
    }
    
    /**
     * MARK: Actions
     */
    @IBAction func addProject(sender: AnyObject) {
        let directoryURL = self.getDirectoryURL()
        if ( directoryURL != nil ) {
            let data = self.getTaskConfigFilePathAndType(directoryURL)
            if ( data != nil && data["path"] != nil ) {
                FTSProjects.sharedInstance.add(data["path"]!, project: data)
            }
        }
    }
    
}
