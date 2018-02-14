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
    
    
    @IBOutlet weak var imagePage1: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startButton(_ sender: Any) {
        performSegue(withIdentifier: "MainSB", sender: self)
        UserDefaults.standard.set(false, forKey: Props.hasBeenSeen)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! HomeViewController
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = startButton.center
        transition.circleColor = UIColor(red: 53/255, green: 74/255, blue: 94/255, alpha: 1)
        
        return transition
    }
    
    
    let gradientView:GradientView = GradientView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onBoardingBackgroundColor1 = UIColor(red: 26/255, green: 44/255, blue: 59/255, alpha: 1)
        let onBoardingBackgroundColor2 = UIColor(red: 53/255, green: 74/255, blue: 94/255, alpha: 1)
        
        gradientView.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradientView.FirstColor = onBoardingBackgroundColor1
        gradientView.SecondColor = onBoardingBackgroundColor2
        
        startButton.layer.cornerRadius = 10;
 

        self.view.addSubview(gradientView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitle)
        self.view.addSubview(imagePage1)
        self.view.addSubview(startButton)

        
    }
}

