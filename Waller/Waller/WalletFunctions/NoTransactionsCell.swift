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
    var infoLabel:UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let viewWidth = UIScreen.main.bounds.width - 30
        self.selectionStyle = UITableViewCellSelectionStyle.none

        infoLabel = UILabel.init(frame: CGRect.init(x: 40, y: 0, width: viewWidth - 80, height: 0))
        infoLabel.backgroundColor = UIColor.clear
        infoLabel.text = ""
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.textColor = UIColor.lightGray
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        self.addSubview(infoLabel)
    }
}
