//
//  WordExtension.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 04.08.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Word {
    static func addWord(word: String) -> Word? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Word", inManagedObjectContext: managedContext) as! Word
        entity.word = word
        
        if managedContext.save(nil) {
            return entity
        } else {
            return nil
        }
    }
}