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
    func scanButtonPressed()
}

class WalletCell: HFCardCollectionViewCell, UITableViewDelegate, UITableViewDataSource
{
    var magneticBand:UIImageView!
    var headerImage:UIImageView!
    var iconImage:UIImageView!
    var nameLabel:UILabel!
    var addressLabel:UILabel!
    var amountLabel:UILabel!
    var currencyAmount:UILabel!
    var delegate:WalletCellDelegate!
    var cardCollectionViewLayout: HFCardCollectionViewLayout?

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1)
        
        let viewWidth = (UIScreen.main.bounds.width - 30)

        headerImage = UIImageView.init(frame: CGRect.init(x: (viewWidth-220)/2, y: 0, width: 220, height: 11))
        let image = UIImage.init(named: "WalletHeaderImage")
        headerImage.image = image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.addSubview(headerImage)
        
        iconImage = UIImageView.init(frame: CGRect.init(x: 10, y: 30, width: 40, height: 40))
        self.addSubview(iconImage)
        
        let btcw:CGFloat = 80
        let btcx = viewWidth - btcw - 10
        
        let btcLabel = UILabel.init(frame: CGRect.init(x: btcx, y: 20, width: btcw, height: 10))
        btcLabel.backgroundColor = UIColor.clear
        btcLabel.textAlignment = .right
        btcLabel.font = UIFont.boldSystemFont(ofSize: 12)
        btcLabel.text = "BTC"
        btcLabel.textColor = UIColor.white
        btcLabel.shadowColor = UIColor.gray
        btcLabel.shadowOffset = CGSize(width: 0.5, height: 0.3)
        self.addSubview(btcLabel)
        
        amountLabel = UILabel.init(frame: CGRect.init(x: btcx, y: 30, width: btcw, height: 20))
        amountLabel.backgroundColor = UIColor.clear
        amountLabel.textAlignment = .right
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.textColor = UIColor.white
        amountLabel.shadowColor = UIColor.black
        amountLabel.shadowOffset = CGSize(width: 0.5, height: 0.3)
        self.addSubview(amountLabel)
        
        currencyAmount = UILabel.init(frame: CGRect.init(x: btcx, y: 50, width: btcw, height: 20))
        currencyAmount.backgroundColor = UIColor.clear
        currencyAmount.textAlignment = .right
        currencyAmount.adjustsFontSizeToFitWidth = true
        self.addSubview(currencyAmount)
        
        let nw = viewWidth - iconImage.frame.size.width - amountLabel.frame.size.width - 35
        let nx = iconImage.frame.origin.x + iconImage.frame.size.width + 10
        nameLabel = UILabel.init(frame: CGRect.init(x: nx, y: 45, width: nw, height: 25))
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.font = UIFont.systemFont(ofSize: 24)
        self.addSubview(nameLabel)
        
        addressLabel = UILabel.init(frame: CGRect.init(x: 10, y: 80, width: viewWidth-20, height: 20))
        addressLabel.backgroundColor = UIColor.clear
        addressLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(addressLabel)
        
        
        let tvh = addressLabel.frame.origin.y + 40
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: tvh, width: viewWidth, height: 150))
        tableView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        self.addSubview(tableView)
        
        
        
        
        
        
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
        showQRCodeButton.frame = CGRect.init(x: Int(viewWidth - 46), y: y + 5, width: 36, height: 36)
        showQRCodeButton.addTarget(self, action: #selector(showQRCodeButtonPressed), for: .touchUpInside)
        showQRCodeButton.backgroundColor = UIColor.clear
        showQRCodeButton.setImage(UIImage.init(named: "ShowQRCode"), for: .normal)
        self.addSubview(showQRCodeButton)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        cell.awakeFromNib()
        cell.backgroundColor = UIColor.clear
        return cell
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
