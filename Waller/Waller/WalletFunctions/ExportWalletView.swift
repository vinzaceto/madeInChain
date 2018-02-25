//
//  ExportWalletView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 16/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

enum ExportType
{
    case iCloud
    case PDFFile
    case Text
}

class ExportWalletView: UIView, UITextFieldDelegate
{
    var delegate:WalletFunctionDelegate!
    var selectedExportType:ExportType!
    var outputAsData: Bool = false
    var lockWrite:Bool = false
    var wallet:Wallet!
    var typeWrapper:UIView!
    var passwordWrapper:UIView!
    var passwordField:PWTextField!
    var passTemporaryText:String = ""
    var temporaryPlaceholder:NSAttributedString!
    var textWrapper:UIView!
    var privateKeyLabel:UITextView!
    
    let decryptButton = UIButton.init(type: .roundedRect)
    let backButton = UIButton.init(type: .custom)

    var views:[UIView] = []
    
    override init(frame: CGRect)
    {        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        layer.cornerRadius = 6
        clipsToBounds = true
        
        let viewWidth = UIScreen.main.bounds.width - 30
        
        let flipButton = UIButton.init(type: .custom)
        flipButton.frame = CGRect.init(x: viewWidth - 55 , y: 10, width:45, height: 45)
        flipButton.addTarget(self, action: #selector(flipButtonPressed), for: .touchUpInside)
        //flipButton.backgroundColor = UIColor.blue
        //flipButton.setTitle("close", for: .normal)
        flipButton.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        //flipButton.center.x = self.center.x
        addSubview(flipButton)
        
        typeWrapper = UIView.init(frame: CGRect.init(x: 0, y: 0, width: viewWidth, height: 340))
        self.addSubview(typeWrapper)
        
        let infoLabel = UILabel.init(frame: CGRect.init(x: 30, y: 60, width: viewWidth - 60, height: 40))
        infoLabel.backgroundColor = UIColor.clear
        infoLabel.text = "Select how to export this wallet"
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.textColor = UIColor.lightGray
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        typeWrapper.addSubview(infoLabel)
        
        let exportICloud = UIButton.init(type: .roundedRect)
        exportICloud.frame = CGRect.init(x: 0, y: 0, width: 104, height: 88)
        exportICloud.setImage(UIImage.init(named: "backupCloudIcon"), for: .normal)
        exportICloud.addTarget(self, action: #selector(exportByICloudPressed), for: .touchUpInside)
        exportICloud.isEnabled = false
        exportICloud.center.y = self.center.y
        exportICloud.center.x = self.center.x - 110
        typeWrapper.addSubview(exportICloud)

        let exportAsText = UIButton.init(type: .roundedRect)
        exportAsText.frame = CGRect.init(x: 0, y: 0, width: 70, height: 87)
        exportAsText.setImage(UIImage.init(named: "txtIcon"), for: .normal)
        exportAsText.addTarget(self, action: #selector(exportAsTextPressed), for: .touchUpInside)
        exportAsText.center.y = self.center.y
        exportAsText.center.x = self.center.x + 10
        exportAsText.tintColor = UIColor.darkGray
        typeWrapper.addSubview(exportAsText)
        
        let exportOnFile = UIButton.init(type: .roundedRect)
        exportOnFile.frame = CGRect.init(x: 0, y: 0, width: 70, height: 87)
        exportOnFile.setImage(UIImage.init(named: "pdfIcon"), for: .normal)
        exportOnFile.addTarget(self, action: #selector(exportByFilePressed), for: .touchUpInside)
        exportOnFile.center.y = self.center.y
        exportOnFile.center.x = self.center.x + 120
        exportOnFile.tintColor = UIColor.darkGray
        typeWrapper.addSubview(exportOnFile)
        
        let textExport = UIButton.init(type: .roundedRect)
        textExport.frame = CGRect.init(x:0, y: 0, width: 80, height: 35)
        textExport.addTarget(self, action: #selector(exportAsTextPressed), for: .touchUpInside)
        textExport.setTitle("txt file", for: .normal)
        textExport.center.x = exportAsText.center.x
        textExport.center.y = exportAsText.center.y + 70
        textExport.setTitleColor(UIColor.darkGray, for: .normal)
        typeWrapper.addSubview(textExport)

        
        let fileExport = UIButton.init(type: .roundedRect)
        fileExport.frame = CGRect.init(x:0, y: 0, width: 80, height: 35)
        fileExport.addTarget(self, action: #selector(exportByFilePressed), for: .touchUpInside)
        fileExport.setTitle("pdf file", for: .normal)
        fileExport.center.x = exportOnFile.center.x
        fileExport.center.y = exportOnFile.center.y + 70
        fileExport.setTitleColor(UIColor.darkGray, for: .normal)
        typeWrapper.addSubview(fileExport)

        let iCloudButton = UIButton.init(type: .roundedRect)
        iCloudButton.frame = CGRect.init(x: 0, y: 0, width: 80, height: 35)
        iCloudButton.addTarget(self, action: #selector(exportByICloudPressed), for: .touchUpInside)
        iCloudButton.setTitle("iCloud", for: .normal)
        iCloudButton.isEnabled = false
        iCloudButton.center.x = exportICloud.center.x
        iCloudButton.center.y = exportICloud.center.y + 70
        typeWrapper.addSubview(iCloudButton)

        
        /*
        let exportICloud = UIButton.init(type: .roundedRect)
        exportICloud.frame = CGRect.init(x: (viewWidth-160)/2, y: 130, width: 160, height: 35)
        exportICloud.addTarget(self, action: #selector(exportByICloudPressed), for: .touchUpInside)
        exportICloud.layer.borderWidth = 2
        exportICloud.layer.borderColor = UIColor.gray.cgColor
        exportICloud.layer.cornerRadius = 6
        exportICloud.setTitle("export on iCloud", for: .normal)
        exportICloud.isEnabled = false
        typeWrapper.addSubview(exportICloud)
        
        let exportOnFile = UIButton.init(type: .roundedRect)
        exportOnFile.frame = CGRect.init(x: (viewWidth-180)/2, y: 190, width: 180, height: 35)
        exportOnFile.addTarget(self, action: #selector(exportByFilePressed), for: .touchUpInside)
        exportOnFile.layer.borderWidth = 2
        exportOnFile.layer.borderColor = UIColor.gray.cgColor
        exportOnFile.layer.cornerRadius = 6
        exportOnFile.setTitle("export as PDF on File", for: .normal)
        typeWrapper.addSubview(exportOnFile)
        
        let exportAsText = UIButton.init(type: .roundedRect)
        exportAsText.frame = CGRect.init(x: (viewWidth-160)/2, y: 250, width: 160, height: 35)
        exportAsText.addTarget(self, action: #selector(exportAsTextPressed), for: .touchUpInside)
        exportAsText.layer.borderWidth = 2
        exportAsText.layer.borderColor = UIColor.gray.cgColor
        exportAsText.layer.cornerRadius = 6
        exportAsText.setTitle("export as Text", for: .normal)
        typeWrapper.addSubview(exportAsText)
        */
        
        passwordWrapper = UIView.init(frame: CGRect.init(x: viewWidth, y: 0, width: viewWidth, height: 340))
        self.addSubview(passwordWrapper)
        
        let infoLabel2 = UILabel.init(frame: CGRect.init(x: 60, y: 60, width: viewWidth - 120, height: 40))
        infoLabel2.backgroundColor = UIColor.clear
        infoLabel2.text = "Insert the password to decrypt the private key."
        infoLabel2.adjustsFontSizeToFitWidth = true
        infoLabel2.textColor = UIColor.lightGray
        infoLabel2.textAlignment = .center
        infoLabel2.numberOfLines = 0
        passwordWrapper.addSubview(infoLabel2)
        
        passwordField = PWTextField.init(frame: CGRect.init(x: 30+15, y: infoLabel2.frame.origin.y + 50, width: viewWidth - 60, height: 35))
        changePlaceholderColor(field: passwordField.textField, color: UIColor.lightText, text: "type the password here")
        passwordField.textField.delegate = self
        passwordField.showButton.tintColor = UIColor.gray
        passwordWrapper.addSubview(passwordField)
        
        decryptButton.frame = CGRect.init(x: (viewWidth-160)/2, y: passwordField.frame.origin.y+45, width: 160, height: 35)
        decryptButton.addTarget(self, action: #selector(checkPasswords), for: .touchUpInside)
        decryptButton.setTitle("decrypt and export", for: .normal)
        decryptButton.isEnabled = false
        passwordWrapper.addSubview(decryptButton)
        
        textWrapper = UIView.init(frame: CGRect.init(x: viewWidth, y: 0, width: viewWidth, height: 340))
        self.addSubview(textWrapper)
        
        let infoLabel3 = UILabel.init(frame: CGRect.init(x: 30, y: 60, width: viewWidth - 60, height: 40))
        infoLabel3.backgroundColor = UIColor.clear
        infoLabel3.text = "This is the private key of you wallet, keep it in a safe place."
        infoLabel3.adjustsFontSizeToFitWidth = true
        infoLabel3.textColor = UIColor.lightGray
        infoLabel3.textAlignment = .center
        infoLabel3.numberOfLines = 0
        textWrapper.addSubview(infoLabel3)
        
        privateKeyLabel = UITextView.init(frame: CGRect.init(x: (viewWidth-280)/2, y: 120, width: 280, height: 200))
        privateKeyLabel.layer.cornerRadius = 6
        privateKeyLabel.backgroundColor = UIColor.darkGray
        privateKeyLabel.textColor = UIColor.lightText
        privateKeyLabel.font = UIFont.systemFont(ofSize: 23)
        privateKeyLabel.allowsEditingTextAttributes = false
        privateKeyLabel.isEditable = false
        textWrapper.addSubview(privateKeyLabel)
        
        backButton.frame = CGRect.init(x: 10, y: 10, width:45, height: 45)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        //backButton.setTitle("back", for: .normal)
        backButton.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
        backButton.isHidden = true
        self.addSubview(backButton)
        
        self.bringSubview(toFront: flipButton)
    }

    
    
    
    
    
    
    
    @objc func decryptAndExport(pass:String)
    {
        print("decrypt w password : \(pass)")
        let data = Data.init(base64Encoded: wallet.privatekey, options: .ignoreUnknownCharacters)
        guard let privateKey = decrypt(data: data!, pass: pass) else
        {
            printErrorOnField(error: "wrong password", field: passwordField.textField)
            return
        }
        
        print("decrypted \(privateKey)")
        
        let unencryptedWallet = Wallet.init(label: wallet.label, address: wallet.address, privatekey: privateKey)
        export(unencryptedWallet:unencryptedWallet)
    }
    
    
    
 

    
    @objc func checkPasswords()
    {
        print("check password")
        
        guard let p = passwordField.textField.text else { return }
        
        // check for empty pass
        if p.trimmingCharacters(in: .whitespaces).isEmpty
        {
            print("password empty!!!!")
            printErrorOnField(error: "The password is empty!", field: passwordField.textField)
            return
        }
        
        decryptAndExport(pass: p)
    }

    //
    // MARK: NAVIGATIONS
    //
    
    func goToPassword()
    {
        backButton.isHidden = false
        let viewWidth = UIScreen.main.bounds.width - 30
        passwordField.textField.becomeFirstResponder()
        UIView.animate(withDuration: 0.5)
        {
            self.typeWrapper.frame.origin.x = -viewWidth
            self.passwordWrapper.frame.origin.x = 0
        }
    }
    
    func goToTextView()
    {
        let viewWidth = UIScreen.main.bounds.width - 30
        backButton.isHidden = true
        passwordField.textField.resignFirstResponder()
        passwordField.textField.text = ""
        UIView.animate(withDuration: 0.5)
        {
            self.passwordWrapper.frame.origin.x = -viewWidth
            self.textWrapper.frame.origin.x = 0
        }
    }
    
    @objc func backButtonPressed()
    {
        backButton.isHidden = true
        passwordField.textField.resignFirstResponder()
        passwordField.textField.text = ""
        let viewWidth = UIScreen.main.bounds.width - 30
        UIView.animate(withDuration: 0.5)
        {
            self.typeWrapper.frame.origin.x = 0
            self.passwordWrapper.frame.origin.x = viewWidth
        }
    }
    
    func export(unencryptedWallet:Wallet)
    {
        print(self.selectedExportType)
        if self.selectedExportType == ExportType.Text
        {
            goToTextView()
            privateKeyLabel.text = unencryptedWallet.privatekey
            return
        }
        
        if self.selectedExportType == ExportType.PDFFile
        {
            passwordField.textField.resignFirstResponder()
            guard let _ = delegate?.exportWalletAsPDF(unencryptedWallet: unencryptedWallet) else {return}
        }
    }
    

    
    
    
    
    //
    // MARK: BUTTONS ACTIONS
    //
    
    @objc func flipButtonPressed()
    {
        print("flipButtonPressed")
        guard let _ = delegate?.unflipCard() else { return }
    }
    
    @objc func exportByICloudPressed()
    {
        selectedExportType = ExportType.iCloud
        goToPassword()
    }
    
    @objc func exportByFilePressed()
    {
        selectedExportType = ExportType.PDFFile
        goToPassword()
    }
    
    @objc func exportAsTextPressed()
    {
        selectedExportType = ExportType.Text
        goToPassword()
    }
    
    //
    // MARK: TEXTFIELD DELEGATE
    //
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        checkPasswords()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if lockWrite == true {return false}
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let o = currentText.replacingCharacters(in: stringRange, with: string)
        if o.count >= 1
        {
            decryptButton.isEnabled = true
        }
        else
        {
            decryptButton.isEnabled = false
        }
        
        // deny whitespaces
        let whitespaceSet = NSCharacterSet.whitespaces
        if let _ = string.rangeOfCharacter(from: whitespaceSet)
        {return false}
        
        return true
    }
    
    //
    // MARK: UTILITY
    //
    
    func decrypt(data:Data, pass:String) -> String?
    {
        print("original data : \(data.base64EncodedString())")
        
        do
        {
            let originalData = try RNCryptor.decrypt(data: data, withPassword: pass)
            let originalPrivateKey = String.init(data: originalData, encoding: String.Encoding.utf8)
            return originalPrivateKey
        }
        catch
        {
            return nil
        }
    }
    
    func printErrorOnField(error:String, field:UITextField)
    {
        if lockWrite == true
        {
            return
        }
        
        guard let pass = field.text else { return }
        guard let placeholder = field.attributedPlaceholder else { return }
        
        lockWrite = true
        
        passTemporaryText = pass
        temporaryPlaceholder = passwordField.textField.attributedPlaceholder
        
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
