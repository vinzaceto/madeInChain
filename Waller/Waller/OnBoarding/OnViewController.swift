//
//  OnViewController.swift
//  Waller
//
//  Created by Pasquale Mauriello on 02/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class OnViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    let transition = CircleTransition()
    
    
    @IBOutlet weak var checkBoxButton: CheckBox!
    @IBOutlet weak var checkBoxButton2: CheckBox!
    @IBOutlet weak var startButton: UIButton!
    
    let gradientView:GradientView = GradientView()
    
    @IBAction func checkBoxButton(_ sender: Any){
        if checkBoxButton2.isChecked == false {
        self.checkBoxButton2.alpha = 0
        self.textView2.alpha = 0
        
        UIView.animate(withDuration: 1, animations: {
            self.view.addSubview(self.checkBoxButton2)
            self.view.addSubview(self.textView2)
            self.checkBoxButton2.alpha = 1
            self.textView2.alpha = 1

        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
            }, completion: nil)
        }
        } else {
            startButton.isHidden = true
        }
    }
    
    @IBAction func checkBoxButton2(_ sender: Any){
        self.startButton.alpha = 0
        if checkBoxButton2.isChecked == false && startButton.isHidden == true {
        UIView.animate(withDuration: 0.4, animations: {
            self.view.addSubview(self.startButton)
            self.startButton.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 0.4, animations: {
            }, completion: nil)
        }
        startButton.isHidden = false
        } else {
            startButton.isHidden = true
        }
        
    }
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textView2: UITextView!
    

    @IBAction func startButton(_ sender: Any) {
        performSegue(withIdentifier: "MainSB", sender: self)
        UserDefaults.standard.set(true, forKey: Props.hasBeenSeen)
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
        self.view.addSubview(firstLabel)
        self.view.addSubview(secondLabel)

        

   }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkBoxButton.alpha = 0
        self.textView.alpha = 0
        
        UIView.animate(withDuration: 1, animations: {
            self.view.addSubview(self.checkBoxButton)
            self.view.addSubview(self.textView)
            self.checkBoxButton.alpha = 1
            self.textView.alpha = 1
            
        }) { (true) in
            UIView.animate(withDuration: 1, animations: {
            }, completion: nil)
        }
    }
    
    
}

