//
//  WalletTable+CoreDataProperties.swift
//  
//
//  Created by Vincenzo Ajello on 09/02/18.
//
//

import Foundation
import CoreData


extension WalletTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletTable> {
        return NSFetchRequest<WalletTable>(entityName: "WalletTable")
    }

    @NSManaged public var walletID: String?

}
