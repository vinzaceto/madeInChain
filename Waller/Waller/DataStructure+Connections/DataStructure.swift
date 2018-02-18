//
//  DataStructure.swift
//  Waller
//
//  Created by Vincenzo Ajello on 06/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit
import Foundation

struct Option
{
    var title:String
    var text:String
    var buttonTitle:String
}

enum AddType
{
    case Standard
    case Multisig
    case Import
}

enum SaveType
{
    case Local
    case Mnemonic
}

enum ImportType
{
    case Text
    case QRCode
}

struct Wallet: Codable
{
    var label:String
    var address: String
    var privatekey: String!
}

struct Transaction
{
    let input:Bool
    let value:BTCAmount
    let time:UInt32
}

struct BitstampValue : Codable
{
    var last: String
}

struct ChartResponse : Codable
{
    var status:Int
    var data:[ChartData]
}

struct ChartData : Codable
{
    var date:String
    var closingprice:String
}
