//
//  EditViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/10/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var courseNumberTextField: UITextField!
    @IBOutlet weak var priorityLevelTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var updateToolbar: UIToolbar!
    var toolbar: UIToolbar?
    var departmentPicker: UIPickerView?
    var priorityPicker: UIPickerView?
    var departmentData = [String]()
    var priorityData = [String]()
    var dueDateRef: DocumentReference?
    var dueDateListener: ListenerRegistration!
    var dueDate : DueDate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolbar = UIToolbar()
        self.toolbar!.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.toolbar!.setItems([spaceButton,doneButton], animated: false)
        
        self.departmentPicker = UIPickerView()
        self.departmentPicker?.delegate = self
        self.departmentPicker?.dataSource = self
        
        self.priorityPicker = UIPickerView()
        self.priorityPicker?.delegate = self
        self.priorityPicker?.dataSource = self
        
        self.departmentData = ["ANTHS","ARTSH","BE", "BIO", "CHE", "CHEM", "CE", "CSSE", "ECE","ECONS","EM","EMGT","ENGD","ENGLH","EP", "ES","GEOGS","GERL","HISTH","HUMH","JAPNL","MA","ME","OE","PH","PHILH","POLSS","PSYCS","RELGH","RH","SPANL"]
        self.priorityData = ["None","!!!", "!!", "!"]
        overrideUserInterfaceStyle = .light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dueDateListener = self.dueDateRef?.addSnapshotListener({ (documentSnapshot, error) in
            if let error = error {
                print("Error getting the document: \(error)")
                return
            }
            if !documentSnapshot!.exists {
                print("This document got deleted by someone else")
                return
            }
            
            self.dueDate = DueDate(document: documentSnapshot!)
            let data = self.dueDate?.getData()
            self.nameTextField.text = (data!["name"] as! String)
            self.departmentTextField.text = (data!["department"] as! String)
            self.courseNumberTextField.text = "\(self.dueDate!.courseNumber!)"
            var priorityLevel = ""
            for _ in 0..<self.dueDate!.priorityLevel {
                priorityLevel += "!"
            }
            self.priorityLevelTextField.text = priorityLevel == "" ? "None" : priorityLevel
            self.dueDateTextField.text = self.formatDateForDisplay(date: (self.dueDate?.dueDate.dateValue())!)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dueDateListener.remove()
    }
    
    @IBAction func courseNumberDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = toolbar
    }
    @IBAction func nameDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = toolbar
    }
    @IBAction func priorityLevelDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = toolbar
        textField.inputView = self.priorityPicker
    }
    
    @IBAction func departmentDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = toolbar
        textField.inputView = self.departmentPicker
    }
    
    @IBAction func dueDateDidBeginEditing(_ textField: UITextField) {
        // Create a date picker for the date field.
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        datePicker.date = self.dueDate!.dueDate.dateValue()
        
        // add toolbar to textField
        textField.inputAccessoryView = toolbar
        
        datePicker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)
        textField.inputView = datePicker
        textField.text = formatDateForDisplay(date: datePicker.date)
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.departmentPicker{
            return self.departmentData.count
        } else {
            return self.priorityData.count
        }
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.departmentPicker{
            return self.departmentData[row]
        } else if pickerView == self.priorityPicker {
            return self.priorityData[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.departmentPicker {
            self.departmentTextField.text = self.departmentData[row]
        } else if pickerView == self.priorityPicker {
            self.priorityLevelTextField.text = self.priorityData[row]
        }
    }
    
    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }

    @objc func donedatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func updateDateField(sender: UIDatePicker) {
        self.dueDateTextField?.text = formatDateForDisplay(date: sender.date)
        self.dueDate?.dueDate = self.getTimestamp(dueDate: (self.dueDateTextField?.text)!)
    }
    
    func countChar(text: String, character: Character) -> Int {
        var count = 0
        for char in text {
            if char == character {
                count += 1
            }
        }
        return count
    }
    
    func getTimestamp(dueDate: String) -> Timestamp {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy"
        let date = inputFormatter.date(from: dueDate) ?? Date()
        return Timestamp(date: date)
    }
    @IBAction func pressedUpdate(_ sender: Any) {
        let priorityLevel = self.countChar(text: self.priorityLevelTextField.text!, character: "!")
        let dueDate = self.getTimestamp(dueDate: self.dueDateTextField.text!)
        let newDueDate = DueDate(name: self.nameTextField.text!, department: self.departmentTextField.text!, courseNumber: self.courseNumberTextField.text!, priorityLevel: priorityLevel, dueDate: dueDate)
        self.dueDateRef!.setData(newDueDate.getData() as [String : Any])
        self.navigationController?.popViewController(animated: true)
    }
}
