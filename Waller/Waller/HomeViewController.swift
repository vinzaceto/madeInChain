//
//  ViewController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 02/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,HFCardCollectionViewLayoutDelegate,AddWalletViewControllerDelegate,WalletCellDelegate,WalletFunctionDelegate {
    
    
    @IBOutlet weak var currentCurrancy: UILabel!
    @IBOutlet weak var currentBTCvalue: UILabel!
    @IBOutlet weak var currentAmount: UILabel!
    @IBOutlet weak var currentBtcAmount: UILabel!
    @IBOutlet weak var lineChart: LineChart!
    
    var loadingLabel:UILabel!
    let gradientView:GradientView = GradientView()

    @IBOutlet var collectionView: UICollectionView?
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    var walletsList:[Wallet]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientView.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradientView.FirstColor = Props().firstGradientColor
        gradientView.SecondColor = Props().secondGradientColor
        self.view.addSubview(gradientView)
        self.view.sendSubview(toBack: gradientView)
                
        lineChart.frame = CGRect.init(x: 10, y: 110, width: self.view.frame.size.width-20, height: 190)
        lineChart.layer.cornerRadius = 6
        lineChart.clipsToBounds = false
        self.view.bringSubview(toFront: collectionView!)
        
        getChartData()
        
        collectionView?.layer.cornerRadius = 6
        collectionView?.frame.origin.y = lineChart.frame.origin.y + 30
        collectionView?.frame.size.height = self.view.frame.size.height - lineChart.frame.origin.y - 28
        collectionView?.frame.size.width = self.view.frame.size.width - 30
        collectionView?.center.x = self.view.center.x
        collectionView?.backgroundView?.backgroundColor = UIColor.clear
        collectionView?.backgroundColor = UIColor.clear

        if let layout = self.collectionView?.collectionViewLayout as? HFCardCollectionViewLayout
        {
            self.cardCollectionViewLayout = layout
            self.cardCollectionViewLayout?.cardHeight = 340
        }
        
        loadWallets()
        
    }
    
    func getChartData()
    {
        loadingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 38, width: lineChart.frame.size.width, height: lineChart.frame.size.height-50))
        loadingLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingLabel.text = "Loading chart data..."
        loadingLabel.textColor = UIColor.lightText
        loadingLabel.font = UIFont.systemFont(ofSize: 28)
        loadingLabel.textAlignment = .center
        lineChart.addSubview(loadingLabel)
        
        let connection = DataConnections.init()
        connection.getBitcoinChartData
            {
                (result) in
                
                switch result
                {
                case .success(let chartData):
                    self.parseChartData(chartData: chartData.data)
                    
                case .failure(let error):
                    print("no chart data")
                }
        }
    }
    
    func parseChartData(chartData:[ChartData])
    {
        print(chartData)
        
        var result: [PointEntry] = []
        for data in chartData
        {
            let calendar = Calendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
            let d = dateFormatter.date (from: data.date)
            let date = "\(calendar.component(.month, from: d!))-\(calendar.component(.day, from: d!))"
            let float = Float(data.closingprice)
            result.append(PointEntry(value: Int(float!), label: date))
        }

        lineChart.dataEntries = result
        lineChart.isCurved = true
        
        perform(#selector(removeLoadingView), with: nil, afterDelay: 2)
    }
    
   @objc func removeLoadingView()
    {
        loadingLabel.removeFromSuperview()
    }
    
    func loadWallets()
    {
        let walletsKeychain = WalletsDatabase.init()
        walletsList = walletsKeychain.getAllWallets()
        print("saved wallets : \(walletsList)")
    }
    

    
    func addButtonPressed()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addWallet = storyboard.instantiateViewController(withIdentifier: "AWController") as! AddWalletViewController
        addWallet.delegate = self
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        present(navigationVC, animated: true, completion: nil)
        self.cardCollectionViewLayout?.unrevealCard()

    }
    
    func scanButtonPressed()
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
        if walletsList.count == 0
        {
            return 1
        }
        
        return walletsList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
            if indexPath.row == 0
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AWCell", for: indexPath) as! AddWalletCell
                cell.delegate = self
                return cell
            }
            else
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletCell", for: indexPath) as! WalletCell
                cell.headerImage.tintColor = UIColor.darkGray
                cell.iconImage.image = UIImage.init(named: "done")
                cell.nameLabel.text = walletsList[indexPath.row-1].label
                cell.addressLabel.text = walletsList[indexPath.row-1].address
                cell.amountLabel.text = "0.00000001"
                cell.currencyAmount.text = "10,00 $"
                cell.cardCollectionViewLayout = cardCollectionViewLayout
                cell.delegate = self
                return cell
            }
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
    
    
    
    
    func listTransactionsButtonPressed(walletCell:WalletCell)
    {
        let view = TransactionsWalletView.init(frame: CGRect.init(x: 0, y: 0, width: walletCell.frame.size.width, height: walletCell.frame.size.height))
        view.delegate = self
        walletCell.cardCollectionViewLayout?.flipRevealedCard(toView: view)
    }
    
    func makeAPaymentButtonPressed(walletCell:WalletCell)
    {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: walletCell.frame.size.width, height: walletCell.frame.size.height))
        view.backgroundColor = UIColor.green
        
        walletCell.cardCollectionViewLayout?.flipRevealedCard(toView: view)
    }
    
    func showQRCodeButtonPressed(walletCell:WalletCell)
    {
        let address = walletCell.addressLabel.text
        let view = QRCodeWalletView.init(frame: CGRect.init(x: 0, y: 0, width: walletCell.frame.size.width, height: walletCell.frame.size.height))
        view.setAddress(address: address!)
        view.delegate = self
        walletCell.cardCollectionViewLayout?.flipRevealedCard(toView: view)
        
    }
    
    func deleteButtonPressed(walletCell: WalletCell)
    {
        let view = DeleteWalletView.init(frame: CGRect.init(x: 0, y: 0, width: walletCell.frame.size.width, height: walletCell.frame.size.height))
        view.delegate = self
        walletCell.cardCollectionViewLayout?.flipRevealedCard(toView: view)
    }
    
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, didUnrevealCardAtIndex index: Int)
    {

    }
    
    func unflipCard()
    {
        self.cardCollectionViewLayout?.flipRevealedCardBack()
    }

    //TODO
    func unflipAndRemove()
    {
        self.cardCollectionViewLayout?.flipRevealedCardBack()
    }
}

