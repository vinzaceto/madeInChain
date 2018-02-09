//
//  SetPasswordView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 08/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class SetPasswordView: UIView, UITextFieldDelegate
{
    var passField:PWTextField!
    var retypePassField:PWTextField!
    var passTemporaryText:String = ""
    var temporaryPlaceholder:NSAttributedString!
    var lockWrite:Bool = false
    var delegate:SetupPageViewDelegate!

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        let labelframe = CGRect.init(x: 40, y:80, width: self.frame.size.width - 80, height: 160)
        let infoText = UILabel.init(frame:labelframe)
        infoText.textColor = UIColor.gray
        infoText.textAlignment = .center
        infoText.text = "Set a strong password for your wallet, these are some useful tips:\n\n• use more than 12 characters\n• don’t use always the same password\n• use special characters"
        infoText.font = UIFont.systemFont(ofSize: 20)
        infoText.numberOfLines = 0
        self.addSubview(infoText)
        
        let py = infoText.frame.origin.y + infoText.frame.size.height + 20

        passField = PWTextField.init(frame: CGRect.init(x: 40, y: py, width: self.frame.size.width - 80, height: 40))
        changePlaceholderColor(field: passField.textField, color: UIColor.lightText, text: "type a password here")
        passField.textField.delegate = self
        self.addSubview(passField)
        
        let rpy = passField.frame.origin.y + passField.frame.size.height + 20
        
        retypePassField = PWTextField.init(frame: CGRect.init(x: 40, y: rpy, width: self.frame.size.width - 80, height: 40))
        changePlaceholderColor(field: retypePassField.textField, color: UIColor.lightText, text: "re-type the password here")
        retypePassField.textField.delegate = self
        self.addSubview(retypePassField)
        
        let by = retypePassField.frame.origin.y + retypePassField.frame.size.height + 30

        let generateButton = UIButton.init(type: .roundedRect)
        generateButton.frame = CGRect.init(x: 0, y: by, width: 160, height: 40)
        generateButton.addTarget(self, action: #selector(generateButtonPressed), for: .touchUpInside)
        generateButton.center.x = self.center.x
        generateButton.layer.borderWidth = 3
        generateButton.layer.borderColor = UIColor.gray.cgColor
        generateButton.layer.cornerRadius = 8
        generateButton.setTitle("generate wallet", for: .normal)
        self.addSubview(generateButton)

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        checkPasswords()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if lockWrite == true {return false}
        
        // deny whitespaces
        let whitespaceSet = NSCharacterSet.whitespaces
        if let _ = string.rangeOfCharacter(from: whitespaceSet)
        {return false}
        
        return true
    }
    
    @objc func generateButtonPressed()
    {
        checkPasswords()
    }
    
    func checkPasswords()
    {
        print("check password")
        
        guard let p = passField.textField.text else { return }
        
        // check for empty pass
        if p.trimmingCharacters(in: .whitespaces).isEmpty
        {
            print("password empty!!!!")
            printErrorOnField(error: "The password is empty!", field: passField.textField)
            return
        }
        
        //print("First password is \(p)")

        guard let rp = retypePassField.textField.text else { return }
        
        // check for empty retype-pass
        if rp.trimmingCharacters(in: .whitespaces).isEmpty
        {
            if retypePassField.textField.isFirstResponder
            {
                print("retype password empty!!!!")
                printErrorOnField(error: "The password is empty!", field: retypePassField.textField)
                return
            }
            
            retypePassField.textField.becomeFirstResponder()
            return
        }
        
        //print("Second password is \(rp)")
        
        if p != rp
        {
            print("passwords does not match !!!!")
            printErrorOnField(error: "The passwords doesn't match", field: retypePassField.textField)
            return
        }
        
        // Success
        
        guard let _ = self.delegate?.passwordSetted(pass: p)
        else { return }

    }
    
    func printErrorOnField(error:String, field:UITextField)
    {
        guard let pass = field.text else { return }
        guard let placeholder = field.attributedPlaceholder else { return }

        lockWrite = true
        
        passTemporaryText = pass
        temporaryPlaceholder = placeholder
        
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
