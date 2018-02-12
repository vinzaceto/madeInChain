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
    func completedButtonPressed()
    func walletFounded(address:String)
    func setWalletForMultisigButtonPressed()
}


class AddWalletViewController: UIViewController,SetupPageViewDelegate {

    var addTypeView:AddTypeView!
    var addNameView:SetNameView!
    var addSaveType:SetSaveTypeView!
    var addPasswordView:SetPasswordView!
    var walletGenerationView:WalletGenerationView!
    var mnemonicView:MnemonicView!
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

        walletGenerationView = WalletGenerationView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        walletGenerationView.delegate = self
       
        mnemonicView = MnemonicView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        mnemonicView.delegate = self

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
        walletGenerationView.gererateWallet(name:walletLabel, pass: pass)
        {
            (success, error) in
            
            if success == true
            {
                self.goToGenerateWallet()
            }
            else
            {
                print("WalletGenerationFailed reason : \(String(describing: error))")
            }
        }
    }
    
    func goToGenerateWallet()
    {
        closeButton.isEnabled = false
        backButton.isEnabled = false
        addPasswordView.passField.textField.resignFirstResponder()
        addPasswordView.retypePassField.textField.resignFirstResponder()
        views.append(walletGenerationView)
        showNextView()
    }
    
    func goToMnemonicView()
    {
        views.append(mnemonicView)
        showNextView()
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

        views.append(setAddressView)
        showNextView()
    }
    
    func setWalletForMultisigButtonPressed()
    {
        
        let items = ["First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item"]
        let params = Parameters(title: "Select Item ...", items: items, cancelButton: "Cancel")
        
        SelectItemController().show(parent: self, params: params) { (index) in
            if let index = index {
                print("selected: \(items[index])")
            } else {
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
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning()
    {super.didReceiveMemoryWarning()}
}
