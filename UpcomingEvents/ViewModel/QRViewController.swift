//
//  QRViewController.swift
//  UpcomingEvents
//
//  Created by Данік on 03/08/2023.
//

import Foundation
import UIKit

final class QRViewController: UIViewController {
    let imageView = UIImageView()
    
    let closeButton = UIButton().apply {
        $0.backgroundColor = .clear
        $0.tintColor = UIColor(red: 0.35, green: 0.34, blue: 0.84, alpha: 1.0)
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)

        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        view.addSubview(closeButton)

        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-20)
            make.height.width.equalTo(45)
        }
    }

    func displayQRCodeImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    @objc func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
