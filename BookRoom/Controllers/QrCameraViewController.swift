//
//  QrCameraViewController.swift
//  BookRoom
//
//  The controller class that is attached to Read QR Scene in Storyboard
//  It is to display the camera and able to read the QR Code
//  It will go to Book Successfully Scene when it read the QR code
//

import UIKit
import AVFoundation
import Network

class QrCameraViewController: UIViewController {

    @IBOutlet weak var videoPreview: UIView!
    private var videoLayer: CALayer!
    private var codeReader: CodeReader!
    private var cameraPosition = "Back"
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.codeReader = AVCodeReader()
        self.videoLayer = codeReader.videoPreview
        self.videoPreview.layer.addSublayer(videoLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setNeedsUpdateOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        self.setAccessibilityIdentifiers()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.videoLayer.frame = videoPreview.bounds
    
        self.codeReader.setNeedsUpateOrientation()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.readQRCode()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.codeReader.stopReading()
    }
    
    // MARK: - private function
    private func setAccessibilityIdentifiers() {
        self.view.accessibilityIdentifier = "QrCamera"
    }
    
    private func readQRCode() {
        self.codeReader.configureDefaultComponent(cameraPosition: self.cameraPosition)
        self.codeReader.startReading { [weak self] (code, type) in
            
            if let url = URL(string: code) {
                self?.performSegue(withIdentifier: "segueWebView", sender: url.absoluteString)
            }
        }
    }
        
    // MARK: - Event functions
    @objc func setNeedsUpdateOrientation() {
        self.view.setNeedsDisplay()
        self.codeReader.setNeedsUpateOrientation()
    }
    
    
    // MARK: - Segue Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueWebView") {
            let vc = segue.destination as! BookSuccessViewController
            vc.WEB_URL = sender as! String
        }
    }


}
