//
//  InputTaskVC.swift
//  Tasks
//
//  Created by mac on 17.04.22.
//

import UIKit

class InputTaskVC: UIViewController {
    
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var taskField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    var piker = UIDatePicker()
    var toolBar = UIToolbar()
    var selectedDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskField.delegate = self
        dateField.delegate = self
        navigationController?.navigationBar.tintColor = .white
        taskField.textColor = .black
        dateField.textColor = .black
        titleLabel.layer.cornerRadius = 20
        taskField.layer.borderWidth = 0.5
        dateField.layer.borderWidth = 0.5
        taskField.layer.cornerRadius = 10
        dateField.layer.cornerRadius = 10
        
        taskView.layer.cornerRadius = taskView.frame.height / 2
        
        dateField.inputView = piker
        piker.datePickerMode = .dateAndTime
        piker.locale = Locale(identifier: "ru_RU")
        piker.preferredDatePickerStyle = .wheels
        piker.addTarget(self, action: #selector(dateDidPiked), for: .allEvents)
        
        toolBar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolBar.setItems([spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        dateField.inputAccessoryView = toolBar

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dateDidPiked() {
        self.selectedDate = piker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateField.text = formatter.string(from: piker.date)
    }
    
    @IBAction func saveTask(_ sender: Any) {
        
        if taskField.text == "" || dateField.text == "" {
            let alert = UIAlertController.init(title: "????????????????!", message: "???????? ???? ?????????? ???????? ??????????????!", preferredStyle: .alert)
            let alertOk = UIAlertAction(title: "????", style: .cancel)
            alert.addAction(alertOk)
            present(alert, animated: true)
        } else {
            let saveTask = Task()
            saveTask.task = taskField.text ?? ""
            saveTask.time = selectedDate
            RealmManager.save(object: saveTask)
            NotificationManager.requestAutorezation(task: saveTask.task, date: saveTask.time!)
            
            taskField.text = ""
            dateField.text = ""
            dismissKeyboard()
        }
    }
    @IBAction func tableTask(_ sender: Any) {
        let taskVC = TableTasksVC.self(nibName: String(describing: TableTasksVC.self), bundle: nil)
        taskVC.modalTransitionStyle = .flipHorizontal
        present(taskVC, animated: true)
    }
}
extension InputTaskVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dateField.becomeFirstResponder()
    }
}
