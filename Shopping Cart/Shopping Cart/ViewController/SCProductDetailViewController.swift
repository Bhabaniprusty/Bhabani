//
//  SCProductDetailViewController.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit

class SCProductDetailViewController: UIViewController {
    
    @IBOutlet weak var addtoCartButton: UIButton!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var catalogImageView: UIImageView!
    
    var catalog: ProductCatalog? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let catalog = catalog {
            addtoCartButton.isHidden = false
            detailDescriptionLabel.text = catalog.productDescription
            title = catalog.productName
            
            if let imageUrl = catalog.productImageUrl, let url =  URL(string: imageUrl){
                
                catalogImageView.sd_setImage(with: url, placeholderImage: nil)
            }
        }else{
            addtoCartButton.isHidden = true
        }
    }
    
    @IBAction func AddToCart(_ sender: UIButton) {
        if let catalog = catalog {
            SCDBManager.sharedInstance.addToCart(product: catalog, quantity: 1)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
