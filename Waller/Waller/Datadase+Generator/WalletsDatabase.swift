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
    func getAllWallets() -> [Wallet]
    {
        let db = coreDataStorage()
        var walletList:[Wallet] = []
        
        let walletEntities:[WalletEntity] = try! db.fetch(FetchRequest<WalletEntity>().sorted(with: "address", ascending: true))
    
        for wEntity in walletEntities
        {
            let w = Wallet.init(label: wEntity.label!, address: wEntity.address!, privatekey: wEntity.privateKey!)
            walletList.append(w)
        }

        return walletList
    }
    
    func saveWallet(wallet:Wallet, completionHandler: @escaping (Bool, String) -> Void)
    {
        let db = coreDataStorage()
        
        do
        {
            try db.operation
            {
                (context, save) throws in
                
                let newWallet: WalletEntity = try context.new()
                newWallet.label = wallet.label
                newWallet.address = wallet.address
                newWallet.privateKey = wallet.privatekey
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
    
    // Initializing CoreDataDefaultStorage
    func coreDataStorage() -> CoreDataDefaultStorage {
        let store = CoreDataStore.named("WalletTable")
        let bundle = Bundle(for: self.classForCoder)
        let model = CoreDataObjectModel.merged([bundle])
        let defaultStorage = try! CoreDataDefaultStorage(store: store, model: model)
        return defaultStorage
    }
    
}
