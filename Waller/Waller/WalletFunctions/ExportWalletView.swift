//
//  ExportWalletView.swift
//  Waller
//
//  Created by Vincenzo Ajello on 16/02/18.
//  Copyright © 2018 madeinchain. All rights reserved.
//

import UIKit

enum ExportType
{
    case iCloud
    case PDFtoFile
    case PDFtoMail
}

class ExportWalletView: UIView
{
    var delegate:WalletFunctionDelegate!
    var outputAsData: Bool = false

    override init(frame: CGRect)
    {        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        layer.cornerRadius = 6
        clipsToBounds = true
        
        let viewWidth = UIScreen.main.bounds.width - 30
        
        let flipButton = UIButton.init(type: .roundedRect)
        flipButton.frame = CGRect.init(x: 0, y: 10, width:60, height: 25)
        flipButton.addTarget(self, action: #selector(flipButtonPressed), for: .touchUpInside)
        flipButton.backgroundColor = UIColor.clear
        flipButton.setTitle("close", for: .normal)
        flipButton.center.x = self.center.x
        addSubview(flipButton)
        
        let infoLabel = UILabel.init(frame: CGRect.init(x: 30, y: 60, width: viewWidth - 60, height: 40))
        infoLabel.backgroundColor = UIColor.clear
        infoLabel.text = "Select how to export this wallet"
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.textColor = UIColor.lightGray
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        self.addSubview(infoLabel)
        
        let exportICloud = UIButton.init(type: .roundedRect)
        exportICloud.frame = CGRect.init(x: (viewWidth-160)/2, y: 130, width: 160, height: 35)
        exportICloud.addTarget(self, action: #selector(exportByICloudPressed), for: .touchUpInside)
        exportICloud.layer.borderWidth = 2
        exportICloud.layer.borderColor = UIColor.gray.cgColor
        exportICloud.layer.cornerRadius = 6
        exportICloud.setTitle("export on iCloud", for: .normal)
        self.addSubview(exportICloud)
        
        let exportOnFile = UIButton.init(type: .roundedRect)
        exportOnFile.frame = CGRect.init(x: (viewWidth-180)/2, y: 190, width: 180, height: 35)
        exportOnFile.addTarget(self, action: #selector(exportByFilePressed), for: .touchUpInside)
        exportOnFile.layer.borderWidth = 2
        exportOnFile.layer.borderColor = UIColor.gray.cgColor
        exportOnFile.layer.cornerRadius = 6
        exportOnFile.setTitle("export as PDF on File", for: .normal)
        self.addSubview(exportOnFile)
        
        let exportByMail = UIButton.init(type: .roundedRect)
        exportByMail.frame = CGRect.init(x: (viewWidth-160)/2, y: 250, width: 160, height: 35)
        exportByMail.addTarget(self, action: #selector(exportByMailPressed), for: .touchUpInside)
        exportByMail.layer.borderWidth = 2
        exportByMail.layer.borderColor = UIColor.gray.cgColor
        exportByMail.layer.cornerRadius = 6
        exportByMail.setTitle("export on iCloud", for: .normal)
        self.addSubview(exportByMail)
        
    }
    
    @objc func flipButtonPressed()
    {
        print("flipButtonPressed")
        guard let _ = delegate?.unflipCard() else { return }
    }
    
    @objc func exportByICloudPressed()
    {
        exportUsing(exportType: ExportType.iCloud)
    }
    
    @objc func exportByFilePressed()
    {
        exportUsing(exportType: ExportType.PDFtoFile)
    }
    
    @objc func exportByMailPressed()
    {
        exportUsing(exportType: ExportType.PDFtoMail)
    }
    
    func exportUsing(exportType:ExportType)
    {
        guard let _ = delegate?.exportUsing(exportType: exportType) else { return }
    }
    
    /*
    func generatePDF()
    {
        print("Generating PDF")
        let v1 = UIScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let v2 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        let v3 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        v1.backgroundColor = UIColor.red
        v1.contentSize = CGSize(width: 100, height: 100)
        v2.backgroundColor = UIColor.green
        v3.backgroundColor = UIColor.blue
        
        do
        {
            let dst = getDestinationPath(1)
            if outputAsData
            {
                let data = try PDFGenerator.generated(by: [v1, v2, v3])
                print(data)
                try data.write(to: URL(fileURLWithPath: dst))
            }
            else
            {
                try PDFGenerator.generate([v1, v2, v3], to: dst)
            }
            openPDFViewer(dst)
        }
        catch (let e)
        {
            print(e)
        }
    }
    
    fileprivate func getDestinationPath(_ number: Int) -> String
    {
        return NSHomeDirectory() + "/sample\(number).pdf"
    }
    
    fileprivate func openPDFViewer(_ pdfPath: String)
    {
        let url = URL(fileURLWithPath: pdfPath)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! PDFPreviewVC
        vc.setupWithURL(url)
        self.present(vc, animated: true, completion: nil)
    }
    */
    
    required init?(coder aDecoder: NSCoder)
    {super.init(coder: aDecoder)}
}
