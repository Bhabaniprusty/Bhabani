//
//  SCProductDetailViewController.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit

class SCProductDetailViewController: SCDetailViewController {
    
    @IBOutlet weak var addtoCartButton: UIButton!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var catalogImageView: UIImageView!
    @IBOutlet weak var removeFromCartButton: UIButton!
    @IBOutlet weak var itemsCoutInCartLabel: UILabel!
    @IBOutlet weak var itemsStockLabel: UILabel!
    
    override var catalog: ProductCatalog? {
        willSet{
            catalog?.removeObserver(self, forKeyPath: "cart.quantity")
            catalog?.removeObserver(self, forKeyPath: "storage.availableQuantity")
            newValue?.addObserver(self, forKeyPath: "cart.quantity", options: .new, context: nil)
            newValue?.addObserver(self, forKeyPath: "storage.availableQuantity", options: .new, context: nil)
        }
        didSet {
            detailContentAvailable = (catalog != nil)
            configureView()
        }
    }
    
    private func configureView() {
        if let catalog = catalog {
            addtoCartButton?.isHidden = false
            detailDescriptionLabel?.text = catalog.productDescription
            title = catalog.productName
            
            itemsCoutInCartLabel?.text = String(catalog.cart?.quantity ?? 0)
            itemsStockLabel?.text = String(catalog.storage?.availableQuantity ?? 0)
            
            if let imageUrl = catalog.productImageUrl, let url =  URL(string: imageUrl) {
                catalogImageView?.sd_setImage(with: url, placeholderImage: nil)
            }
        }else {
            addtoCartButton?.isHidden = true
        }
    }
    
    @IBAction func AddToCart(_ sender: UIButton) {
        if let productId = catalog?.productId {
            SCDBManager.sharedInstance.addToCart(productId: productId, quantity: 1)
        }
    }
    
    @IBAction func removeFromCart(_ sender: UIButton) {
        if let productId = catalog?.productId {
            SCDBManager.sharedInstance.removeFromCart(productId: productId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "cart.quantity"{
            itemsCoutInCartLabel?.text = String(change?[NSKeyValueChangeKey.newKey] as? Double ?? 0)

        }else if keyPath == "storage.availableQuantity"{
            itemsStockLabel?.text = String(change?[NSKeyValueChangeKey.newKey] as? Double ?? 0)
        }
    }
    
    deinit {
        catalog?.removeObserver(self, forKeyPath: "cart.quantity")
        catalog?.removeObserver(self, forKeyPath: "storage.availableQuantity")
    }
}
