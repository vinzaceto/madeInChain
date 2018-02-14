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

struct FullWallet: Codable
{
    var label:String
    var address: String
    var encryptedPrivatekey: String
}

struct WatchOnlyWallet: Codable
{
    var label:String
    var address:String
}

struct WalletsList
{
    let fullWallets:[FullWallet]
    let watchOnlyWallets:[WatchOnlyWallet]
}

struct BitstampValue : Codable
{
    var last: String
}
