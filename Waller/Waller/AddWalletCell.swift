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
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:0.7)
        
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
        
        let addButton = UIButton.init(type: .custom)
        addButton.frame = CGRect.init(x: viewWidth-35-30, y: 290, width: 35, height: 35)
        addButton.setImage(UIImage.init(named: "AddButton"), for: .normal)
        addButton.imageView?.contentMode = .scaleAspectFill
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        self.addSubview(addButton)
        
        let scanButton = UIButton.init(type: .custom)
        scanButton.frame = CGRect.init(x: 30, y: 290, width: 38*0.8, height: 49*0.7)
        scanButton.setImage(UIImage.init(named: "scan"), for: .normal)
        scanButton.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
        self.addSubview(scanButton)
        
        let subtitleLabel = UILabel.init(frame: CGRect.init(x: 30, y: 100, width: viewWidth - 60, height: 120))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.text = "To add a new wallet tap on the + button in the bottom right corner or quick import a QR code with your camera."
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.font = UIFont.init(name: "Rubik-Italic", size: 19)
        subtitleLabel.textColor = UIColor.darkGray
        subtitleLabel.textAlignment = .left
        subtitleLabel.numberOfLines = 0
        self.addSubview(subtitleLabel)
        
        let rect = CGRect.init(x: 0, y: 0, width: viewWidth, height: 340)
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = UIColor.darkGray.cgColor
        dashedBorder.lineDashPattern = [8, 6]
        dashedBorder.frame = rect
        dashedBorder.cornerRadius = 6
        dashedBorder.masksToBounds = true
        dashedBorder.fillColor = nil
        dashedBorder.lineWidth = 6
        dashedBorder.path = UIBezierPath(rect: rect).cgPath
        self.layer.addSublayer(dashedBorder)
        self.clipsToBounds = true

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
