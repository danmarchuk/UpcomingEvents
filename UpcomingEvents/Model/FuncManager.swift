//
//  FuncManager.swift
//  UpcomingEvents
//
//  Created by Данік on 02/08/2023.
//

import Foundation
import UIKit

struct FuncManager {
    static func calculateTimeToTheEvent(now: Date, eventStarts: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: now, to: eventStarts)
        
        guard let days = components.day, let hours = components.hour, let minutes = components.minute else {
            return "Time calculation error"
        }
        
        if days >= 5 {
            return "\(days) days"
        } else if days < 5 && days >= 2 {
            return "\(days) days \(hours % 24) hours"
        } else if days < 2 {
            return "\(hours) h \(minutes % 60) m"
        } else if minutes < 1 {
            return "less than a minute"
        }
        
        return "Time calculation error"
    }
    
    static func createButton(with title: String) -> UIButton {
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
    
    static func generateQrCode(from title: String, startDate: Date, endDate: Date) -> UIImage? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let start = dateFormatter.string(from: startDate)
        let end = dateFormatter.string(from: endDate)
        
        let eventString = "Title: \(title), Start: \(start), End: \(end)"
        
        let data = eventString.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform),
               let cgImage = CIContext().createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
    
    static func createEvent(from qrValue: String) -> Event? {
        let components = qrValue.components(separatedBy: ", ")
        guard components.count == 3 else {return nil}
        
        let titleComponents = components[0].components(separatedBy: ": ")
        let startComponents = components[1].components(separatedBy: ": ")
        let endComponents = components[2].components(separatedBy: ": ")
        
        guard titleComponents.count == 2,
              startComponents.count == 2,
              endComponents.count == 2 else {return nil}
        
        let title = titleComponents[1]
        let startDate = getDate(from: startComponents[1])
        let endDate = getDate(from: endComponents[1])
        
        let event = Event()
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        
        return event
    }
    
    static func getDate(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: string)
    }
    
    static func saveEvent(_ event: Event) {
        do {
            try MenuListViewController.realm.write {
                MenuListViewController.realm.add(event)
            }
        } catch {
            fatalError("\(error)")
        }
    }
    
    static func formattedDateRangeString(endDate: Date) -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, d"
        dateFormatter.locale = Locale(identifier: "en_US")
        let monthAndDayString = dateFormatter.string(from: date).capitalized

        let secondDateFormatter = DateFormatter()
        secondDateFormatter.dateFormat = "MMMM d, yyyy"
        secondDateFormatter.locale = Locale(identifier: "en_US")
        let secondDateString = secondDateFormatter.string(from: endDate).capitalized

        return "\(monthAndDayString) - \(secondDateString)"
    }
    
}
