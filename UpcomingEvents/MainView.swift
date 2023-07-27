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
class MainView: UIView {
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let menuButton = UIButton().apply {
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "menu"), for: .normal)
    }
    
    let myEventsLabel = UILabel().apply {
        $0.text = "My Events"
        $0.font = UIFont(name: "Poppins-Medium", size: 34)
        $0.textColor = .black
    }
    
    let plusButton = UIButton().apply {
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "plus"), for: .normal)
    }
    
    lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [menuButton, myEventsLabel, plusButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let weekButton = createButton(with: "Week")
    let monthButton = createButton(with: "Month")
    let yearButton = createButton(with: "Year")
    let customButton = createButton(with: "Custom")
    
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
    
    private static func createButton(with title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 16)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.setBackgroundImage(UIImage(color: UIColor(red: 0.46, green: 0.46, blue: 0.5, alpha: 0.12)), for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor(red: 0.35, green: 0.34, blue: 0.84, alpha: 1.0)), for: .selected)
        button.layer.cornerRadius = 13
        button.tintColor = .clear
        button.clipsToBounds = true
        button.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        return button
    }
    
    func setupView() {
        // add subviews
        addSubview(headerStackView)
        addSubview(buttonStackView)
        addSubview(dateRangeLabel)
        
        // layout with SnapKit
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        dateRangeLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(16)
            make.left.equalTo(buttonStackView.snp.left)
        }
        
        
    }
}
