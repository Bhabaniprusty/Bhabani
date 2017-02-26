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
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Shopping_Cart")
        container.viewContext.automaticallyMergesChangesFromParent = true

        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveProductCatalogs(catalogs : [JSON]) {
        
        persistentContainer.performBackgroundTask { (moc) in
            for catalog in catalogs{
                if let productId = catalog["productId"].string{
                    var productCatalog: ProductCatalog!
                    
                    let catalogFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityProductCatalog)
                    catalogFetchRequest.predicate = NSPredicate(format: "productId == %@",productId)
                    
                    if let  existingCatalog = (try? moc.fetch(catalogFetchRequest))?.first as? ProductCatalog {
                        productCatalog = existingCatalog
                    }else{
                        productCatalog = ProductCatalog(context: moc)
                        productCatalog.productId = productId
                    }
                    
                    productCatalog.price = catalog["price"].float ?? 0.0
                    productCatalog.productDescription = catalog["productDescription"].string
                    productCatalog.productImageUrl = catalog["productImageUrl"].string
                    productCatalog.productName = catalog["productName"].string
                    productCatalog.unit = catalog["unit"].string
                    productCatalog.updatedAt = catalog["updatedAt"].string?.dateValue()
                    
                    var category: ProductCategory!
                    if let productCategoryName = catalog["productCategory"].string{
                        //Product catalog's category can be changed. update every time is good option
                        if productCatalog.productCategory?.categoryName != productCategoryName {
                            let categoryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityProductCategory)
                            catalogFetchRequest.predicate = NSPredicate(format: "categoryName == %@",productCategoryName)
                            if let  existingCategory = (try? moc.fetch(categoryFetchRequest))?.first as? ProductCategory{
                                category = existingCategory
                            }else{
                                category = ProductCategory(context: moc)
                                category.categoryName = productCategoryName
                            }
                            
                            productCatalog.productCategory = category
                        }
                    }
                }
            }
            
            try? moc.save()
        }
    }
    
    func saveProductCatalogsStorage(catalogStorages : [JSON]) {
        persistentContainer.performBackgroundTask { (moc) in
            for catalogStorage in catalogStorages{
                if let productId = catalogStorage["productId"].string{
                    let catalogFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityProductCatalog)
                    catalogFetchRequest.predicate = NSPredicate(format: "productId == %@",productId)
                    
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
            }
            
            try? moc.save()
        }
    }
    
    func addToCart(productId: String, quantity: Double) {
        persistentContainer.performBackgroundTask { (moc) in
            
            let catalogFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityProductCatalog)
            catalogFetchRequest.predicate = NSPredicate(format: "productId == %@",productId)
            
            //Will update if catalog is locally available
            if let  product = (try? moc.fetch(catalogFetchRequest))?.first as? ProductCatalog{
                var cartItem: ShoppingCart!
                
                if product.cart == nil{
                    cartItem = ShoppingCart(context: moc)
                    cartItem.product = product
                    //                product.cart = cartItem
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
    }
    
    func removeFromCart(productId: String) {
        persistentContainer.performBackgroundTask { (moc) in
            
            let catalogFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityProductCatalog)
            catalogFetchRequest.predicate = NSPredicate(format: "productId == %@",productId)
            
            //Will update if catalog is locally available
            if let  product = (try? moc.fetch(catalogFetchRequest))?.first as? ProductCatalog{
                if let cart = product.cart{
                    moc.delete(cart)
                    product.storage?.cartOrderQuantity = 0
                }
                
                try? moc.save()
            }
        }
    }
    
    func fetchLastStorageUpdatedDate() -> Date? {
        let catalogFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityStorage)
        catalogFetchRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: true)
        catalogFetchRequest.sortDescriptors = [sortDescriptor]
        
        return ((try? persistentContainer.viewContext.fetch(catalogFetchRequest))?.first as? ProductCatalog)?.updatedAt as Date?
    }
    
    func fetchLastCatalogUpdatedDate() -> Date? {
        let catalogFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityProductCatalog)
        catalogFetchRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: true)
        catalogFetchRequest.sortDescriptors = [sortDescriptor]
        
        
        return ((try? persistentContainer.viewContext.fetch(catalogFetchRequest))?.first as? ProductCatalog)?.updatedAt as Date?
    }
    
    private func removeAllEnityData(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        
        persistentContainer.performBackgroundTask {[weak self] (moc) in
            do {
                try self?.persistentContainer.persistentStoreCoordinator.execute(deleteRequest,
                                                                                with: moc)
            } catch let error as NSError {
                // TODO: handle the error
                print("Error : Coredata Remove error =\(error)")
            }
        }
    }
    
    func invalidStorageData() {
        removeAllEnityData(entityName: Static.entityStorage)
    }
    
    func catalogFetchResultController(searchText: String?,
                                      scope: String?) -> NSFetchedResultsController<ProductCatalog> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityProductCatalog)
        
        // Added Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "updatedAt",
                                              ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        
        if let searchText = searchText, !searchText.isEmpty{
            let predicate = NSPredicate(format: "productName contains[c] %@ OR productDescription contains[c] %@",
                                        argumentArray: [searchText, searchText])
            fetchRequest.predicate = predicate
        }
        
        let storageFRC = NSFetchedResultsController(fetchRequest: fetchRequest as! NSFetchRequest<ProductCatalog>,
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        do {
            try storageFRC.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return storageFRC
    }
    
    func cartFetchResultController() -> NSFetchedResultsController<ShoppingCart> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Static.entityShoppingCart)
        
        // Added Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "isAvailable",
                                              ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        
        let catalogFRC = NSFetchedResultsController(fetchRequest: fetchRequest as! NSFetchRequest<ShoppingCart>,
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        do {
            try catalogFRC.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return catalogFRC
    }
}
    
