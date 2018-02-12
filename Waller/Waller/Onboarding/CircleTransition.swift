//
//  CircleTransition.swift
//  Waller
//
//  Created by Pasquale Mauriello on 08/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

class CircleTransition: NSObject {
    
   public  var circle = UIView()
    
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }
    var circleCOlor = UIColor.white
    var duration = 0.3
    enum CircularTransitionMode:Int {
        case present, dismiss, pop
    }
    var transitionMode:CircularTransitionMode = .present
    
}
