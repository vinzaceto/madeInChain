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
    func typeSelected(selectedType:AddType)
    func nameSetted(name:String)
    func saveTypeSelected(selectedType:SaveType)
    func passwordSetted(pass:String)
    func confirmMnemonic(mnemonic:String)
    func mnemonicConfiremed(mnemonic:String)
    func completedButtonPressed()
    func walletFounded(address:String)
    func changeAddressForMultisigButtonPressed()
}


class AddWalletViewController: UIViewController,SetupPageViewDelegate {
    
    var addTypeView:AddTypeView!
    var addNameView:SetNameView!
    var addSaveType:SetSaveTypeView!
    var addPasswordView:SetPasswordView!
    var walletGeneratedView:WalletGeneratedView!
    var mnemonicView:MnemonicView!
    var mnemonicConfirmView:MnemonicConfirmView!
    var qrcodeScanView:QRCodeScanView!
    var setAddressView:SetAddressForMultisigView!

    var walletLabel:String!

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var views:[UIView] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)

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
        
        qrcodeScanView = QRCodeScanView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        qrcodeScanView.delegate = self
        
        setAddressView = SetAddressForMultisigView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        setAddressView.delegate = self
        
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.sizeToFit()
        backButton.isEnabled = false
    }

    //
    // MARK : Navigation
    //
    
    func typeSelected(selectedType: AddType)
    {
        print("selected type : \(selectedType)")
        if selectedType == AddType.Standard
        {
            goToSetNameView()
        }
        if selectedType == AddType.Multisig
        {
            goToSetMultisigView()
        }
        if selectedType == AddType.Import
        {
            goToQRCodeScan()
        }
    }
    
    func goToSetNameView()
    {
        backButton.isEnabled = true
        
        views.append(addNameView)
        addNameView.nameField.text = ""
        showNextView()
    }
    
    func nameSetted(name: String)
    {
        print("selected name : \(name)")
        walletLabel = name
        goToSetSaveType()
    }
    
    func goToSetSaveType()
    {
        views.append(addSaveType)
        showNextView()
    }
 
    func saveTypeSelected(selectedType: SaveType)
    {
        print("save type : \(selectedType)")
        if selectedType == SaveType.Local
        {
            goToSetPassword()
        }
        if selectedType == SaveType.Mnemonic
        {
            goToMnemonicView()
        }
    }
  
    func goToSetPassword()
    {
        views.append(addPasswordView)
        showNextView()
    }
    
    func passwordSetted(pass: String)
    {
        print("password : \(pass)")
        let walletGenerator = WalletsGenerator.init()
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
    
    func confirmMnemonic(mnemonic: String)
    {
        goToConfirmMnemonicView(mnemonic: mnemonic)
    }
    
    func goToConfirmMnemonicView(mnemonic:String)
    {
        print("mnemonic to confirm : \(mnemonic)")
        mnemonicConfirmView.mnemonicLabel.becomeFirstResponder()
        mnemonicConfirmView.rightMnemonic = mnemonic
        views.append(mnemonicConfirmView)
        showNextView()
    }
    
    func mnemonicConfiremed(mnemonic:String)
    {
        print("mnemonic confirmed : \(mnemonic)")
        let mnemonicArray = mnemonic.components(separatedBy: " ")
        
        let m = BTCMnemonic.init(words: mnemonicArray, password: "", wordListType: BTCMnemonicWordListType.english)
        let keychain = m?.keychain
        let addr = keychain?.key.addressTestnet.string

        let coldWallet = WatchOnlyWallet.init(label: walletLabel, address: addr!)

        let walletsDatabase = WalletsDatabase.init()
        walletsDatabase.saveWatchOnlyWallet(watchOnlyWallet: coldWallet)
        {
            (success, error) in
            print("cold wallet saved")
            self.walletGeneratedView.infoText.text = "Your cold wallet has been successfully generated."
            self.walletGeneratedView.infoText2.text = "Remember to store your mnemonic key in a safe place. There is no way to recover your wallet without it"
            self.goToWalletGeneratedView()
        }
    }
    
    func goToQRCodeScan()
    {
        backButton.isEnabled = true
        views.append(qrcodeScanView)
        showNextView()
    }
    
    func goToSetMultisigView()
    {
        backButton.isEnabled = true
        setAddressView.setDefault()
        views.append(setAddressView)
        showNextView()
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
    
    func completedButtonPressed()
    {
        close()
    }
    
    
    @objc func backButtonPressed()
    {
        showPreviousView()
    }
    
    func walletFounded(address: String)
    {
        let alert = EMAlertController(title: "Address found", message: address)
        
        let cancel = EMAlertAction(title: "CANCEL", style: .cancel)
        {
            self.qrcodeScanView.canScan = true
        }
        let confirm = EMAlertAction(title: "IMPORT", style: .normal)
        {
            self.qrcodeScanView.canScan = true
        }
        
        alert.addAction(action: cancel)
        alert.addAction(action: confirm)
        
        present(alert, animated: true, completion: nil)
    }
    
    //
    // MARK : Utility
    //
    
    func showNextView()
    {
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
        
        if nextView == walletGeneratedView
        {
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
    
    @IBAction func closeButtonPressed(_ sender: Any)
    {close()}
    
    func close()
    {
        addNameView.nameField.resignFirstResponder()
        addPasswordView.passField.textField.resignFirstResponder()
        addPasswordView.retypePassField.textField.resignFirstResponder()
        mnemonicConfirmView.mnemonicLabel.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning()
    {super.didReceiveMemoryWarning()}
}
