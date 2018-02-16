//
//  WalletCell.swift
//  Waller
//
//  Created by Vincenzo Aceto on 07/02/2018.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

protocol WalletCellDelegate
{
    func listTransactionsButtonPressed(walletCell:WalletCell)
    func makeAPaymentButtonPressed(walletCell:WalletCell)
    func showQRCodeButtonPressed(walletCell:WalletCell)
    func addButtonPressed()
}

class WalletCell: HFCardCollectionViewCell
{
    var magneticBand:UIImageView!
    var headerImage:UIImageView!
    var iconImage:UIImageView!
    var nameLabel:UILabel!
    var subtitleLabel:UILabel!
    var amountLabel:UILabel!
    var delegate:WalletCellDelegate!
    var cardCollectionViewLayout: HFCardCollectionViewLayout?

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        //self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:0)
        
        let leftMargin = (UIScreen.main.bounds.width - 310) / 2
        
        let bkgImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 310, height: 200))
        //bkgImage.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        bkgImage.image = UIImage.init(named: "glassCard")
        self.addSubview(bkgImage)

        headerImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 220, height: 11))
        headerImage.center.x = 155
        let image = UIImage.init(named: "WalletHeaderImage")
        headerImage.image = image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.addSubview(headerImage)
        
        magneticBand = UIImageView.init(frame: CGRect.init(x: 1, y: 20, width: 308, height: 75))
        magneticBand.backgroundColor = UIColor.gray
        self.addSubview(magneticBand)
        
        
        iconImage = UIImageView.init(frame: CGRect.init(x: 10, y: 20, width: 40, height: 40))
        self.addSubview(iconImage)
        
        nameLabel = UILabel.init(frame: CGRect.init(x: 60, y: 35, width: 310 - 170, height: 25))
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.font = UIFont.systemFont(ofSize: 24)
        self.addSubview(nameLabel)
        
        subtitleLabel = UILabel.init(frame: CGRect.init(x: 10, y: 70, width: 310 - 30, height: 20))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.textColor = UIColor.white
        self.addSubview(subtitleLabel)
        
        let x = nameLabel.frame.origin.x + nameLabel.frame.size.width + 5
        let w = 310 - nameLabel.frame.size.width - 85
        let btcLabel = UILabel.init(frame: CGRect.init(x: x, y: 30, width: w, height: 10))
        btcLabel.backgroundColor = UIColor.clear
        btcLabel.textAlignment = .right
        btcLabel.font = UIFont.boldSystemFont(ofSize: 12)
        btcLabel.text = "BTC"
        btcLabel.textColor = UIColor.white
        btcLabel.shadowColor = UIColor.gray
        btcLabel.shadowOffset = CGSize(width: 0.5, height: 0.3)
        self.addSubview(btcLabel)
        
        amountLabel = UILabel.init(frame: CGRect.init(x: btcLabel.frame.origin.x, y: 40, width: btcLabel.frame.size.width, height: 20))
        amountLabel.backgroundColor = UIColor.clear
        amountLabel.textAlignment = .right
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.textColor = UIColor.white
        amountLabel.shadowColor = UIColor.black
        amountLabel.shadowOffset = CGSize(width: 0.5, height: 0.3)
        self.addSubview(amountLabel)
        
        let y = 340 - 55
        
        let makeAPaymentButton = UIButton.init(type: .custom)
        makeAPaymentButton.frame = CGRect.init(x: 10, y: y, width: 45, height: 45)
        makeAPaymentButton.addTarget(self, action: #selector(makeAPaymentButtonPressed), for: .touchUpInside)
        makeAPaymentButton.backgroundColor = UIColor.clear
        makeAPaymentButton.setImage(UIImage.init(named: "MakeAPayment"), for: .normal)
        self.addSubview(makeAPaymentButton)
        
        let listTransactionButton = UIButton.init(type: .custom)
        listTransactionButton.frame = CGRect.init(x: 75, y: y + 5, width: 35, height: 36)
        listTransactionButton.addTarget(self, action: #selector(listTransactionsButtonPressed), for: .touchUpInside)
        listTransactionButton.backgroundColor = UIColor.clear
        listTransactionButton.setImage(UIImage.init(named: "allTransactionIcon"), for: .normal)
        self.addSubview(listTransactionButton)
        
        let showQRCodeButton = UIButton.init(type: .custom)
        showQRCodeButton.frame = CGRect.init(x: 310 - 10 - 40, y: y + 5, width: 36, height: 36)
        showQRCodeButton.addTarget(self, action: #selector(showQRCodeButtonPressed), for: .touchUpInside)
        showQRCodeButton.backgroundColor = UIColor.clear
        showQRCodeButton.setImage(UIImage.init(named: "ShowQRCode"), for: .normal)
        self.addSubview(showQRCodeButton)
    }
    
    @objc func listTransactionsButtonPressed()
    {
        print("listTransactionsButtonPressed")
        guard let _ = delegate?.listTransactionsButtonPressed(walletCell: self) else
        {return}
    }
    
    @objc func makeAPaymentButtonPressed()
    {
        print("makeAPaymentButtonPressed")
        guard let _ = delegate?.makeAPaymentButtonPressed(walletCell: self) else
        {return}
    }
    
    @objc func showQRCodeButtonPressed()
    {
        print("showQRCodeButtonPressed")
        guard let _ = delegate?.showQRCodeButtonPressed(walletCell: self) else
        {return}
    }
    
}
