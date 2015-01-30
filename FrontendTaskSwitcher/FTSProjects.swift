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
    var data : [Dictionary<String, AnyObject>] = []

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

    /**
    * Adaptor functions
    */
    
    func count() -> Int {
        return self.data.count
    }
    
    func append(project: [String: AnyObject]) {
        var alreadyExist = false
        for item in self.data {
            if ( item["path"] as String == project["path"] as String ) {
                alreadyExist = true
                break
            }
        }
        if ( !alreadyExist ) {
            self.data.append(project)
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
