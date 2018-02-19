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
    func deleteButtonPressed(walletCell:WalletCell)
    func exportButtonPressed(walletCell:WalletCell)
    
    func addButtonPressed()
    func scanButtonPressed()
    
    func getOutputBalanceByAddress(address:String) -> [BTCTransactionOutput]?
    func getUSDVAlueFromAmount(amount:String) -> String?

    /*
    func getBTCBalanceByAddress(address:String) -> WalletBalance?
    func getUSDBalanceByAddress(address:String) -> String?
    func getUnspentOutputsAddress(address:String) -> [BTCTransactionOutput]?
    */
}

class WalletCell: HFCardCollectionViewCell, UITableViewDelegate, UITableViewDataSource
{
    var balance:WalletBalance!
    var magneticBand:UIImageView!
    var headerImage:UIImageView!
    var iconImage:UIImageView!
    var nameLabel:UILabel!
    var addressLabel:UILabel!
    var addressPrivateKey:String!
    var amountLabel:UILabel!
    var unconfirmedAmountLabel:UILabel!
    var currencyAmount:UILabel!
    var tableView:UITableView!
    var delegate:WalletCellDelegate!
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
 
      weak var timer: Timer?
      var txs:[Transaction] = []
//    var unspentTxs:[BTCTransactionOutput] = []

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        if Props.colorSchemaClear {
            self.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
        } else {
            self.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        }
        let viewWidth = (UIScreen.main.bounds.width - 30)

        headerImage = UIImageView.init(frame: CGRect.init(x: (viewWidth-220)/2, y: 0, width: 220, height: 11))
        let image = UIImage.init(named: "WalletHeaderImage")
        headerImage.image = image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.addSubview(headerImage)
        
        iconImage = UIImageView.init(frame: CGRect.init(x: 10, y: 30, width: 40, height: 40))
        self.addSubview(iconImage)
        
        let btcw:CGFloat = 100
        let btcx = viewWidth - btcw - 10
        
        let btcLabel = UILabel.init(frame: CGRect.init(x: btcx, y: 20, width: btcw, height: 10))
        btcLabel.backgroundColor = UIColor.clear
        btcLabel.textAlignment = .right
        btcLabel.font = UIFont.boldSystemFont(ofSize: 12)
        btcLabel.text = "BTC"
        btcLabel.textColor = UIColor.darkGray
        //btcLabel.shadowColor = UIColor.gray
        //btcLabel.shadowOffset = CGSize(width: 0.5, height: 0.3)
        self.addSubview(btcLabel)
        
        amountLabel = UILabel.init(frame: CGRect.init(x: btcx, y: 35, width: btcw, height: 20))
        amountLabel.backgroundColor = UIColor.clear
        amountLabel.textAlignment = .right
        amountLabel.adjustsFontSizeToFitWidth = true
        amountLabel.textColor = UIColor.black
        //amountLabel.shadowColor = UIColor.black
        //amountLabel.shadowOffset = CGSize(width: 0.5, height: 0.3)
        self.addSubview(amountLabel)
        
        let usdLabel = UILabel.init(frame: CGRect.init(x: btcx, y: 60, width: btcw, height: 10))
        usdLabel.backgroundColor = UIColor.clear
        usdLabel.textAlignment = .right
        usdLabel.font = UIFont.boldSystemFont(ofSize: 12)
        usdLabel.text = "USD"
        usdLabel.textColor = UIColor.darkGray
        //btcLabel.shadowColor = UIColor.gray
        //btcLabel.shadowOffset = CGSize(width: 0.5, height: 0.3)
        self.addSubview(usdLabel)
        
