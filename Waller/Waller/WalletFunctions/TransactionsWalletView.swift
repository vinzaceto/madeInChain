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
    var transactions:[String] = []
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        layer.cornerRadius = 6
        clipsToBounds = true
        
        let flipButton = UIButton.init(type: .roundedRect)
        flipButton.frame = CGRect.init(x: 0, y: 10, width:60, height: 25)
        flipButton.addTarget(self, action: #selector(flipButtonPressed), for: .touchUpInside)
        flipButton.backgroundColor = UIColor.clear
        flipButton.setTitle("close", for: .normal)
        flipButton.center.x = self.center.x
        addSubview(flipButton)
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 50, width: frame.size.width, height: frame.size.height-50))
        tableView.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        cell.awakeFromNib()
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
