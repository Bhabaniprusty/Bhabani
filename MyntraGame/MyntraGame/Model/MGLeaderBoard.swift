//
//  MGLeaderBoard.swift
//  MyntraGame
//
//  Created by Bhabani on 10/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation

typealias evalFunc = (Int, Int)->Int

class MGLeaderBoard {
    
    enum MGGameAction {
        case Succeed(evalFunc)
        case Fail(evalFunc)
        case Reset
    }
    
    private var score = 0
    
    private var operation: Dictionary<String, MGGameAction> = [
        "👍" : MGGameAction.Succeed{$1 + $0},
        "👎" : MGGameAction.Fail{$1 - $0},
        "👊" : MGGameAction.Reset
    ]
    
    func evaluateGame(action: String)->Int {
        if let evaluation =  operation[action]{
            switch evaluation {
            case .Succeed(let funnction):
                score = funnction(1,score)
            case .Fail(let funnction):
                score =  funnction(1,score)
            case .Reset: score = 0
            }
        }
        return score
    }
}
