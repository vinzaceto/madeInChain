//
//  SetPasswordViewController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 06/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class SetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        let labelframe = CGRect.init(x: 20, y:100, width: self.view.frame.size.width - 40, height: 50)
        let optionText = UILabel.init(frame:labelframe)
        optionText.textColor = UIColor.gray
        optionText.textAlignment = .center
        optionText.text = "To securely store your new address, please define a password."
        optionText.font = UIFont.systemFont(ofSize: 20)
        optionText.numberOfLines = 0
        self.view.addSubview(optionText)
        
        
        
        
        
        
        
        
        
        
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
