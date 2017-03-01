//
//  SCProductDetailViewController.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit

class SCProductDetailViewController: SCDetailViewController {
    
    private struct Static {
        static let cartQuantityKeyPathIdentifier = "cart.quantity"
        static let availableQuantityKeyPathIdentifier = "storage.availableQuantity"
    }

    
    @IBOutlet weak var addtoCartButton: UIButton!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var catalogImageView: UIImageView!
    @IBOutlet weak var removeFromCartButton: UIButton!
    @IBOutlet weak var itemsCoutInCartLabel: UILabel!
    @IBOutlet weak var itemsStockLabel: UILabel!
    @IBOutlet weak var inCartTextLabel: UILabel!
    @IBOutlet weak var inCartCountLabel: UILabel!
    @IBOutlet weak var inStockTextLabel: UILabel!
    @IBOutlet weak var inStockAmountLabel: UILabel!
    
    override var catalog: ProductCatalog? {
        willSet{
            catalog?.removeObserver(self, forKeyPath: Static.cartQuantityKeyPathIdentifier)
            catalog?.removeObserver(self, forKeyPath: Static.availableQuantityKeyPathIdentifier)
            newValue?.addObserver(self, forKeyPath: Static.cartQuantityKeyPathIdentifier,
                                  options: .new,
                                  context: nil)
            newValue?.addObserver(self, forKeyPath: Static.availableQuantityKeyPathIdentifier,
                                  options: .new,
                                  context: nil)
        }
        didSet {
            detailContentAvailable = (catalog != nil)
            configureView()
        }
    }
    
    private func configureView() {
        if let catalog = catalog {
            title = catalog.productName
            addtoCartButton?.isHidden = false
            removeFromCartButton?.isHidden = false
            inCartTextLabel?.isHidden = false
            inCartCountLabel?.isHidden = false
            inStockTextLabel?.isHidden = false
            inStockAmountLabel?.isHidden = false

            detailDescriptionLabel?.text = catalog.productDescription
            itemsCoutInCartLabel?.text = String(catalog.cart?.quantity ?? 0)
            itemsStockLabel?.text = String(catalog.storage?.availableQuantity ?? 0)
            
            if let imageUrl = catalog.productImageUrl, let url =  URL(string: imageUrl) {
                catalogImageView?.sd_setImage(with: url, placeholderImage: nil)
            }
        }else {
            addtoCartButton?.isHidden = true
            removeFromCartButton?.isHidden = true
            inCartTextLabel?.isHidden = true
            inCartCountLabel?.isHidden = true
            inStockTextLabel?.isHidden = true
            inStockAmountLabel?.isHidden = true
        }
        
        validateButtonPresence()
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
    
    func validateButtonPresence(){
        self.addtoCartButton?.isEnabled = catalog?.canAddMoreItemtoCart() ?? false
        self.removeFromCartButton?.isEnabled = catalog?.canRemoveItemFromCart() ?? false
    }
    
    private func animateValueChange(label: UILabel?, value: String) {
        if let animatableLabel = label {
            DispatchQueue.main.async {
                self.addtoCartButton?.isEnabled = false
                self.removeFromCartButton?.isEnabled = false
                
                UIView.transition(with: animatableLabel,
                                  duration: 0.5,
                                  options: [.transitionCrossDissolve],
                                  animations: {
                                    animatableLabel.text = value
                                    
                }, completion: { (completed) in
                    self.validateButtonPresence()
                })
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Static.cartQuantityKeyPathIdentifier{
            animateValueChange(label: itemsCoutInCartLabel, value: String(change?[NSKeyValueChangeKey.newKey] as? Double ?? 0))
        }else if keyPath == Static.availableQuantityKeyPathIdentifier{
            animateValueChange(label: itemsStockLabel, value: String(change?[NSKeyValueChangeKey.newKey] as? Double ?? 0))
        }
    }
    
    deinit {
        catalog?.removeObserver(self, forKeyPath: Static.cartQuantityKeyPathIdentifier)
        catalog?.removeObserver(self, forKeyPath: Static.availableQuantityKeyPathIdentifier)
    }
}
