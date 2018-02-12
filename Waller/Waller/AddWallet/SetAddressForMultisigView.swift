//
//  SetAddressForMultisigView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 11/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class SetAddressForMultisigView: UIView {

    var delegate:SetupPageViewDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        self.backgroundColor = UIColor.lightGray
        
        let infoText = UILabel.init(frame:CGRect.init(x: 0, y:0, width: 280, height:0))
        infoText.textColor = UIColor.gray
        infoText.textAlignment = .center
        infoText.text = "The generation of a multisig wallet needs 3 addresses, please provide the first and we will build a request to send to the other parties"
        infoText.font = UIFont.systemFont(ofSize: 20)
        infoText.numberOfLines = 0
        infoText.frame.size.height = infoText.sizeThatFits(CGSize.init(width: infoText.frame.size.width, height: 0)).height
        infoText.center.x = self.center.x
        infoText.center.y = self.center.y - 50
        self.addSubview(infoText)
        
        let sy = infoText.frame.origin.y + infoText.frame.size.height + 20
        
        let selectedWalletView = UIView.init(frame: CGRect.init(x: 0, y: sy, width: 280, height: 60))
        selectedWalletView.backgroundColor = UIColor.brown
        selectedWalletView.center.x = self.center.x
        selectedWalletView.layer.cornerRadius = 8
        selectedWalletView.layer.borderColor = UIColor.darkGray.cgColor
        selectedWalletView.layer.borderWidth = 3
        self.addSubview(selectedWalletView)
        
        let selectButton = UIButton.init(type: .roundedRect)
        selectButton.frame = selectedWalletView.frame
        selectButton.addTarget(self, action: #selector(selectedButtonPressed), for: .touchUpInside)
        self.addSubview(selectButton)
        
        let by = selectedWalletView.frame.origin.y + selectedWalletView.frame.size.height + 10
        
        let setAddressButton = UIButton.init(type: .roundedRect)
        setAddressButton.frame = CGRect.init(x: 0, y: by, width: 160, height: 35)
        setAddressButton.addTarget(self, action: #selector(setAddressButtonPressed), for: .touchUpInside)
        setAddressButton.center.x = self.center.x
        setAddressButton.setTitle("use this address", for: .normal)
        setAddressButton.isEnabled = false
        self.addSubview(setAddressButton)
        
    }
    
    @objc func setAddressButtonPressed()
    {
        
    }
    
    @objc func selectedButtonPressed()
    {
        print("selectedButtonPressed")
        
        guard let _ = self.delegate?.setWalletForMultisigButtonPressed()
        else { return }
    }
   
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
