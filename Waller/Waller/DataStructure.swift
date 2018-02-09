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

struct Wallet
{
    var identifier:String
    var name:String
    var address:String
    var encryptedPrivKey:String
}
