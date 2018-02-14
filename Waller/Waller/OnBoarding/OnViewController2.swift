//
//  OnViewController2.swift
//  Waller
//
//  Created by Pasquale Mauriello on 14/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class OnViewController2: UIViewController {


        let gradientView:GradientView = GradientView()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            var onBoardingBackgroundColor1 = UIColor(red: 26/255, green: 44/255, blue: 59/255, alpha: 1)
            var onBoardingBackgroundColor2 = UIColor(red: 53/255, green: 74/255, blue: 94/255, alpha: 1)
            
            gradientView.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            gradientView.FirstColor = onBoardingBackgroundColor1
            gradientView.SecondColor = onBoardingBackgroundColor2
            self.view.addSubview(gradientView)
            
            
        }
}

