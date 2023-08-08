//
//  AddEventViewModel.swift
//  UpcomingEvents
//
//  Created by Данік on 27/07/2023.
//

import Foundation
import UIKit

protocol AddEventDelegate {
    func didAddANewEvent (_ addEventViewModel: AddEventViewModel, eventName: String, eventNotes: String)
}

final class AddEventViewModel: UIViewController {
    let addEventView = AddEventView()
    var delegate: AddEventDelegate?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addDissapearingMessage()
    }
    
    private func addTargetsToTheButtons() {
        addEventView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        addEventView.addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        guard let titleString = addEventView.titleTextField.text else {
            return
        }
        let notesString = addEventView.notesTextField.text ?? ""
        delegate?.didAddANewEvent(self, eventName: titleString, eventNotes: notesString)
        dismiss(animated: true, completion: nil)
    }
    
    func addDissapearingMessage() {
        let alert = UIAlertController(title: nil, message: "Type more than 5 characters to create an Event", preferredStyle: .alert)

        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okayAction)
        
        self.present(alert, animated: true)
    }
}

extension AddEventViewModel: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == addEventView.titleTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {return false}
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            addEventView.addButton.isEnabled = updatedText.count >= 5
        }
        return true
    }
}
