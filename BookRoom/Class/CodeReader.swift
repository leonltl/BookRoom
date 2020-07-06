//
//  CodeReader.swift
//  BookRoom
//
//  The classes that capture QR code type and barcode types from the camera
//

import Foundation
import AVFoundation
import UIKit

protocol CodeReader {
    func startReading(completion: @escaping (String, String) -> Void)
    func stopReading()
    func setNeedsUpateOrientation()
    func configureDefaultComponent(cameraPosition: String)
    var videoPreview: CALayer {get}
}

class AVCodeReader: NSObject {
    private(set) var videoPreview = CALayer()
    private var captureSession: AVCaptureSession?
    private var didFindCode: ((String, String) -> Void)?
    
    let supportedBarCodes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code93, AVMetadataObject.ObjectType.upce, AVMetadataObject.ObjectType.pdf417, AVMetadataObject.ObjectType.ean13, AVMetadataObject.ObjectType.aztec]
    
    override init() {
        super.init()
        
        captureSession = AVCaptureSession()
        self.configureDefaultComponent(cameraPosition: "Back")
        
        //preview
        let captureVideoPreview = AVCaptureVideoPreviewLayer(session: captureSession!)
        captureVideoPreview.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.videoPreview = captureVideoPreview
    }
    
    func configureDefaultComponent(cameraPosition: String) {
        for output in captureSession!.outputs {
            captureSession!.removeOutput(output)
        }
        
        for input in captureSession!.inputs {
            captureSession!.removeInput(input)
        }
        
        // Add video input
        //Make sure the device can handle video
        //Determine camera front or back
        if cameraPosition == "Front" {
            if #available(iOS 10.0, *) {
                guard let videoDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: .video, position: .front),
                    let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
                        return
                }
                //input
                captureSession?.addInput(deviceInput)
            } else {
                guard let videoDevice = AVCaptureDevice.default(for: AVMediaType.video),
                    let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
                        return
                }
                
                //input
                captureSession?.addInput(deviceInput)
            }
        }
        else {
            guard let videoDevice = AVCaptureDevice.default(for: AVMediaType.video),
                let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
                    return
            }
            
            //input
            captureSession?.addInput(deviceInput)
        }
        
        //output
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        //delegate
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //interprets qr codes only
        captureMetadataOutput.metadataObjectTypes = supportedBarCodes
        
        captureSession!.commitConfiguration()
    }
    
    func setNeedsUpateOrientation() {
        // orientation
        let captureVideoPreview = self.videoPreview as! AVCaptureVideoPreviewLayer
        
        if let connection = captureVideoPreview.connection, connection.isVideoOrientationSupported {
            let application                    = UIApplication.shared
            let orientation                    = UIDevice.current.orientation
            
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            let supportedInterfaceOrientations = application.supportedInterfaceOrientations(for: window)
            
            connection.videoOrientation = self.videoOrientation(deviceOrientation: orientation, withSupportedOrientations: supportedInterfaceOrientations, fallbackOrientation: connection.videoOrientation)
        }
    }
    
    private func videoOrientation(deviceOrientation orientation: UIDeviceOrientation, withSupportedOrientations supportedOrientations: UIInterfaceOrientationMask, fallbackOrientation: AVCaptureVideoOrientation? = nil) -> AVCaptureVideoOrientation {
        
        let result: AVCaptureVideoOrientation
        
        switch (orientation, fallbackOrientation) {
        case (.landscapeLeft, _):
            result = .landscapeRight
        case (.landscapeRight, _):
            result = .landscapeLeft
        case (.portrait, _):
            result = .portrait
        case (.portraitUpsideDown, _):
            result = .portraitUpsideDown
        case (_, .some(let orientation)):
            result = orientation
        default:
            result = .portrait
        }
        
        if supportedOrientations.contains(orientationMask(videoOrientation: result)) {
            return result
        }
        else if let orientation = fallbackOrientation , supportedOrientations.contains(orientationMask(videoOrientation: orientation)) {
            return orientation
        }
        else if supportedOrientations.contains(.portrait) {
            return .portrait
        }
        else if supportedOrientations.contains(.landscapeLeft) {
            return .landscapeLeft
        }
        else if supportedOrientations.contains(.landscapeRight) {
            return .landscapeRight
        }
        else {
            return .portraitUpsideDown
        }
    }
    
    private func orientationMask(videoOrientation orientation: AVCaptureVideoOrientation) -> UIInterfaceOrientationMask {
        switch orientation {
            case .landscapeLeft:
                return .landscapeLeft
            case .landscapeRight:
                return .landscapeRight
            case .portrait:
                return .portrait
            case .portraitUpsideDown:
                return .portraitUpsideDown
        }
    }
}

extension AVCodeReader: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            return
        }
        
        guard let readableCode = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let code = readableCode.stringValue else {
                return
        }
        
        for current in metadataObjects {
            if let _readableCodeObject = current as? AVMetadataMachineReadableCodeObject {
                if _readableCodeObject.stringValue != nil {
                    if supportedBarCodes.contains(_readableCodeObject.type) {
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                        stopReading()
                        didFindCode?(code, readableCode.type.rawValue)
                    }
                }
            }
        }
    }
    
}

extension AVCodeReader: CodeReader {
    func startReading(completion: @escaping (String, String) -> Void) {
        self.didFindCode = completion
        captureSession?.startRunning()
    }
    
    func stopReading() {
        captureSession?.stopRunning()
    }
}
