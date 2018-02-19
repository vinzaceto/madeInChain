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
    case PDFtoFile
    case PDFtoMnemonic
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
    var mnemonicWrapper:UIView!
    var mnemonicLabel:UITextView!
    
    let decryptButton = UIButton.init(type: .roundedRect)
    let backButton = UIButton.init(type: .roundedRect)

    var views:[UIView] = []
    
    override init(frame: CGRect)
    {        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        layer.cornerRadius = 6
        clipsToBounds = true
        
        let viewWidth = UIScreen.main.bounds.width - 30
        
        let flipButton = UIButton.init(type: .roundedRect)
        flipButton.frame = CGRect.init(x: 0, y: 10, width:60, height: 25)
        flipButton.addTarget(self, action: #selector(flipButtonPressed), for: .touchUpInside)
        flipButton.backgroundColor = UIColor.clear
        flipButton.setTitle("close", for: .normal)
        flipButton.center.x = self.center.x
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
        exportICloud.frame = CGRect.init(x: (viewWidth-160)/2, y: 130, width: 160, height: 35)
        exportICloud.addTarget(self, action: #selector(exportByICloudPressed), for: .touchUpInside)
        exportICloud.layer.borderWidth = 2
        exportICloud.layer.borderColor = UIColor.gray.cgColor
        exportICloud.layer.cornerRadius = 6
        exportICloud.setTitle("export on iCloud", for: .normal)
        typeWrapper.addSubview(exportICloud)
        
        let exportOnFile = UIButton.init(type: .roundedRect)
        exportOnFile.frame = CGRect.init(x: (viewWidth-180)/2, y: 190, width: 180, height: 35)
        exportOnFile.addTarget(self, action: #selector(exportByFilePressed), for: .touchUpInside)
        exportOnFile.layer.borderWidth = 2
        exportOnFile.layer.borderColor = UIColor.gray.cgColor
        exportOnFile.layer.cornerRadius = 6
        exportOnFile.setTitle("export as PDF on File", for: .normal)
        typeWrapper.addSubview(exportOnFile)
        
        let exportByMnemonic = UIButton.init(type: .roundedRect)
        exportByMnemonic.frame = CGRect.init(x: (viewWidth-160)/2, y: 250, width: 160, height: 35)
        exportByMnemonic.addTarget(self, action: #selector(exportByMnemonicPressed), for: .touchUpInside)
        exportByMnemonic.layer.borderWidth = 2
        exportByMnemonic.layer.borderColor = UIColor.gray.cgColor
        exportByMnemonic.layer.cornerRadius = 6
        exportByMnemonic.setTitle("export as Mnemonic", for: .normal)
        typeWrapper.addSubview(exportByMnemonic)
        
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
        
        
        mnemonicWrapper = UIView.init(frame: CGRect.init(x: viewWidth, y: 0, width: viewWidth, height: 340))
        self.addSubview(mnemonicWrapper)
        
        mnemonicLabel = UITextView.init(frame: CGRect.init(x: (viewWidth-260)/2, y: 80, width: 260, height: 140))
        mnemonicLabel.layer.cornerRadius = 6
        mnemonicLabel.backgroundColor = UIColor.darkGray
        mnemonicLabel.textColor = UIColor.lightText
        mnemonicLabel.isUserInteractionEnabled = false
        mnemonicWrapper.addSubview(mnemonicLabel)
        
        backButton.frame = CGRect.init(x: 10, y: 10, width: 50, height: 25)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.setTitle("back", for: .normal)
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
        UIView.animate(withDuration: 0.5)
        {
            self.typeWrapper.frame.origin.x = -viewWidth
            self.passwordWrapper.frame.origin.x = 0
        }
    }
    
    func goToMnemonicView()
    {
        let viewWidth = UIScreen.main.bounds.width - 30
        backButton.isHidden = true
        passwordField.textField.resignFirstResponder()
        passwordField.textField.text = ""
        UIView.animate(withDuration: 0.5)
        {
            self.passwordWrapper.frame.origin.x = -viewWidth
            self.mnemonicWrapper.frame.origin.x = 0
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
        if self.selectedExportType == ExportType.PDFtoMnemonic
        {
            goToMnemonicView()
            
            /*
            let mne = BTCKeychain.init
            
            let m = BTCKey.init(privateKey: unencryptedWallet.privatekey.data(using: .utf8))
            
            
            let key = BTCKey.init(privateKey: )
            key.mne
            */
            
            mnemonicLabel.text = unencryptedWallet.privatekey
        }
        else
        {
            guard let _ = delegate?.exportUsing(exportType: self.selectedExportType, unencryptedWallet:unencryptedWallet) else { return }
        }
    }
    
    /*
 
 mnemonic : Optional([garlic, stuff, share, candy, neutral, elephant, green, vanish, flower, giraffe, ribbon, skate])
     
 address : Optional(<BTCPublicKeyAddressTestnet: n2QH9s3K2hrcAjJ5og9heuenBtiVJiKCbX>)
     
 pubKey : Optional("xpub661MyMwAqRbcEmkHJa9kGSyC6AFe5ECYkQcbVwZhHJLnxGUAHoeTsNDBFtvkH47Nf9bvR1qCQokQjQtDJLT79JNMD9wo8FhMdpbgA1Rfuhv")
     
 privKey : Optional("xprv9s21ZrQH143K2HfpCYcjuK2TY8R9fmUhPBgzhZA5ixop5U91kGLDKZthQfFMHTRxmhj4SgEXh5dQf9iCwR3ArA15S3tmymauWHMaqBVvqPy")
     
 encrypted PrivateKey : AwEp/miXCvs5Zt3dJxUzBBkD/0DZEkQX0ymvJkMsK7iiCYU4CiqtuKtVIaClw1iVlIYFPfaNt+ZIIrBZq71+5hiNxO2DbhLO8oqwVqw306NuXJhlvHZ/jgTC5d8Uc09t91GbiPGcyR75AvzJYpaeOTVjocaSlCp16CAWeHCbwTIs1qMKk+O/tK0z5sz6PDvgyVgS+PIb0EGBlNbVsIy9o3XUKmTScgrUcqLfMTaDhaBqzQ==
 
 */
    
    
    
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
        selectedExportType = ExportType.PDFtoFile
        goToPassword()
    }
    
    @objc func exportByMnemonicPressed()
    {
        selectedExportType = ExportType.PDFtoMnemonic
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
