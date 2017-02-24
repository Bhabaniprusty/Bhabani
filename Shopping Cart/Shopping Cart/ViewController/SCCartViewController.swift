//
//  SCCartViewController.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit
import CoreData

class SCCartViewController: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    var cartFetchResultController = SCDBManager.sharedInstance.cartFetchResultController() {didSet {cartFetchResultController.delegate = self}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initiate sync operation from last settings
        SCSyncManager.sharedInstance.startSync()
    }
    
    
    @IBAction func closeSearchScreen(sender: UIStoryboardSegue){
        
    }
    
    @IBAction func showSettingOptions(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(message: "Auto Sync")
        alert.modalPresentationStyle = .popover
        let ppc = alert.popoverPresentationController
        ppc?.barButtonItem = sender
        present(alert, animated: true, completion: nil)
    }
}


extension SCCartViewController: UITableViewDataSource {
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.cartFetchResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.cartFetchResultController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath)
        let cartItem = self.cartFetchResultController.object(at: indexPath)
        self.configureCell(cell, withCartItem: cartItem, indexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, withCartItem cartItem: ShoppingCart, indexPath: IndexPath) {
        if let cartCell = cell as? SCCartCell{
            cartCell.titleLabel.text = cartItem.product?.productName
            cartCell.subTitleLabel.text = cartItem.product?.productName
            cartCell.quantityLabel.text = String(cartItem.quantity)
            cartCell.priceLabel.text = String(describing: cartItem.product?.price)  // Need to use currency formatter
            
            cartCell.availabilityIndicatorImageView.backgroundColor = cartItem.isAvailable ? UIColor.green : UIColor.orange
            if let imageUrl = cartItem.product?.productImageUrl, let url =  URL(string: imageUrl){
                cartCell.catalogImageView.sd_setImage(with: url, placeholderImage: nil)
            }
        }
    }
}

extension SCCartViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.cartTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.cartTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.cartTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            cartTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            cartTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(cartTableView.cellForRow(at: indexPath!)!, withCartItem: anObject as! ShoppingCart, indexPath: indexPath!)
        case .move:
            cartTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.cartTableView.endUpdates()
    }
}
