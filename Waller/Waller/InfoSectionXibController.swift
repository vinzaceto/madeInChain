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

    weak var timer: Timer?

    var contentView: UIView?
    @IBInspectable var nibName: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        xibSetup()

        if let lastBtcValueTemp = UserDefaults.standard.string(forKey: Props.lastBtcValue) {
            self.currentBTCvalue.text = lastBtcValueTemp
        } else {
            self.currentBTCvalue.text = "--"
        }
        startTimer()
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
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            let dataConnection = DataConnections()
            dataConnection.getBitcoinValue(currency: Props.btcUsd) { (result) in
                switch result {
                case .success(let posts):
                    print(posts.last + "$")
                    UserDefaults.standard.set(posts.last + "$", forKey: Props.lastBtcValue)
                    self?.currentBTCvalue.text = posts.last + "$"
                case .failure(let error):
                    fatalError("error: \(error)")
                }
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
}
