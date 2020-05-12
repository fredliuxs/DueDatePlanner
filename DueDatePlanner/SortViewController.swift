//
//  SortViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/6/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit

class SortViewController: UIViewController {
    
    var orderBy: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressedAlphabetButton(_ sender: Any) {
        self.orderBy = "name"
        self.goBack()
    }
    
    @IBAction func pressedDepartmentButton(_ sender: Any) {
        self.orderBy = "department"
        self.goBack()
    }
    
    @IBAction func pressedDueDateButton(_ sender: Any) {
        self.orderBy = "dueDate"
        self.goBack()
    }
    
    @IBAction func pressedPriorityButton(_ sender: Any) {
        self.orderBy = "priorityLevel"
        self.goBack()
    }
    @IBAction func pressedCourseNumber(_ sender: Any) {
        self.orderBy = "courseNumber"
        self.goBack()
    }
    
    func goBack(){
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavViewController") as? UINavigationController,
            let mainViewController = controller.viewControllers.first as? MainTableViewController {
            if self.orderBy != nil {
                mainViewController.orderBy = self.orderBy
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
