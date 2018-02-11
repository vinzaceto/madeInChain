//
//  MnemonicView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 09/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class MnemonicView: UIView {

    var delegate:SetupPageViewDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        self.backgroundColor = UIColor.lightGray
        
        let doneImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        doneImage.image = UIImage.init(named: "done")
        doneImage.alpha = 0.1
        doneImage.center.x = self.center.x
        doneImage.center.y = self.center.y - 160
        self.addSubview(doneImage)
        
        let infoTextY = doneImage.frame.origin.y + doneImage.frame.size.height
        
        let infoText = UILabel.init(frame:CGRect.init(x: 0, y:infoTextY, width: 280, height: 170))
        infoText.center.x = self.center.x
        infoText.textColor = UIColor.gray
        infoText.textAlignment = .center
        infoText.text = "Your wallet has been generated, the following words are a rapresentation of your secret key, keep it safe, you will need it every time you have to make a new transaction."
        infoText.font = UIFont.systemFont(ofSize: 20)
        infoText.numberOfLines = 0
        self.addSubview(infoText)
        
        let mY = infoText.frame.origin.y + infoText.frame.size.height
        
        let mnemonicView = UITextView.init(frame: CGRect.init(x: 0, y: mY, width: 260, height: 140))
        mnemonicView.center.x = self.center.x
        mnemonicView.backgroundColor = UIColor .white.withAlphaComponent(0.3)
        mnemonicView.layer.cornerRadius = 8
        mnemonicView.clipsToBounds = true
        mnemonicView.textAlignment = .center
        mnemonicView.isEditable = false
        mnemonicView.font = UIFont.systemFont(ofSize: 24)
        mnemonicView.text = "witch collapse practice feed shame open despair creek road again ice least"
        mnemonicView.textColor = UIColor.lightText
        self.addSubview(mnemonicView)
        
        let by = mnemonicView.frame.origin.y + mnemonicView.frame.size.height + 20
        
        let completeButton = UIButton.init(type: .roundedRect)
        completeButton.frame = CGRect.init(x: 0, y: by, width: 160, height: 40)
        completeButton.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
        completeButton.center.x = self.center.x
        completeButton.layer.borderWidth = 3
        completeButton.layer.borderColor = UIColor.gray.cgColor
        completeButton.layer.cornerRadius = 8
        completeButton.setTitle("complete", for: .normal)
        self.addSubview(completeButton)
        
    }
    
    @objc func completeButtonPressed()
    {
        guard let _ = self.delegate?.completedButtonPressed()
            else { return }
    }

    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
