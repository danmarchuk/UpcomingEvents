//
//  SharedEventsViewController.swift
//  UpcomingEvents
//
//  Created by Данік on 07/08/2023.
//

import Foundation
import UIKit
import RealmSwift

final class SharedEventsViewController: UITableViewController {
    
    let events = MenuListViewController.realm.objects(Event.self)
    var closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: ViewController.self, action: #selector(closeButtonTapped))

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CountDownCell.self, forCellReuseIdentifier: CountDownCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.allowsSelection = true
        tableView.isUserInteractionEnabled = true
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        closeButton.tintColor = K.purple
        navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        events.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        K.cellSpacingHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: CountDownCell.reuseIdentifier, for: indexPath) as? CountDownCell else {return UITableViewCell()}
        if let title = events[indexPath.section].title,
           let startDate = events[indexPath.section].startDate {
            cell.configure(withName: title, timeLeft: FuncManager.calculateTimeToTheEvent(now: Date(), eventStarts: startDate))
        }
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        cell.selectionStyle = .default
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
