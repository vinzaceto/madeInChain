//
//  WalletsKeychain.swift
//  Waller
//
//  Created by Vincenzo Ajello on 09/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class WalletsKeychain: NSObject
{
    func getAllWallets()
    {
        let db = coreDataStorage()
        let wallets: [WalletEntity] = try! db.fetch(FetchRequest<WalletEntity>().sorted(with: "address", ascending: true))
        print("saved wallets : \(wallets)")
    }
    
    func saveWallet(fullWallet:FullWallet, completionHandler: @escaping (Bool, String) -> Void)
    {
        let db = coreDataStorage()
        
        do
        {
            try db.operation
            {
                (context, save) throws in
                
                let newWallet: WalletEntity = try context.new()
                newWallet.label = fullWallet.label
                newWallet.address = fullWallet.address
                newWallet.encryptedPrivatekey = fullWallet.encryptedPrivatekey
                try context.insert(newWallet)
                try save()
                completionHandler(true, "wallet saved")
            }
        }
        catch
        {
            completionHandler(false, "unable to save the wallet")
        }
    }
    
    
    func removeWalletBy(address:String, completionHandler: @escaping (Bool, String) -> Void)
    {
        let db = coreDataStorage()

        do
        {
            try db.operation
            {
                (context, save) throws in
                
                do
                {
                    let thisWallet: WalletEntity? = try context.request(WalletEntity.self).filtered(with: "address", equalTo: address).fetch().first
                    if let this = thisWallet
                    {
                        try context.remove([this])
                        try save()
                        completionHandler(true, "success")
                    }
                    else
                    {
                        completionHandler(false, "unable to find the address")
                    }
                }
                catch
                {
                    completionHandler(false, "select failed")
                }
            }
        }
        catch
        {
            completionHandler(false, "remove failed")
        }
    }
    
    func removeWalletBy(address:String)
    {
        /*
        do {
            db.operation { (context, save) throws in
                let john: User? = try context.request(User.self).filteredWith("id", equalTo: "1234").fetch().first
                if let john = john {
                    try context.remove([john])
                    try save()
                }
            }
        } catch {
            // There was an error in the operation
        }
        
        completionHandler(true, nil)
    */
    }
    
    // Initializing CoreDataDefaultStorage
    func coreDataStorage() -> CoreDataDefaultStorage {
        let store = CoreDataStore.named("WalletTable")
        let bundle = Bundle(for: self.classForCoder)
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }
    
}
