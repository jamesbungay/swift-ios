//
//  CardModel.swift
//  l20 Match Game
//
//  Created by James Bungay on 13/07/2020.
//  Copyright © 2020 James Bungay. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        var generatedCards = [Card]()
        var seenN = [Int]()
        
        for _ in 1...8 {
            var r = 0
            repeat {
                r = Int.random(in: 1...13)
            } while seenN.contains(r)
            seenN.append(r)
            let c1 = Card()
            let c2 = Card()
            c1.imageName = "card\(r)"
            c2.imageName = "card\(r)"
            generatedCards += [c1, c2]
        }
        
        generatedCards.shuffle()
        return generatedCards
    }
}
