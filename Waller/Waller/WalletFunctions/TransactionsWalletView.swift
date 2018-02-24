//
//  TransactionsWalletView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 15/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class TransactionsWalletView: UIView, UITableViewDelegate, UITableViewDataSource
{
    var tableView:UITableView!
    var delegate:WalletFunctionDelegate!
    var transactions:[Transaction] = []
    let viewWidth = UIScreen.main.bounds.width - 30

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        layer.cornerRadius = 6
        clipsToBounds = true
        
        let flipButton = UIButton.init(type: .custom)
        flipButton.frame = CGRect.init(x: viewWidth - 55, y: 10, width:45, height: 45)
        flipButton.addTarget(self, action: #selector(flipButtonPressed), for: .touchUpInside)
        flipButton.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        addSubview(flipButton)
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 60, width: frame.size.width, height: frame.size.height-60))
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.register(NoTransactionsCell.self, forCellReuseIdentifier: "NoTransactionCell")
        tableView.allowsSelection = false
        //tableView.separatorStyle = .none
        self.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if transactions.count == 0
        {
            return self.frame.size.height - 50
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if transactions.count == 0
        {
            self.tableView.isScrollEnabled = false
            return 1
        }
        self.tableView.isScrollEnabled = true
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if transactions.count == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoTransactionCell", for: indexPath) as! NoTransactionsCell
            cell.awakeFromNib()
            cell.backgroundColor = UIColor.clear
            cell.infoLabel.frame.size.height = self.frame.size.height - 50
            cell.infoLabel.text = "No transactions found for this wallet, all the transactions for this wallet will be shown here"
            return cell
        }
        
        let formatter = BTCNumberFormatter.init(bitcoinUnit: BTCNumberFormatterUnit.BTC)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        cell.awakeFromNib()
        
        if transactions[indexPath.row].input == true
        {
            cell.icon.image = UIImage.init(named: "in")
        }
        else
        {
            cell.icon.image = UIImage.init(named: "out")
        }
        
        if let amount = formatter?.string(fromAmount: transactions[indexPath.row].value)
        {
            cell.amountLabel.text = "\(amount)"
        }
        else
        {
            cell.amountLabel.text = "- - -"
        }
        
        cell.confirmationsLabel.text = "-- confirmation/s"
        
        let date = Date.init(timeIntervalSince1970: TimeInterval(transactions[indexPath.row].time))
        let calendar = Calendar.current
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "LLL"
        let month = dateformatter.string(from: date)
        let year = calendar.component(.year, from: date)
        let day = calendar.component(.day, from: date)
        
        cell.dateLabel.text = "\(month) \(day) \(year)"
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    
    
    @objc func flipButtonPressed()
    {
        print("flipButtonPressed")
        guard let _ = delegate?.unflipCard() else { return }
    }
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}

    
}
