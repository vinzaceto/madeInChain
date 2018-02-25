//
//  OnViewController3.swift
//  Waller
//
//  Created by Pasquale Mauriello on 14/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class OnViewController3: UIViewController, UIViewControllerTransitioningDelegate {
    
    let transition = CircleTransition()

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var imagePage1: UIImageView!
    
    
    
    @IBAction func startButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToMain", sender: self)
    }

    
    let gradientView:GradientView = GradientView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePage1.alpha = 0
        self.imagePage1.frame.origin.y = imagePage1.frame.size.height+80
        
        //let onBoardingBackgroundColor1 = UIColor(red: 26/255, green: 44/255, blue: 59/255, alpha: 1)
        //let onBoardingBackgroundColor2 = UIColor(red: 53/255, green: 74/255, blue: 94/255, alpha: 1)
        
        gradientView.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradientView.FirstColor = Props.myBlack
        gradientView.SecondColor = Props.myBlack


        self.view.addSubview(gradientView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitle)
        self.view.addSubview(imagePage1)
        self.view.addSubview(bottomLabel)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
            UIView.animate(withDuration: 2, animations: {
                self.imagePage1.alpha = 1
                self.imagePage1.frame.origin.y = self.imagePage1.frame.size.height-30
            }) { (true) in
                UIView.animate(withDuration: 1, animations: {
                    //self.imagePage1.frame.origin.y -= 150
                }, completion: nil)
            }

    }
}


