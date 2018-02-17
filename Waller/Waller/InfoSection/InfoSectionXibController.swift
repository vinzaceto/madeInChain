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

    weak var timer: Timer?

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
        startTimer()
        requestPrice()
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

    func startTimer() {
        timer?.invalidate() // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true)
        {
            [weak self] _ in
            self?.requestPrice()
        }
    }
    
    func requestPrice()
    {
        let dataConnection = DataConnections()
            dataConnection.getBitcoinValue(currency: Props.btcUsd) { (result) in
                switch result {
                case .success(let posts):

                    let formatter = NumberFormatter()
                    formatter.locale = Locale.current
                    formatter.numberStyle = .currency
                    
                    guard let value = Double(posts.last) else { return }
                    self.btcValue = NSNumber.init(value: value)

                    guard let formattedBTCValue = formatter.string(from: self.btcValue as! NSNumber) else { return }
                    self.currentBTCvalue.text = formattedBTCValue


                    //UserDefaults.standard.set(posts.last + "$", forKey: Props.lastBtcValue)
                    
                    let currencyTotal = self.btcValue.doubleValue * self.btcTotalAmount.doubleValue
                    guard let formattedTotal = formatter.string(from: currencyTotal as! NSNumber) else { return }
                    self.currentAmount.text = formattedTotal


                case .failure(let error):
                    print("No connection \(error.localizedDescription)")
                }
            }
    }

    func stopTimer() {
        timer?.invalidate()
    }

    // if appropriate, make sure to stop your timer in `deinit`

    deinit {
        stopTimer()
    }
    
    func updateWith(total:BTCAmount)
    {
        let formatter = BTCNumberFormatter.init(bitcoinUnit: BTCNumberFormatterUnit.BTC)
        let amount = formatter?.string(fromAmount: total)

        guard let totalBTCAmount = Double(amount!) else { return }
        self.btcTotalAmount = NSNumber.init(value: totalBTCAmount)
        
        self.currentBtcAmount.text = "\(self.btcTotalAmount)"
    }
}
