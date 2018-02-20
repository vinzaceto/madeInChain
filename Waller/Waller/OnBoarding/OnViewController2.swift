//
//  OnViewController2.swift
//  Waller
//
//  Created by Pasquale Mauriello on 14/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class OnViewController2: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var multisignLabel: UILabel!
    @IBOutlet weak var importingLabel: UILabel!
    @IBOutlet weak var subStandardCrypto: UITextView!
    
    @IBOutlet weak var iconLogo: UIImageView!
    @IBOutlet weak var incoming: UIImageView!
    @IBOutlet weak var outComing: UIImageView!
    @IBOutlet weak var multisignDescription: UITextView!
    
    @IBOutlet weak var exportImage: UIImageView!
    
    @IBOutlet weak var qrCode2: UIImageView!
    @IBOutlet weak var qrCode1: UIImageView!
    
    @IBOutlet weak var multiSign: UIImageView!
    
    
    let gradientView:GradientView = GradientView()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.iconLogo.alpha = 0
            self.outComing.alpha = 0
            self.incoming.alpha = 0
            self.exportImage.alpha = 0
            self.qrCode1.alpha = 0
            self.qrCode2.alpha = 0

            let onBoardingBackgroundColor1 = UIColor(red: 26/255, green: 44/255, blue: 59/255, alpha: 1)
            let onBoardingBackgroundColor2 = UIColor(red: 53/255, green: 74/255, blue: 94/255, alpha: 1)
            
            gradientView.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            gradientView.FirstColor = onBoardingBackgroundColor1
            gradientView.SecondColor = onBoardingBackgroundColor2
            self.view.addSubview(gradientView)
            self.view.addSubview(titleLabel)
            self.view.addSubview(subTitle)
            self.view.addSubview(multisignLabel)
            self.view.addSubview(importingLabel)
            self.view.addSubview(subStandardCrypto)
            self.view.addSubview(multisignDescription)
            self.view.addSubview(iconLogo)
            self.view.addSubview(outComing)
            self.view.addSubview(incoming)
            self.view.addSubview(exportImage)
            self.view.addSubview(qrCode1)
            self.view.addSubview(qrCode2)
            self.view.addSubview(multiSign)
  
        }
    
    override func viewDidAppear(_ animated: Bool) {
         
        UIView.animate(withDuration: 1, animations: {
            self.outComing.frame.origin.x = self.outComing.frame.size.height
            self.incoming.frame.origin.x = 265
            self.exportImage.transform = CGAffineTransform(rotationAngle: 3.14)
            
            self.outComing.alpha = 1
            self.iconLogo.alpha = 1
            self.incoming.alpha = 1
            self.exportImage.alpha = 1
            self.qrCode1.alpha = 1
            self.qrCode2.alpha = 1
  
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {

            }, completion: nil)
        }
    }
    
    
}

