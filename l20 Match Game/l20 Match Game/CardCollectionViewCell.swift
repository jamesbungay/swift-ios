//
//  CardCollectionViewCell.swift
//  l20 Match Game
//
//  Created by James Bungay on 14/07/2020.
//  Copyright © 2020 James Bungay. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    
    func configureCell(cardIn: Card) {
        self.card = cardIn
        frontImageView.image = UIImage(named: self.card!.imageName)
        
        // Reset the state of the cell by checking the matched status, and setting card alpha accordingly:
        if self.card!.isMatched {
            self.backImageView.alpha = 0
            self.frontImageView.alpha = 0
            return
        } else {
            self.backImageView.alpha = 1
            self.frontImageView.alpha = 1
        }
        
        // Reset the state of the cell by checking the flipped status of the card and showing the front or back imageView accordingly. Needed to prevent unexpected behaviour due to reuse of cells by the UICollectionView:
        if self.card!.isFlipped {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: .showHideTransitionViews, completion: nil)
        } else {
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: .showHideTransitionViews, completion: nil)
        }
    }
    
    func flip(durationIn:TimeInterval = 0.3, delayIn:TimeInterval = 0, mustFlipDown:Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayIn, execute: {
            if mustFlipDown {
                UIView.transition(from: self.frontImageView, to: self.backImageView, duration: durationIn, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
                self.card!.isFlipped = false
            } else {
                if !self.card!.isFlipped {
                    UIView.transition(from: self.backImageView, to: self.frontImageView, duration: durationIn, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
                } else {
                    UIView.transition(from: self.frontImageView, to: self.backImageView, duration: durationIn, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
                }
                self.card!.isFlipped = !self.card!.isFlipped  // Invert isFlipped state of the card
            }
        })
    }
    
    func remove() {  // Remove card from view, for use when card is matched
        self.backImageView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveLinear, animations: {self.frontImageView.alpha = 0}, completion: nil)
    }
    
}
