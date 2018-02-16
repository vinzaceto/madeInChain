//
//  NoTransactionsCell.swift
//  Waller
//
//  Created by Vincenzo Ajello on 16/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class NoTransactionsCell: UITableViewCell
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let viewWidth = UIScreen.main.bounds.width - 30
        self.selectionStyle = UITableViewCellSelectionStyle.none

        let infoLabel = UILabel.init(frame: CGRect.init(x: 40, y: 80, width: viewWidth - 80, height: 120))
        infoLabel.backgroundColor = UIColor.clear
        infoLabel.text = "No transactions found for this wallet, all the transactions for this wallet will be shown here"
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.textColor = UIColor.lightGray
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        self.addSubview(infoLabel)
    }
}
