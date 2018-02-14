//
//  InfoSectionViewController.swift
//  Waller
//
//  Created by Vincenzo Aceto on 14/02/2018.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class InfoSectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let lastBtcValueTemp = UserDefaults.standard.string(forKey: Props.lastBtcValue) {
//            self.currentBTCvalue.text = lastBtcValueTemp
        } else {
//            self.currentBTCvalue.text = "0$"
        }
        
        let dataConnection = DataConnections()
        dataConnection.getBitcoinValue(currency: Props.btcUsd) { (result) in
            switch result {
            case .success(let posts):
                print(posts.last+"$")
                UserDefaults.standard.set(posts.last+"$", forKey: Props.lastBtcValue)
//                self.currentBTCvalue.text = posts.last+"$"
            case .failure(let error):
                fatalError("error: \(error)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
