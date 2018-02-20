//
//  BitcoinTransaction.swift
//  Waller
//
//  Created by Vincenzo Ajello on 20/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class BitcoinTransaction: NSObject
{
    func executeTransaction()
    {
        
    }

    func initTransaction(recipientAddress:String)
    {
        let builder = BTCTransactionBuilder.init()
        do
        {
            try builder.buildTransaction()
        }
        catch
        {
            print("fail \(error)")
        }
    }
}
