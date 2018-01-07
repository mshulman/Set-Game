//
//  Tableau.swift
//  Set Game
//
//  Created by Michael Shulman on 1/6/18.
//  Copyright © 2018 com.hotmail.shulman.michael. All rights reserved.
//
//  Container for `CardView`s

import UIKit

@IBDesignable
class Tableau: UIView {
    
    var grid = Grid(layout: Grid.Layout.aspectRatio(5/8))
    var cardViews = [CardView]() { didSet { layoutSubviews() }}

    override func awakeFromNib() {
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture))
        self.addGestureRecognizer(rotateGesture)
    }
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.gray
        grid.frame = bounds
        grid.cellCount = cardViews.count
        
        // remove all subviews
        for subView in subviews {
            subView.removeFromSuperview()
        }
    
        for cardViewIndex in cardViews.indices {
            let cardView = cardViews[cardViewIndex]
            cardView.frame = grid[cardViewIndex]!.zoom(by: 0.95)
            addSubview(cardViews[cardViewIndex])
        }
        
    }

    @objc func handleRotateGesture(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .began: break
        case .changed: cardViews.shuffle()
        case .ended: break
        default: break
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }

}

