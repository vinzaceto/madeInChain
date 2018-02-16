//
//  TransactionCell.swift
//  Waller
//
//  Created by Vincenzo Ajello on 15/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    var icon:UIImageView!
    var amountLabel:UILabel!
    var dateLabel:UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        let viewWidth = UIScreen.main.bounds.width - 30
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        icon = UIImageView.init(frame: CGRect.init(x: 10, y: 8, width: 38*0.6, height: 49*0.6))
        icon.image = UIImage.init(named: "out")
        self.addSubview(icon)
        
        let aw = viewWidth - 25 - 10 - 5 - 55
        amountLabel = UILabel.init(frame: CGRect.init(x: 40, y: 5, width: aw, height: 35))
        amountLabel.backgroundColor = UIColor.clear
        amountLabel.text = "+ 0.00000001"
        amountLabel.textAlignment = .center
        amountLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(amountLabel)
        
        dateLabel = UILabel.init(frame: CGRect.init(x: viewWidth - 40 - 5, y: 5, width: 40, height: 35))
        dateLabel.backgroundColor = UIColor.clear
        dateLabel.text = "Feb 5\n2018"
        dateLabel.textAlignment = .right
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.numberOfLines = 0
        self.addSubview(dateLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
