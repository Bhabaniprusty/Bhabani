//
//  SCCartViewController.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit
import CoreData

final class SCCartViewController: UIViewController {
    
    fileprivate struct Static {
        static let cartCellIdentifier = "CartCell"
    }
    
    
    @IBOutlet weak var cartTableView: UITableView!
    fileprivate var cartFetchResultController = SCDBManager.sharedInstance.cartFetchResultController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartFetchResultController.delegate = self
        //Initiate sync operation from last settings
        SCSyncManager.sharedInstance.startSync()
    }
    
    @IBAction func closeSearchScreen(sender: UIStoryboardSegue){
        
    }
    
    @IBAction func showSettingOptions(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(message: NSLocalizedString("Auto Sync",
                                                                 comment: "Auto Sync functionality title"))
        alert.modalPresentationStyle = .popover
        let ppc = alert.popoverPresentationController
        ppc?.barButtonItem = sender
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segueIdentifier(forSegue: segue) {
        case .catalogSelelctionIdentifier:
            if let splitViewController = segue.destination as? UISplitViewController {
                let contentVc = splitViewController.viewControllers.last?.contentViewController
                contentVc?.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
                contentVc?.navigationItem.leftItemsSupplementBackButton = true
                splitViewController.delegate = splitViewController
                
                if (traitCollection.userInterfaceIdiom == .pad){
                    splitViewController.preferredDisplayMode = .allVisible
                }
            }
            
        case .catalogDetailIdentifier:
            if let indexPath = cartTableView.indexPathForSelectedRow,
                let controller = segue.destination as? SCDetailViewController {
                if let poc = controller.popoverPresentationController {
                    poc.sourceView = sender as! UIView?
                    poc.delegate = self
                }
                controller.catalog = cartFetchResultController.object(at: indexPath).product
                controller.navigationItem.rightBarButtonItem = nil
            }
        }
    }
}

extension SCCartViewController: SegueHandlerType {
    internal enum SegueIdentifier: String{
        case catalogSelelctionIdentifier = "showCatalogSelection"
        case catalogDetailIdentifier = "showCartItemDetail"
    }
}

extension SCCartViewController: UITableViewDataSource {
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return cartFetchResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = cartFetchResultController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Static.cartCellIdentifier, for: indexPath)
        let cartItem = cartFetchResultController.object(at: indexPath)
        configureCell(cell, withCartItem: cartItem, indexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, withCartItem cartItem: ShoppingCart, indexPath: IndexPath) {
        if let cartCell = cell as? SCCartCell{
            cartCell.titleLabel.text = cartItem.product?.productName
            cartCell.subTitleLabel.text = cartItem.product?.productName
            cartCell.quantityLabel.text = String(cartItem.quantity)
            cartCell.priceLabel.text = cartItem.product?.price.asLocaleCurrency
            
            cartCell.availabilityIndicatorImageView.backgroundColor = cartItem.isAvailable ? UIColor.green : UIColor.orange
            if let imageUrl = cartItem.product?.productImageUrl,
                let url =  URL(string: imageUrl) {
                cartCell.catalogImageView.sd_setImage(with: url, placeholderImage: nil)
            }
        }
    }
}

extension SCCartViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        cartTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            cartTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            cartTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            cartTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            cartTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            if let cell = cartTableView.cellForRow(at: indexPath!){
                configureCell(cell,
                              withCartItem: anObject as! ShoppingCart,
                              indexPath: indexPath!)
            }
            
        case .move:
            cartTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        cartTableView.endUpdates()
    }
}

extension SCCartViewController: UIPopoverPresentationControllerDelegate {
    func presentationController(_ controller: UIPresentationController,
                                viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        if style == .fullScreen || style == .overFullScreen {
            return UINavigationController(rootViewController: controller.presentedViewController)
        }else {
            return nil
        }
    }
}
