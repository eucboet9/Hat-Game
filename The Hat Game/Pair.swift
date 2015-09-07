//
//  Pair.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 05.08.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import Foundation

class Pair: Printable {
    let playerA: String
    let playerB: String
    var score = 0 {
        didSet {
            println("\(self)")
        }
    }
    
    init(playerA: String, playerB: String) {
        self.playerA = playerA
        self.playerB = playerB
    }
    
    var description: String {
        return (score == 0) ? "\(playerA), \(playerB)" : "\(playerA), \(playerB) - \(score)"
    }
}