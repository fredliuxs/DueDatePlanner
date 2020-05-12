//
//  StatViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/6/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit
import Firebase

class StatViewController: UIViewController {

    @IBOutlet weak var lateLabel: UILabel!
    @IBOutlet weak var notDueLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    var allDueDates = [DueDate]()
    var lateCount = 0
    var notDueCount = 0
    var completedCount = 0
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for dueDate in self.allDueDates {
            if dueDate.completed {
                completedCount += 1
            } else {
                let now = self.getNow()
                if dueDate.dueDate.dateValue().timeIntervalSince1970 < now.timeIntervalSince1970 {
                    lateCount += 1
                } else {
                    notDueCount += 1
                }
            }
        }
        self.total = self.notDueCount + self.lateCount + self.completedCount
        self.completedLabel.text = "\(self.completedCount)/\(self.total) Complted"
        lateLabel.text = "\(self.lateCount)/\(self.total) Late"
        notDueLabel.text = "\(self.notDueCount)/\(self.total) Not Due"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func getNow() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let now = formatter.string(from: Date())
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy"
        let date = inputFormatter.date(from: now)!
        return Timestamp(date: date).dateValue()
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
