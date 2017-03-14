//
//  VContactService.swift
//  Vokal
//
//  Created by Bhabani on 14/03/2017.
//  Copyright © 2017 Bhabani. All rights reserved.
//

import Foundation
import Contacts

class VContactService {
    private func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool, _ message: String?) -> Void) {
        // Get authorization
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true, nil)
            
        case .denied, .notDetermined:
            CNContactStore().requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access, nil)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        
                        let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                        
                        completionHandler(access, message)
                    }
                }
            })
            
        default:
            completionHandler(false, nil)
        }
    }
    
    func searchForContact(withName name: String? = nil, completionHandler: @escaping (_ contacts: [CNContact], _ message: String?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { () -> Void in
            self.requestForAccess { (accessGranted, message) -> Void in
                var contacts = [CNContact]()
                var message = message
                
                if accessGranted {
                    let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactImageDataKey, CNContactPhoneNumbersKey]
                    
                    let contactsStore = CNContactStore()
                    do {
                        let fetchRequest = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                        if let name = name,  !name.isEmpty{
                            fetchRequest.predicate = CNContact.predicateForContacts(matchingName: name)
                        }
                        
                        try contactsStore.enumerateContacts(with: fetchRequest) {
                            (contact, cursor) -> Void in
                            
                            contacts.append(contact)
                        }
                        
                        if contacts.count == 0 {
                            message = "No contacts were found matching the given name."
                        }
                    }
                    catch {
                        message = "Unable to fetch contacts."
                    }
                    
                    
                }
                completionHandler(contacts, message)
            }
        }
    }
}
