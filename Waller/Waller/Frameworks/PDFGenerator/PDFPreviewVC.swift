//
//  PDFPreviewVC.swift
//  PDFGenerator
//
//  Created by Suguru Kishimoto on 2016/02/06.
//
//

import UIKit

class PDFPreviewVC: UIViewController {
    
    @IBOutlet fileprivate weak var webView: UIWebView!
    var url: URL!
    override func viewDidLoad() {
        super.viewDidLoad()
        let req = NSMutableURLRequest(url: url)
        req.timeoutInterval = 60.0
        req.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        webView.scalesPageToFit = true
        webView.loadRequest(req as URLRequest)
        
        loadPDFAndShare()
    }
    
    @IBAction func storeButtonPressed(_ sender: Any)
    {
        loadPDFAndShare()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadPDFAndShare()
    {
        let fileManager = FileManager.default
        let documentoPath = self.getDestinationPath()
        
        if fileManager.fileExists(atPath: documentoPath){
            
            let documento = NSData(contentsOfFile: documentoPath)
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [documento!], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView=self.view
            present(activityViewController, animated: true, completion: nil)
        }
        else {
            print("document was not found")
        }
    }
    
    fileprivate func getDestinationPath() -> String
    {
        return NSHomeDirectory() + "/sample.pdf"
    }
    
    @objc @IBAction fileprivate func close(_ sender: AnyObject!) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupWithURL(_ url: URL) {
        self.url = url
    }

}
