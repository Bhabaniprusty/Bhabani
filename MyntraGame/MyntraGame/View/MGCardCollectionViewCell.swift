//
//  MGCardCollectionViewCell.swift
//  MyntraGame
//
//  Created by Bhabani on 09/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit

class MGCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var frontImageView: UIImageView!
    @IBOutlet var backImageView: UIImageView!
    private var showingBack = true

    func flip() {
        if (showingBack) {
            UIView.transition(from: backImageView, to: frontImageView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
            showingBack = false
        } else {
            UIView.transition(from: frontImageView, to: backImageView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
            showingBack = true
        }
    }
    
    func close(){
        UIView.transition(from: frontImageView, to: backImageView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
        showingBack = true
    }
}
