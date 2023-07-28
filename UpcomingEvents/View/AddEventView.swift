//
//  AddEventView.swift
//  UpcomingEvents
//
//  Created by Данік on 27/07/2023.
//

import Foundation
import UIKit
import SnapKit

@IBDesignable
class AddEventView: UIView {
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let titleLabel = UILabel().apply {
        $0.text = "New Event"
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let cancelButton = UIButton().apply {
        $0.setTitle("Cancel", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.systemGray2, for: .disabled)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let addButton = UIButton().apply {
        $0.setTitle("Add", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.systemGray2, for: .disabled)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var lefBarButtonItem =  UIBarButtonItem(customView: cancelButton)
    lazy var rightBarButtonItem =  UIBarButtonItem(customView: addButton)
    
    let rectangleView = UIView().apply {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 13
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowRadius = 20
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    let stackView = UIStackView().apply {
        $0.axis = .vertical
        $0.spacing = 15
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let titleTextField = UITextField().apply {
        $0.placeholder = "Title"
        $0.borderStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let grayView = UIView().apply {
        $0.backgroundColor = .separator
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    let notesTextField = UITextField().apply {
        $0.placeholder = "Notes"
        $0.borderStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupView() {
        let navigationItem = UINavigationItem().apply {
            $0.titleView = titleLabel
            $0.leftBarButtonItem = lefBarButtonItem
            $0.rightBarButtonItem = rightBarButtonItem
        }
        
        let navBar = UINavigationBar().apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setItems([navigationItem], animated: false)
        }
        
        self.backgroundColor = .white
        self.addSubview(navBar)
        addSubview(rectangleView)
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(grayView)
        stackView.addArrangedSubview(notesTextField)
        
        rectangleView.addSubview(stackView)
        
        navBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        rectangleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(navBar.snp.bottom).offset(40)
            make.height.equalTo(150)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        grayView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(titleTextField.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(16)
        }
        
        notesTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(grayView.snp.bottom).offset(15)
            make.right.equalToSuperview().inset(16)
        }
    }
}
