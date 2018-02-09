//
//  OnViewController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 02/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class OnViewController: UIViewController, UIViewControllerTransitioningDelegate{
    
    @IBOutlet weak var ButtonSkip: UIButton!
    
    let transition = CircleTransition()

    
    @IBAction func skipButt(_ sender: Any) {
        performSegue(withIdentifier: "MainSB", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! HomeViewController
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
        
    }

    
    
    let gradientView:GradientView = GradientView()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        gradientView.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradientView.FirstColor = UIColor.blue
        gradientView.SecondColor = UIColor.green
        self.view.addSubview(gradientView)
        self.view.addSubview(ButtonSkip)
        
     
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = ButtonSkip.center
        transition.circleColor = .white
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = ButtonSkip.center
        transition.circleColor = .white
        
        return transition
    }


}

