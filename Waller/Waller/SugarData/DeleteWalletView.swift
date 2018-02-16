//
//  DeleteWalletView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 16/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class DeleteWalletView: UIView, OptionLabelDelegate, SlideButtonDelegate {
    
    let deleteButton = UIButton.init(type: .roundedRect)
    var delegate:WalletFunctionDelegate!
    
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
        
        let infoLabel = UILabel.init(frame: CGRect.init(x: 30, y: 80, width: viewWidth - 60, height: 120))
        infoLabel.backgroundColor = UIColor.clear
        infoLabel.text = "Warning\nDo you want to remove this wallet? The action isn't reversible, remember to backup your wallet first."
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.textColor = UIColor.lightGray
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        self.addSubview(infoLabel)
        
        let y = infoLabel.frame.origin.y + infoLabel.frame.size.height + 5
        let option = OptionLabel.init(frame: CGRect.init(x: 30, y: y, width: viewWidth - 60, height: 30))
        option.label.text = "i'm sure about deleting"
        option.delegate = self
        self.addSubview(option)
        
        deleteButton.frame = CGRect.init(x: (viewWidth-160)/2, y: y + 40, width: 160, height: 30)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        deleteButton.center.x = self.center.x
        deleteButton.layer.borderWidth = 3
        deleteButton.layer.borderColor = UIColor.gray.cgColor
        deleteButton.layer.cornerRadius = 6
        deleteButton.setTitle("complete", for: .normal)
        deleteButton.isEnabled = false
        self.addSubview(deleteButton)
        
        let slider = MMSlidingButton.init(frame: CGRect.init(x:30, y: y + 60, width: viewWidth - 60, height: 80))
        slider.buttonText = "Slide to Delete Wallet"
        slider.buttonCornerRadius = 6
        slider.buttonUnlockedText = "Wallet Deleted"
        slider.buttonColor = UIColor.gray
        slider.animationFinished()
        slider.delegate = self
        self.addSubview(slider)
    }
    
    @objc func flipButtonPressed()
    {
        print("flipButtonPressed")
        guard let _ = delegate?.unflipCard() else { return }
    }
    
    func checkBoxChange(isChecked: Bool)
    {
        if isChecked == true
        {
            deleteButton.isEnabled = false
            return
        }
        deleteButton.isEnabled = true
    }
    
    @objc func deleteButtonPressed()
    {
        
    }
    
    func buttonStatus(unlocked: Bool, sender: MMSlidingButton) {
        print("slide unlocked \(unlocked)")
        if(unlocked) {
            guard let _ = delegate?.unflipAndRemove() else {
                return
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
