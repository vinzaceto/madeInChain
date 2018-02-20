//
//  DeleteWalletView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 16/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class DeleteWalletView: UIView, OptionLabelDelegate, SlideButtonDelegate {
    
    let viewWidth = UIScreen.main.bounds.width - 30
    let deleteButton = UIButton.init(type: .roundedRect)
    var slider = MMSlidingButton.init(frame: CGRect.init(x:30, y: 0, width: 0, height: 0))
    var delegate:WalletFunctionDelegate!
    var address:String = ""
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        layer.cornerRadius = 6
        clipsToBounds = true
        
        
        let flipButton = UIButton.init(type: .custom)
        flipButton.frame = CGRect.init(x: viewWidth - 55, y: 10, width:45, height: 45)
        flipButton.addTarget(self, action: #selector(flipButtonPressed), for: .touchUpInside)
        flipButton.setImage(#imageLiteral(resourceName: "CloseIcon"), for: .normal)
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
        option.label.text = "Are you sure to delete it?"
        option.delegate = self
        option.optionButton?.check(isChecked: false)
        self.addSubview(option)
        
        deleteButton.frame = CGRect.init(x: (viewWidth-160)/2, y: y + 50, width: 160, height: 30)
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        deleteButton.center.x = self.center.x
        deleteButton.layer.borderWidth = 3
        deleteButton.layer.borderColor = UIColor.gray.cgColor
        deleteButton.layer.cornerRadius = 6
        deleteButton.setTitle("complete", for: .normal)
        deleteButton.isEnabled = false
        //self.addSubview(deleteButton)
        
        slider = MMSlidingButton.init(frame: CGRect.init(x:30, y: y + 40, width: viewWidth - 60, height: 60))
        slider.buttonText = "Slide to Delete >>>"
        slider.buttonCornerRadius = 6
        slider.buttonUnlockedText = "Wallet Deleted"
        slider.buttonColor = UIColor.gray
        slider.animationFinished()
        slider.dragPointWidth = 40
        slider.isUserInteractionEnabled = false
        slider.delegate = self
        slider.alpha = 0.4
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
            slider.alpha = 1
            slider.isUserInteractionEnabled = true
            deleteButton.isEnabled = true
            return
        }
        slider.alpha = 0.4

        slider.isUserInteractionEnabled = false
        deleteButton.isEnabled = false
    }
    
    @objc func deleteButtonPressed()
    {
        guard let _ = delegate?.unflipAndRemove(address: address) else {
            return
        }
    }
    
    func buttonStatus(unlocked: Bool, sender: MMSlidingButton) {
        print("slide unlocked \(unlocked)")
        if(unlocked) {
            guard let _ = delegate?.unflipAndRemove(address: address) else {
                return
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
