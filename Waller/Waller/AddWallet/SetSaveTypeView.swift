//
//  SetSaveTypeView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 08/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class SetSaveTypeView: UIView, MultiOptionViewDelegate {

    var multiView:MultiOptionView!
    var delegate:SetupPageViewDelegate!

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        self.backgroundColor = UIColor.lightGray

        let centeredWrapper = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: 0))
        self.addSubview(centeredWrapper)
        
        let infoText = UILabel.init(frame:CGRect.init(x: 30, y:0, width: 280, height: 50))
        infoText.center.x = self.center.x
        infoText.textColor = UIColor.gray
        infoText.textAlignment = .center
        infoText.text = "Before to generate your new address, select how to save it."
        infoText.font = UIFont.systemFont(ofSize: 20)
        infoText.numberOfLines = 0
        centeredWrapper.addSubview(infoText)
        
        var data:[Option] = []
        
        let option1 = Option.init(title: "Store locally", text: "Create a simple wallet to send and receive funds, it will be protected with a password and stored directly on your device.", buttonTitle: "Setup password for the wallet")
        let option2 = Option.init(title: "Cold wallet", text: "Store the keys of your wallet manually, without saving it into your device.", buttonTitle: "Store the wallet manually")
        
        data.append(option1)
        data.append(option2)
        
        let my = infoText.frame.origin.y + infoText.frame.size.height + 20
        
        multiView = MultiOptionView.init(frame: CGRect.init(x: 0, y: my, width: 300, height: 0),data:data)
        multiView.center.x = self.center.x
        multiView.setDefaultIndex(index: 0)
        multiView.delegate = self
        centeredWrapper.addSubview(multiView)

        let height = infoText.frame.size.height + multiView.frame.size.height + 20
        centeredWrapper.frame.size.height = height
        centeredWrapper.center = self.center
    }
    
    func optionSelected(selectedIndex: Int) {
        
        var saveType = SaveType.Local
        switch selectedIndex
        {
        case 0:
            saveType = SaveType.Local
        case 1:
            saveType = SaveType.Mnemonic
        default:
            saveType = SaveType.Local
        }
        
        guard let _ = self.delegate?.saveTypeSelected(selectedType: saveType)
        else { return }
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
