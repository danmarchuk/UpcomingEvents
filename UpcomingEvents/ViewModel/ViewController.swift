//
//  ViewController.swift
//  UpcomingEvents
//
//  Created by Данік on 24/07/2023.
//

import UIKit
import EventKit
import EventKitUI
import SnapKit
import SideMenu

final class ViewController: UIViewController {
    // MARK: - Properties
    
    private let eventStore = EKEventStore()
    private var lastSelectedButton: UIButton?
    private var chosenRange: [EKEvent]?
    private var chosenDate: Date?
    private var eventsForTheWeek: [EKEvent]?
    private var eventsForTheMonth: [EKEvent]?
    private var eventsForTheYear: [EKEvent]?

    private let mainView = MainView()
    private let addEventViewModel = AddEventViewModel()
    private var menu: SideMenuNavigationController?
    
    // MARK: - UI Components
    
    private var menuButton: UIBarButtonItem!
    private var plusButton: UIBarButtonItem!
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.isHidden = true
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .inline
        }
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.allowsSelection = true
        tableView.register(CountDownCell.self, forCellReuseIdentifier: CountDownCell.reuseIdentifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
        view.backgroundColor = .white
        view.addSubview(datePicker)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    // MARK: - Setup
    
    func initialSetup() {
        addTableView()
        addTargetsToTheButtons()
        addEventViewModel.delegate = self
        setupNavigationBar()
        setupSideMenu()
        tapTheWeekButton()
    }
    
    func tapTheWeekButton() {
        requestAcess { [weak self] success in
            if success {
                self?.buttonTapped(self?.mainView.weekButton ?? UIButton())
                self?.tableView.reloadData()
            }
        }
    }
    
    func setupSideMenu() {
        menu = SideMenuNavigationController(rootViewController: MenuListViewController())
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    func setupNavigationBar() {
        menuButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(menuButtonTapped))
        plusButton = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: #selector(plusButtonTapped))
        
        menuButton.tintColor = K.purple
        plusButton.tintColor = K.purple
        
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.titleView = mainView.myEventsLabel
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        // Handle the date change here
        chosenDate = sender.date
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Handle the button tap here
        lastSelectedButton?.isSelected = false
        sender.isSelected = true
        lastSelectedButton = sender

        if sender == mainView.weekButton {
            weekButtonTapped()
        } else if sender == mainView.monthButton {
            monthButtonTapped()
        } else if sender == mainView.yearButton {
            yearButtonTapped()
        } else if sender == mainView.customButton {
            customButtonTapped()
        }

        tableView.reloadData()
    }
    
    private func weekButtonTapped() {
        chosenRange = eventsForTheWeek
        let dateRangeString = FuncManager.formattedDateRangeString(endDate: K.weekFromNow)
        mainView.dateRangeLabel.text = dateRangeString
        hideTheDatePicker()
    }
    
    private func monthButtonTapped() {
        chosenRange = eventsForTheMonth
        let dateRangeString = FuncManager.formattedDateRangeString(endDate: K.monthFormNow)
        mainView.dateRangeLabel.text = dateRangeString
        hideTheDatePicker()
    }
    
    private func yearButtonTapped() {
        chosenRange = eventsForTheYear
        let dateRangeString = FuncManager.formattedDateRangeString(endDate: K.yearFromNow)
        mainView.dateRangeLabel.text = dateRangeString
        hideTheDatePicker()
    }
    
    private func customButtonTapped() {
        showDatePicker()
    }
    
    @objc func menuButtonTapped(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    
    @objc func plusButtonTapped(_ sender: UIBarButtonItem) {
        let addEventViewModel = AddEventViewModel()
        addEventViewModel.delegate = self
        addEventViewModel.modalPresentationStyle = .popover
        self.present(addEventViewModel, animated: true)
    }
    
    private func addTargetsToTheButtons() {
        mainView.weekButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        mainView.monthButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        mainView.yearButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        mainView.customButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    func requestAcess(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    let weekPredicate = self.eventStore.predicateForEvents(withStart: Date(), end: K.weekFromNow, calendars: nil)
                    let monthPredicate = self.eventStore.predicateForEvents(withStart: Date(), end: K.monthFormNow, calendars: nil)
                    let yearPredicate = self.eventStore.predicateForEvents(withStart: Date(), end: K.yearFromNow, calendars: nil)
                    
                    self.eventsForTheWeek = self.eventStore.events(matching: weekPredicate)
                    self.eventsForTheMonth = self.eventStore.events(matching: monthPredicate)
                    self.eventsForTheYear = self.eventStore.events(matching: yearPredicate)
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        chosenRange?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        K.cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: CountDownCell.reuseIdentifier, for: indexPath) as? CountDownCell else {return UITableViewCell()}
        if let chosenEvents = chosenRange {
            cell.configure(withName: chosenEvents[indexPath.section].title, timeLeft: FuncManager.calculateTimeToTheEvent(now: Date(), eventStarts: chosenEvents[indexPath.section].startDate))
        }
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let chosenEvents = chosenRange {
            let selectedEvent = chosenEvents[indexPath.section]
            guard let startDate = selectedEvent.startDate,
                  let endDate = selectedEvent.endDate,
                  let title = selectedEvent.title else {return}
            
            let alertController = UIAlertController(title: "Share the event",
                                                    message: "Share the event using QR code or simply send it using SMS or any other messenger",
                                                    preferredStyle: .alert)
            
            let qrAction = UIAlertAction(title: "Show QR", style: .default) { (action) in
                let image = FuncManager.generateQrCode(from: title, startDate: startDate, endDate: endDate)
                let qrVc = QRViewController()
                qrVc.modalPresentationStyle = .popover
                qrVc.displayQRCodeImage(image)
                self.present(qrVc, animated: true)
            }
            
            alertController.addAction(qrAction)
            
            let shareAction = UIAlertAction(title: "Share", style: .default) { (action) in
                let message = "I would like to invite you to my event \(title), it starts at \(startDate) and ends at \(endDate). Don't be late! :-)"
                let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }
            
            alertController.addAction(shareAction)
            
            let okAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - AddEventDelegate
extension ViewController: AddEventDelegate {
    func didAddANewEvent(_ addEventViewModel: AddEventViewModel, eventName: String, eventNotes: String) {
        eventStore.requestAccess(to: .event) { [weak self] success, error in
            if success, error == nil {
                DispatchQueue.main.async {
                    guard let store = self?.eventStore else {return}
                    
                    let newEvent = EKEvent(eventStore: store)
                    let startDate = self?.chosenDate ?? Date()
                    newEvent.title = eventName
                    newEvent.notes = eventNotes
                    newEvent.startDate = startDate
                    newEvent.endDate = startDate.addingTimeInterval(3600)
                    newEvent.calendar = self?.eventStore.defaultCalendarForNewEvents
                    do {
                        try store.save(newEvent, span: .thisEvent, commit: true)
                        // "refresh" the event store when the new event was added
                        self?.requestAcess {(success) in
                            if success {
                            }
                            else {}
                        }
                        self?.tableView.reloadData()
                    } catch{
                        
                    }
                }
            }
        }
    }
}

// MARK: - Constraints
extension ViewController {
    
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
}
