//
//  SetGame.swift
//  Set game
//
//  Created by Michael Shulman on 12/4/17.
//  Copyright © 2017 com.hotmail.shulman.michael. All rights reserved.
//

import Foundation

struct SetGame {
    
    var cards = [SetCard]()
    var cardsInPlay = [SetCard]()
    var selectedCards = [SetCard]()
    var matchedSetCards = [SetCard]()
    var misMatchedSetCards = [SetCard]()
    var matchedSets = 0
    var score = 0
    var lastMessage = ""
    
    init() {
        for color in SetCard.Color.all {
            for shape in SetCard.Shape.all {
                for number in SetCard.Number.all {
                    for shading in SetCard.Shading.all {
                        let card = SetCard(color: color, shape: shape, number: number, shading: shading)
                        cards.append(card)
                    }
                }
            }
        }
        cards.shuffle()
        print ("there are \(cards.count) cards")
        
        print ("init done")
    }
    
    func tryToReturnASet() -> [SetCard]? {
        for first in 0..<cardsInPlay.count {
            for second in first+1..<cardsInPlay.count {
                for third in second+1..<cardsInPlay.count {
                    let tryCardSet = [cardsInPlay[first], cardsInPlay[second], cardsInPlay[third]]
                    if doCardsMakeASet(selectedCards: tryCardSet) {
                        return tryCardSet
                    }
                }
            }
        }
        return nil
    }
    
    mutating func drawOneCard() -> SetCard? {
        if cards.count == 0 {
            return nil
        } else {
            let card = cards.removeFirst()
            cardsInPlay.append(card)
            return card
        }
    }
    
    mutating func touchCard(card: SetCard) {
        misMatchedSetCards.removeAll()
        if selectedCards.count == 3 {
            selectedCards.removeAll()
        }
        
        if selectedCards.contains(card) {
            selectedCards.remove(at: selectedCards.index(of: card)!)
            score -= 1
            return
        }
        
        selectedCards.append(card)
        if selectedCards.count == 3 {
            if doCardsMakeASet (selectedCards: selectedCards) {
                matchedSets += 1
                matchedSetCards += selectedCards
                cardsInPlay = cardsInPlay.filter { !selectedCards.contains($0) }
                score += 3
            } else {
                misMatchedSetCards += selectedCards
                score -= 5
            }
        }
    }
    
    func doCardsMakeASet(selectedCards cards: [SetCard]) -> Bool {
        // look at each attribute. It must be all different or all the same
        // so, if you find 2 of any attribute, it's not a set
        
        var colors = [SetCard.Color: Bool]()
        var shapes = [SetCard.Shape: Bool]()
        var numbers = [SetCard.Number: Bool]()
        var shading = [SetCard.Shading: Bool]()
        
        for card in cards {
            colors[card.color] = true
            shapes[card.shape] = true
            numbers[card.number] = true
            shading[card.shading] = true
        }
        
//        lastMessage = ""
        if colors.count == 2 {
//            lastMessage = "Colors: \(colors.keysAsStringList())"
            return false
        }
        if shapes.count == 2 {
//            lastMessage = "Shapes: \(shapes.keysAsStringList())"
            return false
        }
        if numbers.count == 2 {
//            lastMessage = "Numbers: \(numbers.keysAsStringList())"
            return false
        }
        if shading.count == 2 {
//            lastMessage = "Shading: \(shading.keysAsStringList())"
            return false
        }
        return true
    }
}

extension Array {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Dictionary {
    func keysAsStringList() -> String {
        var keys = [String]()
        for key in self.keys {
            let s = "\(key)"
            keys.append(s)
        }
        return keys.joined(separator: ",")
    }
}


