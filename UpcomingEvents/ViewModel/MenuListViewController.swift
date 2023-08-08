//
//  MenuListViewController.swift
//  UpcomingEvents
//
//  Created by Данік on 05/08/2023.
//

import Foundation
import UIKit
import AVFoundation
import RealmSwift

final class MenuListViewController: UITableViewController {
    let items = ["Scan QR", "Shared Events"]
    static let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            checkCameraPermission { [weak self] granted in
                if granted {
                    self?.presentQRScanner()
                }
            }
            
        case 1:
            let sharedEventsVC = SharedEventsViewController()
            let navController = UINavigationController(rootViewController: sharedEventsVC)
            navController.modalPresentationStyle = .popover
            present(navController, animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false)
        }
    }
    
    
    func presentQRScanner() {
        let qrScannerVC = QRScannerViewController()
        qrScannerVC.onQRCodeDetected = { [weak self] qrValue in
            if let event = FuncManager.createEvent(from: qrValue) {
                FuncManager.saveEvent(event)
            }
        }
        let navController = UINavigationController(rootViewController: qrScannerVC)
        navController.modalPresentationStyle = .popover
        present(navController, animated: true)
    }
}

