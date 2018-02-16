//
//  SetAddressForMultisigView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 11/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class SetAddressForMultisigView: UIView {

    var selectedWalletView:SelectedAddressView!
    var setAddressButton = UIButton.init(type: .roundedRect)
    var delegate:SetupPageViewDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = Props().addViewsBackgroundColor

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
        
        selectedWalletView = SelectedAddressView.init(frame: CGRect.init(x: 0, y: sy, width: 280, height: 60))
        selectedWalletView.changeAddressButton.addTarget(self, action: #selector(changeAddressButtonPressed), for: .touchUpInside)
        selectedWalletView.center.x = self.center.x
        self.addSubview(selectedWalletView)
        
        let by = selectedWalletView.frame.origin.y + selectedWalletView.frame.size.height + 10
        
        setAddressButton.frame = CGRect.init(x: 0, y: by, width: 180, height: 35)
        setAddressButton.addTarget(self, action: #selector(setAddressButtonPressed), for: .touchUpInside)
        setAddressButton.center.x = self.center.x
        setAddressButton.setTitle("generate multisig request", for: .normal)
        setAddressButton.isEnabled = false
        self.addSubview(setAddressButton)
        
    }
    
    @objc func setAddressButtonPressed()
    {
        
    }
    
    @objc func changeAddressButtonPressed()
    {
        print("changeAddressButtonPressed")
                
        guard let _ = self.delegate?.changeAddressForMultisigButtonPressed()
        else { return }
    }
    
    func setAddress(name:String,address:String)
    {
        setAddressButton.isEnabled = true
        selectedWalletView.setAddress(name: name, address: address)
    }
   
    func setDefault()
    {
        setAddressButton.isEnabled = false
        selectedWalletView.setDefault()
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
