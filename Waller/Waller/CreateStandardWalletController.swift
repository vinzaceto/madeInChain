//
//  CreateStandardWalletController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 06/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class CreateStandardWalletController: UIViewController, UITextFieldDelegate {

    let nameField:UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        let labelframe = CGRect.init(x: 20, y:100, width: self.view.frame.size.width - 40, height: 50)
        let optionText = UILabel.init(frame:labelframe)
        optionText.textColor = UIColor.gray
        optionText.textAlignment = .center
        optionText.text = "set a name to this new address"
        optionText.font = UIFont.systemFont(ofSize: 20)
        optionText.numberOfLines = 0
        self.view.addSubview(optionText)
        
        let fieldFrame = CGRect.init(x: 30, y: 150, width: self.view.frame.size.width - 60, height: 40)
        nameField.frame = fieldFrame
        nameField.delegate = self
        nameField.placeholder = "wallet name"
        self.view.addSubview(nameField)
        
        let line = UIView.init(frame: CGRect.init(x: 20, y: 190, width: self.view.frame.size.width - 40, height: 3))
        line.backgroundColor = UIColor.white
        self.view.addSubview(line)
        
        nameField.becomeFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        checkName()
        return true
    }
    
    func checkName()
    {
        guard let n = nameField.text else { return }
        
        // trim whitespaces
        let name = n.trimmingCharacters(in: .whitespaces)
        nameField.text = name

        // check for empty name
        if name.trimmingCharacters(in: .whitespaces).isEmpty
        {
            print("name empty!!!!")
            return
        }
        
        print("name : \(name)")
        goToSetPassword(name:name)
    }
    
    func goToSetPassword(name:String)
    {
        print("Go to Set Password")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let setPasswordController = storyboard.instantiateViewController(withIdentifier: "SPController") as! SetPasswordViewController
        setPasswordController.title = name
        navigationController?.pushViewController(setPasswordController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
