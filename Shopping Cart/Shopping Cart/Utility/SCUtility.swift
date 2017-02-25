//
//  SCUtility.swift
//  Shopping Cart
//
//  Created by Bhabani on 23/02/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation


enum SCPageFetchState {
    case Started
    case Stoped
    case Completed
}

typealias PageProgress = (_ currentPage: Int,_ state: SCPageFetchState)->Void


class SCUtility{
    
    struct Static {
        static let pageSize = 10
        static let invalidedDuratopn = 5.0
    }
    
    class func fetchUpdatedProductCatalogs(progress: @escaping PageProgress) {
        let lastUpdatedDate = SCDBManager.sharedInstance.fetchLastCatalogUpdatedDate()
        fetchProductCatalogs(updatedAfterDate: lastUpdatedDate, pageIndex: 0, progress: progress)
    }
    
    // updatedAfterDate : Last local ProductCatalog.updatedAt, nil if no record available
    private class func fetchProductCatalogs(updatedAfterDate: Date?,
                                            pageIndex: Int, progress: @escaping PageProgress){
        progress(pageIndex, .Started)
        SCUtility.fetchBatchProductCatalogs(updatedAfterDate: updatedAfterDate,
                                            pageIndex: pageIndex) { (moreCatalogsAvailable) in
                                                
                                                progress(pageIndex, .Stoped)
                                                if moreCatalogsAvailable {  // fetch the next page
                                                    SCUtility.fetchProductCatalogs(updatedAfterDate: updatedAfterDate,
                                                                                   pageIndex: pageIndex + 1,
                                                                                   progress: progress)
                                                }else{
                                                    progress(pageIndex, .Completed)
                                                }
        }
    }
    
    private class func fetchBatchProductCatalogs(updatedAfterDate: Date?,
                                                 pageIndex: Int,
                                                 completion: @escaping (_ recoerdAvailable: Bool) -> Void) -> Void {
        _ = SCNetworkMager.sharedInstancer.fetchProductCatalogs(updatedAfterDate: updatedAfterDate,
                                                                pageIndex: pageIndex,
                                                                pageSize: Static.pageSize) { (jsonArr, error) in
                                                                    
                                                                    // dump jsonArr in DB
                                                                    if let catalogs = jsonArr{
                                                                        SCDBManager.sharedInstance.saveProductCatalogs(catalogs: catalogs)
                                                                    }
                                                                    completion((jsonArr?.count == Static.pageSize))
        }
    }
    
    
    class func fetchUpdatedProductStorages(progress: @escaping PageProgress) {
        let lastUpdatedDate = SCDBManager.sharedInstance.fetchLastStorageUpdatedDate()
        fetchProductStorages(updatedAfterDate: lastUpdatedDate, pageIndex: 0, progress: progress)
    }
    
    private class func fetchProductStorages(updatedAfterDate: Date?, pageIndex: Int, progress: @escaping PageProgress){
        progress(pageIndex, .Started)
        SCUtility.fetchBatchProductStorages(updatedAfterDate: updatedAfterDate,
                                            pageIndex: pageIndex) { (moreStoragesAvailable) in
                                                
                                                progress(pageIndex, .Stoped)

                                                if moreStoragesAvailable {   // fetch the next page
                                                    SCUtility.fetchProductStorages(updatedAfterDate: updatedAfterDate,
                                                                                   pageIndex: pageIndex + 1, progress: progress)
                                                }else{
                                                    progress(pageIndex, .Completed)
                                                }
        }
    }
    
    
    private class func fetchBatchProductStorages(updatedAfterDate: Date?,
                                                 pageIndex: Int,
                                                 completion: @escaping (_ recoerdAvailable: Bool) -> Void) -> Void {
        _ = SCNetworkMager.sharedInstancer.fetchProductStorages(updatedAfterDate: updatedAfterDate,
                                                                pageIndex: pageIndex,
                                                                pageSize: Static.pageSize,
                                                                completion: { (jsonArr, error) in
                                                                    
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
        SCDBManager.sharedInstance.invalidStorageData()
        DispatchQueue.main.asyncAfter(deadline: .now() + Static.invalidedDuratopn) {
            SCSyncManager.sharedInstance.startSync()
        }
    }
}
