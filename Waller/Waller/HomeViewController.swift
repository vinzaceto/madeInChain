//
//  ViewController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 02/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit



class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,HFCardCollectionViewLayoutDelegate {

    @IBOutlet weak var currentCurrancy: UILabel!
    @IBOutlet weak var currentBTCvalue: UILabel!
    @IBOutlet weak var currentAmount: UILabel!
    @IBOutlet weak var currentBtcAmount: UILabel!
    @IBOutlet weak var adButton: UIButton!
    
    
    @IBOutlet var collectionView: UICollectionView?
    var cardCollectionViewLayout: HFCardCollectionViewLayout?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.frame.origin.y = 200
        collectionView?.frame.size.height = self.view.frame.size.height - 200
        collectionView?.frame.size.width = 310
        collectionView?.center.x = self.view.center.x

        adButton.frame.origin.x = (collectionView?.frame.origin.x)! + (collectionView?.frame.size.width)! - adButton.frame.width
        adButton.frame.origin.y = (collectionView?.frame.origin.y)! - adButton.frame.height - 10
        
        adButton.clipsToBounds = true
        adButton.layer.cornerRadius = adButton.frame.width / 2
        adButton.backgroundColor = UIColor.blue
        adButton.setTitleColor(UIColor.white, for: .normal)
        
        let walletsKeychain = WalletsKeychain.init()
        walletsKeychain.getAllWallets()
        
        self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)

        
    }
    
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willRevealCardAtIndex index: Int) {
        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? WalletCell {
            //cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            //cell.cardIsRevealed(true)
        }
    }
    
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willUnrevealCardAtIndex index: Int) {
        if let cell = self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? WalletCell {
            //cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            //cell.cardIsRevealed(false)
        }
    }
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletCell", for: indexPath) as! WalletCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.cardCollectionViewLayout?.revealCardAt(index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        //let tempItem = self.cardArray[sourceIndexPath.item]
        //self.cardArray.remove(at: sourceIndexPath.item)
        //self.cardArray.insert(tempItem, at: destinationIndexPath.item)
    }

}

