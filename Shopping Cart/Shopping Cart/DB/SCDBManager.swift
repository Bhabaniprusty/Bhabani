//
//  SCDBManager.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class SCDBManager: NSObject{
    
    struct Static {
        static let entityShoppingCart = "ShoppingCart"
        static let entityProductCatalog = "ProductCatalog"
        static let entityProductCategory = "ProductCategory"
        static let entityStorage = "Storage"
    }

    static let sharedInstance = SCDBManager()
    
    private override init() { }
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Shopping_Cart")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveProductCatalogs(catalogs : [JSON]) {
        
        self.persistentContainer.performBackgroundTask { (moc) in
            for catalog in catalogs{
                let productId = catalog["productId"].string
                
                var productCatalog: ProductCatalog!
                
                let catalogFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityProductCatalog)
                catalogFetchRequest.predicate = NSPredicate(format: "productId == \(productId)")
                if let  existingCatalog = (try? moc.fetch(catalogFetchRequest))?.first as? ProductCatalog{
                    productCatalog = existingCatalog
                }else{
                    productCatalog = ProductCatalog(context: moc)
                }
                
                productCatalog.price = catalog["price"].float ?? 0.0
                productCatalog.productDescription = catalog["productDescription"].string
                productCatalog.productImageUrl = catalog["productImageUrl"].string
                productCatalog.productName = catalog["productName"].string
                productCatalog.unit = catalog["unit"].string
                productCatalog.updatedAt = catalog["updatedAt"].string?.dateValue()
                
                var category: ProductCategory!
                let productCategoryName = catalog["category"].string
                
                //Product catalog's category can be changed. update every time is good option
                if productCatalog.productCategory?.categoryName != productCategoryName {
                    let categoryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityProductCategory)
                    catalogFetchRequest.predicate = NSPredicate(format: "categoryName == \(productCategoryName)")
                    if let  existingCategory = (try? moc.fetch(categoryFetchRequest))?.first as? ProductCategory{
                        category = existingCategory
                    }else{
                        category = ProductCategory(context: moc)
                    }
                    
                    productCatalog.productCategory = category
                }
            }
            
            try? moc.save()
        }
    }
    
    
    func saveProductCatalogsStorage(catalogStorages : [JSON]) {
        
        self.persistentContainer.performBackgroundTask { (moc) in
            for catalogStorage in catalogStorages{
                let productId = catalogStorage["productId"].string
                
                let catalogFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityProductCatalog)
                catalogFetchRequest.predicate = NSPredicate(format: "productId == \(productId)")
                
                //Will update if catalog is locally available
                if let  existingCatalog = (try? moc.fetch(catalogFetchRequest))?.first as? ProductCatalog{
                    var storage: Storage!
                    if let existingStorage = existingCatalog.storage{
                        storage = existingStorage
                    }else{
                        storage = Storage(context: moc)
                        existingCatalog.storage = storage
                    }
                    
                    storage.availableQuantity = catalogStorage["availableQuantity"].double ?? 0
                    storage.cartOrderQuantity = 0 // will be updated when synced with Cart
                    
                    // If product added to cart, then update cart and storage
                    if let cartItem = existingCatalog.cart{
                        cartItem.isAvailable = cartItem.quantity <= storage.availableQuantity
                        storage.cartOrderQuantity = cartItem.quantity
                    }
                }
                
            }
            
            try? moc.save()
        }
    }
    
    func addToCart(product: ProductCatalog, quantity: Double) {
        self.persistentContainer.performBackgroundTask { (moc) in
            
            var cartItem: ShoppingCart!
            
            if product.cart == nil{
                cartItem = ShoppingCart(context: moc)
                product.cart = cartItem
            }else{
                cartItem = product.cart
            }
            
            cartItem.quantity += quantity
            product.storage?.cartOrderQuantity = cartItem.quantity
            cartItem.isAvailable = cartItem.quantity <= (product.storage?.availableQuantity ?? 0)
            cartItem.updatedAt = Date() as NSDate?
            
            try? moc.save()
        }
    }
    
    
    func fetchLastStorageUpdatedDate() -> Date? {
        let catalogFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityStorage)
        catalogFetchRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: true)
        catalogFetchRequest.sortDescriptors = [sortDescriptor]
        
        
        return ((try? self.persistentContainer.viewContext.fetch(catalogFetchRequest))?.first as? ProductCatalog)?.updatedAt as Date?
        
    }
    
    func fetchLastCatalogUpdatedDate() -> Date? {
        let catalogFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityProductCatalog)
        catalogFetchRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: true)
        catalogFetchRequest.sortDescriptors = [sortDescriptor]
        
        
        return ((try? self.persistentContainer.viewContext.fetch(catalogFetchRequest))?.first as? ProductCatalog)?.updatedAt as Date?
    }
    
    
    private func removeAllEnityData(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        
        self.persistentContainer.performBackgroundTask { (moc) in
            do {
                try self.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: moc)
            } catch let error as NSError {
                // TODO: handle the error
                print("Error : Coredata Remove error =\(error)")
            }
        }
    }
    
    func invalidStorageData() {
        self.removeAllEnityData(entityName: Static.entityStorage)
    }
    
    func catalogFetchResultController(searchText: String?, scope: String?) -> NSFetchedResultsController<ProductCatalog> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityProductCatalog)
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        
        
        if let searchText = searchText {
            let predicate = NSPredicate(format: "productName contains[c] %@ AND productDescription contains[c] %@", argumentArray: [searchText, searchText])
            
            fetchRequest.predicate = predicate
        }
        
        
        let storageFRC = NSFetchedResultsController(fetchRequest: fetchRequest as! NSFetchRequest<ProductCatalog>, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
        // Configure Fetched Results Controller
        
        do {
            try storageFRC.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return storageFRC
    }
    
    func cartFetchResultController() -> NSFetchedResultsController<ShoppingCart> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityShoppingCart)
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "isAvailable", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        
        let catalogFRC = NSFetchedResultsController(fetchRequest: fetchRequest as! NSFetchRequest<ShoppingCart>, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        
        do {
            try catalogFRC.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return catalogFRC
    }
}
    
