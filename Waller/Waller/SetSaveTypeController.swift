//
//  SetSaveTypeController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 07/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class SetSaveTypeController: UIViewController, MultiOptionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        let labelframe = CGRect.init(x: 40, y:120, width: self.view.frame.size.width - 80, height: 50)
        let optionText = UILabel.init(frame:labelframe)
        optionText.textColor = UIColor.gray
        optionText.textAlignment = .center
        optionText.text = "Before to generate your new address, please select how to save it."
        optionText.font = UIFont.systemFont(ofSize: 20)
        optionText.numberOfLines = 0
        self.view.addSubview(optionText)
        
        var data:[Option] = []
        
        let option1 = Option.init(title: "Store", text: "Create a simple wallet to send and receive funds, it will be protected with a password and stored directly on your device.", buttonTitle: "Setup password for the wallet")
        let option2 = Option.init(title: "Cold wallet", text: "Store the keys of your wallet manually, without saving it into your device.", buttonTitle: "Store the wallet manually")
        
        data.append(option1)
        data.append(option2)
        
        let frame = CGRect.init(x: 10, y: 100, width: self.view.frame.size.width-20, height: 0)
        let multiView = MultiOptionView.init(frame:frame,data:data)
        multiView.delegate = self
        multiView.setDefaultIndex(index: 0)
        self.view.addSubview(multiView)
        
        multiView.center = self.view.center

    }
    
    func optionSelected(selectedIndex: Int)
    {
        switch selectedIndex
        {
            case 0:
                goToSetPassword()
            case 1:
                goToGenerateMnemonic()
            default:
                return
        }
        
    }
    
    func goToSetPassword()
    {
        print("Go to Set Password")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let setPasswordController = storyboard.instantiateViewController(withIdentifier: "SPController") as! SetPasswordViewController
        navigationController?.pushViewController(setPasswordController, animated: true)
    }
    
    func goToGenerateMnemonic()
    {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
