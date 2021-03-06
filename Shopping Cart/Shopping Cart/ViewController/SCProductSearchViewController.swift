//
//  SCProductSearchViewController.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage


final class SCProductSearchViewController: UITableViewController {
    
    private struct Static {
        static let catalogCellIdentifier = "CatalogCell"
    }

    var fetchResultController = SCDBManager.sharedInstance.catalogFetchResultController(searchText:
        nil, scope: nil)
    
    var searchController = UISearchController(searchResultsController: nil) {
        didSet {
            searchController.dimsBackgroundDuringPresentation = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        tableView.tableHeaderView = searchController.searchBar
        fetchResultController.delegate = self
        refreshContent()
        updateRefreshControl()
    }
    
    
    func updateRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh",
                                                                                       comment: "User to pull to refresh content"))
        refreshControl.addTarget(self,
                                  action: #selector(SCProductSearchViewController.refreshContent),
                                  for: UIControlEvents.valueChanged)
        
        self.refreshControl = refreshControl
    }
    
    func refreshContent(){
        refreshControl?.beginRefreshing()
        Log.DLog("refreshContent catalog process started")
        SCUtility.fetchUpdatedProductCatalogs {(_, pageIndex, state) in
            if state == .Completed {
                DispatchQueue.main.async {
                    self.refreshControl?.endRefreshing()
                }
            }
            
            Log.DLog("refreshContent process page index = \(pageIndex) state = \(state)")
        }
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchResultController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Static.catalogCellIdentifier,
                                                 for: indexPath)
        let catalog = fetchResultController.object(at: indexPath)
        configureCell(cell, withCataLog: catalog, indexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell,
                       withCataLog catalog: ProductCatalog,
                       indexPath: IndexPath) {
        
        if let catalogCell = cell as? SCCatalogTableViewCell{
            catalogCell.titleLabel.text = catalog.productName
            catalogCell.subTitleLabel.text = catalog.productDescription
            if let imageUrl = catalog.productImageUrl,
                let url =  URL(string: imageUrl){
                catalogCell.catalogImageView.sd_setImage(with: url, placeholderImage: nil)
            }
            
            //add code for UI automation
            catalogCell.accessibilityIdentifier = catalog.productName
            catalogCell.accessibilityLabel = catalog.productName
        }
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    scope: String = "All") {
        fetchResultController = SCDBManager.sharedInstance.catalogFetchResultController(searchText: searchText,
                                                                                        scope: nil)
        fetchResultController.delegate = self
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = splitViewController?.viewControllers.last?.contentViewController as? SCDetailViewController{
            updateDetail(controller: controller, selectedIndexPath: indexPath)
        } else {
            performSegueWithIdentifier(segueIdentifier: .detailSegIdentifier, sender: tableView.cellForRow(at: indexPath)!)
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(forSegue: segue) {
        case .detailSegIdentifier:
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination.contentViewController as! SCDetailViewController
                updateDetail(controller: controller, selectedIndexPath: indexPath)
            }
        }
    }
    
    private func updateDetail(controller: SCDetailViewController, selectedIndexPath: IndexPath){
        controller.catalog = fetchResultController.object(at: selectedIndexPath)
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
    }
}

extension SCProductSearchViewController: SegueHandlerType {
    internal enum SegueIdentifier: String{
        case detailSegIdentifier = "detailSegIdentifier"
    }
}

extension SCProductSearchViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!,
                                   scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension SCProductSearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension SCProductSearchViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            if let cell = tableView.cellForRow(at: indexPath!){
                configureCell(cell,
                              withCataLog: anObject as! ProductCatalog,
                              indexPath: indexPath!)
            }
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
