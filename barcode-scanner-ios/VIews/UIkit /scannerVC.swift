//
//  scannerVC.swift
//  barcode-scanner-ios
//
//  Created by Aryan Kaushik on 13/11/23.
//

import UIKit
import AVFoundation
// This file is a uiviewcontroller we will need a cooridnator to connect to swiftuiview
enum CameraError : String {
    case invalidDeviceInput = "Something is wrong with the camera. Please check permissions unable to capture the input"
    case invalidScannedValue = "The value Scanned is not valid this app only scans ean-8 and ean-13"
    
}


protocol ScannerVCDelegate : AnyObject { // anyObject same as class (but class is depricated )
    func didFindBarCode(barcode:String)
    func didSurface(error :CameraError )
}

final class ScannerVC : UIViewController{
    
    let caputureSession = AVCaptureSession() // for camera
    var previewLayer: AVCaptureVideoPreviewLayer? // for preview of camera
    weak var scannerDelegate :ScannerVCDelegate?
    
    init(scannerDelegate:ScannerVCDelegate){
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let previewLayer = previewLayer else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    
    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        let videoInput : AVCaptureDeviceInput
        
        do{
            try videoInput = AVCaptureDeviceInput(device : videoCaptureDevice)
        } catch {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        if caputureSession.canAddInput(videoInput) {
            caputureSession.addInput(videoInput)
        }else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)

            return
        }
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if caputureSession.canAddOutput(metaDataOutput) {
            caputureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8 ,.ean13] // these types of outputse
        }else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)

            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: caputureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        caputureSession.startRunning()
    }
}


extension ScannerVC : AVCaptureMetadataOutputObjectsDelegate{
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)

            return
        }
        guard let barcode = machineReadableObject.stringValue else {
            scannerDelegate?.didSurface(error: .invalidScannedValue)

            return
        }
        
        scannerDelegate?.didFindBarCode(barcode:barcode)
        
    }
}
