//
//  QRCodeScanView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 10/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class QRCodeScanView: UIView {

    var canScan = true
    var delegate:SetupPageViewDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        self.backgroundColor = UIColor.lightGray
        
        let scannerView = BTCQRCode.scannerView
        {
            (message) in
            
            if self.canScan == false
            {return}
            
            guard let url = URL.init(string: message!) else
            {
                return
            }
            
            guard let btcurl = BTCBitcoinURL.init(url: url) else
            {
                return
            }
            
            if btcurl.isValid
            {
                print("is valid address")
                print(btcurl.address)
                
                self.canScan = false
                
                guard let _ = self.delegate?.walletFounded(address: (btcurl.address?.string)!)
                else { return }
            }
            else
            {
                print(message!)
            }
        }
        
        self.addSubview(scannerView!)
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
