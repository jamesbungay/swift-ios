//
//  ViewController.swift
//  l20 Match Game
//
//  Created by James Bungay on 13/07/2020.
//  Copyright © 2020 James Bungay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    let model = CardModel()
    var cards = [Card]()
    
    var prevFlippedCardIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cards = model.getCards()
        
        // Set the view controller as the datasource and delegate of the cardCollectionView:
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
    }
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        cell.configureCell(cardIn: cards[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        if cell != nil && !cell!.card!.isFlipped && !cell!.card!.isMatched {
            cell?.flip()
            if prevFlippedCardIndex == nil {  // First card to be flipped, no match check needed
                prevFlippedCardIndex = indexPath
            } else {
                checkForMatch(indexPath)
            }
        }
    }

    // MARK: Game logic methods
    // TODO: Move to CardModel class and call checkForMatch on a card object
    
    func checkForMatch(_ currFlippedCardIndex: IndexPath) {
        
        let cellOfPrevCard = cardCollectionView.cellForItem(at: prevFlippedCardIndex!) as? CardCollectionViewCell
        let cellOfCurrCard = cardCollectionView.cellForItem(at: currFlippedCardIndex) as? CardCollectionViewCell
        
        if cards[prevFlippedCardIndex!.row].imageName == cards[currFlippedCardIndex.row].imageName {
            // Match, mark as matched and remove cells of matched cards and reset prevFlippedCardIndex
            cards[prevFlippedCardIndex!.row].isMatched = true
            cards[currFlippedCardIndex.row].isMatched = true
            cellOfPrevCard?.remove()
            cellOfCurrCard?.remove()
        } else {
            // Not a match, flip cards back and reset prevFlippedCardIndex
            cellOfPrevCard?.flip(delayIn: 0.5, mustFlipDown: true)
            cellOfCurrCard?.flip(delayIn: 0.5, mustFlipDown: true)
            cards[prevFlippedCardIndex!.row].isFlipped = false
            cards[currFlippedCardIndex.row].isFlipped = false
        }
        prevFlippedCardIndex = nil
    }

}

