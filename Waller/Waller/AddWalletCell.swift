//
//  AddWalletCell.swift
//  Waller
//
//  Created by Vincenzo Ajello on 15/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class AddWalletCell: HFCardCollectionViewCell
{
    var delegate:WalletCellDelegate!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        let iconImage = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 40, height: 40))
        iconImage.image = UIImage.init(named: "newWalletIcon")
        self.addSubview(iconImage)
        
        let newLabel = UILabel.init(frame: CGRect.init(x: 60, y: 15, width: 310 - 170, height: 40))
        newLabel.backgroundColor = UIColor.clear
        newLabel.font = UIFont.systemFont(ofSize: 34)
        newLabel.text = "New"
        self.addSubview(newLabel)
        
        let addButton = UIButton.init(type: .custom)
        addButton.frame = CGRect.init(x: 310-35-10, y: 15, width: 35, height: 35)
        addButton.setImage(UIImage.init(named: "AddButton"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        self.addSubview(addButton)
        
        let subtitleLabel = UILabel.init(frame: CGRect.init(x: 40, y: 70, width: 310 - 80, height: 120))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.text = "To add a new wallet tap to the + button in the top right corner."
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.textColor = UIColor.lightGray
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        self.addSubview(subtitleLabel)
    }
    
    @objc func addButtonPressed()
    {
        print("addButtonPressed")
        guard let _ = delegate?.addButtonPressed() else { return }
    }
}
