//
//  FTSAboutWindow.swift
//  FrontendTaskSwitcher
//
//  Created by ogaoga on 2015/03/10.
//  Copyright (c) 2015年 Rakuten Front-end. All rights reserved.
//

import Cocoa

class FTSAboutWindow: NSWindow {

    @IBAction func pressURL(sender: AnyObject) {
        let button = sender as? NSButton
        if let urlString = button?.title {
            NSWorkspace.sharedWorkspace().openURL(NSURL(string: urlString)!)
        }
        self.close()
    }
}
