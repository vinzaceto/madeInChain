//
//  XibView.swift
//  Waller
//
//  Created by Vincenzo Aceto on 14/02/2018.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

@IBDesignable
class InfoSectionXibController: UIView {

    var btcValue:Double = 0.0
    var btcTotalAmount:BTCAmount = 0
    
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
    
    let btcFormatter = BTCNumberFormatter.init(bitcoinUnit: BTCNumberFormatterUnit.BTC)
    let currencyFormatter = NumberFormatter()

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
        print("updating btc price")
        self.btcValue = btcPrice
        
        currencyFormatter.locale = Locale.init(identifier: "en_US")
        currencyFormatter.numberStyle = .currency
        
        let n = NSNumber.init(value: btcPrice)
        guard let formattedBTCValue = currencyFormatter.string(from: n) else {return}
        print("price \(formattedBTCValue)")
        self.currentBTCvalue.text = formattedBTCValue

        updateCurrencyTotal()
    }
    
    func updateBTCTotal(total:BTCAmount)
    {
        print("updating HEADER TOTAL: \(total)")
        self.btcTotalAmount = total

        let amount = btcFormatter?.string(fromAmount: total)
        self.currentBtcAmount.text = amount
        
        updateCurrencyTotal()
    }
    
    
    
    

    
    func updateCurrencyTotal()
    {
        print("converting currency total")
        
        guard let amount = btcFormatter?.string(fromAmount: btcTotalAmount).toDouble() else {return}
        print("btc total amount : \(amount)")
        
        let total = self.btcValue * amount

        currencyFormatter.locale = Locale.init(identifier: "en_US")
        currencyFormatter.numberStyle = .currency
        
        guard let formattedTotal = currencyFormatter.string(from: NSNumber(value:total)) else { return }
        print("formattedTotal: \(formattedTotal)")

        self.currentAmount.text = formattedTotal
    }

    func convertBTCAmountToCurrency(amount:Double) -> String
    {
        if self.btcValue == 0
        {
            return "--"
        }
        
        let value = self.btcValue * amount
        
        currencyFormatter.locale = Locale.init(identifier: "en_US")
        currencyFormatter.numberStyle = .currency
        
        guard let formattedTotal = currencyFormatter.string(from: NSNumber(value:value)) else { return "--" }
        print("formattedTotal: \(formattedTotal)")
        
        return formattedTotal
    }
}
