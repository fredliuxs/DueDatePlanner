//
//  CreateViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/6/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit
import Firebase

class CreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var courseNumberTextField: UITextField!
    @IBOutlet weak var priorityLevelTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var createToolbar: UIToolbar!
    var toolbar: UIToolbar?
    var departmentPicker: UIPickerView?
    var priorityPicker: UIPickerView?
    var courseNumberPicker: UIPickerView?
    var departmentData = [[String]]()
    var priorityData = [[String]]()
    var courseNumberData = [[Character]]()
    var dueDatesRef: CollectionReference?
    var date: Date?
    
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
        
        self.courseNumberPicker = UIPickerView()
        self.courseNumberPicker?.delegate = self
        self.courseNumberPicker?.dataSource = self
        
        self.departmentData = [["ANTHS","ARTSH","BE", "BIO", "CHE", "CHEM", "CE", "CSSE", "ECE","ECONS","EM","EMGT","ENGD","ENGLH","EP", "ES","GEOGS","GERL","HISTH","HUMH","JAPNL","MA","ME","OE","PH","PHILH","POLSS","PSYCS","RELGH","RH","SPANL"]]
        self.priorityData = [["None","!!!", "!!", "!"]]
        self.courseNumberData = [["1","2","3","4","5","6","7","8","9"],
                                 ["0","1","2","3","4","5","6","7","8","9"],
                                 ["0","1","2","3","4","5","6","7","8","9"]] as [[Character]]
        
        self.departmentTextField.text = "ANTHS"
        self.priorityLevelTextField.text = "None"
        self.courseNumberTextField.text = "100"
        
        self.date = Date()
        self.dueDateTextField.text = self.formatDateForDisplay(date: self.date!)
        self.createToolbar.isHidden = true
        
        self.dueDatesRef = Firestore.firestore().collection("dueDates")
        overrideUserInterfaceStyle = .light

    }
    
    @IBAction func nameDidBeginEditing(_ textfield: UITextField) {
        textfield.inputAccessoryView = toolbar
    }
    
    @IBAction func courseNumberDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = toolbar
        textField.inputView = self.courseNumberPicker
    }
    
    @IBAction func priorityDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = toolbar
        textField.inputView = self.priorityPicker
    }
    
    @IBAction func departmentDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = toolbar
        textField.inputView = self.departmentPicker
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.departmentPicker{
            return self.departmentData.count
        } else if pickerView == self.priorityPicker {
            return self.priorityData.count
        } else if pickerView == self.courseNumberPicker {
            return self.courseNumberData.count
        }
        return 0
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.departmentPicker{
            return self.departmentData[component].count
        } else if pickerView == self.priorityPicker {
            return self.priorityData[component].count
        } else if pickerView == self.courseNumberPicker {
            return self.courseNumberData[component].count
        }
        return 0
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.departmentPicker{
            return self.departmentData[component][row]
        } else if pickerView == self.priorityPicker {
            return self.priorityData[component][row]
        } else if pickerView == self.courseNumberPicker {
            return String(self.courseNumberData[component][row])
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.departmentPicker {
            self.departmentTextField.text = self.departmentData[component][row]
        } else if pickerView == self.priorityPicker {
            self.priorityLevelTextField.text = self.priorityData[component][row]
        } else if pickerView == self.courseNumberPicker {
            let charToReplace = self.courseNumberData[component][row]
            self.courseNumberTextField.text = replace(self.courseNumberTextField.text!, component, charToReplace)
        }
    }
    
    func replace(_ myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString) as [Character]
        chars[index] = newChar
        return String(chars)
    }
    
    @IBAction func dueDateDidBeginEditing(_ textField: UITextField) {
        // Create a date picker for the date field.
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        datePicker.date = self.date!
        
        // add toolbar to textField
        textField.inputAccessoryView = toolbar
        
        datePicker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)
        textField.inputView = datePicker
        textField.text = formatDateForDisplay(date: datePicker.date)
    }
    
    @objc func donedatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func updateDateField(sender: UIDatePicker) {
        self.dueDateTextField?.text = formatDateForDisplay(date: sender.date)
        self.date = sender.date
    }
    
    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    @IBAction func textFieldValueChanged(_ sender: Any) {
        if self.nameTextField.text != "" && self.departmentTextField.text != "" && self.courseNumberTextField.text != "" &&
            self.priorityLevelTextField.text != "" &&
            self.dueDateTextField.text != "" {
            self.createToolbar.isHidden = false
        } else {
            self.createToolbar.isHidden = true
        }
    }
    
    @IBAction func pressedCreate(_ sender: Any) {
        let priorityLevel = self.countChar(text: self.priorityLevelTextField.text!, character: "!")
        let dueDate = self.getTimestamp(dueDate: self.dueDateTextField.text!)
        let newDueDate = DueDate(name: self.nameTextField.text!, department: self.departmentTextField.text!, courseNumber: self.courseNumberTextField.text!, priorityLevel: priorityLevel, dueDate: dueDate)
        self.dueDatesRef!.addDocument(data: newDueDate.getData() as [String : Any])
        self.navigationController?.popViewController(animated: true)
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
    
}
