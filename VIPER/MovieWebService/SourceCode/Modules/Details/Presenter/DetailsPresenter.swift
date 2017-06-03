//
//  DetailsPresenter.swift
//  MovieWebService
//
//  Created by Bhabani on 11/04/2017.
//  Copyright © 2017 TestCompany All rights reserved.
//

import Masonry

final class DetailsPresenter: NSObject {
    var interactor: DetailsInteractorInput!
    var router: DetailsRouterInput!
    
    struct Constant {
        static let tapExpandCellIdentifier = "tapExpandCell"
        static let actorCellIdentifier = "actorCell"
        static let directorCellIdentifier = "directorCell"
    }

    
    fileprivate var isActorCellExpanded =  false
    fileprivate var tableView: UITableView!{
        didSet{
            tableView.register(UINib(nibName: "MWDirectorTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.directorCellIdentifier)
            tableView.register(UINib(nibName: "MWActorTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.actorCellIdentifier)
            tableView.register(UINib(nibName: "MWTappableTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.tapExpandCellIdentifier)
            tableView.dataSource = self
            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
            tableView.alwaysBounceVertical = false
        }
    }
}

extension DetailsPresenter: DetailsPresenterInput{
    func setupView(_ view: UIView){
        tableView = UITableView()
        
        view.addSubview(tableView)
        self.tableView.mas_remakeConstraints { (make) in
            make?.edges.setInsets(UIEdgeInsets.zero)
        }
    }
}

extension DetailsPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            // If expanded then count else 1
            if isActorCellExpanded {
                return interactor.castCount
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        if indexPath.section == 0 {

            cell = tableView.dequeueReusableCell(withIdentifier: Constant.directorCellIdentifier)
            
            // Move this code to cell, configure cell, localised text
            if let directorCell = cell as? MWDirectorTableViewCell {
                directorCell.titleLabel.text = "Director Name"
                directorCell.descriptionLabel.text = interactor.directorName
            }
        } else {
            
            if (isActorCellExpanded) {
                
                let castInfo = interactor.castInfo(withIndex: indexPath.row)
                cell = tableView.dequeueReusableCell(withIdentifier: Constant.actorCellIdentifier)
                
                if let actorCell = cell as? MWActorTableViewCell {
                    actorCell.title1Label.text = "Actor Name"
                    actorCell.description1Label.text = castInfo.name
                    actorCell.title2Label.text = "Actor Screen Name"
                    actorCell.description2Label.text = castInfo.screenName
                }
            }else {
                
                cell = tableView.dequeueReusableCell(withIdentifier: Constant.tapExpandCellIdentifier)
                
                if let tappableCell = cell as? MWTappableTableViewCell {
                    tappableCell.tappableLabel.text = "Tap to Expand"
                    tappableCell.tappableLabel.tag = indexPath.section
                    tappableCell.tappableLabel.delegate = self
                }
            }
        }
        
        return cell
    }
}

extension DetailsPresenter: TappableLabelDelegate {
    func didReceiveTouch(_ label: TappableLabel!) {
        isActorCellExpanded = true
        tableView.reloadSections(IndexSet(integer: label.tag), with: .bottom)
    }
}
