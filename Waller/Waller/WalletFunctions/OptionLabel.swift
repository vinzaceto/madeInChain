//
//  OptionLabel.swift
//  Waller
//
//  Created by Vincenzo Ajello on 16/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

protocol OptionLabelDelegate
{
    func checkBoxChange(isChecked:Bool)
}

class OptionLabel: UIView {

    var label:UILabel!
    var optionButton:OptionButton!
    var delegate:OptionLabelDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        layer.cornerRadius = 6
        backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        
        label = UILabel.init(frame: CGRect.init(x: 5, y: 0, width: frame.size.width-10-30, height: frame.size.height))
        label.backgroundColor = UIColor.clear
        self.addSubview(label)
        
        optionButton = OptionButton.init(frame: CGRect.init(x: self.frame.size.width - 25, y: 5, width: 20, height: 20))
        optionButton.button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        optionButton.check(isChecked: false)
        self.addSubview(optionButton)

    }
    
    @objc func buttonPressed()
    {
        print("buttonPressed")
        if optionButton.isChecked == false
        {
            optionButton.check(isChecked: true)
            guard let _ = delegate?.checkBoxChange(isChecked: true) else { return }
            return
        }
        optionButton.check(isChecked: false)
        guard let _ = delegate?.checkBoxChange(isChecked: false) else { return }
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}

class OptionButton: UIView
{
    var fillView:UIView!
    let button = UIButton.init(type: .roundedRect)
    var isChecked:Bool = true

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        layer.cornerRadius = frame.size.width/2
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor

        fillView = UIView.init(frame: CGRect.init(x: 3, y: 3, width: self.frame.size.width-6, height: self.frame.size.height-6))
        fillView.layer.cornerRadius = fillView.frame.size.width/2
        fillView.backgroundColor = UIColor.darkGray
        fillView.isHidden = true
        addSubview(fillView)
        
        button.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        addSubview(button)
    }
    
    func check(isChecked:Bool)
    {
        self.isChecked = isChecked
        fillView.isHidden = isChecked
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
