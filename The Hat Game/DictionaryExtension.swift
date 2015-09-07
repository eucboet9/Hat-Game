//
//  DictionaryExtension.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 04.08.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Dictionary {
    static func findObjectById(id: Int16) -> Dictionary? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Dictionary")
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(short: id))
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [Dictionary]
        
        if let results = fetchedResults {
            return results.first
        } else {
            println(error)
            return nil
        }
    }
    
    static func addDictionary(id: NSNumber, name: String, language: String, difficulty: NSNumber, custom: Bool) -> Dictionary {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        if let instance = Dictionary.findObjectById(Int16(id.integerValue)) {
            managedContext.deleteObject(instance)
        }
        
        let dictionary = NSEntityDescription.insertNewObjectForEntityForName("Dictionary", inManagedObjectContext: managedContext) as! Dictionary
        dictionary.id = id
        dictionary.name = name
        dictionary.language = language
        dictionary.difficulty = difficulty
        dictionary.custom = custom
        
        if managedContext.save(nil) == false {
            println("Failed to save changes in MOC")
        }
    
        return dictionary
    }
    
    func addWord(word: Word) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let relationship = mutableSetValueForKey("words")
        relationship.addObject(word)
        
        managedContext.save(nil)
    }
    
    static func countDicts() -> Int? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Dictionary")
        fetchRequest.includesSubentities = false
        var error: NSError?
        
        let number = managedContext.countForFetchRequest(fetchRequest, error: &error)
        
        if error == nil {
            return number;
        } else {
            println(error)
            return nil
        }
    }
}