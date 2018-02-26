//
//  QRCodeWalletView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 14/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

protocol WalletFunctionDelegate
{
    func unflipCard()
    func unflipAndRemove(address:String)
    func exportWalletAsPDF(unencryptedWallet: Wallet)
    
    func keyboardDidOpen()
    func keyboardDidClose()
    
    func getOutputBalanceByAddress(address:String) -> [BTCTransactionOutput]?
    func getUSDVAlueFromAmount(amount:String) -> String?
    func getBTCValue() ->Double?
    
    func transactionSuccess(success:Bool)
}

class QRCodeWalletView: UIView {

    let viewWidth = UIScreen.main.bounds.width - 30

    var address:String!
    var addressLabel:UILabel!
    var qrCodeImage:UIImageView!
    var delegate:WalletFunctionDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        layer.cornerRadius = 6
        clipsToBounds = true
        
        let flipButton = UIButton.init(type: .custom)
        flipButton.frame = CGRect.init(x: viewWidth - 55, y: 10, width:45, height: 45)
        flipButton.addTarget(self, action: #selector(flipButtonPressed), for: .touchUpInside)
        flipButton.setImage(#imageLiteral(resourceName: "closeIcon"), for: .normal)
        addSubview(flipButton)
        
        qrCodeImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 240, height: 240))
        qrCodeImage.backgroundColor = UIColor.gray
        qrCodeImage.layer.cornerRadius = 6
        qrCodeImage.clipsToBounds = true
        qrCodeImage.center.x = self.center.x
        qrCodeImage.center.y = self.center.y - 10
        self.addSubview(qrCodeImage)
        
        addressLabel = UILabel.init(frame:CGRect.init(x: 0, y:0, width: 260, height: 25))
        addressLabel.textColor = UIColor.gray
        addressLabel.text = ""
        addressLabel.textAlignment = .center
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.backgroundColor = UIColor.clear
        addressLabel.center.x = self.center.x
        addressLabel.center.y = self.center.y + 125
        self.addSubview(addressLabel)
        
        let copyButton = UIButton.init(type: .roundedRect)
        copyButton.frame = CGRect.init(x: 10, y: 10, width: 120, height: 15)
        copyButton.addTarget(self, action: #selector(copyButtonPressed), for: .touchUpInside)
        copyButton.backgroundColor = UIColor.clear
        copyButton.setTitle("copy to clipboard", for: .normal)
        copyButton.center.x = self.center.x
        copyButton.center.y = self.center.y + 150
        addSubview(copyButton)
    }
    
    func setAddress(address:String)
    {
        self.address = address
        addressLabel.text = address
        let image = BTCQRCode.image(for: "bitcoin:\(address)", size: qrCodeImage.frame.size, scale: 10)
        qrCodeImage.image = image
    }
    
    @objc func flipButtonPressed()
    {
        print("flipButtonPressed")
        guard let _ = delegate?.unflipCard() else { return }
    }
    
    @objc func copyButtonPressed()
    {
        UIPasteboard.general.string = self.address
        addressLabel.text = "Address Copied!"
        perform(#selector(restoreLabel), with: nil, afterDelay: 2)
    }
    
    @objc func restoreLabel()
    {
        addressLabel.text = self.address
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
