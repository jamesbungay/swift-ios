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
        // Reset the state of the cell by checking the flipped status of the card and showing the front or back imageView accordingly. Needed to prevent unexpected behaviour due to reuse of cells by the UICollectionView:
        if self.card!.isFlipped {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: .showHideTransitionViews, completion: nil)
        } else {
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: .showHideTransitionViews, completion: nil)
        }
    }
    
    func flip() {
        if !self.card!.isFlipped {
        UIView.transition(from: backImageView, to: frontImageView, duration: 3, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        } else {
        UIView.transition(from: frontImageView, to: backImageView, duration: 0.3, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        self.card!.isFlipped = !self.card!.isFlipped  // Invert isFlipped state of the card
    }
    
}
