//
//  CountDownCell.swift
//  UpcomingEvents
//
//  Created by Данік on 24/07/2023.
//


import Foundation
import UIKit
import SnapKit

final class CountDownCell: UITableViewCell {
    
    static let reuseIdentifier = "CountDownCell"
    
    private let eventName = UILabel().apply {
        $0.font = UIFont(name: "Poppins-Regular", size: 17)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
    }
    
    private let countdownLabel = UILabel().apply {
        $0.font = UIFont(name: "Poppins-Regular", size: 17)
        $0.textColor = K.purple
        $0.textAlignment = .right
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.8)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func configure(withName name: String, timeLeft: String) {
        eventName.text = name
        countdownLabel.text = timeLeft
    }
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [eventName, countdownLabel])
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.spacing = 10
        return sv
    }()
    
    private func setupViews() {
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-13)
        }
    }
}
