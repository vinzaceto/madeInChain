//
//  OnViewController.swift
//  Waller
//
//  Created by Pasquale Mauriello on 02/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class OnViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    let transition = CircleTransition()
    
    @IBOutlet weak var checkBoxButton: CheckBox!
    @IBOutlet weak var checkBoxButton2: CheckBox!
    @IBOutlet weak var startButton: UIButton!
    
    let gradientView:GradientView = GradientView()
    
    @IBAction func checkBoxButton(_ sender: Any){
        self.view.addSubview(checkBoxButton2)
        self.view.addSubview(textView2)
    }
    
    @IBAction func checkBoxButton2(_ sender: Any){
        startButton.isHidden = false
    }
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textView2: UITextView!
    

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

    

    override func viewDidLoad() {
        super.viewDidLoad()

        let onBoardingBackgroundColor1 = UIColor(red: 26/255, green: 44/255, blue: 59/255, alpha: 1)
        let onBoardingBackgroundColor2 = UIColor(red: 53/255, green: 74/255, blue: 94/255, alpha: 1)
        
        gradientView.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradientView.FirstColor = onBoardingBackgroundColor1
        gradientView.SecondColor = onBoardingBackgroundColor2
        self.view.addSubview(gradientView)
        startButton.layer.cornerRadius = 10;
        
        startButton.isHidden = true
        self.view.addSubview(startButton)
        self.view.addSubview(checkBoxButton)
        self.view.addSubview(textView)

   }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

