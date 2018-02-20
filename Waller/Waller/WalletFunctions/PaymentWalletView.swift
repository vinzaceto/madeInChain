//
//  PaymentWalletView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 18/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class PaymentWalletView: UIView
{
    var sendView:UIView!
    var scannerView:UIView!
    let flipButton = UIButton.init(type: .roundedRect)
    let backButton = UIButton.init(type: .roundedRect)
    var receiverAddressField:UITextField!
    var delegate:WalletFunctionDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        layer.cornerRadius = 6
        clipsToBounds = true
        
        let viewWidth = UIScreen.main.bounds.width - 30
        
        flipButton.frame = CGRect.init(x: 0, y: 10, width:60, height: 25)
        flipButton.addTarget(self, action: #selector(flipButtonPressed), for: .touchUpInside)
        flipButton.backgroundColor = UIColor.clear
        flipButton.setTitle("close", for: .normal)
        flipButton.center.x = self.center.x
        addSubview(flipButton)
        
        backButton.frame = CGRect.init(x: 10, y: 10, width: 50, height: 25)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.setTitle("back", for: .normal)
        backButton.isEnabled = false
        self.addSubview(backButton)
        
        sendView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: viewWidth, height: 340))
        addSubview(sendView)
        
        let hintLabel = UILabel.init(frame: CGRect.init(x: 25, y: 50, width: viewWidth-80, height: 20))
        hintLabel.text = "Type or scan a receiver address"
        hintLabel.textColor = UIColor.gray
        sendView.addSubview(hintLabel)
        
        let baseString = "receiver address"
        let attributedString = NSMutableAttributedString(string: baseString, attributes: nil)
        let bitstampRange = (attributedString.string as NSString).range(of: baseString)
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightText], range: bitstampRange)
        receiverAddressField = UITextField.init(frame: CGRect.init(x: 20, y: 73, width: viewWidth-80, height: 35))
        receiverAddressField.backgroundColor = UIColor.darkGray
        receiverAddressField.layer.cornerRadius = 6
        receiverAddressField.textAlignment = .center
        receiverAddressField.attributedPlaceholder = attributedString
        receiverAddressField.textColor = UIColor.lightText
        receiverAddressField.autocorrectionType = UITextAutocorrectionType.no
        sendView.addSubview(receiverAddressField)
        
        let sbx = receiverAddressField.frame.origin.x + receiverAddressField.frame.width + 10
        let scanButton = UIButton.init(type: UIButtonType.roundedRect)
        scanButton.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
        scanButton.frame = CGRect.init(x: sbx, y: 0, width: 35, height: 35)
        scanButton.setImage(UIImage.init(named: "scan"), for: .normal)
        scanButton.center.y = receiverAddressField.center.y
        sendView.addSubview(scanButton)
        
        self.bringSubview(toFront: flipButton)
        self.bringSubview(toFront: backButton)
    }
    
    
    @objc func scanButtonPressed()
    {
        if scannerView != nil
        {
            scannerView.removeFromSuperview()
        }
        let viewWidth = UIScreen.main.bounds.width - 30
        
        scannerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: viewWidth, height: 340))
        scannerView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        scannerView.frame.origin.x = self.frame.size.width
        
        let borderImage = UIImageView.init(frame: CGRect.init(x: (viewWidth-280)/2, y: 40, width: 280, height: 280))
        borderImage.image = UIImage.init(named: "QRBorders")
        scannerView.addSubview(borderImage)
        
        let scanView = getScanView()
        scanView?.frame = CGRect.init(x: 0, y: 0, width: 250, height: 250)
        scanView?.center = borderImage.center
        scannerView.addSubview(scanView!)
        
        self.addSubview(scannerView)
        self.bringSubview(toFront: flipButton)
        self.bringSubview(toFront: backButton)
        
        showScannerView()
    }
    
    func getScanView() -> UIView?
    {
        let scanView = BTCQRCode.scannerView
        {
            (message) in
            print("\(message)")
        }
        return scanView
    }
    
    func showScannerView()
    {
        receiverAddressField.resignFirstResponder()
        backButton.isEnabled = true
        UIView.animate(withDuration: 0.5)
        {
            self.sendView.frame.origin.x = -self.frame.size.width
            self.scannerView.frame.origin.x = 0
        }
    }
    
    
    
    func goBackWithAddress(address:String)
    {
        receiverAddressField.text = address
        backButtonPressed()
    }
    
    @objc func backButtonPressed()
    {
        backButton.isEnabled = false
        UIView.animate(withDuration: 0.5)
        {
            self.sendView.frame.origin.x = 0
            self.scannerView.frame.origin.x = self.frame.size.width
        }
    }
    
    @objc func flipButtonPressed()
    {
        print("flipButtonPressed")
        guard let _ = delegate?.unflipCard() else { return }
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
