//
//  AddViewController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 06/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class AddViewController: UIViewController,MultiOptionViewDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        var data:[Option] = []
        
        let option1 = Option.init(title: "Create a standard Wallet", text: "Create a simple wallet to send and receive funds, it will be protected with a password and stored directly on your device.", buttonTitle: "Create a Wallet")
        let option2 = Option.init(title: "Request a multisig Wallet", text: "A multisignature wallet is like a shared wallet, it can receive funds from anyone, but require the signature of more than one person to send.", buttonTitle: "Request a multisig Wallet")
        let option3 = Option.init(title: "Import a Wallet", text: "Import a wallet that you already have by using a private key or a mnemonic.", buttonTitle: "Import a Wallet")
        
        data.append(option1)
        data.append(option2)
        data.append(option3)
        
        let frame = CGRect.init(x: 10, y: 100, width: self.view.frame.size.width-20, height: 0)
        let multiView = MultiOptionView.init(frame:frame,data:data)
        multiView.delegate = self
        multiView.setDefaultIndex(index: 0)
        self.view.addSubview(multiView)
        
        multiView.center = self.view.center
        
    }

    func optionSelected(selectedIndex: Int) {
        
        //print("selected button with id \(selectedIndex)")
        
        switch selectedIndex
        {
        case 0:
            goToCreateStandardWallet()
        case 1:
            goToRequestMultisigWallet()
        case 2:
            goToImportWallet()
            
        default:
            return
            // none
        }
    }
    
    func goToCreateStandardWallet()
    {
        print("Create New Standard Wallet")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createWalletController = storyboard.instantiateViewController(withIdentifier: "CWController") as! CreateStandardWalletController
        navigationController?.pushViewController(createWalletController, animated: true)
    }
    
    func goToRequestMultisigWallet()
    {
        print("Request a Multisig Wallet")
    }
    
    func goToImportWallet()
    {
        print("Import a Wallet")
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        
        close()
    }
    
    func close() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
