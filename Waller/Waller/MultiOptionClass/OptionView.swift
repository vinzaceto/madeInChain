//
//  OptionView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 06/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

protocol OptionViewDelegate {
    
    func optionButtonPressed(pressedIndex:Int)
    func optionButtonSelected(selectedIndex:Int)
}

class OptionView: UIView {

    var index:Int = 0
    var delegate:OptionViewDelegate!
    var height:CGFloat = 0
    var isOpen:Bool = true
    
    init(frame: CGRect, data:Option, index:Int) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.white 
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(Props.optionCornerRadius)
        self.index = index
        
        let optionTitleFrame = CGRect.init(x: 0, y: Props.optionViewMargin, width: Int(frame.size.width), height: Props.optionTitleHeight)
        let optionTitle = UILabel.init(frame: optionTitleFrame)
        optionTitle.backgroundColor = UIColor.clear
        optionTitle.textColor = UIColor.lightGray
        optionTitle.textAlignment = .center
        optionTitle.font = UIFont.boldSystemFont(ofSize: 20)
        optionTitle.text = data.title
        self.addSubview(optionTitle)
        
        let optionTextFrame = CGRect.init(x: CGFloat(Props.optionViewMargin), y: optionTitle.frame.size.height+20,
        width: frame.size.width - CGFloat(Props.optionViewMargin*2), height: 0)
        let optionText = UILabel.init(frame:optionTextFrame)
        optionText.textColor = UIColor.gray
        optionText.textAlignment = .center
        optionText.text = data.text
        optionText.font = UIFont.systemFont(ofSize: 20)
        optionText.numberOfLines = 0
        optionText.sizeToFit()
        self.addSubview(optionText)
        
        let y:CGFloat = optionText.frame.origin.y + optionText.frame.size.height + 10
        let selectButton = UIButton.init(type: .roundedRect)
        selectButton.frame = CGRect.init(x: 0, y: y, width: frame.size.width, height: 40)
        selectButton.setTitle(data.buttonTitle, for: .normal)
        selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        selectButton.addTarget(self, action: #selector(optionSelected), for: .touchUpInside)
        self.addSubview(selectButton)
        
        height = optionTitle.frame.size.height + optionText.frame.size.height + 20 + CGFloat(Props.optionViewMargin) + selectButton.frame.size.height + 10
        self.frame.size.height = height
        
        let button = UIButton.init(type: UIButtonType.roundedRect)
        button.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width , height: self.frame.size.height)
        button.addTarget(self, action: #selector(optionPressed), for: .touchUpInside)
        self.addSubview(button)
        
        bringSubview(toFront: selectButton)
    }
    
    @objc func optionSelected()
    {
        guard let _ = self.delegate?.optionButtonSelected(selectedIndex: self.index)
        else { return }
    }
    
    @objc func optionPressed()
    {        
        guard let _ = self.delegate?.optionButtonPressed(pressedIndex: self.index)
        else { return }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

}
