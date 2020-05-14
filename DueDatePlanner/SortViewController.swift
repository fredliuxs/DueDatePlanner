//
//  SortViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/6/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit

class SortViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressedAlphabetButton(_ sender: Any) {
        self.goBack(orderBy: "name")
    }
    
    @IBAction func pressedDepartmentButton(_ sender: Any) {
        self.goBack(orderBy: "department")
    }
    
    @IBAction func pressedDueDateButton(_ sender: Any) {
        self.goBack(orderBy: "dueDate")
    }
    
    @IBAction func pressedPriorityButton(_ sender: Any) {
        self.goBack(orderBy: "priorityLevel")
    }
    @IBAction func pressedCourseNumber(_ sender: Any) {
        self.goBack(orderBy: "courseNumber")
    }
    
    func goBack(orderBy: String){
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavViewController") as? UINavigationController,
            let mainViewController = controller.viewControllers.first as? MainTableViewController {
            mainViewController.orderBy = orderBy
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
