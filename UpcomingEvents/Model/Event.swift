//
//  Event.swift
//  UpcomingEvents
//
//  Created by Данік on 07/08/2023.
//

import Foundation
import RealmSwift

class Event: Object {
    @objc dynamic var title: String?
    @objc dynamic var startDate: Date?
    @objc dynamic var endDate: Date?
}
