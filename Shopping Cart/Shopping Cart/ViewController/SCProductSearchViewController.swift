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


class SCProductSearchViewController: UITableViewController {
    
    private struct Static {
        static let catalogCellIdentifier = "CatalogCell"
        static let detailSegIdentifier = "showDetail"
    }

    var fetchResultController = SCDBManager.sharedInstance.catalogFetchResultController(searchText: nil, scope: nil) {didSet {fetchResultController.delegate = self}}
    
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
        refreshContent()
    }
    
    
    func updateRefreshControl() {
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(SCProductSearchViewController.refreshContent), for: UIControlEvents.valueChanged)
    }
    
    func refreshContent(){
        SCUtility.fetchUpdatedProductCatalogs()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchResultController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Static.catalogCellIdentifier, for: indexPath)
        let catalog = self.fetchResultController.object(at: indexPath)
        self.configureCell(cell, withCataLog: catalog, indexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, withCataLog catalog: ProductCatalog, indexPath: IndexPath) {
        
        if let catalogCell = cell as? SCCatalogTableViewCell{
            catalogCell.titleLabel.text = catalog.productName
            catalogCell.subTitleLabel.text = catalog.productDescription
            if let imageUrl = catalog.productImageUrl, let url =  URL(string: imageUrl){
                catalogCell.catalogImageView.sd_setImage(with: url, placeholderImage: nil)
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        fetchResultController = SCDBManager.sharedInstance.catalogFetchResultController(searchText: searchText, scope: nil)
        tableView.reloadData()
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Static.detailSegIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                
                let controller = (segue.destination as! UINavigationController).topViewController as! SCProductDetailViewController
                controller.catalog = fetchResultController.object(at: indexPath)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

extension SCProductSearchViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
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
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)!, withCataLog: anObject as! ProductCatalog, indexPath: indexPath!)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
