//
//  SCUtility.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation


class SCUtility{
    
    struct Static {
        static let pageSize = 100
    }
    
    
    class func fetchUpdatedProductCatalogs() {
        let lastUpdatedDate = SCDBManager.sharedInstance.fetchLastCatalogUpdatedDate()
        self.fetchProductCatalogs(updatedAfterDate: lastUpdatedDate, pageIndex: 0)
    }
    
    // updatedAfterDate : Last local ProductCatalog.updatedAt, nil if no record available
    private class func fetchProductCatalogs(updatedAfterDate: Date?, pageIndex: Int){
        SCUtility.fetchBatchProductCatalogs(updatedAfterDate: updatedAfterDate, pageIndex: pageIndex) { (moreCatalogsAvailable) in
            if moreCatalogsAvailable {  // fetch the next page
                SCUtility.fetchProductCatalogs(updatedAfterDate: updatedAfterDate, pageIndex: pageIndex + 1)
            }
        }
    }
    
    private class func fetchBatchProductCatalogs(updatedAfterDate: Date?, pageIndex: Int, completion: @escaping (_ recoerdAvailable: Bool) -> Void) -> Void {
        _ = SCNetworkMager.sharedInstancer.fetchProductCatalogs(updatedAfterDate: updatedAfterDate, pageIndex: pageIndex, pageSize: Static.pageSize) { (jsonArr, error) in
            
            // dump jsonArr in DB
            if let catalogs = jsonArr{
                SCDBManager.sharedInstance.saveProductCatalogsStorage(catalogStorages: catalogs)
            }
            completion((jsonArr?.count == Static.pageSize))
        }
    }
    
    
    class func fetchUpdatedProductStorates() {
        let lastUpdatedDate = SCDBManager.sharedInstance.fetchLastStorageUpdatedDate()
        self.fetchProductStorages(updatedAfterDate: lastUpdatedDate, pageIndex: 0)
    }
    
    private class func fetchProductStorages(updatedAfterDate: Date?, pageIndex: Int){
        SCUtility.fetchBatchProductStorages(updatedAfterDate: updatedAfterDate, pageIndex: pageIndex) { (moreStoragesAvailable) in
            if moreStoragesAvailable {   // fetch the next page
                SCUtility.fetchProductStorages(updatedAfterDate: updatedAfterDate, pageIndex: pageIndex + 1)
            }
            
        }
    }
    
    
    private class func fetchBatchProductStorages(updatedAfterDate: Date?, pageIndex: Int, completion: @escaping (_ recoerdAvailable: Bool) -> Void) -> Void {
        _ = SCNetworkMager.sharedInstancer.fetchProductStorages(updatedAfterDate: updatedAfterDate, pageIndex: pageIndex, pageSize: Static.pageSize, completion: { (jsonArr, error) in
            
            //Dump to DB
            if let storages = jsonArr{
                SCDBManager.sharedInstance.saveProductCatalogsStorage(catalogStorages: storages)
            }
            
            completion((jsonArr?.count == Static.pageSize))
        })
    }
    
    class func prepareError(domain: String, localisedString: String) -> Error{
        return NSError(domain: domain, code: 0, userInfo: [
            NSLocalizedDescriptionKey: localisedString])
    }
    
    class func invalidateStorage() {
        SCSyncManager.sharedInstance.stopSync()
        SCDBManager.sharedInstance.removeAllEnityData(entityName: "Storage")
        SCSyncManager.sharedInstance.startSync()
    }
    
}
