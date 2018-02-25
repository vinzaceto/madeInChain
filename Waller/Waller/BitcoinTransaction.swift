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
    func estimateFee(tx:BTCTransaction) -> BTCAmount
    {
        var amount:BTCAmount = 0
        amount = tx.estimatedFee
        return amount
    }
    
    func buildTransaction(senderAddress:String, destinationAddress:String, amount:BTCAmount, completionHandler: @escaping (Bool,String?,BTCTransaction?) -> Void)
    {
        var unspentTransactions:NSArray = NSArray.init()
        let api = BTCTestnetInfo.init()

        api.unspentOutputsWithAddress(address: senderAddress)
        {
            (success, error, transactions) in
            if success == true
            {
                guard let utx = transactions else
                {
                    completionHandler(false,"Unable to fetch unspent transactions.",nil)
                    return
                }

                unspentTransactions = NSArray.init(array: utx)
                print("unspent transactions list: \(unspentTransactions)")
                
                let feeAmount:BTCAmount = 0
                
                let totalAmount:BTCAmount = amount + feeAmount
                let dustThreshold:BTCAmount = 100000
                
                // ordering transactions
                unspentTransactions = unspentTransactions.sortedArray
                {
                    (a:Any, b:Any) -> ComparisonResult in
                    let tx1 = a as! BTCTransactionOutput
                    let tx2 = b as! BTCTransactionOutput
                    if ((tx1.value - tx2.value) < 0)
                    {return ComparisonResult.orderedAscending}
                    return ComparisonResult.orderedDescending
                } as NSArray
                
                var unspentTransactionOuts:[BTCTransactionOutput] = []
                for u in unspentTransactions
                {
                    let unspentTransaction = u as! BTCTransactionOutput
                    if unspentTransaction.value > (totalAmount + dustThreshold) && unspentTransaction.script.isPayToPublicKeyHashScript
                    {
                        unspentTransactionOuts.append(unspentTransaction)
                        break
                    }
                }
                
                if unspentTransactionOuts.count <= 0
                {
                    completionHandler(false,"Amount is not enough",nil)
                    return
                }
                
                print("unspent transactions outputs: \(unspentTransactionOuts)")
                
                // Create a new transaction
                let tx = BTCTransaction.init()
                var spentCoins:BTCAmount = 0
                
                for unspentOutput in unspentTransactionOuts
                {
                    let input = BTCTransactionInput.init()
                    input.previousHash = unspentOutput.transactionHash
                    input.previousIndex = unspentOutput.index
                    tx.addInput(input)
                    
                    spentCoins += unspentOutput.value;
                }
            
                print("Total satoshis to spend: \(spentCoins)")
                print("Total satoshis to destination: \(amount)")
                print("Total satoshis to fee: \(feeAmount)")
                print("Total satoshis to change: \((spentCoins - (amount + feeAmount)))")
                
                let paymentOutput = BTCTransactionOutput.init(value: amount, address: BTCAddress.init(string: destinationAddress))
                let changeOutput = BTCTransactionOutput.init(value: spentCoins - (amount + feeAmount), address: BTCAddress.init(string: senderAddress))
                
                tx.addOutput(paymentOutput)
                tx.addOutput(changeOutput)
                
                completionHandler(true,"",tx)

                // signing
                
            }
            else
            {
                completionHandler(false,"Unable to get unspent transactions.",nil)
                return
            }
        }
    }
    
    
    
    func buildTransaction(wallet:Wallet,amount:BTCAmount,fee:BTCAmount,destinationAddress:String,key:BTCKey, completionHandler: @escaping (Bool,String?,BTCTransaction?) -> Void)
    {
    
        
        
   
    }
    

    /*
    func createTransaction(wallet:Wallet,amount:BTCAmount,fee:BTCAmount,destinationAddress:String,key:BTCKey, completionHandler: @escaping (Bool,String?,BTCTransaction?) -> Void)
    {
        var unspentTransactions:NSArray = NSArray.init()

        let api = BTCTestnetInfo.init()
        api.unspentOutputsWithAddress(address: wallet.address)
        {
            (success, error, utxos) in
            
        }
        
        
        guard let utxos = api.unspentOutputsWithAddress(address: wallet.address) else
        {
            completionHandler(false,"Unable to fetch unspent transactions.",nil)
            return
        }
        unspentTransactions = NSArray.init(array: utxos)
        print("unspent transactions list: \(unspentTransactions)")
        
        
        
        let totalAmount:BTCAmount = amount + fee
        let dustThreshold:BTCAmount = 100000
        
        
        
        // ordering transactions
        unspentTransactions = unspentTransactions.sortedArray { (a:Any, b:Any) -> ComparisonResult in
            
            let tx1 = a as! BTCTransactionOutput
            let tx2 = b as! BTCTransactionOutput

            if ((tx1.value - tx2.value) < 0)
            {
                return ComparisonResult.orderedAscending
            }
            return ComparisonResult.orderedDescending
            
        } as NSArray
        

        
        var unspentTransactionOuts:[BTCTransactionOutput] = []
        for u in unspentTransactions
        {
            let unspentTransaction = u as! BTCTransactionOutput
            if unspentTransaction.value > (totalAmount + dustThreshold) && unspentTransaction.script.isPayToPublicKeyHashScript
            {
                unspentTransactionOuts.append(unspentTransaction)
                break
            }
        }
        
        if unspentTransactionOuts.count <= 0
        {
            completionHandler(false,"Amount is not enough",nil)
            return
        }
        
        print("unspent transactions outputs: \(unspentTransactionOuts)")

        
        // Create a new transaction
        let tx = BTCTransaction.init()
        
        
        var spentCoins:BTCAmount = 0
        
        
        for unspentOutput in unspentTransactionOuts
        {
            let input = BTCTransactionInput.init()
            input.previousHash = unspentOutput.transactionHash
            input.previousIndex = unspentOutput.index
            tx.addInput(input)
            
            spentCoins += unspentOutput.value;
        }
        
        
        
        print("Total satoshis to spend: \(spentCoins)")
        print("Total satoshis to destination: \(amount)")
        print("Total satoshis to fee: \(fee)")
        print("Total satoshis to change: \((spentCoins - (amount + fee)))")

        
        let paymentOutput = BTCTransactionOutput.init(value: amount, address: BTCAddress.init(string: destinationAddress))
        let changeOutput = BTCTransactionOutput.init(value: spentCoins - (amount + fee), address: BTCAddress.init(string: wallet.address))
        
        tx.addOutput(paymentOutput)
        tx.addOutput(changeOutput)

        
        for (index, _) in (0...unspentTransactionOuts.count-1).enumerated()
        {
            print(index)
            let txout = unspentTransactionOuts[index]
            let txin = tx.inputs[index] as! BTCTransactionInput
            let sigScript = BTCScript.init()
            
            let d1 = tx.data
            
            let hashtype = BTCSignatureHashType.BTCSignatureHashTypeAll
            
            var hash:Data!
            
            do
            {
                hash = try tx.signatureHash(for: txout.script, inputIndex: UInt32(index), hashType: hashtype)
                
                let d2 = tx.data
                
                if d1 != d2
                {
                    completionHandler(false,"hash change after computing",nil)
                    return
                }
            }
            catch
            {
                completionHandler(false,"signatureHash fail",nil)
                return
            }
            
            print("computed hash \(hash)")
            
            guard let signatureForScript = key.signature(forHash: hash, hashType: hashtype) else
            {
                completionHandler(false,"unable to build signature for hash",nil)
                return
            }
            
            sigScript?.appendData(signatureForScript)
            sigScript?.appendData(key.publicKey as! Data)

            let sig = signatureForScript.subdata(in: Range.init(uncheckedBounds: (lower:0, upper: signatureForScript.count-1)))
                
            if key.isValidSignature(sig, hash: hash) == false
            {
                completionHandler(false,"Signature must be valid",nil)
                return
            }
            
            txin.signatureScript = sigScript
            
        }
        
        
        
        let sm = BTCScriptMachine.init(transaction: tx, inputIndex: 0)
        
        do
        {
            try sm?.verify(withOutputScript: unspentTransactionOuts[0].script)
        }
        catch
        {
            completionHandler(false,"Failed to verify scrypt",nil)
            return
        }
        
        completionHandler(true,"error",tx)
        return
        
    }
    */
    
}
