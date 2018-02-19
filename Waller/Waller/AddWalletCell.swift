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
        
        let viewWidth = (UIScreen.main.bounds.width - 30)
        
        let iconImage = UIImageView.init(frame: CGRect.init(x: 10, y: 5, width: 38, height: 49))
        iconImage.image = UIImage.init(named: "newWallet")
//        self.addSubview(iconImage)
        
        let newLabel = UILabel.init(frame: CGRect.init(x: 30, y: 15, width: viewWidth - 170, height: 40))
        newLabel.backgroundColor = UIColor.clear
        newLabel.font = UIFont.init(name: "Rubik-Medium", size: 40)
        newLabel.text = "New"
        newLabel.textColor = UIColor.iosBlueColor
        self.addSubview(newLabel)
        
        let addButton = UIButton.init(type: .custom)
        addButton.frame = CGRect.init(x: viewWidth-35-10, y: 210, width: 35, height: 35)
        addButton.setImage(UIImage.init(named: "AddButton"), for: .normal)
        addButton.imageView?.contentMode = .scaleAspectFill
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        self.addSubview(addButton)
        
        let scanButton = UIButton.init(type: .custom)
        scanButton.frame = CGRect.init(x: 30, y: 210, width: 38*0.8, height: 49*0.8)
        scanButton.setImage(UIImage.init(named: "scan"), for: .normal)
        scanButton.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
        self.addSubview(scanButton)
        
        let subtitleLabel = UILabel.init(frame: CGRect.init(x: 30, y: 80, width: viewWidth - 80, height: 120))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.text = "Ta add a new wallet tap to the + button in the bottom right corner or quick import a QR code with your camera."
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.font = UIFont.init(name: "Rubik-Italic", size: 19)
        subtitleLabel.textColor = UIColor.lightGray
        subtitleLabel.textAlignment = .left
        subtitleLabel.numberOfLines = 0
        self.addSubview(subtitleLabel)

    }
    
    @objc func scanButtonPressed()
    {
        print("scanButtonPressed")
        guard let _ = delegate?.scanButtonPressed() else { return }
    }
    
    @objc func addButtonPressed()
    {
        print("addButtonPressed")
        guard let _ = delegate?.addButtonPressed() else { return }
    }
}
