//
//  ViewController.swift
//  Set game
//
//  Created by Michael Shulman on 12/4/17.
//  Copyright © 2017 com.hotmail.shulman.michael. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    var game = SetGame()
    var hints = [SetCard]()
    var gameBoard = [CardView: SetCard]()
    var matchedCardsOnBoard = false

    @IBOutlet weak var tableau: Tableau!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dealSomeCards()
        updateUI()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        gameBoard.removeAll()
        startGame()
        updateUI()
    }
    
    @IBAction func swipeToDeal3Cards(_ sender: UISwipeGestureRecognizer) {
        dealSomeCards()
        updateUI()
    }
    @IBOutlet weak var deal3CardsButton: UIButton!
    @IBAction func deal3CardsButton(_ sender: UIButton) {
        dealSomeCards()
        updateUI()
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cheatButton: UIButton!
    
    @IBAction func cheat(_ sender: UIButton) {
        if game.cards.count == 0 {
            removeMatchedCardsFromBoardsIfAny()
        }
        if hints.count > 0 {        // already asked for a hint
            game.touchCard(card: hints.removeFirst())
            updateUI()
        } else if let set = game.tryToReturnASet() {
            hints = set
            game.touchCard(card: hints.removeFirst())
            updateUI()
        }
    }
    
    func removeMatchedCardsFromBoardsIfAny() {
        // remove any matched cards from tableau
        if matchedCardsOnBoard {
            for (cardView, card) in gameBoard {
                if game.matchedSetCards.contains(card) {
                    tableau.cardViews = tableau.cardViews.filter { $0 != cardView}
                    gameBoard.removeValue(forKey: cardView)
                }
            }
        }
    }
    
    
    func dealSomeCards() {
        removeMatchedCardsFromBoardsIfAny()
        let numberOfCardsToDeal = max(3, 12 - tableau.cardViews.count)
        
        for _ in 1...numberOfCardsToDeal {
            if let card = game.drawOneCard() {
                let cardView = makeCardView(fromCard: card)
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))
                cardView.addGestureRecognizer(tap)
                gameBoard[cardView] = card
                tableau.cardViews.append(cardView)
            }
        }
    }
    
    @objc func handleCardTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let cardView = sender.view as! CardView
            if let setCard = gameBoard[cardView] {
                game.touchCard(card: setCard)
            }
            hints.removeAll()   // hints no longer valid
            updateUI()
        }
    }
    
    func makeCardView(fromCard card: SetCard) -> CardView {
        let cardView = CardView()
        
        switch card.shape {
        case .squiggle: cardView.shape = .squiggle
        case .oval: cardView.shape = .oval
        case .diamond: cardView.shape = .diamond
        }
        
        switch card.shading {
        case .outlined: cardView.shading = .outlined
        case .solid: cardView.shading = .solid
        case .striped: cardView.shading = .striped
        }
        
        cardView.count = card.number.rawValue
        
        switch card.color {
        case .red: cardView.color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        case .purple: cardView.color = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        case .green: cardView.color = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        return cardView
    }
    
    func startGame() {
        dealSomeCards()
    }
    

    
    func setBorderColor(button: UIView, color: UIColor) {
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 4.0
    }
    
    func clearBorder(button: UIView) {
        button.layer.borderWidth = 0
        button.layer.borderColor = nil
    }
    
    func updateUI() {
        matchedCardsOnBoard = false
        for (cardView, card) in gameBoard {
            cardView.selected = game.selectedCards.contains(card)
            cardView.misMatched = game.misMatchedSetCards.contains(card)
            
            if game.matchedSetCards.contains(card) {
                cardView.matched = true
                matchedCardsOnBoard = true
            }
        }
        
        scoreLabel.text = "Score: \(game.score) Matches: \(game.matchedSets) "
        
        cheatButton.isHidden = (game.tryToReturnASet() == nil)
        //print ("\(game.cards.count) remaining in deck")
        
        if game.cards.count == 0 {
            deal3CardsButton.isHidden = true
        }
        
    }
}

