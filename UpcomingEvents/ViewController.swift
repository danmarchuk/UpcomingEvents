//
//  ViewController.swift
//  UpcomingEvents
//
//  Created by Данік on 24/07/2023.
//

import UIKit
import EventKit
import SnapKit

class ViewController: UIViewController {
    
    let mainView = MainView()
    var lastSelectedButton: UIButton?
    let eventStore = EKEventStore()
    var chosenRange: [EKEvent]?
    var eventsForTheWeek: [EKEvent]?
    var eventsForTheMonth: [EKEvent]?
    var eventsForTheYear: [EKEvent]?
    
    let cellSpacingHeight: CGFloat = 10
    
    let oneWeek: TimeInterval = 7 * 24 * 60 * 60
    let oneMonth: TimeInterval = 31 * 24 * 60 * 60
    let oneYear: TimeInterval = 365 * 24 * 60 * 60
    
    lazy var weekFromNow = Date().advanced(by: TimeInterval(oneWeek))
    lazy var monthFormNow = Date().advanced(by: TimeInterval(oneMonth))
    lazy var yearFromNow = Date().advanced(by: TimeInterval(oneYear))
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.register(CountDownCell.self, forCellReuseIdentifier: CountDownCell.reuseIdentifier)
        return tableView
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.isHidden = true
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .inline
        }
        return picker
    }()
    
    override func loadView() {
        view = mainView
        view.backgroundColor = .white
        view.addSubview(datePicker)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addTableView()
        requestAcess()
        addTargetsToTheButtons()
    }
    
    func showDatePicker() {
        datePicker.snp.remakeConstraints { make in
            make.left.equalTo(mainView.buttonStackView.snp.left)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mainView.buttonStackView.snp.bottom).offset(20)
        }
        
        datePicker.isHidden = false
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        mainView.dateRangeLabel.snp.remakeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.left.equalTo(mainView.buttonStackView.snp.left)
        }
        
        tableView.snp.remakeConstraints { make in
            make.left.equalTo(mainView.buttonStackView.snp.left)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mainView.dateRangeLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }

    func addTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalTo(mainView.dateRangeLabel.snp.left)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(mainView.dateRangeLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }

    
    @objc func dateChanged(_ sender: UIDatePicker) {
        // Handle the date change here
        
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Handle the button tap here
        lastSelectedButton?.isSelected = false
        sender.isSelected = true
        lastSelectedButton = sender
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, d"
        dateFormatter.locale = Locale(identifier: "en_US")
        let secondDateFormatter = DateFormatter()
        secondDateFormatter.dateFormat = "MMMM d, yyyy"
        secondDateFormatter.locale = Locale(identifier: "en_US")
        let monthAndDayString = dateFormatter.string(from: date).capitalized
        
        if sender == mainView.weekButton {
            chosenRange = eventsForTheWeek
            let secondDateString = secondDateFormatter.string(from: weekFromNow).capitalized
            mainView.dateRangeLabel.text = "\(monthAndDayString) - \(secondDateString)"
            hideTheDatePicker()
        } else if sender == mainView.monthButton {
            chosenRange = eventsForTheMonth
            let secondDateString = secondDateFormatter.string(from: monthFormNow).capitalized
            mainView.dateRangeLabel.text = "\(monthAndDayString) - \(secondDateString)"
            hideTheDatePicker()
        } else if sender == mainView.yearButton {
            chosenRange = eventsForTheYear
            let secondDateString = secondDateFormatter.string(from: yearFromNow).capitalized
            mainView.dateRangeLabel.text = "\(monthAndDayString) - \(secondDateString)"
            hideTheDatePicker()
        } else if sender == mainView.customButton {
            showDatePicker()
        }
        
        tableView.reloadData()
    }
    
    @objc func plusButtonTapped(_ sender: UIButton) {
        let addEventViewModel = AddEventViewModel()
        addEventViewModel.modalPresentationStyle = .popover
        self.present(addEventViewModel, animated: true)
    }
    
    func hideTheDatePicker() {
        if !datePicker.isHidden {
            datePicker.isHidden = true
            mainView.dateRangeLabel.snp.remakeConstraints { make in
                make.top.equalTo(mainView.buttonStackView.snp.bottom).offset(20)
                make.left.equalTo(mainView.buttonStackView.snp.left)
            }
            
            tableView.snp.remakeConstraints { make in
                make.left.equalTo(mainView.dateRangeLabel.snp.left)
                make.right.equalToSuperview().offset(-16)
                make.top.equalTo(mainView.dateRangeLabel.snp.bottom).offset(20)
                make.bottom.equalToSuperview()
            }
        }
    }
    
    private func addTargetsToTheButtons() {
        mainView.weekButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        mainView.monthButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        mainView.yearButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        mainView.customButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        mainView.plusButton.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
    }
    
    func requestAcess() {
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    let weekPredicate = self.eventStore.predicateForEvents(withStart: Date(), end: self.weekFromNow, calendars: nil)
                    let monthPredicate = self.eventStore.predicateForEvents(withStart: Date(), end: self.monthFormNow, calendars: nil)
                    let yearPredicate = self.eventStore.predicateForEvents(withStart: Date(), end: self.yearFromNow, calendars: nil)
                    
                    self.eventsForTheWeek = self.eventStore.events(matching: weekPredicate)
                    self.eventsForTheMonth = self.eventStore.events(matching: monthPredicate)
                    self.eventsForTheYear = self.eventStore.events(matching: yearPredicate)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func calculateTimeToTheEvent(now: Date, eventStarts: Date) -> String {
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
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        chosenRange?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: CountDownCell.reuseIdentifier, for: indexPath) as? CountDownCell else {return UITableViewCell()}
        if let chosenEvents = chosenRange {
            cell.configure(withName: chosenEvents[indexPath.section].title, timeLeft: calculateTimeToTheEvent(now: Date(), eventStarts: chosenEvents[indexPath.section].startDate))
        }
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
