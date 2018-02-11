//
//  WalletGenerationView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 09/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class WalletGenerationView: UIView
{

    var delegate:SetupPageViewDelegate!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        let infoText = UILabel.init(frame:CGRect.init(x: 0, y:120, width: 280, height: 75))
        infoText.center.x = self.center.x
        infoText.textColor = UIColor.gray
        infoText.textAlignment = .center
        infoText.text = "Your wallet has been successfully generated and stored on this device."
        infoText.font = UIFont.systemFont(ofSize: 20)
        infoText.numberOfLines = 0
        self.addSubview(infoText)
        
        let doneImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 130, height: 130))
        doneImage.image = UIImage.init(named: "done")
        doneImage.alpha = 0.1
        doneImage.frame.origin.y = infoText.frame.origin.y + infoText.frame.size.height + 10
        doneImage.center.x = self.center.x
        self.addSubview(doneImage)
        
        let y = doneImage.frame.origin.y + doneImage.frame.size.height + 10
        
        let infoText2 = UILabel.init(frame:CGRect.init(x: 0, y:y, width: 280, height: 100))
        infoText2.center.x = self.center.x
        infoText2.textColor = UIColor.gray
        infoText2.textAlignment = .center
        infoText2.text = "Remember you to use the export feature to make a backup or share this wallet on other devices."
        infoText2.font = UIFont.systemFont(ofSize: 20)
        infoText2.numberOfLines = 0
        self.addSubview(infoText2)
        
        let by = infoText2.frame.origin.y + infoText2.frame.size.height + 30

        let completeButton = UIButton.init(type: .roundedRect)
        completeButton.frame = CGRect.init(x: 0, y: by, width: 160, height: 40)
        completeButton.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
        completeButton.center.x = self.center.x
        completeButton.layer.borderWidth = 3
        completeButton.layer.borderColor = UIColor.gray.cgColor
        completeButton.layer.cornerRadius = 8
        completeButton.setTitle("complete", for: .normal)
        self.addSubview(completeButton)

    }
    
    func gererateWallet(name:String, pass:String, completionHandler: @escaping (Bool, String?) -> Void)
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
        
        let walletsKeychain = WalletsKeychain.init()
        walletsKeychain.saveWallet(fullWallet: fullWallet)
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
    
    
    
    // Convert from NSData to json object
    func nsdataToJSON(data: Data) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    // Convert from JSON to nsdata
    func jsonToNSData(json: Any) -> Data?{
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
        
    @objc func completeButtonPressed()
    {
        guard let _ = self.delegate?.completedButtonPressed()
        else { return }
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
