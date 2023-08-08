//
//  QRScannerViewController.swift
//  UpcomingEvents
//
//  Created by Данік on 05/08/2023.
//

import Foundation
import UIKit
import AVFoundation

final class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var onQRCodeDetected: ((String) -> Void)?
    private var hasDetectedQRCode = false
    
    var closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: ViewController.self, action: #selector(closeButtonTapped))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        startScanning()
    }

    func setupNavigationBar() {
        closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        closeButton.tintColor = K.purple
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard !hasDetectedQRCode,
              let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue else {
            return
        }
        
        hasDetectedQRCode = true
        onQRCodeDetected?(stringValue)
        dismiss(animated: true)
    }

    private func startScanning() {
        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }

        let captureSession = AVCaptureSession()
        captureSession.addInput(captureDeviceInput)

        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(metadataOutput)

        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr] // You can add other types of codes if you want.

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
}
