//
//  SetCard.swift
//  Set game
//
//  Created by Michael Shulman on 12/4/17.
//  Copyright © 2017 com.hotmail.shulman.michael. All rights reserved.
//

import Foundation

struct SetCard: Equatable, CustomStringConvertible {
    static func ==(lhs: SetCard, rhs: SetCard) -> Bool {
        return (lhs.color == rhs.color &&
            lhs.shape == rhs.shape &&
            lhs.number == rhs.number &&
            lhs.shading == rhs.shading)
    }
    
    var description: String {
        return ("\(number) \(color) \(shading) \(shape) ")
    }
    
    let color: Color
    let shape: Shape
    let number: Number
    let shading: Shading
    
    enum Color: String, CustomStringConvertible {
        var description: String {
            return ("\(self.rawValue)")
        }
        
        case red = "red"
        case purple = "purple"
        case green = "green"
        
        static var all = [red, purple, green]
    }
    
    enum Shape: String, CustomStringConvertible {
        var description: String {
            return ("\(self.rawValue)")
        }
        case oval = "oval"
        case squiggle = "squiggle"
        case diamond = "diamond"
        
        static var all = [oval, squiggle, diamond]
    }
    
    enum Number: Int, CustomStringConvertible {
        var description: String {
            return ("\(self.rawValue)")
        }
        case one = 1
        case two = 2
        case three = 3
        
        static var all = [one, two, three]
    }
    
    enum Shading: String, CustomStringConvertible {
        var description: String {
            return ("\(self.rawValue)")
        }
        case solid = "solid"
        case striped = "striped"
        case outlined = "outlined"
        
        static var all = [solid, striped, outlined]
    }
}


