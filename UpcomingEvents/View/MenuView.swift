//
//  MenuView.swift
//  UpcomingEvents
//
//  Created by Данік on 02/08/2023.
//

import Foundation
import UIKit
import SnapKit

final class MenuView: UIView {
    
    let scanQrButton = FuncManager.createButton(with: "Scan Qr")
    
    let sharedEventsButton = FuncManager.createButton(with: "Shared Events")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .white

        scanQrButton.setTitle("Scan QR", for: .normal)
        sharedEventsButton.setTitle("Shared Events", for: .normal)

        let stackView = UIStackView(arrangedSubviews: [scanQrButton, sharedEventsButton])
        stackView.axis = .vertical
        stackView.spacing = 10

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
