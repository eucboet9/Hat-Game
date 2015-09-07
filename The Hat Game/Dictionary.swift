//
//  Dictionary.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 04.08.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import Foundation
import CoreData

@objc(Dictionary)
class Dictionary: NSManagedObject {

    @NSManaged var custom: NSNumber
    @NSManaged var difficulty: NSNumber
    @NSManaged var language: String
    @NSManaged var name: String
    @NSManaged var id: NSNumber
    @NSManaged var words: NSSet
}
