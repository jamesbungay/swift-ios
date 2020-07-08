//
//  ViewController.swift
//  l4 War Card Game
//
//  Created by James Bungay on 07/07/2020.
//  Copyright © 2020 James Bungay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftScoreLabel: UILabel!
    @IBOutlet weak var rightScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func dealButtonTapped(_ sender: Any) {
        
        var leftNum:Int
        var rightNum:Int
        
        repeat {
            leftNum = Int.random(in: 2...14)
            rightNum = Int.random(in: 2...14)
        } while leftNum == rightNum
        
        leftImageView.image = UIImage(named: "card\(leftNum)")
        rightImageView.image = UIImage(named: "card\(rightNum)")
    }
    
    
}

