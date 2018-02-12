//
//  WalletsDatabase.swift
//  Waller
//
//  Created by Vincenzo Ajello on 09/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class WalletsDatabase: NSObject
{
    func getAllWallets() -> WalletsList
    {
        let db = coreDataStorage()
        var fullWalletsList:[FullWallet] = []
        var watchOnlyWalletsList:[WatchOnlyWallet] = []
        
        let fullWalletsEntities: [FullWalletEntity] = try! db.fetch(FetchRequest<FullWalletEntity>().sorted(with: "address", ascending: true))
        for fwEntity in fullWalletsEntities
        {
            let fullWallet = FullWallet.init(label: fwEntity.label!, address: fwEntity.address!, encryptedPrivatekey: fwEntity.encryptedPrivatekey!)
            fullWalletsList.append(fullWallet)
        }
        
        let watchOnlyEntities: [WatchOnlyEntity] = try! db.fetch(FetchRequest<WatchOnlyEntity>().sorted(with: "address", ascending: true))
        for watchOnlyEntity in watchOnlyEntities
        {
            let watchOnlyWallet = WatchOnlyWallet.init(label: watchOnlyEntity.label!, address: watchOnlyEntity.address!)
            watchOnlyWalletsList.append(watchOnlyWallet)
        }
        
        let walletList = WalletsList.init(fullWallets: fullWalletsList, watchOnlyWallets: watchOnlyWalletsList)

        return walletList
    }
    
    func saveFullWallet(fullWallet:FullWallet, completionHandler: @escaping (Bool, String) -> Void)
    {
        let db = coreDataStorage()
        
        do
        {
            try db.operation
            {
                (context, save) throws in
                
                let newWallet: FullWalletEntity = try context.new()
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
    
    func saveWatchOnlyWallet(watchOnlyWallet:WatchOnlyWallet, completionHandler: @escaping (Bool, String) -> Void)
    {
        let db = coreDataStorage()
        
        do
        {
            try db.operation
            {
                (context, save) throws in
                
                let newWallet: WatchOnlyEntity = try context.new()
                newWallet.label = watchOnlyWallet.label
                newWallet.address = watchOnlyWallet.address
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
                    let thisWallet: FullWalletEntity? = try context.request(FullWalletEntity.self).filtered(with: "address", equalTo: address).fetch().first
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
    
    // Initializing CoreDataDefaultStorage
    func coreDataStorage() -> CoreDataDefaultStorage {
        let store = CoreDataStore.named("WalletTable")
        let bundle = Bundle(for: self.classForCoder)
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }
    
}
