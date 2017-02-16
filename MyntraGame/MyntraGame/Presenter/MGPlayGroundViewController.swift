//
//  MGPlayGroundViewController.swift
//  MyntraGame
//
//  Created by Bhabani on 09/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit
import SDWebImage

class MGPlayGroundViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var randomImageView: UIImageView!
    fileprivate var gameEngine: MGGameEngineCardDataSource & MGGameEngineScoreDelegate?
    fileprivate let itemsPerRow: CGFloat = 3.0
    private var initialScore = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load network, wait till all images downloaded
        startGame()
    }
    
    private func startGame(){
        scoreLabel.text = "\(initialScore)"
        activityIndicator.startAnimating()
        gameEngine = MGGameEngine(gameState: { (state) in
            switch state{
            case .FetchDataState: break
            case .SettingUpState: break
            case .ReadyState:
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    
                    self.collectionView.isUserInteractionEnabled = false
                    self.collectionView.reloadData()
                    self.collectionView.layoutIfNeeded()
                    
                    self.flipAll(timer: nil)
                    Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(MGPlayGroundViewController.flipAll), userInfo: nil, repeats: false)
                }
                
            case .ErrorState: break
            }
        })
    }
    
    @IBAction func resetGame(_ sender: Any) {
        randomImageView.image = nil
        flipAllAround(timer: nil, hide: true)
        startGame()
    }
    func flipAllAround(timer : Timer?, hide: Bool) {
        DispatchQueue.main.async {
            for cell in self.collectionView.visibleCells{
                if let cardCell = cell as? MGCardCollectionViewCell{
                    if hide{
                        cardCell.close()
                    }else{
                        cardCell.flip()
                    }
                }
                
                if (timer != nil){
                    self.collectionView.isUserInteractionEnabled = true
                    self.showCard(withUrl: self.gameEngine?.currentImageUrl)
                }
            }
        }
    }
    
    func flipAll(timer : Timer?) {
        flipAllAround(timer: timer, hide: false)
    }
    
    func showCard(withUrl url: String?) {
        if let urlString = url, let imageUrl =  URL(string: urlString){
            
            UIView.animate(withDuration: 1.0,
                           animations: {
                            self.randomImageView.alpha = 0.0 },
                           completion: { (completed) in
                            UIView.animate(withDuration: 1.0,
                                           animations: {
                                            self.randomImageView.alpha = 1.0;
                                            self.randomImageView.sd_setImageWithPreviousCachedImage(with: imageUrl, placeholderImage: nil, options: [], progress: nil, completed: nil)},
                                           completion: nil)})
        }
    }
    
}


// MARK: - UICollectionViewDataSource
extension MGPlayGroundViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return gameEngine?.numberOfCards() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Game Card",
                                                      for: indexPath)
        if let cardCell = cell as? MGCardCollectionViewCell{
            
            if let nextUrl = gameEngine?.imageUrl(forCardIndex: indexPath.row),
                let imageUrl =  URL(string: nextUrl){
                cardCell.frontImageView.sd_setImageWithPreviousCachedImage(with: imageUrl, placeholderImage: nil, options: [], progress: nil, completed: nil)
            }
        }
        
        return cell
    }
}

extension MGPlayGroundViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool{
        return gameEngine?.userSelectedCard(index: indexPath.row, completion: { (score, nextImageUrl, isCorrectGuess) in
            // update the score
            scoreLabel.text = "\(score)"
            self.showCard(withUrl: nextImageUrl)
            if ((nextImageUrl == nil) && isCorrectGuess){
                let alertController = UIAlertController(title: "Hooray!", message: "Congrats! Completed the game", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                //Delay the sucess message
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.present(alertController, animated: true, completion: nil)
                }

            }
        }) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if let cardCell = collectionView.cellForItem(at: indexPath) as? MGCardCollectionViewCell{
            cardCell.flip()
        }
    }
}

extension MGPlayGroundViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = min(collectionView.frame.size.width, collectionView.frame.size.height)
        let height = min(collectionView.frame.size.width, collectionView.frame.size.height)
        return CGSize(width: width/itemsPerRow -  (itemsPerRow-1)*10, height: height/itemsPerRow -  (itemsPerRow-1)*10)
    }
}
