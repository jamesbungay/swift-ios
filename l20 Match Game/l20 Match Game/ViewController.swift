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
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cards = [Card]()
    
    var gameTimer: Timer?
    var msRem: Int = 60 * 1000
    
    var prevFlippedCardIndex: IndexPath?
    
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cards = model.getCards()
        
        // Set the view controller as the datasource and delegate of the cardCollectionView:
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        
        // Selector = Method to call when timer elapses; target = object to call said method on.
        // In this case, self = ViewController
        gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(gameTimer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Play shuffle card sound when the cards view first appears
        soundPlayer.playSound(effect: .shuffle)
    }
    
    // MARK: - Timer Methods
    
    @objc func timerFired() {
        msRem -= 10
        let secRem: Double? = Double(msRem)/1000
        timerLabel.text = String(format: "%.2f seconds remaining", secRem!)
        if msRem <= 0 {
            gameTimer?.invalidate()  // Stop timer from firing again
            timerLabel.textColor = UIColor.red
            checkForGameEnd()
        }
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
        if msRem > 0 && cell != nil && !cell!.card!.isFlipped && !cell!.card!.isMatched {
            cell?.flip()
            if prevFlippedCardIndex == nil {  // First card to be flipped, no match check needed
                prevFlippedCardIndex = indexPath
                soundPlayer.playSound(effect: .flip)
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
            soundPlayer.playSound(effect: .match)
            cards[prevFlippedCardIndex!.row].isMatched = true
            cards[currFlippedCardIndex.row].isMatched = true
            cellOfPrevCard?.remove()
            cellOfCurrCard?.remove()
            checkForGameEnd()
        } else {
            // Not a match, flip cards back and reset prevFlippedCardIndex
            soundPlayer.playSound(effect: .noMatch)
            cellOfPrevCard?.flip(delayIn: 0.5, mustFlipDown: true)
            cellOfCurrCard?.flip(delayIn: 0.5, mustFlipDown: true)
            cards[prevFlippedCardIndex!.row].isFlipped = false
            cards[currFlippedCardIndex.row].isFlipped = false
        }
        prevFlippedCardIndex = nil
    }
    
    func checkForGameEnd() {
        var hasWon = true
        for c in cards {
            if !c.isMatched {
                hasWon = false
                break
            }
        }
        if hasWon {
            gameTimer?.invalidate()
            showAlert(titleIn: "Congratulations!", msgIn: "You have won!")
        } else if msRem <= 0 {
            flipAllCardsUp()
            showAlert(titleIn: "Bad luck!", msgIn: "You ran out of time.")
        }
    }
    
    func showAlert(titleIn:String, msgIn:String) {
        let alert = UIAlertController(title: titleIn, message: msgIn, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertOkAction)
        present(alert, animated: true, completion: nil)
    }
    
    func flipAllCardsUp() {
        for c in cardCollectionView.visibleCells as! [CardCollectionViewCell] {
            UIView.transition(from: c.backImageView, to: c.frontImageView, duration: 0.3, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
            c.card!.isFlipped = true
        }
        for c in cards {
            c.isFlipped = true
        }
    }

}

