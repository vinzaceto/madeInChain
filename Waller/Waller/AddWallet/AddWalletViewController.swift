//
//  AddWalletViewController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 08/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

protocol SetupPageViewDelegate
{
    func addtypeSelected(selectedType:AddType)
    func nameSetted(name:String)
    func saveTypeSelected(selectedType:SaveType)
    func passwordSetted(pass:String)
    func confirmMnemonic(mnemonic:String)
    func mnemonicConfiremed(mnemonic:String)
    func completedButtonPressed()
    func changeAddressForMultisigButtonPressed()
    func importTypeSelected(selectedType: ImportType)
    func keychainImported(btcKeychain: BTCKeychain)
}

protocol AddWalletViewControllerDelegate
{
    func walletAdded(success:Bool)
}

class AddWalletViewController: UIViewController,SetupPageViewDelegate {    
    
    var addTypeView:AddTypeView!
    var addNameView:SetNameView!
    var addSaveType:SetSaveTypeView!
    var addPasswordView:SetPasswordView!
    
    var mnemonicView:MnemonicView!
    var mnemonicConfirmView:MnemonicConfirmView!
    
    var setAddressView:SetAddressForMultisigView!
    
    var walletGeneratedView:WalletGeneratedView!
    
    var setImportTypeView:SetImportTypeView!
    var importUsingTextView:ImportUsingTextView!
    var importUsingQRCodeView:ImportUsingQRCodeView!

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var views:[UIView] = []
    
    var delegate:AddWalletViewControllerDelegate!
    
    var walletLabel:String!
    var addType:AddType!
    var saveType:SaveType!
    var importType:ImportType!
    var importedKeychain:BTCKeychain!
    
    let gradientView:GradientView = GradientView()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        gradientView.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        if Props.colorSchemaClear {
            gradientView.FirstColor = Props().firstGradientColor
            gradientView.SecondColor = Props().secondGradientColor
        } else {
            gradientView.FirstColor = Props().firstGradientColorDark
            gradientView.SecondColor = Props().secondGradientColorDark
        }
        self.view.addSubview(gradientView)
        
