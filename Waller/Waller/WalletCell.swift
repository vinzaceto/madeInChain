//
//  WalletCell.swift
//  Waller
//
//  Created by Vincenzo Aceto on 07/02/2018.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class WalletCell: HFCardCollectionViewCell
{
    var headerImage:UIImageView!
    var iconImage:UIImageView!
    var nameLabel:UILabel!
    var subtitleLabel:UILabel!
    var amountLabel:UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.red
        
        let leftMargin = (UIScreen.main.bounds.width - 310) / 2
        
        let bkgImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 310, height: 200))
        bkgImage.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        self.addSubview(bkgImage)

        headerImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 220, height: 11))
        headerImage.center.x = 155
        let image = UIImage.init(named: "WalletHeaderImage")
        headerImage.image = image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.addSubview(headerImage)
        
        iconImage = UIImageView.init(frame: CGRect.init(x: 10, y: 20, width: 40, height: 40))
        self.addSubview(iconImage)
        
        nameLabel = UILabel.init(frame: CGRect.init(x: 60, y: 35, width: 310 - 170, height: 25))
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.font = UIFont.systemFont(ofSize: 24)
        self.addSubview(nameLabel)
        
        subtitleLabel = UILabel.init(frame: CGRect.init(x: 10, y: 70, width: 310 - 30, height: 20))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(subtitleLabel)
        
        let x = nameLabel.frame.origin.x + nameLabel.frame.size.width + 5
        let w = 310 - nameLabel.frame.size.width - 85
        let btcLabel = UILabel.init(frame: CGRect.init(x: x, y: 30, width: w, height: 10))
        btcLabel.backgroundColor = UIColor.clear
        btcLabel.textAlignment = .right
        btcLabel.font = UIFont.boldSystemFont(ofSize: 12)
        btcLabel.text = "BTC"
        self.addSubview(btcLabel)
        
        amountLabel = UILabel.init(frame: CGRect.init(x: btcLabel.frame.origin.x, y: 40, width: btcLabel.frame.size.width, height: 20))
        amountLabel.backgroundColor = UIColor.clear
        amountLabel.textAlignment = .right
        amountLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(amountLabel)
        
        let makeAPaymentButton = UIButton.init(type: .roundedRect)
        makeAPaymentButton.frame = CGRect.init(x: 20, y: 250, width: 45, height: 45)
        makeAPaymentButton.addTarget(self, action: #selector(makeAPaymentButtonPressed), for: .touchUpInside)
        makeAPaymentButton.backgroundColor = UIColor.gray
        self.addSubview(makeAPaymentButton)
        
        let listTransactionButton = UIButton.init(type: .roundedRect)
        listTransactionButton.frame = CGRect.init(x: 85, y: 250, width: 45, height: 45)
        listTransactionButton.addTarget(self, action: #selector(listTransactionsButtonPressed), for: .touchUpInside)
        listTransactionButton.backgroundColor = UIColor.gray
        self.addSubview(listTransactionButton)
        
        let showQRCodeButton = UIButton.init(type: .roundedRect)
        showQRCodeButton.frame = CGRect.init(x: UIScreen.main.bounds.width - 10 - 45 - 20, y: 250, width: 45, height: 45)
        showQRCodeButton.addTarget(self, action: #selector(showQRCodeButtonPressed), for: .touchUpInside)
        showQRCodeButton.backgroundColor = UIColor.gray
        self.addSubview(showQRCodeButton)
    }
    
    @objc func listTransactionsButtonPressed()
    {
        print("listTransactionsButtonPressed")
    }
    
    @objc func makeAPaymentButtonPressed()
    {
        print("makeAPaymentButtonPressed")
    }
    
    @objc func showQRCodeButtonPressed()
    {
        print("showQRCodeButtonPressed")
    }
    
}
