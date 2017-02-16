//
//  MGSequenceNumberProvider.swift
//  MyntraGame
//
//  Created by Bhabani on 10/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation

class MGRandomSequenceNumberProvider {
    private var numbers = [Int]()
 
    convenience init(max : Int){
        self.init()

        for i in 0..<max {
            self.numbers.append(i)
        }
    }
    
    func nextRandomSequence() -> Int? {
        var nextRandom: Int?
        if numbers.count > 0 {
            let arrayKey = Int(arc4random_uniform(UInt32(numbers.count)))
            nextRandom = numbers[arrayKey]
            numbers.remove(at: arrayKey)
        }
        
        return nextRandom
    }
}
