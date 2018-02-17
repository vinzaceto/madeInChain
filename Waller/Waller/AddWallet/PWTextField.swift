//
//  PWTextField.swift
//  Waller
//
//  Created by Vincenzo Ajello on 09/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class PWTextField: UIView {

    var textField:UITextField!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let cornerRadius:CGFloat = 6
        
        textField = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width-frame.size.height-2, height: frame.size.height))
        textField.backgroundColor = UIColor.gray
        textField.layer.cornerRadius = cornerRadius
        textField.clipsToBounds = true
        self.addSubview(textField)
        
        textField.textAlignment = .center
        textField.isSecureTextEntry = true
                
        let showButton = UIButton.init(type: UIButtonType.roundedRect)
        showButton.frame = CGRect.init(x: textField.frame.size.width+2, y: 0, width: frame.size.height, height: frame.size.height)
        showButton.layer.cornerRadius = cornerRadius
        showButton.tintColor = UIColor.lightText
        showButton.setImage(UIImage.init(named: "eye"), for: .normal)
        showButton.clipsToBounds = true
        showButton.addTarget(self, action: #selector(revealText), for: .touchDown)
        showButton.addTarget(self, action: #selector(hideText), for: .touchDragExit)
        showButton.addTarget(self, action: #selector(hideText), for: .touchUpInside)
        showButton.backgroundColor = UIColor.clear
        self.addSubview(showButton)
    }
 
    @objc func revealText()
    {textField.isSecureTextEntry = false}
    
    @objc func hideText()
    {textField.isSecureTextEntry = true}
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
    
}
