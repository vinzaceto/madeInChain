//
//  ViewController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 02/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,HFCardCollectionViewLayoutDelegate,AddWalletViewControllerDelegate {

    @IBOutlet weak var currentCurrancy: UILabel!
    @IBOutlet weak var currentBTCvalue: UILabel!
    @IBOutlet weak var currentAmount: UILabel!
    @IBOutlet weak var currentBtcAmount: UILabel!
    @IBOutlet weak var adButton: UIButton!
    @IBOutlet weak var quickImportButton: UIButton!

    @IBOutlet var collectionView: UICollectionView?
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    var walletsList:WalletsList!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.frame.origin.y = 200
        collectionView?.frame.size.height = self.view.frame.size.height - 200
        collectionView?.frame.size.width = 310
        collectionView?.center.x = self.view.center.x

        if let layout = self.collectionView?.collectionViewLayout as? HFCardCollectionViewLayout
        {
            self.cardCollectionViewLayout = layout
        }
        
        adButton.frame.origin.x = (collectionView?.frame.origin.x)! + (collectionView?.frame.size.width)! - adButton.frame.width
        adButton.frame.origin.y = (collectionView?.frame.origin.y)! - adButton.frame.height - 10
        //adButton.frame.origin.y = 200

        adButton.clipsToBounds = true
        adButton.layer.cornerRadius = adButton.frame.width / 2
        adButton.backgroundColor = UIColor.blue
        adButton.setTitleColor(UIColor.white, for: .normal)
        
        quickImportButton.frame.origin.x = (collectionView?.frame.origin.x)!
        quickImportButton.frame.origin.y = adButton.frame.origin.y
        
        
        quickImportButton.clipsToBounds = true
        quickImportButton.layer.cornerRadius = adButton.layer.cornerRadius
        quickImportButton.backgroundColor = UIColor.blue
        quickImportButton.setTitleColor(UIColor.white, for: .normal)
        
        loadWallets()
        
        self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)

        
        let dataConnection = DataConnections()
        dataConnection.getBitcoinValue(currency: "btcusd") { (result) in
            switch result {
            case .success(let posts):
                self.currentBTCvalue.text = posts.last+"$"
            case .failure(let error):
                fatalError("error: \(error)")
            }
        }
        
    }
    
    
    func loadWallets()
    {
        let walletsKeychain = WalletsDatabase.init()
        walletsList = walletsKeychain.getAllWallets()
        print("saved wallets : \(walletsList)")
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addWallet = storyboard.instantiateViewController(withIdentifier: "AWController") as! AddWalletViewController
        addWallet.delegate = self
        let navigationVC = UINavigationController(rootViewController: addWallet)
        present(navigationVC, animated: true, completion: nil)
    }
    
    @IBAction func quickImportButtonPressed(_ sender: Any)
    {
        print("quick import button pressed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let quickImport = storyboard.instantiateViewController(withIdentifier: "QIController") as! QuickImportViewController
        let navigationVC = UINavigationController(rootViewController: quickImport)
        present(navigationVC, animated: true, completion: nil)
    }
    func walletAdded(success: Bool)
    {
        if success == true
        {
            print("reload data")
            loadWallets()
            self.collectionView?.reloadData()
        }
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
        if(walletsList.fullWallets.count==0 && walletsList.watchOnlyWallets.count==0){
            return 1
        }
        return walletsList.fullWallets.count + walletsList.watchOnlyWallets.count + 1
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

