//
//  XibView.swift
//  Waller
//
//  Created by Vincenzo Aceto on 14/02/2018.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

@IBDesignable
class InfoSectionXibController: UIView {

    var btcValue:NSNumber = 0.0
    var btcTotalAmount:NSNumber = 0.0
    
    @IBOutlet weak var currentCurrancy: UILabel!
    @IBOutlet weak var currentBTCvalue: UILabel!
    @IBOutlet weak var currentAmount: UILabel!
    @IBOutlet weak var currentBtcAmount: UILabel!
    
    @IBOutlet weak var currentCurrencyLabel: UILabel!
    @IBOutlet weak var currentAmountLabel: UILabel!
    @IBOutlet weak var currentBTCvalueLabel: UILabel!
    @IBOutlet weak var currentBtcAmountLabel: UILabel!
    
    var contentView: UIView?
    @IBInspectable var nibName: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()

        /*
        if let lastBtcValueTemp = UserDefaults.standard.string(forKey: Props.lastBtcValue) {
            self.currentBTCvalue.text = lastBtcValueTemp
        } else {
            self.currentBTCvalue.text = "--"
        }
        */
        self.currentBTCvalue.text = "--"
        
        print("COLOR SCHEMA CLEAR: \(Props.colorSchemaClear)")
        if Props.colorSchemaClear {
            currentAmountLabel.textColor = UIColor.black
            currentBTCvalueLabel.textColor = UIColor.black
            currentCurrencyLabel.textColor = UIColor.black
            currentBtcAmountLabel.textColor = UIColor.black
            
            currentAmount.textColor = UIColor.black
            currentBTCvalue.textColor = UIColor.black
            currentCurrancy.textColor = UIColor.black
            currentBtcAmount.textColor = UIColor.black
        } else {
            currentAmountLabel.textColor = UIColor.white
            currentBTCvalueLabel.textColor = UIColor.white
            currentCurrencyLabel.textColor = UIColor.white
            currentBtcAmountLabel.textColor = UIColor.white
            
            currentAmount.textColor = UIColor.white
            currentBTCvalue.textColor = UIColor.white
            currentCurrancy.textColor = UIColor.white
            currentBtcAmount.textColor = UIColor.white
        }
    }

    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }

    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    func updateBTCPrice(btcPrice:Double)
    {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.numberStyle = .currency
        
        self.btcValue = NSNumber.init(value: btcPrice)

        guard let formattedBTCValue = formatter.string(from: self.btcValue) else { return }
        self.currentBTCvalue.text = formattedBTCValue
        
        updateCurrencyTotal()
    }
    
    func updateBTCTotal(total:BTCAmount)
    {
        print("totale : \(total)")
        let formatter = BTCNumberFormatter.init(bitcoinUnit: BTCNumberFormatterUnit.BTC)
        let amount = formatter?.string(fromAmount: total)
        guard let totalBTCAmount = Double(amount!) else { return }
        self.btcTotalAmount = NSNumber.init(value: totalBTCAmount)
        self.currentBtcAmount.text = "\(self.btcTotalAmount)"
        
        updateCurrencyTotal()
    }
    
    func updateCurrencyTotal()
    {
        if self.btcTotalAmount.doubleValue == 0
        {
            self.currentAmount.text = "--"
            return
        }
        let formattedTotal = self.convertBTCAmountToCurrency(amount: self.btcTotalAmount.doubleValue)
        self.currentAmount.text = formattedTotal
    }

    func convertBTCAmountToCurrency(amount:Double) -> String
    {
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.numberStyle = .currency
        
        let total = self.btcValue.doubleValue * amount
        guard let formattedTotal = formatter.string(from: total as NSNumber) else { return "" }

        return formattedTotal
    }
}
