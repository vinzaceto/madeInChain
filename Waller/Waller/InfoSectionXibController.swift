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

    @IBOutlet weak var currentCurrancy: UILabel!
    @IBOutlet weak var currentBTCvalue: UILabel!
    @IBOutlet weak var currentAmount: UILabel!
    @IBOutlet weak var currentBtcAmount: UILabel!

    var contentView: UIView?
    @IBInspectable var nibName: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()
        
        if let lastBtcValueTemp = UserDefaults.standard.string(forKey: Props.lastBtcValue) {
            self.currentBTCvalue.text = lastBtcValueTemp
        } else {
            self.currentBTCvalue.text = "0$"
        }
        
        let dataConnection = DataConnections()
        dataConnection.getBitcoinValue(currency: Props.btcUsd) { (result) in
            switch result {
            case .success(let posts):
                print(posts.last + "$")
                UserDefaults.standard.set(posts.last + "$", forKey: Props.lastBtcValue)
                self.currentBTCvalue.text = posts.last+"$"
            case .failure(let error):
                fatalError("error: \(error)")
            }
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
}
