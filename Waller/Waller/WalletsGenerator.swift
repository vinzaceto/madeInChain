//
//  WalletsGenerator.swift
//  Waller
//
//  Created by Vincenzo Ajello on 12/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class WalletsGenerator: NSObject
{
    func generateMnemonic(completionHandler: @escaping (Bool, [String]?) -> Void)
    {
        let seed = UUID().uuidString.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        let entropy = BTCDataFromHex(seed)
        let mnemonic = BTCMnemonic.init(entropy: entropy, password: "", wordListType: BTCMnemonicWordListType.english)
        print("mnemonic : \(String(describing: mnemonic?.words))")
        
        let keychain = mnemonic?.keychain
        print("address : \(keychain?.key.addressTestnet)")
        print("pubKey : \(keychain?.extendedPublicKey)")
        
        if let words = mnemonic?.words
        {
            var w:[String] = []
            for word in words
            {
                guard let gw:String = word as? String else
                {
                    completionHandler(false, nil)
                    return
                }
                w.append(gw)
            }
            completionHandler(true, w)
        }
        
        completionHandler(false, nil)
        return
    }
    
    func generateWallet(name:String, pass:String, completionHandler: @escaping (Bool, String?) -> Void)
    {
        print("Generating wallet with name :  \(name) and pass : \(pass)")
        
        // mnemonic
        let seed = UUID().uuidString.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        print("seed : \(seed)")
        
        let entropy = BTCDataFromHex(seed)
        let mnemonic = BTCMnemonic.init(entropy: entropy, password: pass, wordListType: BTCMnemonicWordListType.english)
        print("mnemonic : \(mnemonic?.words)")
        
        let keychain = mnemonic?.keychain
        print("address : \(keychain?.key.addressTestnet)")
        print("pubKey : \(keychain?.extendedPublicKey)")
        print("privKey : \(keychain?.extendedPrivateKey)")
        
        // Private key encryption
        let encryptedPrivateKey = encrypt(privateKey: (keychain?.extendedPrivateKey)!, pass: pass)
        print("encrypted PrivateKey : \(encryptedPrivateKey.base64EncodedString())")
        
        let fullWallet = FullWallet.init(label: name, address: (keychain?.key.addressTestnet.string)!, encryptedPrivatekey: encryptedPrivateKey.base64EncodedString())
        print(fullWallet)
        
        let walletsKeychain = WalletsDatabase.init()
        walletsKeychain.saveFullWallet(fullWallet: fullWallet)
        {
            (success, error) in
            print(error)
        }
        
        /*
         // Decryption
         do
         {
         let originalData = try RNCryptor.decrypt(data: ciphertext, withPassword: pass)
         print("original data : \(originalData.base64EncodedString())")
         
         let originalPrivateKey = originalData.base64EncodedString()
         print("decrypted priv key : \(String.init(data: originalData, encoding: String.Encoding.utf8))")
         }
         catch
         {
         print("decrypt error : \(error)")
         }
         */
        
        
        /*
         let fullWallet = FullWallet.init(label: name, address: (keychain?.key.addressTestnet.string)!, privkey: keychain?.extendedPrivateKey)
         print(fullWallet)
         
         //Create JSON
         let encodeWallet = try? JSONEncoder().encode(fullWallet)
         var json: Any?
         if let data = encodeWallet
         {
         json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
         }
         
         //Print JSON Object
         
         var walletJson:Any?
         if let j = json
         {
         walletJson = j
         print("Wallet JSON:\(String(describing: walletJson))")
         }
         
         let walletJsonData = jsonToNSData(json: walletJson)
         print(walletJsonData?.base64EncodedString())
         */
        
        /*
         // Encryption
         let data: Data = Data.in
         let ciphertext = RNCryptor.encrypt(data: data, withPassword: pass)
         print("encrypted json : \(ciphertext)")
         
         
         // Decryption
         do
         {
         let originalData = try RNCryptor.decrypt(data: ciphertext, withPassword: pass)
         print("decrypted json : \(originalData)")
         }
         catch
         {
         print("decrypt error : \(error)")
         }
         
         
         */
        
        /*
         print()
         
         let msp = BTCMnemonic.init(words: mnemonic?.words, password: "", wordListType: BTCMnemonicWordListType.english)
         print("mnemonic w/o pass : \(msp?.words)")
         print("address : \(msp?.keychain?.key.addressTestnet)")
         print("pubKey : \(msp?.keychain?.extendedPublicKey)")
         print("privKey : \(msp?.keychain?.extendedPrivateKey)")
         
         
         print()
         
         
         let m = BTCMnemonic.init(words: msp?.words, password: "passpass", wordListType: BTCMnemonicWordListType.english)
         print("mnemonic w pass : \(m?.words)")
         print("address : \(m?.keychain?.key.addressTestnet)")
         print("pubKey : \(m?.keychain?.extendedPublicKey)")
         print("privKey : \(m?.keychain?.extendedPrivateKey)")
         */
        
        
        
        
        //
        // {"addresses":[{"address":"1E5PAuSJJA3FZn8kt17CnSDdXqF1wbpM3v","privkey":"5JiRi5aw1bd2pgXrsWoUhUEN93gdk65X1GRE6VRvXupQRvoYjsu"}]}
        
        //        seed : DB045048DB5543148F478B182439C240
        //        seed : Optional([swallow, card, banana, repeat, feature, medal, dial, vapor, blouse, canyon, identify, liberty])
        //        address : Optional(<BTCPublicKeyAddressTestnet: mfnXaPxFYszopKMVeZGyJdV3ewTa8LfoFg>)
        // pubKey Optional("xpub661MyMwAqRbcFK1MVVLPYSU7KDd12bt9QYwf5MWgnfU5NzMTTSz6wu6gw2wmuoKRu9kU2HdJgyFcseZzzZA2oAzCiKYJ3kCobHrGmPw9yfC")
        //        privKey : Optional("xprv9s21ZrQH143K2pvtPToPBJXNmBnWd9AJ3L24Gy75EKw6WC2JuufrQ6nD5jB76fxVg7vUXXmtPYkHZ4YkycskBNzWrx7YBZYJy5JbcTrresX")
        
        
        
        completionHandler(true, nil)
    }
    
    func encrypt(privateKey:String, pass:String) -> Data
    {
        // string encoding to data
        let data = privateKey.data(using: String.Encoding.utf8)
        //print("PrivateKeyData : \(data?.base64EncodedString())")
        
        // private key encryption
        let ciphertext = RNCryptor.encrypt(data: data!, withPassword: pass)
        //print("encrypted PrivateKey : \(ciphertext.base64EncodedString())")
        
        return ciphertext
    }

}
