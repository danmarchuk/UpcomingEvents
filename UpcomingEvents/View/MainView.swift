//
//  MainView.swift
//  UpcomingEvents
//
//  Created by Данік on 24/07/2023.
//

import Foundation
import UIKit
import SnapKit

@IBDesignable
final class MainView: UIView {
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let myEventsLabel = UILabel().apply {
        $0.text = "My Events"
        $0.font = UIFont(name: "Poppins-Medium", size: 34)
        $0.textColor = .black
    }
    
    let weekButton = FuncManager.createButton(with: "Week")
    let monthButton = FuncManager.createButton(with: "Month")
    let yearButton = FuncManager.createButton(with: "Year")
    let customButton = FuncManager.createButton(with: "Custom")
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weekButton, monthButton, yearButton, customButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    let dateRangeLabel = UILabel().apply {
        $0.font = UIFont(name: "Poppins-Bold", size: 20)
        $0.text =  "May 31 - Jun 6, 2021"
    }
    
    func setupView() {
        // add subviews
        addSubview(buttonStackView)
        addSubview(dateRangeLabel)
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        dateRangeLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(16)
            make.left.equalTo(buttonStackView.snp.left)
        }
    }
}