        setupViews()
        
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.sizeToFit()
        backButton.isEnabled = false
    }
    
    //
    // MARK:  SetupPageViewDelegate - Delegates
    //
    
    func addtypeSelected(selectedType: AddType)
    {
        addType = selectedType
        if selectedType == AddType.Standard
        {
            addNameView.infoText.text = "You are creating a new wallet, give a name to it to continue."
            goToSetNameView()
        }
        if selectedType == AddType.Multisig
        {
            goToSetMultisigView()
        }
        if selectedType == AddType.Import
        {
            goToSetImportTypeView()
        }
    }
    
    func nameSetted(name: String)
    {
        print("selected name : \(name)")
        walletLabel = name
        if addType == AddType.Standard
        {
            goToSetSaveType()
        }
        if addType == AddType.Import
        {
            goToSetPassword()
        }
    }
    
    func saveTypeSelected(selectedType: SaveType)
    {
        saveType = selectedType
        if selectedType == SaveType.Local
        {
            goToSetPassword()
        }
        if selectedType == SaveType.Mnemonic
        {
            goToMnemonicView()
        }
    }
    
    func passwordSetted(pass: String)
    {
        print("password : \(pass)")
        
        let walletGenerator = WalletsGenerator.init()
        
        if addType == AddType.Standard
        {
            walletGenerator.generateWallet(name: walletLabel, pass: pass)
            {
                (success, error) in
                if success == true
                {
                    self.walletGeneratedView.infoText.text = "Your wallet has been successfully generated and stored on this device."
                    self.walletGeneratedView.infoText2.text = "Remember you to use the export feature to make a backup or share this wallet on other devices."
                    self.goToWalletGeneratedView()
                }
                else
                {
                    print("WalletGenerationFailed reason : \(String(describing: error))")
                }
            }
        }
        
        if addType == AddType.Import
        {
            walletGenerator.importFullWallet(name: walletLabel, pass: pass, keychain: importedKeychain)
            {
                (success, error) in
                if success == true
                {
                    self.goToWalletImportedView()
                }
                else
                {
                    print("import fail")
                }
            }
        }
    }
    
    func confirmMnemonic(mnemonic: String)
    {
        goToConfirmMnemonicView(mnemonic: mnemonic)
    }
    
    func mnemonicConfiremed(mnemonic:String)
    {
        print("mnemonic confirmed : \(mnemonic)")
        let mnemonicArray = mnemonic.components(separatedBy: " ")
        
        let m = BTCMnemonic.init(words: mnemonicArray, password: "", wordListType: BTCMnemonicWordListType.english)
        let keychain = m?.keychain
        let addr = keychain?.key.addressTestnet.string
        
        let coldWallet = Wallet.init(label: walletLabel, address: addr!, privatekey: nil)
        
        let walletsDatabase = WalletsDatabase.init()
        if walletsDatabase.checkIfAlreadyListed(address: addr!) == true
        {
            addressIsAlreadyPresent(address: addr!)
            return
        }
        
        walletsDatabase.saveWallet(wallet: coldWallet)
        {
            (success, error) in
            print("cold wallet saved")
            self.walletGeneratedView.infoText.text = "Your cold wallet has been successfully generated."
            self.walletGeneratedView.infoText2.text = "Remember to store your mnemonic key in a safe place. There is no way to recover your wallet without it"
            self.goToWalletGeneratedView()
        }
    }
    
    func importTypeSelected(selectedType: ImportType)
    {
        importType = selectedType
        if selectedType == ImportType.Text
        {
            goToImportUsingTextView()
        }
        if selectedType == ImportType.QRCode
        {
            goToImportUsingQRCodeView()
        }
    }
    
    func keychainImported(btcKeychain: BTCKeychain)
    {
        importedKeychain = btcKeychain
        addNameView.infoText.text = "You are importing a new wallet, give a name to it to continue."
     
        let db = WalletsDatabase.init()
        if db.checkIfAlreadyListed(address: importedKeychain.key.addressTestnet.string) == true
        {
            addressIsAlreadyPresent(address: importedKeychain.key.addressTestnet.string)
            return
        }
        
        goToSetNameView()
    }
    
    func importWallet(keychain:BTCKeychain,name:String,pass:String)
    {
        let walletGenerator = WalletsGenerator.init()
        walletGenerator.importFullWallet(name: name, pass: pass, keychain: keychain)
        {
            (success, error) in
            if success == true
            {
                self.goToWalletImportedView()
            }
            else
            {
                print("import fail")
            }
        }
    }
    
    func changeAddressForMultisigButtonPressed()
    {
        let w1 = (label:"name 1",address:"1BoatSLRHtKNngkdXEeobR76b53LETtpyT")
        let w2 = (label:"name 2",address:"1BoatSLRHtKNngkdXEeobR76b53LETtpyT")
        let w3 = (label:"name 3",address:"1BoatSLRHtKNngkdXEeobR76b53LETtpyT")
        let w4 = (label:"name 4",address:"1BoatSLRHtKNngkdXEeobR76b53LETtpyT")
        let items = [w1, w2, w3, w4]
        let params = Parameters(title: "Select address...", items: items, cancelButton: "Cancel")
        
        SelectItemController().show(parent: self, params: params)
        {
            (index) in
            if let index = index
            {
                print("selected: \(items[index])")
                self.setAddressView.setAddress(name: items[index].label, address: items[index].address)
            }
            else
            {
                print("cancel")
            }
        }
    }

    //
    // MARK: Navigation
    //
    
    func goToSetNameView()
    {
        addNameView.nameField.text = ""
        views.append(addNameView)
        showNextView()
    }
    
    func goToSetSaveType()
    {
        views.append(addSaveType)
        showNextView()
    }
  
    func goToSetPassword()
    {
        views.append(addPasswordView)
        addPasswordView.passField.textField.text = ""
        addPasswordView.retypePassField.textField.text = ""
        showNextView()
    }
    
    func goToWalletGeneratedView()
    {
        closeButton.isEnabled = false
        backButton.isEnabled = false
        views.append(walletGeneratedView)
        showNextView()
    }
    
    func goToMnemonicView()
    {
        let walletsGenerator = WalletsGenerator.init()
        walletsGenerator.generateMnemonic
        {
            (success, mnemonic) in
            if success == true
            {
                print("mnemonic generated : \(String(describing: mnemonic))")
                self.mnemonicView.mnemonicLabel.text = mnemonic?.joined(separator: " ")
                self.views.append(self.mnemonicView)
                self.showNextView()
            }
            else
            {
                print("error while generating mnemonic")
            }
        }
    }
    
    func goToConfirmMnemonicView(mnemonic:String)
    {
        print("mnemonic to confirm : \(mnemonic)")
        mnemonicConfirmView.rightMnemonic = mnemonic
        mnemonicConfirmView.mnemonicLabel.text = ""
        views.append(mnemonicConfirmView)
        showNextView()
    }
    
    func goToSetImportTypeView()
    {
        backButton.isEnabled = true
        views.append(setImportTypeView)
        showNextView()
    }
    
    func goToImportUsingTextView()
    {
        views.append(importUsingTextView)
        importUsingTextView.textField.text = ""
        showNextView()
    }
    
    func goToImportUsingQRCodeView()
    {
        views.append(importUsingQRCodeView)
        showNextView()
    }
    
    func goToWalletImportedView()
    {
        self.walletGeneratedView.infoText.text = "Your wallet has been successfully imported and stored on this device."
        self.walletGeneratedView.infoText2.text = "Remember you to use the export feature to make a backup or share this wallet on other devices."
        self.goToWalletGeneratedView()
    }
    
    func goToSetMultisigView()
    {
        backButton.isEnabled = true
        setAddressView.setDefault()
        views.append(setAddressView)
        showNextView()
    }

    //
    // MARK: Nav bar Navigation
    //
    
    func completedButtonPressed()
    {
        guard let _ = self.delegate?.walletAdded(success: true)
        else { return }
        close()
    }

    @objc func backButtonPressed()
    {
        showPreviousView()
    }
    
    
    //
    // MARK: Utility
    //
    
    func showNextView()
    {
        backButton.isEnabled = true
        
        let currentIndex = views.count - 2
        let nextIndex = views.count - 1
        
        let currentView = views[currentIndex]
        let nextView = views[nextIndex]
        
        if nextView == addNameView
        {
            addNameView.nameField.becomeFirstResponder()
        }
        
        if nextView == addPasswordView
        {
            addPasswordView.passField.textField.becomeFirstResponder()
        }
        
        if nextView == mnemonicConfirmView
        {
            mnemonicConfirmView.mnemonicLabel.becomeFirstResponder()
        }
        
        if nextView == importUsingTextView
        {
            importUsingTextView.textField.becomeFirstResponder()
        }
        
        if nextView == walletGeneratedView
        {
            backButton.isEnabled = false
            addNameView.nameField.resignFirstResponder()
            addPasswordView.passField.textField.resignFirstResponder()
            addPasswordView.retypePassField.textField.resignFirstResponder()
            mnemonicConfirmView.mnemonicLabel.resignFirstResponder()
        }
        
        nextView.frame.origin.x = self.view.frame.size.width
        self.view.addSubview(nextView)
        
        self.view.bringSubview(toFront: backButton)
        
        UIView.animate(withDuration: 0.5)
        {
            currentView.frame.origin.x = 0 - currentView.frame.size.width
            nextView.frame.origin.x = 0
        }
    }
    
    func showPreviousView()
    {
        let currentIndex = views.count - 1
        let previousIndex = views.count - 2

        
        addNameView.nameField.resignFirstResponder()
        addPasswordView.passField.textField.resignFirstResponder()
        addPasswordView.retypePassField.textField.resignFirstResponder()
        mnemonicConfirmView.mnemonicLabel.resignFirstResponder()

        if views.count < 2
        {
            return
        }
        if views.count == 2
        {
            backButton.isEnabled = false
            walletLabel = ""
        }
        
        let currentView = views[currentIndex]
        let previousView = views[previousIndex]
        
        if previousView == addNameView
        {
            addNameView.nameField.becomeFirstResponder()
        }
        if previousView == addPasswordView
        {
            addPasswordView.passField.textField.becomeFirstResponder()
        }
        if previousView == setImportTypeView
        {
            importUsingTextView.textField.resignFirstResponder()
        }
        
        UIView.animate(withDuration: 0.5, animations:
            {
                currentView.frame.origin.x = self.view.frame.size.width
                previousView.frame.origin.x = 0
        })
        { (completed) in
            
            currentView.removeFromSuperview()
            self.views.remove(at: currentIndex)
        }
    }
    
    
    func setupViews()
    {
        
        addTypeView = AddTypeView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        addTypeView.delegate = self
        
        self.view.addSubview(addTypeView)
        views.append(addTypeView)
        
        addNameView = SetNameView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        addNameView.delegate = self
        
        addSaveType = SetSaveTypeView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        addSaveType.delegate = self
        
        addPasswordView = SetPasswordView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        addPasswordView.delegate = self
        
        walletGeneratedView = WalletGeneratedView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        walletGeneratedView.delegate = self
        
        mnemonicView = MnemonicView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        mnemonicView.delegate = self
        
        mnemonicConfirmView = MnemonicConfirmView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        mnemonicConfirmView.delegate = self
        
        setAddressView = SetAddressForMultisigView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        setAddressView.delegate = self
        
        setImportTypeView = SetImportTypeView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        setImportTypeView.delegate = self
        
        importUsingTextView = ImportUsingTextView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        importUsingTextView.delegate = self
        
        importUsingQRCodeView = ImportUsingQRCodeView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        importUsingQRCodeView.delegate = self
    }
    
    @IBAction func closeButtonPressed(_ sender: Any)
    {close()}
    
    func close()
    {
        closeAllTextField()
        self.dismiss(animated: true, completion: nil)
    }
    
    func closeAllTextField()
    {
        addNameView.nameField.resignFirstResponder()
        addPasswordView.passField.textField.resignFirstResponder()
        addPasswordView.retypePassField.textField.resignFirstResponder()
        mnemonicConfirmView.mnemonicLabel.resignFirstResponder()
        importUsingTextView.textField.resignFirstResponder()
    }
    
    func addressIsAlreadyPresent(address:String)
    {
        let alert = EMAlertController(title: "Address already listed", message: address)
        let close = EMAlertAction(title: "Close", style: .cancel){}
        alert.addAction(action: close)
        alert.buttonSpacing = 0
        present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {super.didReceiveMemoryWarning()}
}
