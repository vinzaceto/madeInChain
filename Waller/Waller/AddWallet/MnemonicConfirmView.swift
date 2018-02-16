//
//  MnemonicConfirmView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 12/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class MnemonicConfirmView: UIView {

    var mnemonicLabel:UITextView!
    var delegate:SetupPageViewDelegate!
    var rightMnemonic:String!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    
        self.backgroundColor = Props().addViewsBackgroundColor
        
        let infoText = UILabel.init(frame:CGRect.init(x: 0, y:0, width: 280, height: 130))
        infoText.center.x = self.center.x
        infoText.center.y = self.center.y - 140
        infoText.textColor = UIColor.gray
        infoText.textAlignment = .center
        infoText.text = "Retype the previous generated words to confirm the generation of the wallet. Remember to keep it in a safe place, you will need it for every transaction."
        infoText.font = UIFont.systemFont(ofSize: 20)
        infoText.numberOfLines = 0
        self.addSubview(infoText)
        
        let mY = infoText.frame.origin.y + infoText.frame.size.height + 20
        
        mnemonicLabel = UITextView.init(frame: CGRect.init(x: 0, y: mY, width: 260, height: 70))
        mnemonicLabel.center.x = self.center.x
        mnemonicLabel.backgroundColor = UIColor .white.withAlphaComponent(0.3)
        mnemonicLabel.layer.cornerRadius = 8
        mnemonicLabel.clipsToBounds = true
        mnemonicLabel.textAlignment = .center
        mnemonicLabel.autocorrectionType = UITextAutocorrectionType.no
        mnemonicLabel.font = UIFont.systemFont(ofSize: 24)
        mnemonicLabel.textColor = UIColor.lightText
        self.addSubview(mnemonicLabel)
        
        let by = mnemonicLabel.frame.origin.y + mnemonicLabel.frame.size.height + 10
        
        let confirmButton = UIButton.init(type: .roundedRect)
        confirmButton.frame = CGRect.init(x: 0, y: by, width: 200, height: 30)
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        confirmButton.center.x = self.center.x
        confirmButton.setTitle("confirm mnemonic", for: .normal)
        self.addSubview(confirmButton)
    }
    
    @objc func confirmButtonPressed()
    {
        guard let mnemonic = mnemonicLabel.text else { return }
        
        if mnemonic.count > 0
        {
            if compareMnemonix(stringMnemonic: mnemonic)
            {
                guard let _ = self.delegate?.mnemonicConfiremed(mnemonic: rightMnemonic)
                else { return }
            }
        }
        else
        {
            print("no mnemonic")
        }
    }
    
    func compareMnemonix(stringMnemonic:String) -> Bool
    {        
        let userMnemonic = stringMnemonic.replacingOccurrences(of: " ", with: ",").lowercased()
        
        let userMnemonicArray = userMnemonic.components(separatedBy: [",","\n"])
        let rightMnemonicArray = rightMnemonic.components(separatedBy: [" "])
        
        print("compare : \(userMnemonicArray)")
        print("with : \(rightMnemonicArray)")
        
        if userMnemonicArray.count != 12 || rightMnemonicArray.count != 12
        {
            print("mnemonic < 12 words \(userMnemonicArray.count)")
            return false
        }
        
        for (index, m) in userMnemonicArray.enumerated()
        {
            if m != rightMnemonicArray[index]
            {
                print("wrong mnemonic - w1 \(m) != w2 \(rightMnemonicArray[index])")
                return false
            }
        }

        return true
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
