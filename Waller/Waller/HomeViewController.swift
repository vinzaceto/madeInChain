//
//  ViewController.swift
//  Waller
//
//  Created by Vincenzo Ajello on 02/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit
import MapKit
import LocalAuthentication

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,HFCardCollectionViewLayoutDelegate,AddWalletViewControllerDelegate,WalletCellDelegate,WalletFunctionDelegate,QuickImportDelegate {
    
    

    
    
    weak var timer: Timer?
    
    @IBOutlet weak var totalView: InfoSectionXibController!
    @IBOutlet weak var lineChart: LineChart!
    var infoButton: UIButton!
    
    var loadingLabel:UILabel!
    let gradientView:GradientView = GradientView()

    @IBOutlet var collectionView: UICollectionView?
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    var defaultCollectionViewCenter:CGPoint!
    
    var walletsList:[Wallet]!
    var walletsBalancesList:[(address:String,unspent:[BTCTransactionOutput])] = []
    var walletsTransactionsList:[WalletTransactions] = []
    
    var eeTimer:Timer!
    var numPressed = 0
    
    let dataConnection = DataConnections()
    let testnet = BTCTestnetInfo.init()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        walletsList = []
        
        gradientView.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        if Props.colorSchemaClear
        {
            gradientView.FirstColor = Props().firstGradientColor
            gradientView.SecondColor = Props().secondGradientColor
        }
        else
        {
            gradientView.FirstColor = Props().firstGradientColorDark
            gradientView.SecondColor = Props().secondGradientColorDark
        }
        self.view.addSubview(gradientView)
        self.view.sendSubview(toBack: gradientView)
    
        lineChart.frame = CGRect.init(x: 15, y: 110, width: self.view.frame.size.width-30, height: 190)
        lineChart.layer.cornerRadius = 6
        lineChart.clipsToBounds = true
        lineChart.isUserInteractionEnabled = false
        lineChart.scrollView.setContentOffset(CGPoint.init(x: lineChart.scrollView.contentSize.width, y: 0), animated: true)
        self.view.bringSubview(toFront: collectionView!)
        
        var footerY = self.view.frame.size.height-20
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436
        {
            //iPhone X
            footerY = self.view.frame.size.height-40
        }

        let baseString = ""
        let attributedString = NSMutableAttributedString(string: baseString, attributes: nil)
        let blockchainRange = (attributedString.string as NSString).range(of: "blockchain.com")
        let bitstampRange = (attributedString.string as NSString).range(of: "bitstamp.net")
        attributedString.setAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)], range: blockchainRange)
        attributedString.setAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)], range: bitstampRange)
        let footerLabel = UILabel.init(frame: CGRect.init(x: 0, y: footerY,
        width: self.view.frame.size.width, height: 20))
        footerLabel.font = UIFont.systemFont(ofSize: 14)
        footerLabel.attributedText = attributedString
        footerLabel.textAlignment = .center
        footerLabel.textColor = UIColor.lightText
        self.view.addSubview(footerLabel)
        
        collectionView?.layer.cornerRadius = 10
        collectionView?.frame.origin.y = lineChart.frame.origin.y + 30
        collectionView?.frame.size.height = self.view.frame.size.height - lineChart.frame.origin.y - 28
        collectionView?.frame.size.width = self.view.frame.size.width - 30
        collectionView?.center.x = self.view.center.x
        collectionView?.backgroundView?.backgroundColor = UIColor.clear
        collectionView?.backgroundColor = UIColor.clear
        defaultCollectionViewCenter = collectionView?.center
        
        if let layout = self.collectionView?.collectionViewLayout as? HFCardCollectionViewLayout
        {
            self.cardCollectionViewLayout = layout
            self.cardCollectionViewLayout?.cardHeight = 340
        }
        
        infoButton = UIButton.init(frame:CGRect.init(x: 12, y: 107, width: 20, height:20))
        infoButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        infoButton.layer.cornerRadius = 5
        infoButton.setTitle("i", for: .normal)
        infoButton.titleLabel?.font = UIFont(name: "Rubik", size: 14)
        infoButton.addTarget(self,action:#selector(infoButtonPopUp), for: .touchUpInside)
        view.addSubview(infoButton)
        
        
        updateBTCValue()
        getChartData()
        
        loadWallets()
        startTimer()
    }
    
    //Pasquale pop up infoButton
    
    @objc func infoButtonPopUp()
    {
        print("pressed")
        
        numPressed = numPressed + 1
        
        if eeTimer != nil
        {eeTimer.invalidate()}
        
        eeTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false)
        {_ in
            if self.numPressed == 3
            {self.showEE()}
            else {self.showInfoAlert()}
            self.numPressed = 0
        }
    }
    
    func showInfoAlert()
    {
        let alert = EMAlertController(title: "Credits", message: "Data from:\nblockchain.info and bitstamp.net")
        let close = EMAlertAction(title: "Close", style: .cancel)
        alert.addAction(action: close)
        alert.buttonSpacing = 0
        present(alert, animated: true, completion: nil)
    }
    
    
    
    // This is a present for our unforgotten bestfriend
    func showEE()
    {
        let latitude: CLLocationDegrees =  50.110924
        let longitude: CLLocationDegrees = 8.682127
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "FRANCOFORTE"
        mapItem.openInMaps(launchOptions: options)
    }
    
    func loadWallets()
    {
        walletsList = []
        let walletsKeychain = WalletsDatabase.init()
        walletsList = walletsKeychain.getAllWallets()
        
        loadBalance()
        loadTransactions()
    }
    
    func startTimer()
    {
        timer?.invalidate() // just in case you had existing `Timer`, `invalidate` it before we lose our reference to it
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true)
        {
            [weak self] _ in
            self?.loadTransactions()
            self?.updateTotal()
            self?.loadBalance()
            self?.updateBTCValue()
        }
    }
    
    func loadBalance()
    {
        walletsBalancesList = []

        for (index, wallet) in walletsList.enumerated()
        {
            testnet.unspentOutputsWithAddress(address: wallet.address, completion:
            {
                (success, error, unspentOutputs) in
                if success == true
                {
                    self.walletsBalancesList.append((address: wallet.address, unspent: unspentOutputs!))
                }
                else
                {
                    print("GET unspent outputs fail : \(error)")
                }
            })
        }
    }
    
    func updateTotal()
    {
        print("updating total")
        var confirmedTotalBalance:BTCAmount = 0
        for walletBalance in walletsBalancesList
        {
            for unspent in walletBalance.unspent
            {
                confirmedTotalBalance = confirmedTotalBalance + unspent.value
            }
        }
        self.totalView.updateBTCTotal(total: confirmedTotalBalance)
    }
    
    func loadTransactions()
    {
        walletsTransactionsList = []
        for wallet in walletsList
        {
            testnet.getWalletTransactions(address: wallet.address, completion:
            {
                (success, txs) in
                if success == true
                {
                    if let transactions = txs
                    {
                        self.walletsTransactionsList.append(transactions)
                    }
                }
            })
        }
    }
    
    
    // WalletCell Delegate
    
    func getOutputBalanceByAddress(address:String) -> [BTCTransactionOutput]?
    {
        for balance in walletsBalancesList
        {
            if balance.address == address
            {
                return balance.unspent
            }
        }
        return nil
    }

    
    func getUSDVAlueFromAmount(amount:String) -> String?
    {
        print("update total in the cells")
        print("string amount: \(amount)")
        print("double amount: \(amount.toDouble())")

        if amount.toDouble() == 0
        {
            return "--"
        }
        
        let formattedBalance = totalView.convertBTCAmountToCurrency(amount: amount.toDouble()!)
        return formattedBalance
    }

    func getTransactionsBy(address: String) -> WalletTransactions?
    {
        print("GET transactions for address : \(address)")
        for walletTransactions in walletsTransactionsList
        {
            if walletTransactions.address == address
            {
                return walletTransactions
            }
        }
        return nil
    }
    
    func getBTCValue() ->Double?
    {
        return totalView.btcValue
    }
   

    

    
    
    //
    // MARK: COLLECTION VIEW DELEGATE METHODS
    //
    
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willRevealCardAtIndex index: Int) {
        if (self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? WalletCell) != nil {
            //cell.cardCollectionViewLayout = self.cardCollectionViewLayout
            //cell.cardIsRevealed(true)
        }
    }
    
    func cardCollectionViewLayout(_ collectionViewLayout: HFCardCollectionViewLayout, willUnrevealCardAtIndex index: Int) {
        if (self.collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as? WalletCell) != nil {
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
                
                cell.wallet = walletsList[indexPath.row-1]
                
                if let privateKey = cell.wallet.privatekey
                {
                    cell.addressPrivateKey = privateKey
                    cell.backgroundColor = Props.myYellow
                    cell.headerImage.tintColor = UIColor.darkGray
                    cell.iconImage.image = UIImage.init(named: "standardIcon")
                }
                else
                {
                    cell.backgroundColor = Props.myBlue
                    cell.headerImage.tintColor = UIColor.blue
                    cell.iconImage.image = UIImage.init(named: "watchOnlyIcon")
                }
                
                cell.nameLabel.text = walletsList[indexPath.row-1].label
                let address = walletsList[indexPath.row-1].address
                cell.addressLabel.text = address
                cell.amountLabel.text = "0"
                cell.currencyAmount.text = "--"
                cell.cardCollectionViewLayout = cardCollectionViewLayout
                cell.delegate = self
                cell.updateTransactions()
                cell.updateBalance()
                cell.updateCurrencyPrice()
                cell.startTimer()
                return cell
                
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.cardCollectionViewLayout?.revealCardAt(index: indexPath.item)
    }
    
    
    
    
    
    //
    // MARK: NEW WALLET CELL BUTTONS
    //
    
    func addButtonPressed()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addWallet = storyboard.instantiateViewController(withIdentifier: "AWController") as! AddWalletViewController
        addWallet.delegate = self
        let navigationVC = UINavigationController.init(rootViewController: addWallet)
        present(navigationVC, animated: true, completion: nil)
        self.cardCollectionViewLayout?.unrevealCard()
    }
    
    func scanButtonPressed()
    {
        print("quick import button pressed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let quickImport = storyboard.instantiateViewController(withIdentifier: "QIController") as! QuickImportViewController
        quickImport.delegate = self
        let navigationVC = UINavigationController(rootViewController: quickImport)
        present(navigationVC, animated: true, completion: nil)
    }
    
    //
    // WALLET CELL BUTTONS
    //
    
    func makeAPaymentButtonPressed(walletCell:WalletCell)
    {
        authenticationWithTouchID()
        
        let view = PaymentWalletView.init(frame: CGRect.init(x: 0, y: 0, width: walletCell.frame.size.width, height: walletCell.frame.size.height))
        view.delegate = self
        let w = Wallet.init(label: walletCell.amountLabel.text!, address: walletCell.addressLabel.text!, privatekey: walletCell.addressPrivateKey)
        view.wallet = w
        //view.testTransactionWithWallet(wallet: w)
        walletCell.cardCollectionViewLayout?.flipRevealedCard(toView: view)
        view.receiverAddressField.becomeFirstResponder()
        view.updateAmount()
        view.updateBtcValue()
    }
    
    func listTransactionsButtonPressed(walletCell:WalletCell,transactions:[Transaction])
    {
        let view = TransactionsWalletView.init(frame: CGRect.init(x: 0, y: 0, width: walletCell.frame.size.width, height: walletCell.frame.size.height))
        view.delegate = self
        view.transactions = transactions
        view.tableView.reloadData()
        walletCell.cardCollectionViewLayout?.flipRevealedCard(toView: view)
    }
    
    func exportButtonPressed(walletCell: WalletCell)
    {
        let view = ExportWalletView.init(frame: CGRect.init(x: 0, y: 0, width: walletCell.frame.size.width, height: walletCell.frame.size.height))
        view.delegate = self
        view.wallet = Wallet.init(label: walletCell.nameLabel.text!, address: walletCell.addressLabel.text!, privatekey: walletCell.addressPrivateKey)
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
        view.address = walletCell.addressLabel.text!
        walletCell.cardCollectionViewLayout?.flipRevealedCard(toView: view)
    }
    
    func exportWalletAsPDF(unencryptedWallet: Wallet)
    {
        PDFExport(unencryptedWallet: unencryptedWallet)
    }
    
    
    
    
    
    
    
    func unflipCard()
    {
        self.cardCollectionViewLayout?.flipRevealedCardBack()
    }

    func unflipAndRemove(address:String)
    {
        print("remove address : \(address)")
        self.cardCollectionViewLayout?.unrevealRevealedCardAction()
        removeWallet(address: address)
    }
    
    
    
    
    
    //
    // MARK: WALLET OPERATIONS
    //
    
    func walletAdded(success: Bool)
    {
        if success == true
        {
            print("reload data")
            loadWallets()
            self.collectionView?.reloadData()
        }
    }
    
    
    func removeWallet(address:String)
    {
        let database = WalletsDatabase.init()
        database.removeWalletBy(address: address)
        {
            (success, error) in
            
            if success == true
            {
                print("address removed")
                DispatchQueue.main.async
                {
                    self.loadWallets()
                    self.collectionView?.reloadData()
                }
                return
            }
            print("remove address failed")
        }
    }
    
    func PDFExport(unencryptedWallet:Wallet)
    {
        print("Generating PDF")
        let v1 = UIView(frame: CGRect(x: 0.0,y: 0, width: 420, height: 594))
        v1.backgroundColor = UIColor.white
        
        // Draw logo
        let mod:CGFloat = 0.6
        let logo = UIImageView.init(frame: CGRect.init(x: 0, y:20, width: 153*mod, height: 149*mod))
        logo.image = UIImage.init(named: "LogoBig")
        logo.center.x = v1.center.x
        v1.addSubview(logo)
        
        // Draw private key as QRCode
        let privKeyQRCode = BTCQRCode.image(for: unencryptedWallet.privatekey!, size: CGSize.init(width: 100, height: 100 ), scale: 10)
        let privateKeyImageView = UIImageView.init(frame: CGRect.init(x: 20, y: 20, width: 100, height: 100))
        privateKeyImageView.image = privKeyQRCode
        v1.addSubview(privateKeyImageView)
        
        // Draw private key label
        let privateKeyLabel = UILabel.init(frame: CGRect.init(x: 20, y: privateKeyImageView.frame.size.height+40,
                                                              width:privateKeyImageView.frame.size.width, height: 200))
        privateKeyLabel.textAlignment = .center
        privateKeyLabel.numberOfLines = 0
        privateKeyLabel.text = unencryptedWallet.privatekey
        //privateKeyLabel.font = UIFont.systemFont(ofSize: 5)
        privateKeyLabel.adjustsFontSizeToFitWidth = true
        v1.addSubview(privateKeyLabel)
        
        let pubKeyQRCode = BTCQRCode.image(for: "bitcoin:\(unencryptedWallet.address)", size: CGSize.init(width: 100, height: 100 ), scale: 10)
        let pubKeyImageView = UIImageView.init(frame: CGRect.init(x: v1.frame.size.width-120, y: 20, width: 100, height: 100))
        pubKeyImageView.image = pubKeyQRCode
        v1.addSubview(pubKeyImageView)

        
        let addressLabel = UILabel.init(frame: CGRect.init(x: v1.frame.size.width-120, y: privateKeyImageView.frame.size.height+40,
                                                              width:privateKeyImageView.frame.size.width, height: 100))
        addressLabel.textAlignment = .center
        addressLabel.numberOfLines = 0
        addressLabel.text = unencryptedWallet.address
        //privateKeyLabel.font = UIFont.systemFont(ofSize: 5)
        addressLabel.adjustsFontSizeToFitWidth = true
        v1.addSubview(addressLabel)
        
        //        Draw Name
        let nameLabel = UILabel.init(frame: CGRect.init(x: 0, y: 150,width: 153*mod, height: 149*mod))
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.text = "This is your wallet:\n \(unencryptedWallet.label)"
        nameLabel.backgroundColor = .clear
        nameLabel.center.x = v1.center.x
        nameLabel.adjustsFontSizeToFitWidth = true
        v1.addSubview(nameLabel)
        
        do
        {
            let data = try PDFGenerator.generated(by: [v1])
            loadPDFAndShare(data: data)
        }
        catch
        {
            print("error in the generation of the pdfxD")
        }
    }
    
    func loadPDFAndShare(data:Data)
    {
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView=self.view
        activityViewController.completionWithItemsHandler =
        {
            (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            
            // Do something
            self.cardCollectionViewLayout?.flipRevealedCardBack()
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func keyboardDidOpen()
    {
        let fix = self.view.frame.size.height - 330
        
        UIView.animate(withDuration: 0.3)
        {
            self.collectionView?.center.y = fix
        }
    }
    
    func keyboardDidClose()
    {
        UIView.animate(withDuration: 0.5)
        {
            self.collectionView?.center = self.defaultCollectionViewCenter
        }
    }
    
    //
    // MARK: CHART DATA LOADING
    //
    
    func getChartData()
    {
        loadingLabel = UILabel.init(frame: CGRect.init(x: 0, y: 38, width: lineChart.frame.size.width, height: lineChart.frame.size.height-50))
        loadingLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingLabel.text = "Loading chart data..."
        loadingLabel.textColor = UIColor.lightText
        loadingLabel.font = UIFont.systemFont(ofSize: 28)
        loadingLabel.textAlignment = .center
        lineChart.addSubview(loadingLabel)
        
        dataConnection.getBitcoinChartData
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

    //
    // MARK: UPDATE BTC PRICE 
    //
    
    func updateBTCValue()
    {
        dataConnection.getBitcoinValue(currency: Props.btcUsd) { (result) in
            switch result
            {
            case .success(let posts):
                
                guard let btcValue = Double(posts.last) else { return }
                print("btc value : \(btcValue)")
                self.totalView.updateBTCPrice(btcPrice: btcValue)
                
            case .failure(let error):
                
                print("No connection \(error.localizedDescription)")
            }
        }
    }
}

extension HomeViewController {
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    
                    //TODO: User authenticated successfully, take appropriate action
                    
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action

                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}

