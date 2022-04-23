//
//  SignView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 25/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

enum SignType
{
    case signTypePassword
    case signTypeMnemonic
}

protocol SignViewDelegate
{
    func transactionBroadcast(success:Bool)
}

class SignView: UIView
{
    var totalLabel:UILabel!
    var passwordField:PWTextField!
    var slider:MMSlidingButton!
    let signButton = UIButton.init(type: .roundedRect)
    var delegate:SignViewDelegate!
    var unsignedTX:UnsignedBTCTransaction!
    var wallet:Wallet!

    var lockWrite:Bool = false
    var passTemporaryText:String = ""
    var temporaryPlaceholder:NSAttributedString!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        debugPrint("XXX: Here ")

        
        backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        layer.cornerRadius = 6
        clipsToBounds = true
        
        let infoLabel = UILabel.init(frame: CGRect.init(x: 30, y: 60, width: self.frame.size.width - 60, height: 60))
        infoLabel.backgroundColor = UIColor.clear
        infoLabel.text = "This is a recap of your transaction, please insert your password to sign and broadcast it to the network."
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.textColor = UIColor.lightGray
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        self.addSubview(infoLabel)
        
        totalLabel = UILabel.init(frame: CGRect.init(x: 20, y:135, width: self.frame.size.width-40, height: 30))
        totalLabel.text = "Total = 1.000 BTC"
        totalLabel.adjustsFontSizeToFitWidth = true
        totalLabel.textAlignment = .center
        self.addSubview(totalLabel)
        
        passwordField = PWTextField.init(frame: CGRect.init(x: 30, y: 180, width: self.frame.size.width - 60, height: 35))
        changePlaceholderColor(field: passwordField.textField, color: UIColor.lightText, text: "type the password here")
        passwordField.showButton.tintColor = UIColor.gray
        self.addSubview(passwordField)
        
        signButton.frame = CGRect.init(x: (self.frame.size.width-160)/2, y: passwordField.frame.origin.y+45, width: 160, height: 35)
        signButton.addTarget(self, action: #selector(checkPasswords), for: .touchUpInside)
        signButton.setTitle("sign and broadcast", for: .normal)
        self.addSubview(signButton)
        
        /*
        slider = MMSlidingButton.init(frame: CGRect.init(x:20, y: 250, width: self.frame.size.width - 40, height: 60))
        slider.buttonText = "Slide to Send >>>"
        slider.buttonCornerRadius = 6
        slider.buttonUnlockedText = "Transaction created"
        slider.buttonColor = UIColor.gray
        slider.animationFinished()
        slider.dragPointWidth = 60
        slider.isUserInteractionEnabled = true
        //slider.delegate = self
        self.addSubview(slider)
        */
    }
    
    
    
    
    @objc func checkPasswords()
    {
        print("check password")
        
        guard let p = passwordField.textField.text else { return }
        
        // check for empty pass
        if p.trimmingCharacters(in: .whitespaces).isEmpty
        {
            print("password empty!!!!")
            printErrorOnField(error: "The password is empty!", field: passwordField.textField)
            return
        }
        
        print("decrypt w password : \(p)")
        
        let data = Data.init(base64Encoded: wallet.privatekey, options: .ignoreUnknownCharacters)
        guard let privateKey = decrypt(data: data!, pass: p) else
        {
            printErrorOnField(error: "wrong password", field: passwordField.textField)
            return
        }
        
        guard let keychain = BTCKeychain.init(extendedKey: privateKey) else
        {
            printErrorOnField(error: "wrong key", field: passwordField.textField)
            return
        }
        
        print("decrypted \(privateKey)")
        
        let api = BitcoinTransaction.init()
        api.signTransaction(unsignedTX: unsignedTX, key: keychain.key)
        {
            (success, error, signedTransactions) in
            if success == true
            {
                print("transaction signed")
                print("RAW SIGNED TRANSACTION : \(BTCHexFromData(signedTransactions?.data))")
                
                let network = BTCTestnetInfo.init()
                network.broadcastTransactionData(data: (signedTransactions?.data)!, completion:
                {
                    (success, error) in
                    if success == true
                    {
                        DispatchQueue.main.async
                        {
                            guard let _ = self.delegate?.transactionBroadcast(success: true) else {return}
                        }
                    }
                    else
                    {
                        print("fail to broadcast the transaction : \(error)")
                        DispatchQueue.main.async
                        {
                            self.printErrorOnField(error: "unable to broadcast", field: self.passwordField.textField)
                        }
                    }
                })
            }
            else
            {
                print("fail to sign the transaction : \(error)")
                DispatchQueue.main.async
                {
                    self.printErrorOnField(error: "unable to sign", field: self.passwordField.textField)
                }                
                return
            }
        }
    }
    
    
    
    
    
    
    

    
    
    
    
    func decrypt(data:Data, pass:String) -> String?
    {
        print("original data : \(data.base64EncodedString())")
        
        do
        {
            let originalData = try RNCryptor.decrypt(data: data, withPassword: pass)
            let originalPrivateKey = String.init(data: originalData, encoding: String.Encoding.utf8)
            return originalPrivateKey
        }
        catch
        {
            return nil
        }
    }
    
    func printErrorOnField(error:String, field:UITextField)
    {
        if lockWrite == true
        {
            return
        }
        
        guard let pass = field.text else { return }
        guard let placeholder = field.attributedPlaceholder else { return }
        
        lockWrite = true
        
        passTemporaryText = pass
        temporaryPlaceholder = passwordField.textField.attributedPlaceholder
        
        field.text = ""
        changePlaceholderColor(field: field, color: UIColor.orange, text: error)
        
        perform(#selector(resetField(field:)), with: field, afterDelay: 2)
    }
    
    @objc func resetField(field:UITextField)
    {
        lockWrite = false
        field.text = passTemporaryText
        field.attributedPlaceholder = temporaryPlaceholder
        passTemporaryText = ""
        temporaryPlaceholder = nil
    }
    
    func changePlaceholderColor(field:UITextField, color:UIColor, text:String?)
    {
        var p = field.placeholder
        if text != nil{p = text}
        let attrPlaceholder = NSAttributedString(string: p!, attributes: [NSAttributedStringKey.foregroundColor: color])
        field.attributedPlaceholder = attrPlaceholder
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
