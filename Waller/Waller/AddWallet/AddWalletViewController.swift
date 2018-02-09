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
}


class AddWalletViewController: UIViewController,SetupPageViewDelegate {

    var addTypeView:AddTypeView!
    var addNameView:SetNameView!
    var addSaveType:SetSaveTypeView!
    var addPasswordView:SetPasswordView!
    var walletGenerationView:WalletGenerationView!

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

        backButton.setTitle("back", for: .normal)
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
        goToSetNameView()
    }
    
    func goToSetNameView()
    {
        backButton.isEnabled = true
        
        views.append(addNameView)
        addNameView.nameField.text = ""
        addNameView.nameField.becomeFirstResponder()
        showNextView()
    }
    
    func nameSetted(name: String)
    {
        print("selected name : \(name)")
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
    }
  
    func goToSetPassword()
    {
        views.append(addPasswordView)
        showNextView()
        addPasswordView.passField.textField.becomeFirstResponder()
    }
    
    func passwordSetted(pass: String)
    {
        print("password : \(pass)")
        goToGenerateWallet()
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
    
    func completedButtonPressed()
    {
        close()
    }
    
    
    @objc func backButtonPressed()
    {
        showPreviousView()
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
        
        if views.count < 2
        {
            return
        }
        if views.count == 2
        {
            backButton.isEnabled = false
        }
        
        let currentView = views[currentIndex]
        let previousView = views[previousIndex]
        
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
    {self.dismiss(animated: true, completion: nil)}
    
    override func didReceiveMemoryWarning()
    {super.didReceiveMemoryWarning()}
}
