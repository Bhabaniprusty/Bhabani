//
//  SCProductCatalog.swift
//  Shopping Cart
//
//  Created by Bhabani on 26/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

//import Foundation
//import CoreData


extension ProductCatalog{
    func canAddMoreItemtoCart() -> Bool {
        return (storage?.availableQuantity ?? 0) > (cart?.quantity ?? 0)
    }
    
    func canRemoveItemFromCart() -> Bool {
        return (cart?.quantity ?? 0) > 0
    }
}
