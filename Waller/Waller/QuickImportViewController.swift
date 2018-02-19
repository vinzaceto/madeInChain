//
//  QuickImportViewController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 13/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

enum QRImportType
{
    case watchOnlyImport
    case fullWalletImport
}

protocol QuickImportDelegate
{
    func walletAdded(success: Bool)
}

class QuickImportViewController: UIViewController, SetupPageViewDelegate
{
    var canScan = true
    var borderImage:UIImageView!
    let gradientView:GradientView = GradientView()
    var importType:QRImportType = QRImportType.watchOnlyImport
    var address:String!
    var keychain:BTCKeychain!
    var label:String!
    var qrcodeView:UIView!
    var addNameView:SetNameView!
    var addPasswordView:SetPasswordView!
    var walletGeneratedView:WalletGeneratedView!
    @IBOutlet weak var backButton: UIButton!
    var delegate:QuickImportDelegate!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        backButton.isEnabled = false

        gradientView.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        if Props.colorSchemaClear {
            gradientView.FirstColor = Props().firstGradientColor
            gradientView.SecondColor = Props().secondGradientColor
        } else {
            gradientView.FirstColor = Props().firstGradientColorDark
            gradientView.SecondColor = Props().secondGradientColorDark
        }
        self.view.addSubview(gradientView)

        qrcodeView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        self.view.addSubview(qrcodeView)
        
        borderImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 280, height: 280))
        borderImage.image = UIImage.init(named: "QRBorders")
        borderImage.center.x = self.view.center.x
        borderImage.center.y = self.view.center.y + 70
        qrcodeView.addSubview(borderImage)
        
        let infoText = UILabel.init(frame:CGRect.init(x: 0, y:0, width: 280, height: 100))
        infoText.center.x = self.view.center.x
        infoText.frame.origin.y = borderImage.frame.origin.y - infoText.frame.size.height - 10
        infoText.textColor = UIColor.gray
        infoText.textAlignment = .center
        infoText.text = "Scan a QRCode to import a wallet as watch only or import a multisig or payment request created by another user."
        infoText.font = UIFont.systemFont(ofSize: 20)
        infoText.numberOfLines = 0
        qrcodeView.addSubview(infoText)
  
        addScannerView()
        
        addNameView = SetNameView.init(frame: CGRect.init(x: 0, y: 0,
        width: self.view.frame.size.width, height: self.view.frame.size.height))
        addNameView.frame.origin.x = self.view.frame.size.width
        self.view.addSubview(addNameView)
        addNameView.delegate = self
        
        addPasswordView = SetPasswordView.init(frame: CGRect.init(x: 0, y: 0,
        width: self.view.frame.size.width, height: self.view.frame.size.height))
        addPasswordView.generateButton.setTitle("set password", for: .normal)
        addPasswordView.frame.origin.x = self.view.frame.size.width
        self.view.addSubview(addPasswordView)
        addPasswordView.delegate = self
        
        walletGeneratedView = WalletGeneratedView.init(frame: CGRect.init(x: 0, y: 0,
        width: self.view.frame.size.width, height: self.view.frame.size.height))
        walletGeneratedView.infoText.text = "Your wallet has been imported correctly."
        walletGeneratedView.infoText2.text = "You will see it in the list now."
        self.view.addSubview(walletGeneratedView)
        walletGeneratedView.frame.origin.x = self.view.frame.size.width
        walletGeneratedView.delegate = self
        
    }
    
    func addScannerView()
    {
        let scannerView = BTCQRCode.scannerView
        {
            (message) in
            
            if self.canScan == false {return}
            
            guard let msg = message else { return }
            
            if let  btcurl = BTCBitcoinURL.init(url: URL.init(string: msg))
            {
                // check bitcoin address as valid BTCBitcoinUrl
                if btcurl.isValid
                {
                    print(btcurl.address!)
                    self.canScan = false
                    print("WALLET FOUND : \(String(describing: btcurl.address?.string))")
                    self.addressFounded(address: (btcurl.address?.string)!)
                    return
                }
            }

            // check private key with xprv prefix
            if msg.hasPrefix("xprv")
            {
                guard let keychain = BTCKeychain.init(extendedKey: msg) else { print("wrong private"); return  }
                self.canScan = false
                print("PRIV KEY FOUND : \(keychain.extendedPrivateKey))")
                self.privateKeyFounded(keychain: keychain)
            }
        }
        
        scannerView?.frame = CGRect.init(x: 0, y: 0, width: 250, height: 250)
        scannerView?.center = borderImage.center
        qrcodeView.addSubview(scannerView!)
    }
    
    func nameSetted(name: String)
    {
        print("nameSetted: \(name)")
        self.label = name
        
        switch self.importType
        {
            case QRImportType.watchOnlyImport:
                importWatchOnlyAddress()
            
            case QRImportType.fullWalletImport:
                goToPasswordView()
        }
    }
    
    func passwordSetted(pass: String)
    {
        print("pass setted: \(pass)")
        
        switch self.importType
        {
            case QRImportType.watchOnlyImport:
                importWatchOnlyAddress()
         
            case QRImportType.fullWalletImport:
                importFullWallet(pass:pass)
         }
    }
    
    func completedButtonPressed()
    {
        print("completedButtonPressed")
        dismiss(animated: true)
        {guard let _ = self.delegate?.walletAdded(success: true) else {return}}
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func importWatchOnlyAddress()
    {
        let walletGenerator = WalletsGenerator.init()
        walletGenerator.importWatchOnly(name: self.label, address: self.address)
        {
            (success, error) in
            if success == true
            {
                print("Wallet imported")
                self.goToCompleteView()
            }
            else
            {
                print("error while importing the wallet")
            }
        }
    }
    
    func importFullWallet(pass:String)
    {
        let walletGenerator = WalletsGenerator.init()
        walletGenerator.importFullWallet(name: self.label, pass: pass, keychain: keychain)
        {
            (success, error) in
            if success == true
            {
                print("Wallet imported")
                self.goToCompleteView()
            }
            else
            {
                print("error while importing the wallet")
            }
        }
    }
    
    
    
    
    
    
    
    @objc func goToSetNameView()
    {
        addNameView.nameField.becomeFirstResponder()
        backButton.isEnabled = true
        UIView.animate(withDuration: 0.5)
        {
            self.qrcodeView.frame.origin.x =  -self.view.frame.size.width
            self.addNameView.frame.origin.x =  0
        }
    }
    
    func goToPasswordView()
    {
        backButton.removeTarget(nil, action: nil, for: .allEvents)
        backButton.addTarget(self, action: #selector(backToNameView), for: .touchUpInside)
        
        addPasswordView.passField.textField.becomeFirstResponder()
        UIView.animate(withDuration: 0.5)
        {
            self.addNameView.frame.origin.x =  -self.view.frame.size.width
            self.addPasswordView.frame.origin.x =  0
        }
    }
    
    func goToCompleteView()
    {
        backButton.isEnabled = false
        addPasswordView.passField.textField.resignFirstResponder()
        addPasswordView.retypePassField.textField.resignFirstResponder()
        UIView.animate(withDuration: 0.5)
        {
            self.addPasswordView.frame.origin.x =  -self.view.frame.size.width
            self.addNameView.frame.origin.x =  -self.view.frame.size.width
            self.walletGeneratedView.frame.origin.x =  0
        }
    }
    
    @objc func backToNameView()
    {
        backButton.removeTarget(nil, action: nil, for: .allEvents)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        addPasswordView.passField.textField.text = ""
        addPasswordView.retypePassField.textField.text = ""
        
        addNameView.nameField.becomeFirstResponder()
        UIView.animate(withDuration: 0.5)
        {
            self.addPasswordView.frame.origin.x =  self.view.frame.size.width
            self.addNameView.frame.origin.x =  0
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.canScan = true
        backButton.isEnabled = false
        UIView.animate(withDuration: 0.5)
        {
            self.qrcodeView.frame.origin.x =  0
            self.addNameView.frame.origin.x =  self.view.frame.size.width
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func addressFounded(address: String)
    {
        self.address = address
        let alert = EMAlertController(title: "Address found", message: address)
        let cancel = EMAlertAction(title: "Cancel", style: .cancel){self.canScan = true}
        let confirm = EMAlertAction(title: "Import", style: .normal)
        {
            self.importType = QRImportType.watchOnlyImport
            self.perform(#selector(self.goToSetNameView), with: nil, afterDelay: 0.5)
        }
        alert.addAction(action: cancel)
        alert.addAction(action: confirm)
        alert.buttonSpacing = 0
        present(alert, animated: true, completion: nil)
    }
    
    func privateKeyFounded(keychain:BTCKeychain)
    {
        let msg = "A private key was founded, do you want to import the wallet as full wallet or do you want to add it as watch only?"
        let alert = EMAlertController(title: "Private key found", message: msg)
        let watchOnly = EMAlertAction(title: "Watch only", style: .normal)
        {
            self.importType = QRImportType.watchOnlyImport
            self.address = keychain.extendedPrivateKey
            self.perform(#selector(self.goToSetNameView), with: nil, afterDelay: 0.5)
        }
        let fullWallet = EMAlertAction(title: "Full wallet", style: .normal)
        {
            self.importType = QRImportType.fullWalletImport
            self.keychain = keychain
            self.perform(#selector(self.goToSetNameView), with: nil, afterDelay: 0.5)
        }
        let cancel = EMAlertAction(title: "Cancel", style: .cancel){self.canScan = true}
        alert.addAction(action: watchOnly)
        alert.addAction(action: fullWallet)
        alert.addAction(action: cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func addressIsAlreadyPresent(address:String)
    {
        let alert = EMAlertController(title: "Address already listed", message: address)
        let close = EMAlertAction(title: "Close", style: .cancel){self.canScan = true}
        alert.addAction(action: close)
        alert.buttonSpacing = 0
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any)
    {dismiss(animated: true, completion: nil)}

    override func didReceiveMemoryWarning()
    {super.didReceiveMemoryWarning()}
    
    // Unused
    func addtypeSelected(selectedType: AddType) {}
    func changeAddressForMultisigButtonPressed() {}
    func importTypeSelected(selectedType: ImportType) {}
    func keychainImported(btcKeychain: BTCKeychain) {}
    func saveTypeSelected(selectedType: SaveType) {}
    func confirmMnemonic(mnemonic: String) {}
    func mnemonicConfiremed(mnemonic: String) {}
}
