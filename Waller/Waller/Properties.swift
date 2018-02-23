//
//  Properties.swift
//  Waller
//
//  Created by Vincenzo Ajello on 06/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import Foundation

class Props:NSObject
{
    static let selectionMargin = 15
    static let selectionClosedSize = 53
    static let optionTitleHeight = 30
    static let optionViewMargin = 10
    static let optionCornerRadius = 10
    
    static let hasBeenSeen:String = "visualized"

    
    static let lastBtcValue = "LASTBTCVALUE"
    
    
    static let httpsSchema = "https"
    static let httpSchema = "http"
    
    static let bitstampHost = "www.bitstamp.net"
    static let istampHost = "istamp.mskaline.com"
    
    static let btcUsd = "btcusd/"
    static let btcEur = "btceur/"
    
    let firstGradientColorDark = UIColor(red: 26/255, green: 44/255, blue: 59/255, alpha: 1)
    let secondGradientColorDark = UIColor(red: 53/255, green: 74/255, blue: 94/255, alpha: 1)
    
    let firstGradientColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    let secondGradientColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    
    let addViewsBackgroundColor = UIColor.clear
    
    static let colorSchemaClear = false
    
    static let myBlack = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
    static let myBlue = UIColor(red:0.15, green:0.68, blue:0.75, alpha:1.0)
    static let myRose = UIColor(red:0.95, green:0.42, blue:0.41, alpha:1.0)
    static let myGreen = UIColor(red:0.70, green:0.69, blue:0.19, alpha:1.0)
    static let myOrange = UIColor(red:1.00, green:0.69, blue:0.02, alpha:1.0)
    static let myYellow = UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0)
    static let myGrey = UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
    static let myGreyAlpha = UIColor(red:0.80, green:0.80, blue:0.80, alpha:0.9)

    
}

extension UILabel{
    var defaultFont: UIFont? {
        get { return self.font }
        set { self.font = newValue }
    }
}
