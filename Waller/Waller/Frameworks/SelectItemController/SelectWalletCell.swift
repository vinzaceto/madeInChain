//
//  SelectWalletCell.swift
//  Waller
//
//  Created by Vincenzo Ajello on 11/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class SelectWalletCell: UITableViewCell {

    var nameLabel:UILabel!
    var addressLabel:UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel = UILabel.init(frame: CGRect.init(x: 10, y: 5, width: UIScreen.main.bounds.width-20, height: 20))
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.text = "NAME"
        self.addSubview(nameLabel)
        
        addressLabel = UILabel.init(frame: CGRect.init(x: 10, y: 30, width: UIScreen.main.bounds.width-20, height: 15))
        addressLabel.backgroundColor = UIColor.clear
        addressLabel.font = UIFont.systemFont(ofSize: 12)
        addressLabel.text = "ADDRESS"
        self.addSubview(addressLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
