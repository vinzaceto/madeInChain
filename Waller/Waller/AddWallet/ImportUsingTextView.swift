//
//  ImportUsingTextView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 13/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class ImportUsingTextView: UIView {

    var textField:UITextView!
    var delegate:SetupPageViewDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = Props().addViewsBackgroundColor

        let infoText = UILabel.init(frame:CGRect.init(x: 0, y:0, width: 280, height: 130))
        infoText.center.x = self.center.x
        infoText.center.y = self.center.y - 140
        infoText.textColor = UIColor.gray
        infoText.textAlignment = .center
        infoText.text = "Type a private key or a mnemonic in the field below to import a wallet. Remember mnemonic are 12 word long"
        infoText.font = UIFont.systemFont(ofSize: 20)
        infoText.numberOfLines = 0
        self.addSubview(infoText)
        
        let mY = infoText.frame.origin.y + infoText.frame.size.height + 20
        
        textField = UITextView.init(frame: CGRect.init(x: 0, y: mY, width: 260, height: 70))
        textField.center.x = self.center.x
        textField.backgroundColor = UIColor .white.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.textAlignment = .center
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.textColor = UIColor.lightText
        self.addSubview(textField)
        
        let by = textField.frame.origin.y + textField.frame.size.height + 10
        
        let confirmButton = UIButton.init(type: .roundedRect)
        confirmButton.frame = CGRect.init(x: 0, y: by, width: 120, height: 30)
        confirmButton.addTarget(self, action: #selector(checkText), for: .touchUpInside)
        confirmButton.center.x = self.center.x
        confirmButton.setTitle("import", for: .normal)
        self.addSubview(confirmButton)
    }
    
    @objc func checkText()
    {
        guard let text = textField.text else { failedToImport();return }
        
        if text.count <= 0 {failedToImport();return}
        
        let userMnemonic = text.replacingOccurrences(of: " ", with: ",").lowercased()
        let userMnemonicArray = userMnemonic.components(separatedBy: [",","\n"])
        if userMnemonicArray.count == 12
        {
            importFromMnemonic(mnemonic:userMnemonicArray)
        }
        else
        {
            print("Priv key inserted")
            importFromPrivKey(privKey:text)
        }
    }
    
    func failedToImport()
    {
        print("fail to import")
    }
    
    func importFromMnemonic(mnemonic:[String])
    {
        print("import from mnemonic")
        print(mnemonic)
        
        let m = BTCMnemonic.init(words: mnemonic, password: "", wordListType: BTCMnemonicWordListType.english)
        guard let keychain = m?.keychain else { print("wrong mnemonic");return }
        keychainImported(btcKeychain:keychain )
    }

    func importFromPrivKey(privKey:String)
    {
        print("import from private key")
        print(privKey)
        
        guard let keychain = BTCKeychain.init(extendedKey: privKey) else { print("wrong private"); return  }
        keychainImported(btcKeychain:keychain )
    }
    
    
    func keychainImported(btcKeychain:BTCKeychain)
    {
        print("key imported")
        guard let _ = self.delegate?.keychainImported(btcKeychain: btcKeychain)
        else { return }
    }
    
    
    
    
    
   
    
    @objc func confirmButtonPressed()
    {
//        guard let _ = self.delegate?.confirmMnemonic(mnemonic:mnemonicLabel.text!)
//            else { return }
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
