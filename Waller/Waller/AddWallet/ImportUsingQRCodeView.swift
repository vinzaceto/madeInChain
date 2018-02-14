//
//  ImportUsingQRCodeView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 10/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class ImportUsingQRCodeView: UIView {

    var canScan = true
    var delegate:SetupPageViewDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        self.backgroundColor = UIColor.lightGray        
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
