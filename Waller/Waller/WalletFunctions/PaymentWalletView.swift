//
//  PaymentWalletView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 18/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class PaymentWalletView: UIView, SlideButtonDelegate
{
    var sendView:UIView!
    var scannerView:UIView!
    let flipButton = UIButton.init(type: .custom)
    let backButton = UIButton.init(type: .custom)
    var receiverAddressField:UITextField!
    var amountField:UITextField!
    var feeLabel:UILabel!
    var delegate:WalletFunctionDelegate!
    var slider:MMSlidingButton!
    var btcAmountLabel:UILabel!
    var usdLabel:UILabel!
    var usdAmountLabel:UILabel!

    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        layer.cornerRadius = 6
        clipsToBounds = true
        
        let viewWidth = UIScreen.main.bounds.width - 30
        
        let flipButton = UIButton.init(type: .custom)
        flipButton.frame = CGRect.init(x: viewWidth - 55 , y: 10, width:45, height: 45)
        flipButton.addTarget(self, action: #selector(flipButtonPressed), for: .touchUpInside)
        flipButton.setImage(#imageLiteral(resourceName: "CloseIcon"), for: .normal)
        addSubview(flipButton)
        
        backButton.frame = CGRect.init(x: 10, y: 10, width:45, height: 45)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        //backButton.setTitle("back", for: .normal)
        backButton.setImage(#imageLiteral(resourceName: "BackIcon"), for: .normal)
        backButton.isHidden = true
        self.addSubview(backButton)
        
        sendView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: viewWidth, height: 340))
        addSubview(sendView)
        
        /******* *******/
        let btcw:CGFloat = 33
        let btcx = (viewWidth / 2) + btcw
        
        let btcLabel = UILabel.init(frame: CGRect.init(x: btcx, y: 10, width: btcw, height: 10))
        btcLabel.backgroundColor = UIColor.clear
        btcLabel.textAlignment = .right
        btcLabel.font = UIFont.boldSystemFont(ofSize: 12)
        btcLabel.text = "BTC"
        btcLabel.textColor = UIColor.darkGray
        //btcLabel.shadowColor = UIColor.gray
        //btcLabel.shadowOffset = CGSize(width: 0.5, height: 0.3)
        sendView.addSubview(btcLabel)
        
        btcAmountLabel = UILabel.init(frame: CGRect.init(x: btcx-100, y: 10, width: 100, height: 20))
        btcAmountLabel.backgroundColor = UIColor.clear
        btcAmountLabel.textAlignment = .right
        btcAmountLabel.adjustsFontSizeToFitWidth = true
        btcAmountLabel.textColor = UIColor.black
        //amountLabel.shadowColor = UIColor.black
        //amountLabel.shadowOffset = CGSize(width: 0.5, height: 0.3)
        sendView.addSubview(btcAmountLabel)
        
        usdLabel = UILabel.init(frame: CGRect.init(x: btcx, y: 25, width: btcw, height: 10))
        usdLabel.backgroundColor = UIColor.clear
        usdLabel.textAlignment = .right
        usdLabel.font = UIFont.boldSystemFont(ofSize: 12)
        usdLabel.text = "USD"
        usdLabel.textColor = UIColor.darkGray
        //btcLabel.shadowColor = UIColor.gray
        //btcLabel.shadowOffset = CGSize(width: 0.5, height: 0.3)
        sendView.addSubview(usdLabel)
        
        usdAmountLabel = UILabel.init(frame: CGRect.init(x: btcx-100, y: 25, width: 100, height: 20))
        usdAmountLabel.backgroundColor = UIColor.clear
        usdAmountLabel.textAlignment = .right
        usdAmountLabel.adjustsFontSizeToFitWidth = true
        sendView.addSubview(usdAmountLabel)
        
        let hintLabel = UILabel.init(frame: CGRect.init(x: 25, y: 50, width: viewWidth-80, height: 20))
        hintLabel.text = "Address"
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
        let scanButton = UIButton.init(type: UIButtonType.custom)
        scanButton.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
        scanButton.frame = CGRect.init(x: sbx, y: 0, width: 35, height: 35)
        scanButton.setImage(UIImage.init(named: "scan"), for: .normal)
        scanButton.center.y = receiverAddressField.center.y
        sendView.addSubview(scanButton)
        
        self.bringSubview(toFront: flipButton)
        self.bringSubview(toFront: backButton)
        
        let amountLabel = UILabel.init(frame: CGRect.init(x: 25, y: 120, width: viewWidth-80, height: 20))
        amountLabel.text = "Amount"
        amountLabel.textColor = UIColor.gray
        sendView.addSubview(amountLabel)
        
        
        let amountString = "Type the amount to send"
        let attributedAmountString = NSMutableAttributedString(string: amountString, attributes: nil)
        let amountRange = (attributedAmountString.string as NSString).range(of: amountString)
        attributedAmountString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightText], range: amountRange)
        amountField = UITextField.init(frame: CGRect.init(x: 20, y: 140, width: viewWidth-80, height: 35))
        amountField.backgroundColor = UIColor.darkGray
        amountField.layer.cornerRadius = 6
        amountField.textAlignment = .center
        amountField.attributedPlaceholder = attributedAmountString
        amountField.textColor = UIColor.lightText
        amountField.keyboardType = UIKeyboardType.numberPad
        amountField.autocorrectionType = UITextAutocorrectionType.no
        sendView.addSubview(amountField)
        
        feeLabel = UILabel.init(frame: CGRect.init(x: 25, y: 190, width: viewWidth-80, height: 20))
        feeLabel.text = "Fee"
        feeLabel.textColor = UIColor.gray
        sendView.addSubview(feeLabel)
        
        slider = MMSlidingButton.init(frame: CGRect.init(x:20, y: 250, width: viewWidth - 40, height: 60))
        slider.buttonText = "Slide to Send >>>"
        slider.buttonCornerRadius = 6
        slider.buttonUnlockedText = "Transaction created"
        slider.buttonColor = UIColor.gray
        slider.animationFinished()
        slider.dragPointWidth = 40
        slider.isUserInteractionEnabled = false
        slider.delegate = self
        sendView.addSubview(slider)
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
        backButton.isHidden = false
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
        backButton.isHidden = true
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
    
    func buttonStatus(unlocked: Bool, sender: MMSlidingButton) {
        print("slide unlocked \(unlocked)")
        if(unlocked) {

        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
