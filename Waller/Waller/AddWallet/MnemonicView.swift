//
//  MnemonicView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 09/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class MnemonicView: UIView {

    var mnemonicLabel:UILabel!
    var delegate:SetupPageViewDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = Props().addViewsBackgroundColor
        
        /*
        let doneImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        doneImage.image = UIImage.init(named: "done")
        doneImage.alpha = 0.1
        self.addSubview(doneImage)
        */
        
        
        
        
        let infoText = UILabel.init(frame:CGRect.init(x: 0, y:0, width: 280, height: 110))
        infoText.center.x = self.center.x
        infoText.center.y = self.center.y - 70
        infoText.textColor = UIColor.gray
        infoText.textAlignment = .center
        infoText.text = "The wallet has been generated, these words are your secret key, take note of it."
        infoText.font = UIFont.systemFont(ofSize: 20)
        infoText.numberOfLines = 0
        self.addSubview(infoText)
        
        let mY = infoText.frame.origin.y + infoText.frame.size.height
        
        mnemonicLabel = UILabel.init(frame: CGRect.init(x: 0, y: mY, width: 260, height: 140))
        mnemonicLabel.center.x = self.center.x
        mnemonicLabel.backgroundColor = UIColor .white.withAlphaComponent(0.3)
        mnemonicLabel.layer.cornerRadius = 8
        mnemonicLabel.numberOfLines = 0
        mnemonicLabel.clipsToBounds = true
        mnemonicLabel.textAlignment = .center
        mnemonicLabel.font = UIFont.systemFont(ofSize: 24)
        mnemonicLabel.text = ""
        mnemonicLabel.textColor = UIColor.lightText
        self.addSubview(mnemonicLabel)
        
        let by = mnemonicLabel.frame.origin.y + mnemonicLabel.frame.size.height + 10
        
        let confirmButton = UIButton.init(type: .roundedRect)
        confirmButton.frame = CGRect.init(x: 0, y: by, width: 200, height: 30)
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        confirmButton.center.x = self.center.x
        confirmButton.setTitle("i have saved the mnemonic", for: .normal)
        self.addSubview(confirmButton)
    }
    
    @objc func confirmButtonPressed()
    {
        guard let _ = self.delegate?.confirmMnemonic(mnemonic:mnemonicLabel.text!)
        else { return }
    }

    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
