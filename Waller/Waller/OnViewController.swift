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


}
