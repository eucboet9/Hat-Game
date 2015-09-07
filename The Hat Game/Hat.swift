//
//  Hat.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 05.08.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import Foundation

class Hat {
    private var words = [Word]()
    private var size: Int
    
    init(dictionary: Dictionary, size: Int) {
        assert(dictionary.words.count >= size, "hat's size should be <= than dict's size")
        
        var words = [Word]()
        for word in dictionary.words {
            words.append(word as! Word)
        }
        
        self.size = size
        for var i = 0; i < size; i++ {
            let ind = Int(arc4random()) % words.count
            self.words.append(words[ind])
            words.removeAtIndex(ind)
        }
    }
    
    func getWord() -> Word? {
        if size > 0 {
            let ind = Int(arc4random()) % size
            let word = words[ind]
            words.removeAtIndex(ind)
            size--
            return word
        } else {
            return nil
        }
    }
    
    func takeBackWord(word: Word) {
        words.append(word)
        size++
    }
    
    func getSize() -> Int {
        return size
    }
    
    func hasMoreWords() -> Bool {
        return size > 0
    }
}