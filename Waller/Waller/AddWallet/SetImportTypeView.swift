//
//  SetImportTypeView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 13/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class SetImportTypeView: UIView,MultiOptionViewDelegate {

    var multiView:MultiOptionView!
    var delegate:SetupPageViewDelegate!
    
    override init(frame: CGRect) {

        super.init(frame: frame)
    
        self.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        self.backgroundColor = Props().addViewsBackgroundColor

        var data:[Option] = []
        
        let option1 = Option.init(title: "Import from text", text: "Insert a text containing your private key or a previously generated mnemonic word to import a wallet.", buttonTitle: "Insert a text")
        let option2 = Option.init(title: "Import from QR Code", text: "Use the camera of your device to import a new wallet by scanning a QR Code.", buttonTitle: "Scan a QR Code")
        
        data.append(option1)
        data.append(option2)
        
        multiView = MultiOptionView.init(frame:CGRect.init(x: 0, y: 100, width: 300, height: 0),data:data)
        multiView.center.x = self.center.x
        multiView.delegate = self
        multiView.setDefaultIndex(index: 0)
        self.addSubview(multiView)
        
        multiView.center = self.center
    }
    
    func optionSelected(selectedIndex: Int)
    {
        
        var importType = ImportType.Text
        switch selectedIndex
        {
        case 0:
            importType = ImportType.Text
        case 1:
            importType = ImportType.QRCode
        default:
            importType = ImportType.Text
        }
        
        guard let _ = self.delegate?.importTypeSelected(selectedType: importType)
        else { return }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
