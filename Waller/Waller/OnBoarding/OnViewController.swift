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
    
    @IBOutlet weak var checkBoxButton2: CheckBox!
    
    
    @IBAction func checkBoxButton(_ sender: Any){
        if (checkBoxButton.isChecked &&  checkBoxButton2.isChecked) {
        }
        startButton.isHidden = false
        print("\(checkBoxButton.isChecked)")
    }
    
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textView2: UITextView!
    
    let transition = CircleTransition()
    
    @IBOutlet weak var startButton: UIButton!
    
    
    @IBAction func skipButt(_ sender: Any) {
        performSegue(withIdentifier: "MainSB", sender: self)
        UserDefaults.standard.set(false, forKey: Props.hasBeenSeen)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! HomeViewController
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
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
        startButton.layer.cornerRadius = 10;
        
        startButton.isHidden = true
        self.view.addSubview(startButton)
        self.view.addSubview(checkBoxButton)
        self.view.addSubview(textView)
        self.view.addSubview(checkBoxButton2)
        self.view.addSubview(textView2)
        
     
     
   }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

