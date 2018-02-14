//
//  OnViewController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 02/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class OnViewController: UIViewController {
    
    @IBOutlet weak var ButtonSkip: UIButton!
    
    @IBAction func skipButt(_ sender: Any) {
        performSegue(withIdentifier: "MainSB", sender: self)
        UserDefaults.standard.set(false, forKey: Props.hasBeenSeen)
    }
    

    let gradientView:GradientView = GradientView()

    override func viewDidLoad() {
        super.viewDidLoad()

        var onBoardingBackgroundColor1 = UIColor(red: 26/255, green: 44/255, blue: 59/255, alpha: 1)
        var onBoardingBackgroundColor2 = UIColor(red: 53/255, green: 74/255, blue: 94/255, alpha: 1)
        
        gradientView.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradientView.FirstColor = onBoardingBackgroundColor1
        gradientView.SecondColor = onBoardingBackgroundColor2
        self.view.addSubview(gradientView)
        self.view.addSubview(ButtonSkip)
        
     
   }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

