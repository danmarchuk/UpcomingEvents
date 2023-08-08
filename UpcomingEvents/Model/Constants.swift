//
//  Constants.swift
//  UpcomingEvents
//
//  Created by Данік on 02/08/2023.
//

import Foundation
import UIKit

struct K {
    
    static let cellSpacingHeight: CGFloat = 10
    
    static let oneWeek: TimeInterval = 7 * 24 * 60 * 60
    static let oneMonth: TimeInterval = 31 * 24 * 60 * 60
    static let oneYear: TimeInterval = 365 * 24 * 60 * 60
    
    static var weekFromNow = Date().advanced(by: TimeInterval(oneWeek))
    static var monthFormNow = Date().advanced(by: TimeInterval(oneMonth))
    static var yearFromNow = Date().advanced(by: TimeInterval(oneYear))
    
    static let purple = UIColor(red: 0.35, green: 0.34, blue: 0.84, alpha: 1.0)
}
