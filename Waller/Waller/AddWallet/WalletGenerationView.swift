//
//  WalletGenerationView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 09/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class WalletGenerationView: UIView
{

    var delegate:SetupPageViewDelegate!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        let labelframe = CGRect.init(x: 30, y:120, width: self.frame.size.width - 60, height: 50)
        let infoText = UILabel.init(frame:labelframe)
        infoText.textColor = UIColor.gray
        infoText.textAlignment = .center
        infoText.text = "Your wallet has been successfully generated and stored on this device."
        infoText.font = UIFont.systemFont(ofSize: 20)
        infoText.numberOfLines = 0
        self.addSubview(infoText)
        
        let doneImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 130, height: 130))
        doneImage.image = UIImage.init(named: "done")
        doneImage.alpha = 0.1
        doneImage.frame.origin.y = infoText.frame.origin.y + infoText.frame.size.height + 10
        doneImage.center.x = self.center.x
        self.addSubview(doneImage)
        
        let y = doneImage.frame.origin.y + doneImage.frame.size.height + 10
        
        let infoText2 = UILabel.init(frame:CGRect.init(x: 40, y:y, width: self.frame.size.width - 80, height: 80))
        infoText2.textColor = UIColor.gray
        infoText2.textAlignment = .center
        infoText2.text = "Remember you to use the export feature to make a backup or share this wallet on other devices."
        infoText2.font = UIFont.systemFont(ofSize: 20)
        infoText2.numberOfLines = 0
        self.addSubview(infoText2)
        
        let by = infoText2.frame.origin.y + infoText2.frame.size.height + 30

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
