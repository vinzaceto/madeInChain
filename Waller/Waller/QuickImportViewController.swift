//
//  QuickImportViewController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 13/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class QuickImportViewController: UIViewController
{
    
    var canScan = true
    var borderImage:UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        self.view.backgroundColor = UIColor.lightGray
        
        borderImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 280, height: 280))
        borderImage.image = UIImage.init(named: "QRBorders")
        borderImage.center.x = self.view.center.x
        borderImage.center.y = self.view.center.y + 70
        self.view.addSubview(borderImage)
        
        let infoText = UILabel.init(frame:CGRect.init(x: 0, y:0, width: 280, height: 100))
        infoText.center.x = self.view.center.x
        infoText.frame.origin.y = borderImage.frame.origin.y - infoText.frame.size.height - 10
        infoText.textColor = UIColor.gray
        infoText.textAlignment = .center
        infoText.text = "Scan a QRCode to import a wallet as watch only or import a multisig or payment request created by another user."
        infoText.font = UIFont.systemFont(ofSize: 20)
        infoText.numberOfLines = 0
        self.view.addSubview(infoText)
        
        addScannerView()
    }
    
    func addScannerView()
    {
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
                print(btcurl.address!)
                
                self.canScan = false
                
                print("WALLET FOUND : \(String(describing: btcurl.address?.string))")
//                guard let _ = self.delegate?.walletFounded(address: (btcurl.address?.string)!)
//                    else { return }
            }
            else
            {
                print(message!)
            }
        }
        
        scannerView?.frame = CGRect.init(x: 0, y: 0, width: 250, height: 250)
        scannerView?.center = borderImage.center
        self.view.addSubview(scannerView!)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
