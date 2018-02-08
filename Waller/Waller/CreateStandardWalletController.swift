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
    var nameFieldPlaceholder = "type a wallet name here"
    var nameFieldTemporaryText:String = ""
    var nameFieldTemporaryPlaceholder:NSAttributedString!
    let continueButton = UIButton.init(type: .roundedRect)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        let labelframe = CGRect.init(x: 30, y:160, width: self.view.frame.size.width - 60, height: 50)
        let optionText = UILabel.init(frame:labelframe)
        optionText.textColor = UIColor.gray
        optionText.textAlignment = .center
        optionText.text = "You are creating a new wallet, please give a name to it to continue."
        optionText.font = UIFont.systemFont(ofSize: 20)
        optionText.numberOfLines = 0
        self.view.addSubview(optionText)
        
        let fieldFrame = CGRect.init(x: 30, y: 260, width: self.view.frame.size.width - 120, height: 40)
        nameField.frame = fieldFrame
        nameField.delegate = self
        nameField.font = UIFont.systemFont(ofSize: 24)
        changePlaceholderColor(field: nameField, color: UIColor.gray, text: nameFieldPlaceholder)
        self.view.addSubview(nameField)
        
        let line = UIView.init(frame: CGRect.init(x: 20, y: 300, width: self.view.frame.size.width - 40, height: 3))
        line.backgroundColor = UIColor.white
        self.view.addSubview(line)
        
        let w:CGFloat = 65
        let h:CGFloat = 30
        let x = line.frame.origin.x + line.frame.size.width - w
        let y = line.frame.origin.y - h
        
        continueButton.frame = CGRect.init(x: x, y: y, width: w, height: h)
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        continueButton.setTitle("continue", for: .normal)
        continueButton.isEnabled = false
        self.view.addSubview(continueButton)
        
        nameField.becomeFirstResponder()
    }
    
    func changePlaceholderColor(field:UITextField, color:UIColor, text:String?)
    {
        var p = field.placeholder
        if text != nil{p = text}
        let attrPlaceholder = NSAttributedString(string: p!, attributes: [NSAttributedStringKey.foregroundColor: color])
        field.attributedPlaceholder = attrPlaceholder
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        checkName()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let o = currentText.replacingCharacters(in: stringRange, with: string)
        if o.count >= 1
        {
            continueButton.isEnabled = true
        }
        else
        {
            continueButton.isEnabled = false
        }
        
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
            printErrorOnField(error: "The name is empty!", field: nameField)
            return
        }
        
        print("name : \(name)")
        goToSetType(name:name)
    }
    

    @objc func continueButtonPressed()
    {
        checkName()
    }
    
    func goToSetType(name:String)
    {
        print("Go to Generate")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let saveTypeController = storyboard.instantiateViewController(withIdentifier: "STController") as! SetSaveTypeController
        navigationController?.pushViewController(saveTypeController, animated: true)
    }
    
    
    
    
    func printErrorOnField(error:String, field:UITextField)
    {
        guard let text = field.text else { return }
        guard let placeholder = field.attributedPlaceholder else { return }
        nameFieldTemporaryText = text
        nameFieldTemporaryPlaceholder = placeholder
        
        field.text = ""
        changePlaceholderColor(field: field, color: UIColor.orange, text: error)
        
        perform(#selector(resetField(field:)), with: field, afterDelay: 2)
    }
    
    @objc func resetField(field:UITextField)
    {
        field.text = nameFieldTemporaryText
        field.attributedPlaceholder = nameFieldTemporaryPlaceholder
        nameFieldTemporaryText = ""
        nameFieldTemporaryPlaceholder = nil
    }

    override func didReceiveMemoryWarning()
    {super.didReceiveMemoryWarning()}
}
