//
//  GenerateWalletController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 07/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class GenerateWalletController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        let pk = "92YEdQpKUqAYjyw29VVRuh6Z1TUL4YfC1f9fbCQH7xRpao9d6Xt"
        let privKey = BTCPrivateKeyAddress.init(string: pk)
        let wallet = BTCKey.init(privateKeyAddress:privKey)
        print(wallet?.addressTestnet.string)
        
        let d = Data.init(referencing: (wallet?.privateKey)!)
        
        let key = BTCKey.init(privateKey: d)
        let destination = "mmUZ98EhFFh9HTbTfqoTHsghUTW8h6hXh1"
        let changeAddress = wallet?.addressTestnet.string
        let amount:BTCAmount = 10000
        let fee:BTCAmount = 1000
        
        let bci = BTCTestnetInfo.init()
        var utxos = bci.unspentOutputsWithAddress(address: (wallet?.addressTestnet.string)!) as! NSArray
        
        // 0.00000001 btc = 1 satoshi
        // standard fee = 1000 satoshi = 0.00001000
        
        let totalAmount:BTCAmount = amount + fee
        let dustThreshold:BTCAmount = 100000
        
        let unspentTX:NSArray = NSArray.init(array: utxos)
        
        let orderedTX:NSArray = unspentTX.sortedArray { (a:Any, b:Any) -> ComparisonResult in
            
            let tr1 = a as! BTCTransactionOutput
            let tr2 = b as! BTCTransactionOutput

            if (tr1.value - tr2.value) < 0
            {
                return ComparisonResult.orderedAscending
            }
            else
            {
                return ComparisonResult.orderedDescending
            }
            } as NSArray
        
        var txouts:[BTCTransactionOutput] = []
        
        for t in orderedTX
        {
            let txout = t as!BTCTransactionOutput
            if txout.value > (totalAmount + dustThreshold) && txout.script.isPayToPublicKeyHashScript
            {
                txouts.append(txout)
            }
        }
        
        if txouts.count < 1
        {
            print("error no valid txouts")
            return
        }

        var spentCoins:BTCAmount = 0
        
        let transaction = BTCTransaction.init()
        
        for txout in txouts
        {
            let txin = BTCTransactionInput.init()
            txin.previousHash = txout.transactionHash
            txin.previousIndex = txout.index
            transaction.addInput(txin)
            
            print("txhash: http://blockchain.info/rawtx/\(BTCHexFromData(txout.transactionHash!))")
            print("txhash: http://blockchain.info/rawtx/\(BTCHexFromData(BTCReversedData(txout.transactionHash!))) (reversed)")
            
            spentCoins = spentCoins + txout.value
        }
        
        let change = (spentCoins - (amount + fee))
        
        print("Total satoshis to spend:             \(spentCoins)")
        print("Total satoshis to destination:       \(amount)")
        print("Total satoshis to fee:               \(fee)")
        print("Total satoshis to change:            \(change)")

        let destinantionAddress = BTCAddress.init(string: destination)
        let changeAddr = BTCAddress.init(string: changeAddress)

        let paymentOutput = BTCTransactionOutput.init(value: amount, address: destinantionAddress)
        let changeOutput = BTCTransactionOutput.init(value: change, address: changeAddr)
        
        transaction.addOutput(paymentOutput)
        transaction.addOutput(changeOutput)

        
        for (index, txout) in txouts.enumerated()
        {
            let txin = transaction.inputs[index] as! BTCTransactionInput
            
            let sigScript = BTCScript.init()
            let d1 = transaction.data
            let d2 = transaction.data
            let hashType:BTCSignatureHashType = BTCSignatureHashType.BTCSignatureHashTypeAll
            
            var txHash:Data?
            do
            {
                let txh = try transaction.signatureHash(for: txout.script, inputIndex: UInt32(index), hashType: hashType)
                txHash = txh
            }
            catch let error as NSError
            {
                print(error)
            }
            
        
            assert(d1 == d2, "Transaction must not change within signatureHashForScript!")
            print("Hash for input \(index) : \(BTCHexFromData(txHash))")
            
            if txHash == nil
            {
                print("tx hash not computed")
            }
            
            let signatureForScript = key?.signature(forHash: txHash, hashType: hashType)
            sigScript?.appendData(signatureForScript)
            sigScript?.appendData(Data.init(referencing: (key?.publicKey)!))

            
            let sig = signatureForScript?.subdata(in: Range.init(uncheckedBounds: (lower: 0, upper: (signatureForScript?.count)!-1)))
            
            assert((key?.isValidSignature(sig, hash: txHash))!, "Signature must be valid!")

            txin.signatureScript = sigScript;
        }
        
    
            let sm = BTCScriptMachine.init(transaction: transaction, inputIndex: 0)
            do
            {
                let v = try sm?.verify(withOutputScript: txouts[0].script)
            }
            catch let error as NSError
            {
                print(error)
                print("should verify first output!")
            }
        
        bci.broadcastTransactionData(data: NSData.init(data: transaction.data), error: nil)
 */
        
    }
    
    func start()
    {
        let progressView = ACProgressHUD.shared
        progressView.progressText = "generating wallet..."
        progressView.showHUD()
        
        perform(#selector(stop), with: nil, afterDelay: 3)
    }
    
    
    
    
    @objc func stop()
    {
        ACProgressHUD.shared.hideHUD()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
