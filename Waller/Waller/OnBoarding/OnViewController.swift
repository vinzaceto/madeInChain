//
//  OnViewController.swift
//  Waller
//
//  Created by Pasquale Mauriello on 02/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class OnViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var checkBoxButton: CheckBox!
    
    @IBOutlet weak var textView: UITextView!
    
    let transition = CircleTransition()
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var ButtonSkip: UIButton!
    
    @IBAction func skipButt(_ sender: Any) {
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
        transition.startingPoint = ButtonSkip.center
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
        self.view.addSubview(gradientView)
        self.view.addSubview(ButtonSkip)
        startButton.layer.cornerRadius = 10;
        
        
        self.view.addSubview(checkBoxButton)
        self.view.addSubview(textView)
        
     
   }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

