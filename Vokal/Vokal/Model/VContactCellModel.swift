//
//  VContactCellModel.swift
//  Vokal
//
//  Created by Bhabani on 14/03/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation
import UIKit
import Contacts

struct VContactCellModel {
    fileprivate var contact: CNContact!
    init(contact: CNContact) {
        self.contact = contact
    }
    
    var name: String {
        get{
            return contact.givenName + contact.familyName
        }
    }
    
    var image: UIImage? {
        get {
            guard let imageData = contact.imageData, let image =  UIImage(data: imageData) else {
                return nil
            }
            
            return image
        }
    }
    
    var audioIdentifier: String{
        get {
            return contact.identifier
        }
    }
    
}
