//
//  SoundManager.swift
//  l20 Match Game
//
//  Created by James Bungay on 22/07/2020.
//  Copyright © 2020 James Bungay. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum GameSoundEffect {
        case flip
        case match
        case noMatch
        case shuffle
    }
    
    func playSound(effect:GameSoundEffect) {
        
        var soundFilename = ""
        switch effect {
            case .flip:
                soundFilename = "cardflip"
                break
            case .match:
                soundFilename = "dingcorrect"
                break
            case .noMatch:
                soundFilename = "dingwrong"
                break
            case .shuffle:
                soundFilename = "shuffle"
        }
        
        // Get the path to the specified sound resource
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
        
        // Exit function if no valid file path
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            return  // Exit function if initialisation of audioPlayer failed
        }
    }
    
}