        currencyAmount = UILabel.init(frame: CGRect.init(x: btcx, y: 75, width: btcw, height: 20))
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
        
        
        addressLabel = UILabel.init(frame: CGRect.init(x: 10, y: 90, width: viewWidth-20, height: 20))
        addressLabel.backgroundColor = UIColor.clear
        addressLabel.adjustsFontSizeToFitWidth = true
        //self.addSubview(addressLabel)
        
        
        let tvh = addressLabel.frame.origin.y + 40
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: tvh, width: viewWidth, height: 150))
        tableView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.register(NoTransactionsCell.self, forCellReuseIdentifier: "NoTransactionsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        self.addSubview(tableView)
        
        let mod:CGFloat = 0.8
        let width:CGFloat = 38 * mod
        let height:CGFloat = 49 * mod
        let by:CGFloat = 340 - height - 15

        let margin:CGFloat = (viewWidth - (width * 5)) / 6
        
        let makeAPaymentButton = UIButton.init(type: .custom)
        makeAPaymentButton.frame = CGRect.init(x: margin, y: by, width: width, height:height)
        makeAPaymentButton.addTarget(self, action: #selector(makeAPaymentButtonPressed), for: .touchUpInside)
        makeAPaymentButton.backgroundColor = UIColor.clear
        makeAPaymentButton.setImage(UIImage.init(named: "out"), for: .normal)
        self.addSubview(makeAPaymentButton)
        
        var newMargin = (margin * 2) + (width * 1)
        
        let listTransactionButton = UIButton.init(type: .custom)
        listTransactionButton.frame = CGRect.init(x: newMargin, y: by+4, width: width, height: height)
        listTransactionButton.addTarget(self, action: #selector(listTransactionsButtonPressed), for: .touchUpInside)
        listTransactionButton.backgroundColor = UIColor.clear
        listTransactionButton.setImage(UIImage.init(named: "list"), for: .normal)
        self.addSubview(listTransactionButton)
        
        newMargin = (margin * 3) + (width * 2)
        
        let exportButton = UIButton.init(type: .custom)
        exportButton.frame = CGRect.init(x: newMargin, y: by+1, width: width, height: height)
        exportButton.addTarget(self, action: #selector(exportButtonPressed), for: .touchUpInside)
        exportButton.backgroundColor = UIColor.clear
        exportButton.setImage(UIImage.init(named: "export"), for: .normal)
        self.addSubview(exportButton)
        
        newMargin = (margin * 4) + (width * 3)
        
        let trashButton = UIButton.init(type: .custom)
        trashButton.frame = CGRect.init(x: newMargin, y: by+1, width: width, height: height)
        trashButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        trashButton.backgroundColor = UIColor.clear
        trashButton.setImage(UIImage.init(named: "trash"), for: .normal)
        self.addSubview(trashButton)
        
        newMargin = (margin * 5) + (width * 4)
        
        let showQRCodeButton = UIButton.init(type: .custom)
        showQRCodeButton.frame = CGRect.init(x: newMargin, y: by+2, width: width, height: height)
        showQRCodeButton.addTarget(self, action: #selector(showQRCodeButtonPressed), for: .touchUpInside)
        showQRCodeButton.backgroundColor = UIColor.clear
        showQRCodeButton.setImage(UIImage.init(named: "qrCode"), for: .normal)
        self.addSubview(showQRCodeButton)

    }
    
    func showUnconfirmedLabel()
    {
        unconfirmedAmountLabel = UILabel.init(frame: CGRect.init(x: amountLabel.frame.origin.x, y: amountLabel.frame.origin.y+25, width: amountLabel.frame.size.width, height: 15))
        unconfirmedAmountLabel.backgroundColor = UIColor.clear
        unconfirmedAmountLabel.textAlignment = .right
        unconfirmedAmountLabel.textColor = UIColor.orange
        unconfirmedAmountLabel.font = UIFont.systemFont(ofSize: 13)
        currencyAmount.frame.origin.y = 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if txs.count == 0
        {
            return tableView.frame.size.height
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if txs.count == 0
        {
            return 1
        }
        if txs.count > 3
        {
            return 3
        }
        return txs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if txs.count == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoTransactionsCell", for: indexPath) as! NoTransactionsCell
            cell.awakeFromNib()
            if Props.colorSchemaClear {
                cell.backgroundColor = UIColor(red:1, green:0.8, blue:0, alpha:1)
            } else {
                cell.backgroundColor = UIColor.clear
            }
            cell.infoLabel.frame.size.height = tableView.frame.size.height - 70
            cell.infoLabel.text = "No transactions found for this wallet, the latest 3 transactions for this wallet will be shown here"
            return cell
        }
        
        let formatter = BTCNumberFormatter.init(bitcoinUnit: BTCNumberFormatterUnit.BTC)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        
        let tx = txs[indexPath.row]
        var mod = ""
        var unconfirmed = ""
        
        cell.awakeFromNib()
        cell.backgroundColor = UIColor.clear
        
        if tx.confirmations < 3
        {
            unconfirmed = "unconfirmed "
            cell.amountLabel.textColor = UIColor.orange
        }
        if tx.confirmations == 3
        {
            cell.amountLabel.textColor = UIColor.green
        }
        
        if tx.input
        {
            mod = "\(unconfirmed)+"
            cell.icon.image = UIImage.init(named: "in")
        }
        else
        {
            mod = "\(unconfirmed)-"
            cell.icon.image = UIImage.init(named: "out")
        }
        
        if let amount = formatter?.string(fromAmount: tx.value)
        {
            cell.amountLabel.text = "\(mod) \(amount)"
        }
        else
        {
            cell.amountLabel.text = "- - -"
        }
        
        cell.confirmationsLabel.text = "\(tx.confirmations) confirmations"
        
        let date = Date.init(timeIntervalSince1970: TimeInterval(tx.time))
        let calendar = Calendar.current
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "LLL"
        let month = dateformatter.string(from: date)
        let year = calendar.component(.year, from: date)
        let day = calendar.component(.day, from: date)
        
        cell.dateLabel.text = "\(month) \(day) \(year)"
        print("drawcell")
        
        return cell
    }
 
    @objc func makeAPaymentButtonPressed()
    {
        print("makeAPaymentButtonPressed")
        guard let _ = delegate?.makeAPaymentButtonPressed(walletCell: self) else
        {return}
    }
    
    @objc func listTransactionsButtonPressed()
    {
        print("listTransactionsButtonPressed")
        guard let _ = delegate?.listTransactionsButtonPressed(walletCell: self) else
        {return}
    }
    
    @objc func exportButtonPressed()
    {
        print("exportButtonPressed")
        guard let _ = delegate?.exportButtonPressed(walletCell: self) else
        {return}
    }
    
    @objc func deleteButtonPressed()
    {
        print("deleteButtonPressed")
        guard let _ = delegate?.deleteButtonPressed(walletCell: self) else
        {return}
    }
    
    @objc func showQRCodeButtonPressed()
    {
        print("showQRCodeButtonPressed")
        guard let _ = delegate?.showQRCodeButtonPressed(walletCell: self) else
        {return}
    }
    
    func startTimer()
    {
        timer?.invalidate() // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true)
        {
            [weak self] _ in
            self?.updateBalance()
            self?.updateCurrencyPrice()
        }
    }
    
    func updateBalance()
    {
        print("updating balance for address : \(addressLabel.text!)")
        guard let outputs = delegate.getOutputBalanceByAddress(address: addressLabel.text!) else {return}
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
        self.amountLabel.text = amount
        
        if unconfirmedAmount > 0
        {
            if let formattedAmount = formatter?.string(fromAmount: unconfirmedAmount)
            {
                showUnconfirmedLabel()
                self.unconfirmedAmountLabel.text = "+ \(formattedAmount)"
            }
        }
    }
    
    func updateCurrencyPrice()
    {
        guard let btcPrice = delegate.getUSDVAlueFromAmount(amount: amountLabel.text!) else {return}
        self.currencyAmount.text = btcPrice
    }
    
    /*

    
    func updateBalance()
    {
        //print("Updating balance for address : \(String(describing: addressLabel.text))")
        guard let balance = delegate.getBTCBalanceByAddress(address: addressLabel.text!) else {return}
        //print(balance)
        if balance.final_balance == 0
        {
            self.amountLabel.text = "--"
            return
        }
        let formatter = BTCNumberFormatter.init(bitcoinUnit: BTCNumberFormatterUnit.BTC)
        let amount = formatter?.string(fromAmount: balance.final_balance)
        self.amountLabel.text = amount
        
        filterTransactions(transactions: balance.txs)
    }
    
    func updateCurrencyPrice()
    {
        print("updating address \(addressLabel.text)")
        guard let btcPrice = delegate.getUSDBalanceByAddress(address: addressLabel.text!) else {return}
        self.currencyAmount.text = btcPrice
    }
    
    func updateUnspent()
    {
        guard let unspentsTxs = delegate.getUnspentOutputsAddress(address: addressLabel.text!) else {return}
        self.unspentTxs = unspentsTxs
    }
    
    func filterTransactions(transactions:[TXs])
    {
        txs = []
        
        var txsInput:[TXin] = []
        for tx in transactions
        {
            for input in tx.inputs
            {
                if input.prev_out.addr == addressLabel.text
                {
                    txsInput.append(input)
                }
            }
            
            for outputs in tx.out
            {
                if outputs.addr == addressLabel.text
                {
                    let confirmations = getConfirmationsByScript(script:outputs.script)
                    let tx = Transaction.init(input: true, value: outputs.value, time: tx.time, confirmations: confirmations)
                    txs.append(tx)
                }
            }
        }
        print("txsInput \(txsInput)")
        tableView.reloadData()
    }
    
    func getConfirmationsByScript(script:String) -> UInt
    {
        for unspent in unspentTxs
        {
            if unspent.script.hex == script
            {
                return unspent.confirmations
            }
        }
        return 0
    }
 */
    
}
