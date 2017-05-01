//
//  SPItemsViewController.swift
//  SamsungPOC
//
//  Created by Bhabani on 24/04/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit
import AlamofireImage

final class SPItemsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    fileprivate let reuseIdentifier = "ItemCollectionCell"
    var imageItems: [SPItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        activityIndicator.startAnimating()
        SPNetworkEngine.loadItems {[weak self] (items) in
            self?.imageItems = items
            self?.imageCollectionView.reloadData()
            self?.activityIndicator.stopAnimating()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension SPItemsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageItems?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath)
        if let imageCell = cell as? SPItemCollectionViewCell,
            let url = URL(string: imageItems![indexPath.row].imageUrl){
            
            imageCell.itemImageView.af_setImage(withURL: url,
                                                placeholderImage: UIImage(named: "defaultSamsunglogo"),
                                                filter: nil)
        }
        
        return cell
    }
}

