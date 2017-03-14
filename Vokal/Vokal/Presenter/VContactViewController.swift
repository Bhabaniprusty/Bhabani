//
//  VContactViewController.swift
//  Vokal
//
//  Created by Bhabani on 14/03/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import UIKit
import Contacts

class VContactViewController: UIViewController {

    struct Static {
        static let contactCellIdentifier = "contactCell"
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var contactTableView: UITableView!
    var contacts = [CNContact]()
    let contactService = VContactService()

    var searchController = UISearchController(searchResultsController: nil) {
        didSet {
            searchController.dimsBackgroundDuringPresentation = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        contactTableView.tableHeaderView = searchController.searchBar
        
        contactService.searchForContact { (contacts, message) in
            self.updateUI(contacts: contacts, message: message)
        }
    }
    
    func updateUI(contacts: [CNContact], message: String?) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.contacts = contacts
            if let message = message {
                self.messageLabel.text = message
                self.contactTableView.isHidden = true
                self.messageLabel.isHidden = false
            }else{
                self.messageLabel.isHidden = true
                self.contactTableView.isHidden = false
            }
            
            self.contactTableView.reloadData()
        })
    }
}

extension VContactViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Static.contactCellIdentifier,
                                                 for: indexPath) as! VContactTableViewCell
        
        cell.cellModel = VContactCellModel(contact: contacts[indexPath.row])
        return cell
    }
}

extension VContactViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        contactService.searchForContact(withName: searchBar.text) { (contacts, message) in
            self.updateUI(contacts: contacts, message: message)
        }
    }
}

extension VContactViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        contactService.searchForContact(withName: searchController.searchBar.text) { (contacts, message) in
            self.updateUI(contacts: contacts, message: message)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        contactService.searchForContact { (contacts, message) in
            self.updateUI(contacts: contacts, message: message)
        }
    }
}

