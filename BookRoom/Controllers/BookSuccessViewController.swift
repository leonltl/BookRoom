//
//  BookSuccessViewController.swift
//  BookRoom
//
//  The controller class that is attached to Book Successfully Scene in Storyboard
//  It is to display a web view (that show successfully booked) and go back to the Room Listing scene
//  It will be triggered by Qr Camera controller
//

import UIKit
import WebKit

class BookSuccessViewController: UIViewController {
     
    @IBOutlet weak var webViewWrapperView: UIView!
    @IBOutlet weak var btnHome: UIButton!
    
    private var webView: WKWebView?
    public var WEB_URL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.btnHome.layer.cornerRadius = 15
        
        // Setup the webview frame and constraint to the parent view
        let config = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: config)
        
        if let webView = self.webView {
            webView.translatesAutoresizingMaskIntoConstraints = false

            webViewWrapperView.addSubview(webView)
            
            // Set constraint
            let topConstraint = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: webViewWrapperView, attribute: .top, multiplier: 1, constant: 0)

            let leadingConstraint = NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: webViewWrapperView, attribute: .leading, multiplier: 1, constant: 0)

            let trailingConstraint = NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: webViewWrapperView, attribute: .trailing, multiplier: 1, constant: 0)

            let bottomConstraint = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: webViewWrapperView, attribute: .bottom, multiplier: 1, constant: 0)

            webViewWrapperView.addConstraints([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])

            webView.isAccessibilityElement = false
            
            // Load the request into web view
            if let urlData = URL(string: WEB_URL) {
                let request = URLRequest(url: urlData)
                self.webView!.load(request)
            }

            
        }
    }
    
    // MARK: - Button events
    @IBAction func onBtnBackHome(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
