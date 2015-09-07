//
//  Game.swift
//  The Hat
//
//  Created by Руслан Тхакохов on 05.08.15.
//  Copyright (c) 2015 Руслан Тхакохов. All rights reserved.
//

import Foundation

protocol GameDelegate {
    func gameIsFinished()
}

class Game {
    private let pairs: [Pair]
    private let hat: Hat
    
    private var roundNumber = 0
    
    var gameOver = false
    
    var delegate: GameDelegate?
    
    init(pairs: [Pair], numberOfWords: Int, dictionary: Dictionary) {
        self.pairs = pairs
        self.hat = Hat(dictionary: dictionary, size: numberOfWords)
    }
    
    func getCurrentPair() -> Pair {
        return pairs[(roundNumber % pairs.count)]
    }
    
    func getCurrentPlayer() -> String {
        let pair = getCurrentPair()
        let localRound = (roundNumber + 1) / pairs.count + Int(((roundNumber + 1) % pairs.count) > 0)
        return (localRound % 2 == 0) ? pair.playerA : pair.playerB
    }
    
    func finishTurn() {
        roundNumber++
        
        if getNumberOfWords() == 0 {
            delegate?.gameIsFinished()
        }
    }
    
    func getWord() -> Word? {
        if getNumberOfWords() == 0 {
            delegate?.gameIsFinished()
        }
        return hat.getWord()
    }
    
    func getNumberOfWords() -> Int {
        return hat.getSize()
    }
    
    func guessWord() {
        getCurrentPair().score++
    }
    
    func takeBackWord(word: Word) {
        hat.takeBackWord(word)
    }
    
    func getResults() -> [Pair] {
        return pairs
    }
    
    func hasMoreWords() -> Bool {
        return hat.hasMoreWords()
    }
    
}