//
//  FTSLogWindowController.swift
//  FrontendTaskSwitcher
//
//  Created by Ogasawara, Tsutomu | Oga | CWDD on 3/9/15.
//  Copyright (c) 2015 Rakuten Front-end. All rights reserved.
//

import Cocoa

class FTSLogWindowController: NSWindowController {

    var logFilePath : String!

    @IBOutlet var logTextView: NSTextView!
    
    convenience init(windowNibName: String, logFilePath: NSString) {
        self.init(windowNibName: windowNibName)
        self.logFilePath = logFilePath as! String
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        // show log file text
        self.loadLogFile()
    }

    func loadLogFile() {
        if self.logFilePath != nil {
            var error : NSError?
            if let text = String(contentsOfFile: self.logFilePath, encoding: NSUTF8StringEncoding, error: &error) {
                self.appendText(text)
            }
        }
    }

    func appendText(text: String) {
        self.logTextView.textStorage?.beginEditing()
        let attributedString = NSAttributedString(string: text)
        self.logTextView.textStorage?.appendAttributedString(attributedString)
        self.logTextView.textStorage?.endEditing()
        self.logTextView.autoscroll(NSEvent())
    }
}
