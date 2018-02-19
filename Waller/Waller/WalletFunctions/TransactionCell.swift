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
    var confirmationsLabel:UILabel!
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
        amountLabel = UILabel.init(frame: CGRect.init(x: 40, y: 5, width: aw, height: 20))
        amountLabel.backgroundColor = UIColor.clear
        amountLabel.text = "+ 0.00000001"
        amountLabel.textAlignment = .center
        amountLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(amountLabel)
        
        confirmationsLabel = UILabel.init(frame: CGRect.init(x: 45, y: 28, width: aw, height: 15))
        confirmationsLabel.backgroundColor = UIColor.clear
        confirmationsLabel.text = "0 confirms"
        confirmationsLabel.textAlignment = .center
        confirmationsLabel.textColor = UIColor.gray
        //confirmationsLabel.adjustsFontSizeToFitWidth = true
        confirmationsLabel.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(confirmationsLabel)
        
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
