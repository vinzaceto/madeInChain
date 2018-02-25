//
//  PaymentWalletView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 18/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class PaymentWalletView: UIView, SlideButtonDelegate,UITextFieldDelegate
{
    var canScan = true
    var wallet:Wallet!
    var sendView:UIView!
    var scannerView:UIView!
    let flipButton = UIButton.init(type: .custom)
    let backButton = UIButton.init(type: .custom)
    var receiverAddressField:UITextField!
    var amountField:UITextField!
    var currencyField:UITextField!
    var feeLabel:UILabel!
    var totalLabel:UILabel!
    var delegate:WalletFunctionDelegate!
    var slider:MMSlidingButton!
    var btcAmountLabel:UILabel!
    var usdLabel:UILabel!
    var usdAmountLabel:UILabel!
    var btcValue:Double!
    
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
        flipButton.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        addSubview(flipButton)
        
        backButton.frame = CGRect.init(x: 10, y: 10, width:45, height: 45)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.setImage(#imageLiteral(resourceName: "backIcon"), for: .normal)
        backButton.isHidden = true
        self.addSubview(backButton)
        
        sendView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: viewWidth, height: 340))
        addSubview(sendView)
        
        /******* *******/
        let btcw:CGFloat = 70
        let btcx = (viewWidth / 2) + btcw - 30
        
        let btcLabel = UILabel.init(frame: CGRect.init(x: btcx, y: 20, width: btcw, height: 10))
        btcLabel.backgroundColor = UIColor.clear
        btcLabel.textAlignment = .right
        btcLabel.font = UIFont.boldSystemFont(ofSize: 11)
        btcLabel.text = "TOTAL BTC"
        btcLabel.textColor = UIColor.darkGray
        sendView.addSubview(btcLabel)
        
        btcAmountLabel = UILabel.init(frame: CGRect.init(x: btcx-100, y: 15, width: 100, height: 20))
        btcAmountLabel.backgroundColor = UIColor.clear
        btcAmountLabel.textAlignment = .right
        btcAmountLabel.adjustsFontSizeToFitWidth = true
        btcAmountLabel.textColor = UIColor.black
        btcAmountLabel.text = "0"
        sendView.addSubview(btcAmountLabel)
        
        usdLabel = UILabel.init(frame: CGRect.init(x: btcLabel.frame.origin.x + 10, y: 40, width: btcw, height: 10))
        usdLabel.backgroundColor = UIColor.clear
        usdLabel.textAlignment = .left
        usdLabel.font = UIFont.boldSystemFont(ofSize: 12)
        usdLabel.text = "USD"
        usdLabel.textColor = UIColor.darkGray
        //btcLabel.shadowColor = UIColor.gray
        //btcLabel.shadowOffset = CGSize(width: 0.5, height: 0.3)
        //sendView.addSubview(usdLabel)
        
        usdAmountLabel = UILabel.init(frame: CGRect.init(x: btcx-100, y: 37, width: 100, height: 20))
        usdAmountLabel.backgroundColor = UIColor.clear
        usdAmountLabel.textAlignment = .right
        usdAmountLabel.adjustsFontSizeToFitWidth = true
        usdAmountLabel.text = "--"
        //sendView.addSubview(usdAmountLabel)
        
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
        receiverAddressField.delegate = self
        sendView.addSubview(receiverAddressField)
        
        let sbx = receiverAddressField.frame.origin.x + receiverAddressField.frame.width + 10
        let scanButton = UIButton.init(type: UIButtonType.custom)
        scanButton.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
        scanButton.frame = CGRect.init(x: sbx, y: 0, width: 45, height: 45)
        scanButton.setImage(UIImage.init(named: "barcodeIcon"), for: .normal)
        scanButton.center.y = receiverAddressField.center.y
        sendView.addSubview(scanButton)
        
        self.bringSubview(toFront: flipButton)
        self.bringSubview(toFront: backButton)
        
        let btc = UILabel.init(frame: CGRect.init(x: 25, y: 120, width: 50, height: 20))
        btc.text = "BTC"
        btc.textColor = UIColor.gray
        sendView.addSubview(btc)
        
        /*
        let amountString = "Type the amount to send"
        let attributedAmountString = NSMutableAttributedString(string: amountString, attributes: nil)
        let amountRange = (attributedAmountString.string as NSString).range(of: amountString)
        attributedAmountString.setAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightText], range: amountRange)
        */
        
        amountField = UITextField.init(frame: CGRect.init(x: 20, y: 140, width: (viewWidth/2)-45, height: 35))
        amountField.backgroundColor = UIColor.lightGray
        amountField.layer.cornerRadius = 6
        amountField.textAlignment = .center
        //amountField.attributedPlaceholder = attributedAmountString
        amountField.textColor = UIColor.lightText
        amountField.keyboardType = UIKeyboardType.decimalPad
        amountField.autocorrectionType = UITextAutocorrectionType.no
        amountField.text = "0"
        amountField.delegate = self
        sendView.addSubview(amountField)
        
        currencyField = UITextField.init(frame: CGRect.init(x: viewWidth-((viewWidth/2)-45)-18, y: 140, width: (viewWidth/2)-45, height: 35))
        currencyField.backgroundColor = UIColor.lightGray
        currencyField.layer.cornerRadius = 6
        currencyField.textAlignment = .center
        currencyField.textColor = UIColor.lightText
        currencyField.keyboardType = UIKeyboardType.decimalPad
        currencyField.autocorrectionType = UITextAutocorrectionType.no
        currencyField.delegate = self
        currencyField.text = formatNumberWithCurrency(number: 0)
        sendView.addSubview(currencyField)
       
        let usd = UILabel.init(frame: CGRect.init(x: currencyField.frame.origin.x, y: 120, width: 50, height: 20))
        usd.text = "USD"
        usd.textColor = UIColor.gray
        sendView.addSubview(usd)
        
        var convertImage = UIImage.init(named: "convertIcon")
        convertImage = convertImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        let swapIcon = UIImageView.init(frame: CGRect.init(x: 0, y: 135, width: 45, height: 45))
        swapIcon.image = convertImage
        swapIcon.tintColor = UIColor.lightGray
        swapIcon.center.x = self.center.x
        sendView.addSubview(swapIcon)
        
        let fee = UILabel.init(frame: CGRect.init(x: 20, y: 190, width: 120, height: 20))
        fee.text = "Calculated fee:"
        fee.textColor = UIColor.gray
        sendView.addSubview(fee)
        
        feeLabel = UILabel.init(frame: CGRect.init(x: 140, y: 190, width: viewWidth-160, height: 20))
        feeLabel.text = "0.000001"
        feeLabel.textColor = UIColor.gray
        feeLabel.backgroundColor = UIColor.clear
        sendView.addSubview(feeLabel)
        
        let total = UILabel.init(frame: CGRect.init(x: 20, y: 220, width: 120, height: 20))
        total.text = "Total:"
        total.textAlignment = .right
        total.textColor = UIColor.gray
        sendView.addSubview(total)
        
        totalLabel = UILabel.init(frame: CGRect.init(x: 140, y: 220, width: viewWidth-160, height: 20))
        totalLabel.text = "0"
        totalLabel.textColor = UIColor.gray
        totalLabel.backgroundColor = UIColor.clear
        sendView.addSubview(totalLabel)
        
        slider = MMSlidingButton.init(frame: CGRect.init(x:20, y: 260, width: viewWidth - 40, height: 60))
        slider.buttonText = "Slide to Send >>>"
        slider.buttonCornerRadius = 6
        slider.buttonUnlockedText = "Transaction created"
        slider.buttonColor = UIColor.gray
        slider.animationFinished()
        slider.dragPointWidth = 60
        slider.isUserInteractionEnabled = true
        slider.delegate = self
        sendView.addSubview(slider)
    }
    
    func createTransaction(pass:String)
    {
        let data = Data.init(base64Encoded: wallet.privatekey, options: .ignoreUnknownCharacters)
        guard let privateKey = decrypt(data: data!, pass: pass) else
        {
            print("unable to decrypt the private key")
            return
        }
        print("decrypted \(privateKey)")
        guard let keychain = BTCKeychain.init(extendedKey: privateKey) else
        {
            print("unable to build the keychain")
            return
        }
        
        print("decrypted \(privateKey)")
       
        let amount:BTCAmount = 123000
        let fee:BTCAmount = 1000
        print(amount)
        
        let test = BitcoinTransaction.init()
        test.buildTransaction(wallet: wallet, amount: amount,fee:fee, destinationAddress: "mmUZ98EhFFh9HTbTfqoTHsghUTW8h6hXh1", key: keychain.key)
        {
            (success, error, transaction) in
            if success == true
            {
                guard let tx = transaction else {return}

                print("Transaction builded : \(String(describing: transaction))")
                print("estimated fee : \(test.estimateFee(tx: transaction!))")
                print(tx.data)
                
                let api = BTCTestnetInfo.init()
                api.broadcastTransactionData(data: tx.data, completion:
                {
                    (success, error) in
                    print(error)
                })
            }
            else
            {
                print("fail to build the transaction : \(String(describing: error))")
            }
        }
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
        
        let borderImage = UIImageView.init(frame: CGRect.init(x: (viewWidth-260)/2, y: 60, width: 260, height: 260))
        borderImage.image = UIImage.init(named: "QRBorders")
        scannerView.addSubview(borderImage)
        
        let scanView = getScanView()
        scanView?.frame = CGRect.init(x: 0, y: 0, width: 230, height: 230)
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
            print("\(String(describing: message))")
            
            if self.canScan == false
            {
                return
            }
            
            if let  btcurl = BTCBitcoinURL.init(url: URL.init(string: message!))
            {
                // check bitcoin address as valid BTCBitcoinUrl
                if btcurl.isValid
                {
                    print(btcurl.address!)
                    self.canScan = false
                    
                    guard let address = btcurl.address?.string else { return }
                    print("WALLET FOUND : \(address)")
                    
                    self.goBackWithAddress(address: address)
                    
                    return
                }
            }
        }
        return scanView
    }
    
    func showScannerView()
    {
        amountField.resignFirstResponder()
        currencyField.resignFirstResponder()
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
        self.canScan = true
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
    
    func decrypt(data:Data, pass:String) -> String?
    {
        print("original data : \(data.base64EncodedString())")
        
        do
        {
            let originalData = try RNCryptor.decrypt(data: data, withPassword: pass)
            let originalPrivateKey = String.init(data: originalData, encoding: String.Encoding.utf8)
            return originalPrivateKey
        }
        catch
        {
            return nil
        }
    }
    
    func formatNumberWithCurrency(number:NSNumber) -> String
    {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.numberStyle = .currency
        
        guard let formattedTotal = formatter.string(from: number)
        else
        {
            return formatter.string(from: 0)!
        }
        
        return formattedTotal
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason)
    {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.numberStyle = .currency
        
        if amountField.text == ""
        {
            amountField.text = "0"
        }
        if currencyField.text == ""
        {
            currencyField.text = formatter.string(from: 0)
        }
        
        guard let _ = delegate?.keyboardDidClose() else {return}
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        guard let _ = delegate?.keyboardDidOpen() else {return}
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let o = currentText.replacingCharacters(in: stringRange, with: string)
        
        
        
        if textField == currencyField
        {
            if let amount = convertCurrencyToDouble(usd:o)
            {
                print("calculate bitcoin from usd")
                print("usd amount: \(amount)")
                guard let value = btcValue else { return true }
                print("bitcoin value: \(value)")
                var total = amount / value
                total = (total * 100000000).rounded() / 100000000
                
                if total.isLess(than: 0.0001)
                {
                    total = 0
                }
                
                amountField.text = "\(total)"

                let fee:Double = Double(0.00000100)
                feeLabel.text = "0.00000100"

                total = total + fee
                totalLabel.text = "\(total)"

            }
        }
        if textField == amountField
        {
            print("calculate usd from bitcoin")
            let amount = o.toDouble()
            print("btc amount: \(amount)")
            guard let value = btcValue else { return true }
            print("bitcoin value: \(value)")
            guard let amo = amount else {return true}
            var total = amo * value
            print("btc total : \(total)")

            let formatter = NumberFormatter()
            formatter.locale = Locale.init(identifier: "en_US")
            formatter.numberStyle = .currency
            
            guard let formattedTotal = formatter.string(from: NSNumber(value:total)) else { return true }
            print("formattedTotal: \(formattedTotal)")
            currencyField.text  = formattedTotal
            
            print("btc total: \(amount)")
            
            
            
            let fee:Decimal = Decimal(0.00000100)
            feeLabel.text = "0.00000100"
            var tot  = Decimal.init(amo) + fee

            if tot.isLess(than: fee)
            {
                tot = 0.0
            }
            
            
            totalLabel.text = "\(tot)"
        }
        
        return true
    }
    
    func convertCurrencyToDouble(usd:String) -> Double?
    {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.numberStyle = .currency

        if let number = formatter.number(from: usd)
        {
            return number.doubleValue
        }
        return nil
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
    
    func updateAmount()
    {
        print("updating payment view for address : \(wallet.address)")
        guard let outputs = delegate?.getOutputBalanceByAddress(address: wallet.address) else {return}
        var unconfirmedAmount:BTCAmount = 0
        var confirmedAmount:BTCAmount = 0
        var totalAmount:BTCAmount = 0
        for output in outputs
        {
            totalAmount = totalAmount + output.value
            if output.confirmations >= 3
            {
                confirmedAmount = confirmedAmount + output.value
            }
        }
        unconfirmedAmount = totalAmount - confirmedAmount
        
        print("total : \(totalAmount)")
        print("confirmed : \(confirmedAmount)")
        print("unconfirmed : \(unconfirmedAmount)")
        
        let formatter = BTCNumberFormatter.init(bitcoinUnit: BTCNumberFormatterUnit.BTC)
        let amount = formatter?.string(fromAmount: confirmedAmount)
        self.btcAmountLabel.text = amount
    }
    
    func updateBtcValue()
    {
        guard let value = delegate?.getBTCValue() else {return}
        self.btcValue = value
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

}
