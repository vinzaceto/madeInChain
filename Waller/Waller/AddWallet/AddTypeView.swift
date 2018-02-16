//
//  AddTypeView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 08/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit




class AddTypeView: UIView, MultiOptionViewDelegate {
    
    var multiView:MultiOptionView!
    var delegate:SetupPageViewDelegate!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        self.backgroundColor = Props().addViewsBackgroundColor

        var data:[Option] = []
        
        let option1 = Option.init(title: "Create a standard Wallet", text: "Create a simple wallet to send and receive funds, it will be protected with a password and stored directly on your device.", buttonTitle: "Create a Wallet")
        let option2 = Option.init(title: "Request a multisig Wallet", text: "A multisignature wallet is like a shared wallet, it can receive funds from anyone, but require the signature of more than one person to send.", buttonTitle: "Request a multisig Wallet")
        let option3 = Option.init(title: "Import a Wallet", text: "Import a wallet that you already have by using a private key or a mnemonic.", buttonTitle: "Import a Wallet")
        
        data.append(option1)
        data.append(option2)
        data.append(option3)
        
        multiView = MultiOptionView.init(frame:CGRect.init(x: 0, y: 100, width: 300, height: 0),data:data)
        multiView.delegate = self
        multiView.setDefaultIndex(index: 0)
        self.addSubview(multiView)
        
        multiView.center.x = self.center.x
        multiView.center.y = self.center.y + 40
    }
    
    func optionSelected(selectedIndex: Int) {
        
        var addType = AddType.Standard
        switch selectedIndex
        {
        case 0:
            addType = AddType.Standard
        case 1:
            addType = AddType.Multisig
        case 2:
            addType = AddType.Import
        default:
            addType = AddType.Standard
        }
        
        guard let _ = self.delegate?.addtypeSelected(selectedType: addType)
        else { return }
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
