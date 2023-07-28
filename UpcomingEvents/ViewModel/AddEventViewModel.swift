//
//  AddEventViewModel.swift
//  UpcomingEvents
//
//  Created by Данік on 27/07/2023.
//

import Foundation
import UIKit

class AddEventViewModel: UIViewController {
    let addEventView = AddEventView()
    
    override func loadView() {
        view = addEventView

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addEventView.notesTextField.delegate = self
        addEventView.titleTextField.delegate = self
        addEventView.addButton.isEnabled = false
        addTargetsToTheButtons()
    }
    
    private func addTargetsToTheButtons() {
        addEventView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        addEventView.addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        
    }
}

extension AddEventViewModel: UITextFieldDelegate {
    
}
