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
        self.backgroundColor = Props.myGreyAlpha
        
        let viewWidth = (UIScreen.main.bounds.width - 30)
        
        let iconImage = UIImageView.init(frame: CGRect.init(x: 10, y: 5, width: 38, height: 49))
        iconImage.image = UIImage.init(named: "newWallet")
//        self.addSubview(iconImage)
        
        let newLabel = UILabel.init(frame: CGRect.init(x: 30, y: 20, width: viewWidth - 170, height: 40))
        newLabel.backgroundColor = UIColor.clear
        newLabel.font = UIFont.init(name: "Rubik-Medium", size: 40)
        newLabel.text = "New"
        newLabel.textColor = UIColor.darkGray
        self.addSubview(newLabel)
        
        let createButton = UIButton.init(type: UIButtonType.roundedRect)
        createButton.frame = CGRect.init(x: 0, y: 220, width: 213, height: 38)
        createButton.setImage(UIImage.init(named: "createNewWallet"), for: .normal)
        createButton.imageView?.contentMode = .scaleAspectFill
        createButton.center.x = self.center.x-20
        createButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        self.addSubview(createButton)
        
        let scanButton = UIButton.init(type: UIButtonType.roundedRect)
        scanButton.frame = CGRect.init(x: 0, y: 280, width: 213, height: 38)
        scanButton.setImage(UIImage.init(named: "quickImport"), for: .normal)
        scanButton.imageView?.contentMode = .scaleAspectFill
        scanButton.center.x = self.center.x-45
        scanButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        self.addSubview(scanButton)

        let subtitleLabel = UILabel.init(frame: CGRect.init(x: 30, y: 90, width: viewWidth - 60, height: 120))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.text = "This placeholder is for your new wallet. Click on the button + on the bottom right to create one or import an existing wallet using the QR code."
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.font = UIFont.init(name: "Rubik-Italic", size: 19)
        subtitleLabel.textColor = UIColor.darkGray
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
