//
//  MGGameEngine.swift
//  MyntraGame
//
//  Created by Bhabani on 10/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation


enum MGGameState {
    case FetchDataState
    case SettingUpState
    case ReadyState
    case ErrorState
}

class MGGameEngine {
    
    fileprivate var cardUrlArr: [String]?
    fileprivate let sequenceProvider = MGRandomSequenceNumberProvider(max: MGStatic.numberOfCardtoPlay)
    fileprivate var currentImageIndex: Int?
    fileprivate let leaderBoard = MGLeaderBoard()
    
    init(gameState:@escaping (_ state: MGGameState)->Void) {
        gameState(.FetchDataState)
        let _ = MGNetworkManager.sharedInstance.fetchCards { (cardUrls) in
            gameState(.SettingUpState)

            if cardUrls != nil{
                self.cardUrlArr = cardUrls
                self.currentImageUrl = self.nextImageUrl()
                gameState(.ReadyState)
            }else{
                gameState(.ErrorState)
            }
        }
    }
    
    
    var currentImageUrl: String?
    
    fileprivate func nextImageUrl() ->String?{
        var imageUrl: String?
        if let nextSequence = sequenceProvider.nextRandomSequence(), let cardUrl = cardUrlArr?[nextSequence]{
            currentImageIndex = nextSequence
            imageUrl = cardUrl
        }
        
        return imageUrl
    }
}

protocol MGGameEngineCardDataSource {
    func numberOfCards() -> Int
    func imageUrl(forCardIndex index: Int) -> String?
}

protocol MGGameEngineScoreDelegate {
    func userSelectedCard(index : Int, completion: (_ score: Int, _ nextUrl: String?,_ iscurrectGuess: Bool)->Void) -> Bool
    var currentImageUrl: String? { get }
}

//Game Card Data source
extension MGGameEngine: MGGameEngineCardDataSource{
    func numberOfCards() -> Int {
        return cardUrlArr?.count ?? 0
    }
    
    func imageUrl(forCardIndex index: Int) -> String? {
        var imageUrl: String?
        if ((index >= 0) && (index < numberOfCards())){
            imageUrl = cardUrlArr?[index]
        }
        return imageUrl
    }
}

//Game validator
extension MGGameEngine: MGGameEngineScoreDelegate{
    func userSelectedCard(index : Int, completion: (_ score: Int, _ nextUrl: String?, _ iscurrectGuess: Bool)->Void) -> Bool {
        if index ==  currentImageIndex{
            // Bingo user selected the corrcet image
            // update the score
            let score = leaderBoard.evaluateGame(action: "👍")
            currentImageUrl = nextImageUrl()
            completion(score, currentImageUrl, true)
            
            return true
        }else{
            // User selected rhe wrong one
            //update the score
            let score = leaderBoard.evaluateGame(action: "👎")
            completion(score, nil, false)
            
            return false
        }
    }
}
