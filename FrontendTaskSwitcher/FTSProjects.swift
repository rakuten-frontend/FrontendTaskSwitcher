//
//  FTSProjects.swift
//  FrontendTaskSwitcher
//
//  Created by Ogasawara, Tsutomu | Oga | CWDD on 1/30/15.
//  Copyright (c) 2015 Rakuten Front-end. All rights reserved.
//

import Cocoa
import Foundation

class FTSProjects: NSObject {

    dynamic var length = 0 // for KVC
    var data : Dictionary<String, Dictionary<String, AnyObject>> = Dictionary()

    /**
    * Singleton
    * see https://github.com/hpique/SwiftSingleton
    */
    class var sharedInstance: FTSProjects {
        struct Singleton {
            static let instance : FTSProjects = FTSProjects()
        }
        return Singleton.instance
    }
    
    // MARK: -
    
    func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(self.data, forKey: "data")
        defaults.synchronize()
    }
    
    func load() {
        let defaults = NSUserDefaults.standardUserDefaults()
        var _data = defaults.objectForKey("data") as? Dictionary<String, Dictionary<String, AnyObject>>
        if ( _data != nil ) {
            self.data = _data!
            self.length = self.data.count
        }
    }

    /**
    * Adaptor functions
    */
    
    func count() -> Int {
        return self.data.count
    }
    
    subscript(path: String) -> Dictionary<String, Dictionary<String, String>> {
        get {
            return self.data[path] as Dictionary<String, Dictionary<String, String>>
        }
        set(item) {
            self.add(path, project: item)
        }
    }
    
    func add(path: String, project: Dictionary<String, AnyObject>) {
        if ( path.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 ) {
            self.data[path] = project
            self.length = self.data.count
        }
    }

    /*
    func setArray(otherArray: NSArray) {
        self.data.setArray(otherArray)
        self.length = self.data.count
    }
    
    func indexOfObjectPassingTest(predicate: ((AnyObject!, Int, UnsafeMutablePointer<ObjCBool>) -> Bool)!) -> Int {
        return self.data.indexOfObjectPassingTest(predicate)
    }
    
    func addObject(anObject: AnyObject!) {
        self.data.addObject(anObject)
        self.length = self.data.count
    }
    
    func objectAtIndex(index: Int) -> AnyObject! {
        return self.data.objectAtIndex(index)
    }
    
    func addObjectsFromArray(otherArray: [AnyObject]!) {
        if ( otherArray.count > 0 ) {
            self.data.addObjectsFromArray(otherArray)
            self.length = self.data.count
        }
    }
    
    func removeObjectAtIndex(index: Int) {
        self.data.removeObjectAtIndex(index)
        self.length = self.data.count
    }
    
    func removeAllObjects() {
        self.data.removeAllObjects()
        self.length = 0
    }
    */
}
