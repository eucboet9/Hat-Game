//
//  Word.swift
//  
//
//  Created by Руслан Тхакохов on 26.07.15.
//
//

import Foundation
import CoreData

@objc(Word)
class Word: NSManagedObject {

    @NSManaged var word: String
}
