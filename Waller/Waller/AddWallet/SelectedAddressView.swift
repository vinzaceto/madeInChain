//
//  SelectedAddressView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 11/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class SelectedAddressView: UIView {

    var defaultView:UILabel!
    let changeAddressButton = UIButton.init(type: .roundedRect)
    var nameLabel:UILabel!
    var addressLabel:UILabel!

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 3
        
        nameLabel = UILabel.init(frame: CGRect.init(x: 5, y: 5, width: self.frame.size.width-10, height: 25))
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.darkGray
        nameLabel.text = "Selected wallet: yoyo"
        self.addSubview(nameLabel)
        
        addressLabel = UILabel.init(frame: CGRect.init(x: 5, y: 30, width: self.frame.size.width-10, height: 25))
        addressLabel.backgroundColor = UIColor.clear
        addressLabel.font = UIFont.systemFont(ofSize: 13)
        addressLabel.textAlignment = .center
        addressLabel.textColor = UIColor.darkGray
        addressLabel.text = "1BoatSLRHtKNngkdXEeobR76b53LETtpyT"
        self.addSubview(addressLabel)
        
        changeAddressButton.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(changeAddressButton)        
    }
    
    func setAddress(name:String,address:String)
    {
        defaultView.removeFromSuperview()
        nameLabel.text = "Selected address: \(name)"
        addressLabel.text = address
    }
    
    func setDefault()
    {
        nameLabel.text = ""
        addressLabel.text = ""
        
        defaultView = UILabel.init(frame: CGRect.init(x:5,y:5,width:self.frame.size.width-10,height:self.frame.size.height - 10))
        defaultView.layer.cornerRadius = 6
        defaultView.clipsToBounds = true
        defaultView.backgroundColor = UIColor.darkGray
        defaultView.text = "tap to select an address"
        defaultView.textAlignment = .center
        defaultView.textColor = UIColor.lightText
        self.addSubview(defaultView)
        
        self.bringSubview(toFront: changeAddressButton)
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
